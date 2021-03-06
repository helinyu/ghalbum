//
//  YDImgPickerViewController.m
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <Photos/Photos.h>
#import "YDImgPickerViewController.h"
#import "YDPhotoTakeViewController.h"
#import "YDImgPickerView.h"

#import "YDImgPickerCCell.h"
#import "YDImgPickerTakeCCell.h"
#import "YDImgTitleIconTCell.h"
#import "YDPreviewBottomView.h"
#import "YDPickerBottomView.h"
#import "YDImgPickerVCTitleView.h"

#import "YDObtainManagerMgr.h"
#import "YDAlbumMgr.h"
#import "YDAlbumAssetService.h"
#import "YDAlbumTCell.h"

#import "YDAlbumAssetService.h"
#import "YDCommonImgBrowser.h"

#import "YDCategoriesMacro.h"

#define kCellLength (SCREEN_WIDTH_V0 -(kSpaceLength * (kCCellNumOfALine -1)))/kCCellNumOfALine

typedef NS_ENUM(NSInteger, YDAssetSelectedType) {
    YDAssetSelectedTypeNotSure,
    YDAssetSelectedTypeImg,
    YDAssetSelectedTypeVideo,
};

typedef NS_ENUM(NSUInteger, YDAlbumDisplayType) {
    YDAlbumDisplayTypeUnknown,
    YDAlbumDisplayTypeTotal,
    YDAlbumDisplayTypeImageOnly,
    YDAlbumDisplayTypeVideoOnly,
};

@interface YDImgPickerViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) YDImgPickerVCTitleView *titleContentView;
@property (nonatomic, strong) YDImgPickerView *view;

@property (nonatomic, assign) BOOL isAlbumDisplay; // 这里面是两个进行切换

@property (nonatomic, assign) BOOL isSecondMoreTime;

@property (nonatomic, assign) NSInteger leafChoiceNum;
@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *allSelctedAssets;

@property (nonatomic, assign) YDCommingSourceType previewType;
@property (nonatomic, strong) TZAlbumModel *selectedAlbum;
@property (nonatomic, strong) NSArray<TZAssetModel *> *videoAssets;
@property (nonatomic, assign) BOOL isVideoFilter;

@property (nonatomic, assign) BOOL canLoadVideo;
@property (nonatomic, assign) BOOL canLoadImage;
@property (nonatomic, assign) BOOL needFetchAssets;

// 相册中分为两类型： 视频 、图像（img,git,live）
@property (nonatomic, strong) NSArray<YDAlbumModel *> *totalAlbums;
@property (nonatomic, strong) NSArray<YDAlbumModel *> *imageAlbums;
@property (nonatomic, strong) NSArray<YDAlbumModel *> *videoAlbums;
@property (nonatomic, strong) NSArray<YDAlbumModel *> *displayAlbums;
@property (nonatomic, assign) YDAlbumDisplayType albumDisplayType;

// 展示相册列表还是图片瀑布流
@property (nonatomic, assign) BOOL showAssets; // 默认展示相册列表, NO 展示相册列表 YES： 展示相册瀑布流
@property (nonatomic, strong) YDAlbumModel *showAssetOfTheAlbum; //展示当前瀑布流的相册对象

// asset
@property (nonatomic, strong) NSArray<PHAsset *> *currentTotalAssets;
@property (nonatomic, strong) NSArray<PHAsset *> *currentVideoAssets;
@property (nonatomic, strong) NSArray<PHAsset *> *currentImageAssets;

@end

static NSString *const kImgPickerChoiceCellCIdentifier = @"k.img.picker.choice.cell.C.identifier";
static NSString *const kImgPickerTakeCellCIdentifier = @"k.img.picker.take.cell.C.identifier";
static NSString *const kImgPickerAblumCellTIdentifier = @"k.img.picker.ablum.cell.T.identifier";

static NSString *const kTitleText = @"相机胶卷";
static NSString *const kVidelTitle = @"视频";

static const CGFloat kTableViewCellH = 96.f;
static const CGFloat kSpaceLength = 1.f;
static const CGFloat kCCellNumOfALine = 3;

