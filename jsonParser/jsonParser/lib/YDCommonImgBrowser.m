//
//  YDCommonImgBrowser.m
//  SportsBar
//
//  Created by Aka on 2017/11/20.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDCommonImgBrowser.h"
//#import "YDCommonImgBrowser+YDEditor.h"
#import "YDImgBrowserCCell.h"
#import "YYWebImage.h"
//#import "UIViewController+YDAdd.h"
//#import "YDConstant.h"

#import "YDBrowserImgModel.h"

#import "TZAssetModel.h"
#import "TZImageManager.h"

#import <AVFoundation/AVFoundation.h>

#import "YDPreviewBottomView.h"
//#import "WBGImageEditor.h"
//#import "YDTools.h"
//#import "YDWatermarkMgr.h"
//#import "YDWatermark.h"
//#import "WBGMoreKeyboardItem.h"
//#import "YDAlbumMgr.h"
#import "YDObtainManagerMgr.h"
#import "YDCommonImgBrowserView.h"
//#import "YDCommonVideoPlayerService.h"
#import "TZImageManager.h"

@interface YDCommonImgBrowser ()< UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//,WBGImageEditorDelegate,WBGImageEditorDataSource

@property (nonatomic, strong) YDCommonImgBrowserView *view;

@property (nonatomic, strong) AVPlayerItem *currentItem;

@property (nonatomic, assign) BOOL isCurrentImgSelected;

@property (nonatomic, assign) YDImgsType type;
@property (nonatomic, assign) YDNavBarRightItemType rightItemType;

@property (nonatomic, strong) NSArray<UIImage *> *imgs;
@property (nonatomic, strong) NSArray<NSString *> *imgNames;
@property (nonatomic, strong) NSArray<NSString *> *imgUrlStrings;
@property (nonatomic, strong) NSArray<YDBrowserImgModel *> *browserImgs;

@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *assets;
@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *selectedAssets;

@property (nonatomic, assign) NSInteger toIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalNum;

@property (nonatomic, assign) BOOL canEditor;

@property (nonatomic, assign) BOOL hasPlay;

@end

static NSString *const kImgBrowserCCellIdentifier = @"k.img.browser.c.cell.identifier";

#define CURRENT_INDEX_TEXT(indexText) \
if (_rightItemType == YDNavBarRightItemTypeNone) { \
    self.view.titleLabel.text =indexText; \
} \
else { \
    self.navBar.topItem.title =indexText; \
}

@implementation YDCommonImgBrowser

