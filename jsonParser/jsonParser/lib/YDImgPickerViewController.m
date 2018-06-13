//
//  YDImgPickerViewController.m
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgPickerViewController.h"
#import "YDImgPickerView.h"
//#import "YDBaseCollectionView.h"
//#import "YDBaseTableView.h"

#import "YDImgPickerCCell.h"
#import "YDImgPickerTakeCCell.h"
//#import "YDImgTitleIconTCell.h"
#import "YDPreviewBottomView.h"
#import "YDPickerBottomView.h"
#import "YDImgPickerVCTitleView.h"

#import "YDObtainManagerMgr.h"
//#import "YDAlbumMgr.h"
//#import "NSString+YDAdd.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
#import "YDAlbumTCell.h"

#import "YDPhotoTakeViewController.h"
//#import "YDCircleEditorViewController.h"

#import "TZImageManager.h"
//#import "YDCommonImgBrowserProtocol.h"
//#import "BHServiceManager.h"
//#import "MSDefine.h"
//#import "YDPreference.h"

#define kCellLength (SCREEN_WIDTH_V0 -(kSpaceLength * (kCCellNumOfALine -1)))/kCCellNumOfALine

typedef NS_ENUM(NSInteger, YDAssetSelectedType) {
    YDAssetSelectedTypeNotSure,
    YDAssetSelectedTypeImg,
    YDAssetSelectedTypeVideo,
};

@interface YDImgPickerViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) YDImgPickerVCTitleView *titleContentView;
@property (nonatomic, strong) YDImgPickerView *view;

@property (nonatomic, assign) BOOL isAlbumDisplay; // 这里面是两个进行切换

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, assign) BOOL isSecondMoreTime;

@property (nonatomic, assign) NSInteger leafChoiceNum;
@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *allSelctedAssets;

@property (nonatomic, assign) YDCommingSourceType previewType;

//  version 2.0
@property (nonatomic, strong) TZAlbumModel *selectedAlbum;

//vesion 3.0
@property (nonatomic, strong) NSArray<TZAssetModel *> *videoAssets;
@property (nonatomic, assign) BOOL isVideoFilter;

@property (nonatomic, assign) BOOL canLoadVideo;
//@property (nonatomic, strong) NSArray *selectedAssets;

@end

static NSString *const kImgPickerChoiceCellCIdentifier = @"k.img.picker.choice.cell.C.identifier";
static NSString *const kImgPickerTakeCellCIdentifier = @"k.img.picker.take.cell.C.identifier";
static NSString *const kImgPickerAblumCellTIdentifier = @"k.img.picker.ablum.cell.T.identifier";

static NSString *const kTitleText = @"相机胶卷";
static NSString *const kVidelTitle = @"视频";

static const CGFloat kTableViewCellH = 96.f;
static const CGFloat kSpaceLength = f1;
static const CGFloat kCCellNumOfALine = 3;

static NSInteger const kVideoMaxDuration = 180;
static NSInteger const kVideoMinDuration = 3;

#define Main_Queue(x) dispatch_async(dispatch_get_main_queue(), ^{x});

@implementation YDImgPickerViewController

YD_DYNAMIC_VC_VIEW([YDImgPickerView class]);

- (void)configureSelectedAssets:(NSArray *)assets then:(void(^)(NSArray *assets, BOOL change))then {
    _allSelctedAssets = @[].mutableCopy;
    [_allSelctedAssets addObjectsFromArray:assets];
    _canLoadVideo = [[YDPreference sharedUserPreference] boolForKey:[NSString stringWithFormat:@"%@_%@",CIRCLE_VIDEO_AUTH,[YDAppInstance userId]]];
}

/**
 *  create subviews
 */
- (void)msComInit {
    
    [super msComInit];
    
    [self yd_navBarInitWithStyle:YDNavBarStyleGray];
    
    [self.view updateDisplayViewWithIsUP:_isAlbumDisplay];
    
    [self createViewConstraints];
    
    if (![self yd_isLoading]) {
        [self yd_startLoading];
    }
}

/**
 *  create constraints
 */
- (void)createViewConstraints {
    [super createViewConstraints];
}

/**
 *  notification bind & touch events bind & delegate bind
 */
- (void)msBind {
    [super msBind];

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
    [super msDataInit];
    
    [self loadAlbumsInit];
    [self someBaseDataInit];
    [self bottomViewInit];
}

- (void)someBaseDataInit {
    _leafChoiceNum = kMaxChoiceImgNum - _allSelctedAssets.count;
    [self reloadCollectionView];
}