static NSInteger const kVideoMaxDuration = 180;
static NSInteger const kVideoMinDuration = 3;

#define Main_Queue(x) dispatch_async(dispatch_get_main_queue(), ^{x});

@implementation YDImgPickerViewController

YD_DYNAMIC_VC_VIEW([YDImgPickerView class]);

- (void)configureSelectedAssets:(NSArray *)assets then:(void(^)(NSArray *assets, BOOL change))then {
    _allSelctedAssets = @[].mutableCopy;
    [_allSelctedAssets addObjectsFromArray:assets];
//    _canLoadVideo = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@",CIRCLE_VIDEO_AUTH,[YDAppInstance userId]]];
}

/**
 *  create subviews
 */
- (void)msComInit {
    
//    [self yd_navBarInitWithStyle:YDNavBarStyleGray];
    
//    [self.view updateDisplayViewWithIsUP:_isAlbumDisplay];
    
    [self createViewConstraints];
}

/**
 *  create constraints
 */
- (void)createViewConstraints {
}

/**
 *  notification bind & touch events bind & delegate bind
 */
- (void)msBind {

    {
        [self.view.tableView registerClass:[YDAlbumTCell class] forCellReuseIdentifier:kImgPickerAblumCellTIdentifier];
        [self.view.collectionView registerClass:[YDImgPickerCCell class] forCellWithReuseIdentifier:kImgPickerChoiceCellCIdentifier];
        [self.view.collectionView registerClass:[YDImgPickerTakeCCell class] forCellWithReuseIdentifier:kImgPickerTakeCellCIdentifier];
    }

    {
        self.view.tableView.dataSource = self;
        self.view.tableView.delegate = self;
        self.view.collectionView.dataSource = self;
        self.view.collectionView.delegate = self;
    }
}

/**
 *  data init
 */
- (void)msDataInit {
    
    self.title = @"图片选择";
    if (self.albumDisplayType == YDAlbumDisplayTypeUnknown) {
        self.albumDisplayType = YDAlbumDisplayTypeTotal;
    }
    [self loadAlbumsInit];
    [self someBaseDataInit];
    [self bottomViewInit];
}

- (void)someBaseDataInit {
//    _leafChoiceNum = kMaxChoiceImgNum - _allSelctedAssets.count;
    [self __reloadCollectionView];
}

- (void)loadAlbumsInit {
//    TZAssetAuthorizationStatus status = [TZImageManager getAuthorizationStatus];
//    switch (status) {
//        case TZAssetAuthorizationStatusNotAuthorized:
//        {
//            NSString *tipString = @"";
//            if (!tipString) {
//                NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
//                NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
//                if (!appName) {
//                    appName = [mainInfoDictionary objectForKey:(NSString *)kCFBundleNameKey];
//                }
//                tipString = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
//            }
//            [self yd_popText:tipString];
//            return;
//        }
//            break;
//        case TZAssetAuthorizationStatusAuthorized:
//        {
            [self loadActualAlbum];
//        }
//            break;
//        case TZAssetAuthorizationStatusNotDetermined:
//        {
//            __weak typeof (self) wSelf = self;
//            [TZImageManager requestAuthorization:^(TZAssetAuthorizationStatus status) {
//                if (status == TZAssetAuthorizationStatusAuthorized) {
//                    [wSelf loadActualAlbum];
//                }
//            }];
//        }
//            break;
//        default:
//        {
//            MSLogD(@"gh- TZAssetAuthorizationStatusNotUsingPhotoKit");
//        }
//            break;
//    }
}