YD_DYNAMIC_VC_VIEW(YDCommonImgBrowserView)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = -1;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    {
        [self.view.collectionView registerClass:[YDImgBrowserCCell class] forCellWithReuseIdentifier:kImgBrowserCCellIdentifier];
        self.view.collectionView.dataSource = self;
        self.view.collectionView.delegate = self;
    }

    {
        NSInteger totalNum = 0;
        switch (_type) {
            case YDImgsTypeImg:
                totalNum = _imgs.count;
                break;
            case YDImgsTypeImgName:
                totalNum = _imgNames.count;
                break;
            case YDImgsTypeImgUrlStrings:
                totalNum = _imgUrlStrings.count;
                break;
            case YDImgsTypeImgBrowserModel:
                totalNum = _browserImgs.count;
                break;
            case YDImgsTypeAssetImg:
            case YDImgsTypeAssetNotSure:
            case YDImgsTypeAssetVideo:
                totalNum = _assets.count;
                break;
            default:
                break;
        }
        _totalNum = totalNum;
        NSString *title =[NSString stringWithFormat:@"%ld/%ld",(_toIndex+1),totalNum];
        CURRENT_INDEX_TEXT(title);
    }
    
    {
        if (_rightItemType == YDNavBarRightItemTypeSelected) {
            self.view.bottomView.hidden = NO;
            [self _updateRightBottomBtn];
        }
        else {
            self.view.bottomView.hidden = YES;
        }
        NSString *rightTitle = @"完成";
        if (_selectedAssets.count >=1) {
            rightTitle = [NSString stringWithFormat:@"完成(%ld)",(long)_selectedAssets.count];
        }
        
        __weak __typeof(self) weakSelf = self;
        [self.view.bottomView configureLeftBtnTitle:MSLocalizedString(@"编辑", nil) rightBtnTitle:MSLocalizedString(rightTitle,nil) then:^(NSInteger index) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (index == YDPreviewActionTypeLeft) {
                __block UIImage *img;
                TZAssetModel *asset = strongSelf.assets[strongSelf.currentIndex];
                if (asset.type == TZAssetModelMediaTypeVideo) {
                    [strongSelf yd_popText:@"亲，暂时不支持视频编辑"];
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf yd_isLoading];
                });
                [[TZImageManager manager] getOriginalPhotoWithAsset:asset.asset completion:^(UIImage *photo, NSDictionary *info) {
                    BOOL flag = [info[PHImageResultIsDegradedKey] boolValue];
                    if (!flag) {
                        img = photo;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf yd_endLoading];
                            WBGImageEditor *vc = [[WBGImageEditor alloc] initWithImage:[YDTools compressImageTo1M:img] delegate:strongSelf dataSource:strongSelf];
                            [strongSelf presentViewController:vc animated:YES completion:nil];
                            [[YDStatisticsMgr sharedMgr] eventPreviewImgEditor];
                        });
                    }
                }];
            }
            else {
                [OBTAIN_MGR(YDAlbumMgr).selectedAssets removeAllObjects];
                [OBTAIN_MGR(YDAlbumMgr).selectedAssets addObjectsFromArray:strongSelf.selectedAssets];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [[YDStatisticsMgr sharedMgr] eventPreviewImgFinished];
            }
        }];
        [self.view.bottomView updateRightBtncorner];
        [self.view.bottomView updateRightBtnEnable:_selectedAssets.count];
        [[YDWatermarkMgr sharedMgr] netLoadWalkWaterMakerImgs:nil];
    }

    if (_canEditor) {
        [self editorInit];
    }
}

- (void)msNavBarInit: (YDNavigationBar *)navBar {
    if (_rightItemType == YDNavBarRightItemTypeSelected) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_circle_editory_img_nomal"] style:UIBarButtonItemStylePlain target:self action:@selector(onImgSelectedAction:)];
        navBar.topItem.rightBarButtonItem = self.view.rightBarItem;
        navBar.topItem.title = [NSString stringWithFormat:@"%zd/%zd",_toIndex,_assets.count];
        self.view.rightBarItem = barItem;
    }
}

- (void)updateEditorHiddenWithItem:(TZAssetModel *)currentAsset {
    if (currentAsset.type == TZAssetModelMediaTypeVideo) {
        [self.view.bottomView updateLeftBtnHidden:YES];
    }
    else {
        [self.view.bottomView updateLeftBtnHidden:NO];
    }
}

- (void)updateRightItemHiddenWithItem:(TZAssetModel *)currentAsset {
    if ( ((currentAsset.type == TZAssetModelMediaTypeVideo) && (_type == YDImgsTypeAssetImg))
        ||((currentAsset.type == TZAssetModelMediaTypePhoto) &&(_type ==YDImgsTypeAssetVideo)) ) {
        [self updateRightItemWithStatus:NO];
    }
    else {
        [self updateRightItemWithStatus:YES];
        _isCurrentImgSelected = currentAsset.isSelected;
        [self updateImgWithFlag:_isCurrentImgSelected];
    }
}

- (void)updateRightItemWithStatus:(BOOL)status {
    if (status) {
        self.navBar.topItem.rightBarButtonItem = self.view.rightBarItem;
    }
    else {
        self.navBar.topItem.rightBarButtonItem = nil;
    }
}

- (void)_updateRightBottomBtn {
    if (_selectedAssets.count >0) {
        [self.view.bottomView updateRightBtnTitlte:[NSString stringWithFormat:@"完成(%zd)",_selectedAssets.count]];
        [self.view.bottomView updateRightBtnEnable:YES];
    }
    else {
        [self.view.bottomView updateRightBtnTitlte:MSLocalizedString(@"完成", nil)];
        [self.view.bottomView updateRightBtnEnable:NO];
    }
}