- (void)loadAlbumsInit {
    TZAssetAuthorizationStatus status = [TZImageManager getAuthorizationStatus];
    switch (status) {
        case TZAssetAuthorizationStatusNotAuthorized:
        {
            NSString *tipString = @"";
            if (!tipString) {
                NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
                if (!appName) {
                    appName = [mainInfoDictionary objectForKey:(NSString *)kCFBundleNameKey];
                }
                tipString = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
            }
            [self yd_popText:tipString];
            return;
        }
            break;
        case TZAssetAuthorizationStatusAuthorized:
        {
            [self loadActualAlbum];
        }
            break;
        case TZAssetAuthorizationStatusNotDetermined:
        {
            __weak typeof (self) wSelf = self;
            [TZImageManager requestAuthorization:^(TZAssetAuthorizationStatus status) {
                if (status == TZAssetAuthorizationStatusAuthorized) {
                    [wSelf loadActualAlbum];
                }
            }];
        }
            break;
        default:
        {
            MSLogD(@"gh- TZAssetAuthorizationStatusNotUsingPhotoKit");
        }
            break;
    }
}

- (void)loadActualAlbum {
    _albums = @[].mutableCopy;
    dispatch_async_on_main_queue(^{
        if (!self.yd_isLoading) {
            [self yd_startLoading];
        };
    });

    [[TZImageManager manager] getAllAlbums:_canLoadVideo allowPickingImage:YES completion:^(NSArray<TZAlbumModel *> *models) {
        [_albums addObjectsFromArray:models];
        if (_albums.count >0) {
            _selectedAlbum = _albums.firstObject;
        }
        [self reloadAssetsAndReloadView];
    }];
}

- (void)reloadAssetsAndReloadView {
    [[TZImageManager manager] base_getAssetsFromFetchResult:_selectedAlbum.result allowPickingVideo:_canLoadVideo allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models, NSArray<TZAssetModel *> *videos) {
        _selectedAlbum.models = models;
        _selectedAlbum.videos = videos;
        [self reloadCollectionView];
    }];
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
        MSLogD(@"gh- index : %ld",(long)index);
        if (index == YDPreviewActionTypeLeft) {
            if (wSelf.allSelctedAssets.count <= 0) {
                [wSelf yd_popText:@"请选择照片"];
                return ;
            }
            
           id<YDCommonImgBrowserProtocol> vc = [[BHServiceManager sharedManager] createService:@protocol(YDCommonImgBrowserProtocol) withServiceName:nil shouldCache:NO];
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
            [wSelf reloadCollectionView];
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
    [super msStyleInit];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  language init
 */
- (void)msLangInit {
    [super msLangInit];
}

#pragma mark - life cycle not need to change nomal

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isSecondMoreTime) {
        if (!_isAlbumDisplay) {
            [self reloadCollectionView];
        }
    }else {
        _isSecondMoreTime = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.yd_isLoading) {
        [self yd_endLoading];
    }
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
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDAlbumTCell *cell = [tableView dequeueReusableCellWithIdentifier:kImgPickerAblumCellTIdentifier forIndexPath:indexPath];
    TZAlbumModel *album = _albums[indexPath.row];
    cell.model = album;
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
    OBTAIN_MGR(YDAlbumMgr).selectedAlbum = _selectedAlbum = _albums[indexPath.row];
    [self _updateTitleViewPostionWithText:OBTAIN_MGR(YDAlbumMgr).selectedAlbum.name];
    [self.view updateDisplayViewWithIsUP:NO];
    [self reloadAssetsAndReloadView];
    [[YDStatisticsMgr sharedMgr] eventCircleAlbumChange];
}

- (void)_updateTitleViewPostionWithText:(NSString *)text {
    CGFloat titleViewW = [self _titleViewWidthWithText:text];
    [_titleContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleViewW);
    }];
    [_titleContentView configureWithTitle:_selectedAlbum.name isUpDirection:NO];
}