// 这个是只有在  YDAlbumAssetTypeAlbumAssetBoth, // 在一个vc里面展示两种切换
// YDAlbumAssetTypeAlbumListOnly, //只是展示相册 才会加载
- (void)loadActualAlbum {
    
    [OBTAIN_MGR(YDAlbumAssetService) base_getAllAlbumsWithAllowPickingVideo:_canLoadVideo allowPickingImage:_canLoadImage needFetchAssets:_needFetchAssets completion:^(NSArray<YDAlbumModel *> *albums, NSArray<YDAlbumModel *> *videoAlbums, NSArray<YDAlbumModel *> *imageAlbums) {
        _totalAlbums = albums;
        _videoAlbums = videoAlbums;
        _imageAlbums = imageAlbums;
        _displayAlbums = [self changeDisplayAlbumsWithType:_albumDisplayType];
        if (_showAssets) {
        //load camera roll
            if (_totalAlbums.count <=0) {
                [self __reloadView];
            }
            else {
                YDAlbumModel *cameraAlbum = _totalAlbums.firstObject;
                [OBTAIN_MGR(YDAlbumAssetService) base_getAssetWithAlbum:cameraAlbum allowPickingVideo:_canLoadVideo allowPickingImage:_canLoadImage then:^(NSArray<PHAsset *> *totals, NSArray<PHAsset *> *images, NSArray<PHAsset *> *videos) {
                    dispatch_async_on_main_queue(^{
                        _currentTotalAssets = totals;
                        _currentImageAssets = images;
                        _currentVideoAssets = videos;
                        [self __reloadView];
                    });
                }];
            }
        }
        else {
            [self __reloadView];
        }
        //        [_albums addObjectsFromArray:models];
        //        if (_albums.count >0) {
        //            _selectedAlbum = _albums.firstObject;
        //        }
//        [self reloadAssetsAndReloadView];
    }];
}

- (void)reloadAssetsAndReloadView {
//    [[TZImageManager manager] base_getAssetsFromFetchResult:_selectedAlbum.result allowPickingVideo:_canLoadVideo allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models, NSArray<TZAssetModel *> *videos) {
//        _selectedAlbum.models = models;
//        _selectedAlbum.videos = videos;
//        [self reloadCollectionView];
//    }];
}

- (void)bottomViewInit {
    __weak typeof (self) wSelf = self;
    NSString *rightBtnTitle = @"完成";
    if (_allSelctedAssets.count >0) {
        rightBtnTitle = [NSString stringWithFormat:@"完成(%ld)",(unsigned long)_allSelctedAssets.count];
    }
    
    NSString *videoSelectText;
    if (_canLoadVideo) {
        videoSelectText = @"只看视频";
    }
    
    [self.view.pickerButtomView configureLeftBtnTitle:@"预览" rightBtnTitle:rightBtnTitle videoBtnTitle:videoSelectText then:^(NSInteger index) {

        if (index == YDPreviewActionTypeLeft) {
            if (wSelf.allSelctedAssets.count <= 0) {
                NSLog(@"请选择照片");
                return ;
            }

            YDCommonImgBrowser *vc = [YDCommonImgBrowser new];
            [vc configureWithTotalImgs:wSelf.allSelctedAssets selectedImgs:wSelf.allSelctedAssets toIndex:0 type:[wSelf _getAssetType] rightItemType:YDNavBarRightItemTypeSelected];
            [wSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == YDPreviewActionTypeRight) {
            [OBTAIN_MGR(YDAlbumMgr).selectedAssets removeAllObjects];
            [OBTAIN_MGR(YDAlbumMgr).selectedAssets addObjectsFromArray:wSelf.allSelctedAssets];
            [wSelf dismissViewControllerAnimated:YES completion:nil];
        }
        if (index == YDPreviewActionTypeVideoSelect) {
            wSelf.isVideoFilter = !wSelf.isVideoFilter;
            [wSelf __reloadCollectionView];
        }
    }];
    [self.view.pickerButtomView updateRightBtncorner];
    if (!_canLoadVideo) {
        [self.view.pickerButtomView updateBtnEnable:YES];
    }
    
    if (_allSelctedAssets.count >0) {
        [self.view.pickerButtomView updateBtnEnable:YES];
    }
    else {
        [self.view.pickerButtomView updateBtnEnable:NO];
    }
}

/**
 *  static style
 */
- (void)msStyleInit {
    [self.view showViewWithIsAsset:_showAssets];
    
    self.view.backgroundColor = [UIColor redColor];
}

/**
 *  language init
 */
- (void)msLangInit {
}

#pragma mark - life cycle not need to change nomal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self msComInit];
    [self msBind];
    [self msDataInit];
    [self msLangInit];
    [self msStyleInit];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isSecondMoreTime) {
        if (!_isAlbumDisplay) {
            [self __reloadCollectionView];
        }
    }else {
        _isSecondMoreTime = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDAlbumTCell *cell = [tableView dequeueReusableCellWithIdentifier:kImgPickerAblumCellTIdentifier forIndexPath:indexPath];
    YDAlbumModel *albumItem = _displayAlbums[indexPath.row];
    cell.modelItem = albumItem;
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEVICE_WIDTH_OF(kTableViewCellH);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_albumAssetType) {
        case YDAlbumAssetTypeAlbumAssetBoth:
        {
            //    OBTAIN_MGR(YDAlbumMgr).selectedAlbum = _selectedAlbum = _albums[indexPath.row];
            //    [self _updateTitleViewPostionWithText:OBTAIN_MGR(YDAlbumMgr).selectedAlbum.name];
            //    [self.view updateDisplayViewWithIsUP:NO];
            [self reloadAssetsAndReloadView];
        }
            break;
        case YDAlbumAssetTypeAlbumListOnly:
        {
            YDImgPickerViewController *vc = [YDImgPickerViewController new];
            vc.view.backgroundColor = [UIColor redColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case YDAlbumAssetTypeAssetFlowOnly:
        {
            NSLog(@"gh- 展示的内容不正确");
        }
            break;
        default:
        {
            NSLog(@"gh- 请设置展示样式的类型");
        }
            break;
    }
}

- (void)_updateTitleViewPostionWithText:(NSString *)text {
    CGFloat titleViewW = [self _titleViewWidthWithText:text];
    [_titleContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleViewW);
    }];