- (void)updateImgWithFlag:(BOOL)flag {
    if (flag) {
        self.view.rightBarItem.image = [UIImage imageNamed:@"icon_circle_editory_img_selected"];
        self.view.rightBarItem.tintColor = YD_TEXT_DEFAULT_GREEN;
    }
    else {
        self.view.rightBarItem.image = [UIImage imageNamed:@"icon_circle_editory_img_nomal"];
        self.view.rightBarItem.tintColor = YDC_NAV_TINT;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLayoutSubviews {
    if ((_toIndex >=0) && (_totalNum >_toIndex)) {
        [self.view.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        NSString *text =[NSString stringWithFormat:@"%ld/%ld",(_toIndex+1),_totalNum];
        CURRENT_INDEX_TEXT(text);
        _toIndex = -1;
    }
    if (self.view.collectionView.visibleCells.count >0) {
        [self scrollViewDidScroll:self.view.collectionView];
    }
    
    [super viewDidLayoutSubviews];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YDImgBrowserCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImgBrowserCCellIdentifier forIndexPath:indexPath];
    __block UIImage *currentImg;
    switch (_type) {
        case YDImgsTypeImg:
        {
            currentImg = _imgs[indexPath.item];
            cell.imgView.image = currentImg;
        }
            break;
        case YDImgsTypeImgName:
        {
            cell.imgView.image =currentImg = [UIImage imageNamed:_imgNames[indexPath.item]];
        }
            break;
        case YDImgsTypeImgUrlStrings:
        {
            [cell.imgView yy_setImageWithURL:[NSURL URLWithString:_imgUrlStrings[indexPath.item]] placeholder:[UIImage imageNamed:@"img_origin_circle_mycircle_placeholder.jpg"]];
            currentImg = cell.imgView.image;
        }
            break;
        case YDImgsTypeImgBrowserModel:
        {
            YDBrowserImgModel *item = _browserImgs[indexPath.item];
            if (item.type == YDBrowserImgTypeUrl) {
                [cell.imgView yy_setImageWithURL:[NSURL URLWithString:item.urlStr] placeholder:[UIImage imageNamed:@"img_origin_circle_mycircle_placeholder.jpg"]];
                currentImg = cell.imgView.image;
            }
            else if(item.type == YDBrowserImgTypeImg) {
                cell.imgView.image =currentImg =item.img;
            }
            else if(item.type == YDBrowserImgTypeName) {
                cell.imgView.image =currentImg = [UIImage imageNamed:item.imgName];
            }
            else { }
        }
            break;
        case YDImgsTypeAssetNotSure:
        case YDImgsTypeAssetImg:
        case YDImgsTypeAssetVideo:
        {
            TZAssetModel *asset = _assets[indexPath.item];
            [cell setImageProgressUpdateBlock:nil];
            cell.assetItem = asset;
            if (_assets.count ==1 && asset.type == TZAssetModelMediaTypeVideo) {
                [self scrollViewDidScroll:self.view.collectionView];
            }
        }
            break;
        default:
            break;
    }

    __weak typeof (self) wSelf = self;
    __weak typeof (cell) weakCell = cell;
    cell.longPressBlock = ^{
        if (weakCell.assetItem && weakCell.assetItem.type == TZAssetModelMediaTypeVideo) {
            return ;
        }
        currentImg = weakCell.imgView.image;
        if (!currentImg) {
            [wSelf yd_popText:@"当前图片类型暂时不支持保存"];
            return;
        }
        [wSelf saveImgWithImg:currentImg];
    };
    
    cell.tapBlock = ^{
        if (wSelf.type <YDImgsTypeAssetNotSure) {
            [wSelf yd_popUp];
        }
    };
    cell.tapPlayVideoblock = ^{
        [wSelf _playWithCurrentCell:weakCell];
    };
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (_type) {
        case YDImgsTypeImg:
            return _imgs.count;
            break;
        case YDImgsTypeImgName:
            return _imgNames.count;
            break;
        case YDImgsTypeImgUrlStrings:
            return _imgUrlStrings.count;
            break;
        case YDImgsTypeImgBrowserModel:
            return _browserImgs.count;
            break;
        case YDImgsTypeAssetNotSure:
        case YDImgsTypeAssetImg:
        case YDImgsTypeAssetVideo:
            return _assets.count;
            break;
        default:
            break;
    }
    return _imgs.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_BOUNDS.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - configure

- (void)configureWithImgs:(NSArray<UIImage *> *) imgs toIndex:(NSInteger)toIndex {
    _imgs = imgs;
    _type = YDImgsTypeImg;
}

- (void)configureWithImgNames:(NSArray<NSString *> *)imgNames toIndex:(NSInteger)toIndex {
    _imgNames = imgNames;
    _type = YDImgsTypeImgName;
}

- (void)configureWithImgUrlStrings:(NSArray<NSString *> *)imgUrlStrings toIndex:(NSInteger)toIndex {
    _imgUrlStrings = imgUrlStrings;
    _type = YDImgsTypeImgUrlStrings;
    _toIndex = toIndex;
}

- (void)configureWithBrowserImgs:(NSArray <YDBrowserImgModel *> *)imgs toIndex:(NSInteger)toIndex {
    _browserImgs = imgs;
    _type = YDImgsTypeImgBrowserModel;
    _toIndex = toIndex;
}

- (void)configureWithImgs:(NSArray *)imgs type:(YDImgsType)type toIndex:(NSInteger)toIndex {
    [self configureWithTotalImgs:imgs selectedImgs:@[] toIndex:toIndex type:type rightItemType:YDNavBarRightItemTypeNone];
}

- (void)configureWithTotalImgs:(NSArray *)imgs selectedImgs:(NSArray *)selectedImgs toIndex:(NSInteger)toIndex type:(YDImgsType)type rightItemType:(YDNavBarRightItemType)rightItemType {
    _type = type;
    _toIndex = toIndex;
    _rightItemType = rightItemType;
    switch (type) {
        case YDImgsTypeImg:
            _imgs = imgs;
            break;
        case YDImgsTypeImgName:
            _imgNames = imgs;
            break;
        case YDImgsTypeImgUrlStrings:
            _imgUrlStrings = imgs;
            break;
        case YDImgsTypeImgBrowserModel:
            _browserImgs = imgs;
            break;
        case YDImgsTypeAssetImg:
        case YDImgsTypeAssetVideo:
        case YDImgsTypeAssetNotSure:
        {
            _assets = @[].mutableCopy;
            _selectedAssets = @[].mutableCopy;
            [_assets addObjectsFromArray:imgs];
            [_selectedAssets addObjectsFromArray: selectedImgs];
            if (_rightItemType != YDNavBarRightItemTypeNone) {
                [self yd_navBarInitWithStyle:YDNavBarStyleGray];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - custom method

#pragma mark -- scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat f = scrollView.contentOffset.x / SCREEN_WIDTH_V0;
    NSInteger denominator;
    switch (_type) {
        case YDImgsTypeImg:
            denominator = _imgs.count;
            break;
        case YDImgsTypeImgName:
            denominator = _imgNames.count;
            break;
        case YDImgsTypeImgBrowserModel:
            denominator = _browserImgs.count;
            break;
        case YDImgsTypeAssetImg:
        case YDImgsTypeAssetNotSure:
        case YDImgsTypeAssetVideo:
            denominator = _assets.count;
            break;
        default:
            denominator = _imgUrlStrings.count;
            break;
    }
    
    NSInteger index = lround(f);
    TZAssetModel *currentAsset = _assets[index];
    if (index == _currentIndex) {
        if (!_hasPlay) {
            [self _playVideowhileScrollWithAsset:currentAsset];
        }
        return;
    }
    
    _currentIndex = index;
    NSString *text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,denominator];
    CURRENT_INDEX_TEXT(text);
    
    [self updateEditorHiddenWithItem:currentAsset];
    [self updateRightItemHiddenWithItem:currentAsset];

    [self _playVideowhileScrollWithAsset:currentAsset];

}

#pragma mark -- save image

- (void)_playVideowhileScrollWithAsset:(TZAssetModel *)currentAsset {
    //    视频播放
    NSArray *cells = self.view.collectionView.visibleCells;
    for (YDImgBrowserCCell *cell in cells) {
        if ([cell.assetItem isEqual:currentAsset]) {
            [self _playWithCurrentCell:cell];
        }
        else {
            [cell showImg];
            [OBTAIN_MGR(YDCommonVideoPlayerService) stop];
        }
    }
}

- (void)_playWithCurrentCell:(YDImgBrowserCCell *)cell {
    if (cell.assetItem.type == TZAssetModelMediaTypeVideo) {
        _hasPlay = YES;
        [OBTAIN_MGR(YDCommonVideoPlayerService) playWithAsset:cell.assetItem.asset then:^(AVPlayerLayer *playerLayer,AVPlayerItemStatus status) {
            if (status ==AVPlayerItemStatusReadyToPlay) {
                [cell showVideoWithPlayerLayer:playerLayer];
            }
            else {
                [cell showImg];
            }
        }];
    }
}

- (void)saveImgWithImg:(UIImage *)img {
    __weak typeof (self) wSelf = self;
    MMPopupItem *saveImgItem = MMItemMake(MSLocalizedString(@"保存图片", nil), MMItemTypeNormal, ^(NSInteger index) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[TZImageManager manager] savePhotoWithImage:img completion:^(NSError *error) {
                dispatch_async_on_main_queue(^{
                    if (wSelf.yd_isLoading) {
                        [wSelf yd_endLoading];
                    }
                    if (error) {
                        [wSelf yd_popText:@"保存图片失败"];
                    }
                    else {
                        [wSelf yd_popText:@"保存图片成功"];
                    }
                });
            }];
        });
        if (!wSelf.yd_isLoading) {
            [wSelf yd_startLoading];
        }
    });
    [self yd_sheetWithTitle:nil items:@[saveImgItem]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_type == YDImgsTypeAssetVideo) {
        [OBTAIN_MGR(YDCommonVideoPlayerService) stop];
    }
    MSLogD(@"gh- img browser dealloc ");
}


#pragma mark - custom method

- (void)onImgSelectedAction:(UIBarButtonItem *)barItem {
    TZAssetModel *currentAsset = _assets[_currentIndex];
    if (_type == YDImgsTypeAssetVideo && !currentAsset.isSelected) {
        [self yd_popText:@"亲!当前只可以选择一个视频"];
        return;
    }
    
    _isCurrentImgSelected = !_isCurrentImgSelected;
    currentAsset.isSelected = _isCurrentImgSelected;

    //    deal with data & filter type
    if (currentAsset.isSelected) {
        [_selectedAssets addObject:currentAsset];
        if (_type == YDImgsTypeAssetNotSure) {
            if (currentAsset.type == TZAssetModelMediaTypePhoto) {
                _type = YDImgsTypeAssetImg;
            }
            if (currentAsset.type == TZAssetModelMediaTypeVideo) {
                _type =YDImgsTypeAssetVideo;
            }
        }
    }
    else {
        [_selectedAssets removeObject:currentAsset];
        if (_selectedAssets.count <=0) {
            _type = YDImgsTypeAssetNotSure;
        }
    }
    
    [self updateImgWithFlag:_isCurrentImgSelected];
    [self _updateRightBottomBtn];
}

- (TZAssetModel *)getAssetBeforeEditor {
    return _assets[_currentIndex];
}

- (void)replaceBeforeEditorAsset:(TZAssetModel *)asset0 withAsset:(TZAssetModel *)asset1 {
    [_assets insertObject:asset1 atIndex:_currentIndex];
    [_assets removeObject:asset0];
}

- (void)replaceBeforeEditorAssetATSelected:(TZAssetModel *)asset0 withAsset:(TZAssetModel *)asset1 {
    [_selectedAssets removeObject:asset0];
    [_selectedAssets addObject:asset1];
}

@end