#pragma mark -- collectionView datasource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isVideoFilter) return _selectedAlbum.videos.count;
    return (_selectedAlbum.models.count + i1);
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
            asset= _selectedAlbum.models[index];
        }
        else {
            asset = _selectedAlbum.videos[index];
        }
        [cell configureWithAsset:asset then:^{
            TZAssetModel *firstAsset = wSelf.allSelctedAssets.firstObject;
            if (!asset.isSelected && firstAsset) {
                if (wSelf.allSelctedAssets.count >= kMaxChoiceImgNum) {
                    [wSelf yd_popText:@"最多只能够选择9张"];
                    return ;
                }
                if (firstAsset.type ==TZAssetModelMediaTypeVideo){
                    if (asset.type == TZAssetModelMediaTypeVideo) {
                        [wSelf yd_popText:@"最多选择一个视频"];
                    }
                    else if (asset.type == TZAssetModelMediaTypePhoto) {
                        [wSelf yd_popText:MSLocalizedString(@"图片和视频不能够同时选择", nil)];
                    }
                    else {
                        [wSelf yd_popText:MSLocalizedString(@"您已经选择了视频类型并且只可以选择一个视频", nil)];
                    }
                    return;
                }
               
                if ((firstAsset.type ==TZAssetModelMediaTypePhoto) && (asset.type == TZAssetModelMediaTypeVideo)){
                    [wSelf yd_popText:MSLocalizedString(@"图片和视频不能够同时选择", nil)];
                    return;
                }
            }
            
            if (asset.type ==TZAssetModelMediaTypeVideo){
                PHAsset *phAsset =asset.asset;
                if (phAsset.duration > kVideoMaxDuration) {
                    [wSelf yd_popText:@"视频时长不能长于3分钟"];
                    return;
                }
                if (phAsset.duration <=kVideoMinDuration) {
                    [wSelf yd_popText:@"视频时长不能小于3秒"];
                    return;
                }
            }

            
            if (!asset.isSelected) {
                asset.isSelected = YES;
                [wSelf.allSelctedAssets addObject:asset];
                wSelf.leafChoiceNum--;
                [wSelf.view.pickerButtomView updateBtnEnable:YES];
            }else {
                for (TZAssetModel *model_item in wSelf.allSelctedAssets) {
                    NSString *outIdentifier =[[TZImageManager manager] getAssetIdentifier:asset.asset];
                    NSString *innerIdentifier = [[TZImageManager manager] getAssetIdentifier:model_item.asset];
                    if ([outIdentifier isEqualToString:innerIdentifier]) {
                        [wSelf.allSelctedAssets removeObject:model_item];
                        wSelf.leafChoiceNum++;
                        asset.isSelected = NO;
                        break;
                    }
                }
            }
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
    if (indexPath.row == kIndex0 && !_isVideoFilter) {
        if ([self isVideoSelected]) {
            [self yd_popText:@"您已经选择了视频，暂时不支持拍照"];
            return;
        }
        
        [self _configurePhotoTaken];
        return;
    }
   
    // 选择图片、视频的处理
    OBTAIN_MGR(YDAlbumMgr).sourceType = YDPhotoSourceTypeAlbumDidSelected;

    NSInteger index = indexPath.item;
    NSArray *allAssets = _selectedAlbum.videos;
    if (!_isVideoFilter) {
        index = indexPath.item -1;
        allAssets = _selectedAlbum.models;
    }
    id<YDCommonImgBrowserProtocol> vc = [[BHServiceManager sharedManager] createService:@protocol(YDCommonImgBrowserProtocol) withServiceName:nil shouldCache:NO];
    [vc configureWithTotalImgs:allAssets selectedImgs:_allSelctedAssets.copy toIndex:index type:[self _getAssetType] rightItemType:YDNavBarRightItemTypeSelected];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- custom methods

- (void)_configurePhotoTaken {
        TZAssetAuthorizationStatus status = [TZImageManager getCameraAuthorStatus];
        if (status == TZAssetAuthorizationStatusNotAuthorized) {
            [self _alertCamaraInfoWhileNotAuthorized];
            return;
        }
        else if (status == TZAssetAuthorizationStatusNotDetermined) {
            [TZImageManager requestCameraAuthorization:^(TZAssetAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == TZAssetAuthorizationStatusAuthorized) {
                        [self _toPhotoTakenVC];
                    }else {
                        [self _alertCamaraInfoWhileNotAuthorized];
                    }
                    return ;
                });
            }];
        }
        else {
            [self _toPhotoTakenVC];
        }
}

- (void)_alertCamaraInfoWhileNotAuthorized {
    [self yd_alertSingle:@"请打开相机权限" message:@"您已经禁止了拍照权限，请前往设置->隐私->相机授权应用拍照权限" configure:^(MMPopupItem *item) {
        MSLogD(@"gh- 确定");
    }];
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
    CGFloat textW = [NSString yd_textWidthWithText:MSLocalizedString(text, nil) rSize:f18];
    CGFloat imgW = f13;
    CGFloat textToImgW = f6;
    CGFloat titleViewW = textW + imgW + textToImgW;
    return titleViewW;
}

- (void)yd_popUp {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ydCircleEditorBack object:nil];
    [[YDStatisticsMgr sharedMgr] eventImgPickerback];
}

- (void)checkAllSelectedAssets {
    if (_allSelctedAssets.count >0) {
        NSMutableArray *mSelectAssets = @[].mutableCopy;
        for (TZAssetModel *item in _allSelctedAssets) {
            [mSelectAssets addObject:item.asset];
        }
        for (TZAssetModel *model in _selectedAlbum.models) {
            model.isSelected = NO;
            if ([[TZImageManager manager] isAssetsArray:mSelectAssets containAsset:model.asset]) {
                model.isSelected = YES;
            }
        }
    }
}

- (void)reloadCollectionView {
    [self checkAllSelectedAssets];
    dispatch_async_on_main_queue(^{
        if (self.yd_isLoading) {
            [self yd_endLoading];
        }
        [self.view.collectionView reloadData];
    });
}

- (void)reloadTableView {
    [self checkAllSelectedAssets];
    [self.view.tableView reloadData];
}

- (BOOL)isVideoSelected {
    if (_allSelctedAssets.count >0) {
        TZAssetModel *firstAsset = _allSelctedAssets.firstObject;
        if (firstAsset.type == TZAssetModelMediaTypeVideo) {
            return YES;
        }
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

- (void)dealloc {
    MSLogD(@"gh- YDImgPickerViewController dealloc");
}

@end