//    [_titleContentView configureWithTitle:_selectedAlbum.name isUpDirection:NO];
}

#pragma mark -- collectionView datasource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning  -- test
//    if (_isVideoFilter) return _selectedAlbum.videos.count;
//    return (_selectedAlbum.models.count + i1);
    return _currentTotalAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item <=0 && !_isVideoFilter) {
        YDImgPickerTakeCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImgPickerTakeCellCIdentifier forIndexPath:indexPath];
        return cell;
    }else {
        NSInteger index = indexPath.item;
        if (!_isVideoFilter) {
            index --;
        }
        YDImgPickerCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImgPickerChoiceCellCIdentifier forIndexPath:indexPath];
        
        __weak typeof (self) wSelf = self;
        TZAssetModel *asset;
        if (!_isVideoFilter) {
//            asset= _selectedAlbum.models[index];
        }
        else {
//            asset = _selectedAlbum.videos[index];
        }
        [cell configureWithAsset:asset then:^{
            TZAssetModel *firstAsset = wSelf.allSelctedAssets.firstObject;
//            if (!asset.isSelected && firstAsset) {
//                if (wSelf.allSelctedAssets.count >= kMaxChoiceImgNum) {
//                    NSLog(@"最多只能够选择9张");
//                    return ;
//                }
//                if (firstAsset.type ==TZAssetModelMediaTypeVideo){
//                    if (asset.type == TZAssetModelMediaTypeVideo) {
//                        NSLog(@"最多选择一个视频");
//                    }
//                    else if (asset.type == TZAssetModelMediaTypePhoto) {
//                        NSLog(@"图片和视频不能够同时选择");
//                    }
//                    else {
//                        NSLog(@"您已经选择了视频类型并且只可以选择一个视频");
//                    }
//                    return;
//                }
//
//                if ((firstAsset.type ==TZAssetModelMediaTypePhoto) && (asset.type == TZAssetModelMediaTypeVideo)){
//                    NSLog(@"图片和视频不能够同时选择");
//                    return;
//                }
//            }
//
//            if (asset.type ==TZAssetModelMediaTypeVideo){
//                PHAsset *phAsset =asset.asset;
//                if (phAsset.duration > kVideoMaxDuration) {
//                    NSLog(@"视频时长不能长于3分钟");
//                    return;
//                }
//                if (phAsset.duration <=kVideoMinDuration) {
//                    NSLog(@"视频时长不能小于3秒");
//                    return;
//                }
//            }
//
//            if (!asset.isSelected) {
//                asset.isSelected = YES;
//                [wSelf.allSelctedAssets addObject:asset];
//                wSelf.leafChoiceNum--;
//                [wSelf.view.pickerButtomView updateBtnEnable:YES];
//            }else {
//                for (TZAssetModel *model_item in wSelf.allSelctedAssets) {
//                    NSString *outIdentifier =[[TZImageManager manager] getAssetIdentifier:asset.asset];
//                    NSString *innerIdentifier = [[TZImageManager manager] getAssetIdentifier:model_item.asset];
//                    if ([outIdentifier isEqualToString:innerIdentifier]) {
//                        [wSelf.allSelctedAssets removeObject:model_item];
//                        wSelf.leafChoiceNum++;
//                        asset.isSelected = NO;
//                        break;
//                    }
//                }
//            }
            if (wSelf.allSelctedAssets.count >0) {
                [wSelf.view.pickerButtomView updateRightBtnTitlte:[NSString stringWithFormat:@"完成(%ld)",(unsigned long)wSelf.allSelctedAssets.count]];
            }
            else {
                [wSelf.view.pickerButtomView updateRightBtnTitlte:[NSString stringWithFormat:@"完成"]];
                [wSelf.view.pickerButtomView updateBtnEnable:NO];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.view.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
        }];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellLength = (SCREEN_WIDTH_V0 - (kSpaceLength * (kCCellNumOfALine -1)))/kCCellNumOfALine;
    return CGSizeMake(cellLength, cellLength);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return DEVICE_WIDTH_OF(kSpaceLength);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return DEVICE_WIDTH_OF(kSpaceLength);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && !_isVideoFilter) {
        if ([self isVideoSelected]) {
            NSLog(@"您已经选择了视频，暂时不支持拍照");
            return;
        }
        
        [self _configurePhotoTaken];
        return;
    }
   
    // 选择图片、视频的处理
    OBTAIN_MGR(YDAlbumMgr).sourceType = YDPhotoSourceTypeAlbumDidSelected;

    NSInteger index = indexPath.item;
//    NSArray *allAssets = _selectedAlbum.videos;
//    if (!_isVideoFilter) {
//        index = indexPath.item -1;
//        allAssets = _selectedAlbum.models;
//    }
//
//    YDCommonImgBrowser *vc = [YDCommonImgBrowser new];
//    [vc configureWithTotalImgs:allAssets selectedImgs:_allSelctedAssets.copy toIndex:index type:[self _getAssetType] rightItemType:YDNavBarRightItemTypeSelected];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- custom methods

- (void)_configurePhotoTaken {
//        TZAssetAuthorizationStatus status = [TZImageManager getCameraAuthorStatus];
//        if (status == TZAssetAuthorizationStatusNotAuthorized) {
//            [self _alertCamaraInfoWhileNotAuthorized];
//            return;
//        }
//        else if (status == TZAssetAuthorizationStatusNotDetermined) {
//            [TZImageManager requestCameraAuthorization:^(TZAssetAuthorizationStatus status) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (status == TZAssetAuthorizationStatusAuthorized) {
//                        [self _toPhotoTakenVC];
//                    }else {
//                        [self _alertCamaraInfoWhileNotAuthorized];
//                    }
//                    return ;
//                });
//            }];
//        }
//        else {
            [self _toPhotoTakenVC];
//        }
}

- (void)_alertCamaraInfoWhileNotAuthorized {
    NSLog(@"您已经禁止了拍照权限，请前往设置->隐私->相机授权应用拍照权限");
}

- (void)_toPhotoTakenVC {
    YDPhotoTakeViewController *vc = [YDPhotoTakeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)msNavBarInit: (YDNavigationBar *)navBar {
//    CGFloat titleViewW = [self _titleViewWidthWithText:kTitleText];
//    YDImgPickerVCTitleView *titleContentView = [YDImgPickerVCTitleView new];
//    [navBar addSubview:titleContentView];
//    [titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(titleViewW);
//        make.height.mas_equalTo(navBar.yd_height- YDStatusBarH);
//        make.centerX.equalTo(navBar);
//        make.bottom.equalTo(navBar);
//    }];
//
//    __weak typeof (self) wSelf = self;
//    [titleContentView configureWithTitle:MSLocalizedString(kTitleText, nil) isUpDirection:NO then:^(BOOL flag) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            __strong typeof (wSelf) strongSelf = wSelf;
//            [strongSelf.view updateDisplayViewWithIsUP:flag];
//            if (flag) {
//                for (TZAlbumModel *albumModel in strongSelf.albums) {
//                    albumModel.selectedModels = strongSelf.allSelctedAssets;
//                }
//                [strongSelf reloadTableView];
//            }
//            else {
//                [[YDStatisticsMgr sharedMgr] eventPreviewAlbum];
//                [strongSelf reloadCollectionView];
//            }
//        });
//    }];
//    _titleContentView = titleContentView;
//}

- (CGFloat)_titleViewWidthWithText:(NSString *)text {
//    CGFloat textW = [NSString yy_textWidthWithText:text rSize:18.f];
//    CGFloat imgW = 13.f;
//    CGFloat textToImgW = 6.f;
//    CGFloat titleViewW = textW + imgW + textToImgW;
//    return titleViewW;
    return 40.f;
}

- (void)yd_popUp {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yd.circle.editor.back" object:nil];
}

- (void)checkAllSelectedAssets {
    if (_allSelctedAssets.count >0) {
        NSMutableArray *mSelectAssets = @[].mutableCopy;
//        for (TZAssetModel *item in _allSelctedAssets) {
//            [mSelectAssets addObject:item.asset];
//        }
//        for (TZAssetModel *model in _selectedAlbum.models) {
//            model.isSelected = NO;
//            if ([[TZImageManager manager] isAssetsArray:mSelectAssets containAsset:model.asset]) {
//                model.isSelected = YES;
//            }
//        }
    }
}

- (void)__reloadView {
    if (_showAssets) {
        [self __reloadCollectionView];
    }
    else {
        [self __reloadTableView];
    }
}

- (void)__reloadCollectionView {
    [self checkAllSelectedAssets];
    [self.view.collectionView reloadData];
}

- (void)__reloadTableView {
    [self checkAllSelectedAssets];
    [self.view.tableView reloadData];
}

- (BOOL)isVideoSelected {
    if (_allSelctedAssets.count >0) {
        TZAssetModel *firstAsset = _allSelctedAssets.firstObject;
//        if (firstAsset.type == TZAssetModelMediaTypeVideo) {
//            return YES;
//        }
    }
    return NO;
}

- (YDImgsType)_getAssetType {
    YDImgsType imgType = YDImgsTypeAssetNotSure;
    if ([self isVideoSelected]) {
        imgType =YDImgsTypeAssetVideo;
    }
    else {
        if (self.allSelctedAssets.count >0) {
            imgType = YDImgsTypeAssetImg;
        }
    }
    return imgType;
}


- (NSArray<YDAlbumModel *> *)changeDisplayAlbumsWithType:(YDAlbumDisplayType)displayType {
    switch (displayType) {
        case YDAlbumDisplayTypeTotal:
            return _totalAlbums;
            break;
        case YDAlbumDisplayTypeImageOnly:
            return _imageAlbums;
            break;
        case YDAlbumDisplayTypeVideoOnly:
            return _videoAlbums;
            break;
        default:
            break;
    }
    return @[];
}

- (void)configureVariables {
    switch (_albumAssetType) {
        case YDAlbumAssetTypeAlbumAssetBoth: {
            _showAssets = YES;
        }
            break;
        case YDAlbumAssetTypeAssetFlowOnly: {
            _showAssets = YES;
        }
            break;
        case YDAlbumAssetTypeAlbumListOnly: {
            _showAssets = NO;
        }
            break;
        default:
            break;
    }
    [self.view showViewWithIsAsset:_showAssets];
}

- (void)dealloc {
    NSLog(@"gh- YDImgPickerViewController dealloc");
}

@end
