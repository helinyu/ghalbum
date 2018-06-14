//
//  YDPhotoTakeViewController.m
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPhotoTakeViewController.h"
#import "YDPhotoTakenBottomView.h"
#import "YDPhotoTakenContentView.h"
#import "YDPhotoHasTakeView.h"
//#import "YDCircleEditorViewController.h"
//#import "WBGImageEditor.h"
#import "TZAssetModel.h"
#import "YDObtainManagerMgr.h"
#import "YDLeftRightBtnView.h"
//#import "WBGImageEditor.h"
//#import "WBGMoreKeyboardItem.h"
//#import "YDFilterSelectedView.h"
//#import "YDWatermark.h"
//#import "YDWatermarkMgr.h"
//#import "YDCircleRootViewController.h"
#import "YDAlbumService.h"
#import "YDPhotoTakenBottomView.h"
#import "YDPhotoTakenView.h"
//#import "YDTools.h"
//#import "UIImage+YDAdd.h"
//#import "YDTools.h"

@interface YDPhotoTakeViewController ()
//<WBGImageEditorDelegate,WBGImageEditorDataSource>

@property (nonatomic, strong) YDPhotoTakenBottomView *beforeTakenBottomView;
@property (nonatomic, strong) YDPhotoHasTakeView *afterTakenBottomView;
@property (nonatomic, strong) UIView *bottomWrapperView;

@property (nonatomic, strong) YDPhotoTakenContentView *contentView;

@property (nonatomic, strong) UIImage *takeImg;
@property (nonatomic, assign) BOOL isCameraFront;

@property (nonatomic, assign) BOOL isPreviewImg;

@end

static const CGFloat kBottomViewH = 100.f;

@implementation YDPhotoTakeViewController

/**
 *  create subviews
 */
- (void)msComInit {
    
//    [self yd_navBarInitWithStyle:YDNavBarStyleGray];
    
    _bottomWrapperView = [UIView new];
    [self.view addSubview:_bottomWrapperView];

    _afterTakenBottomView = [YDPhotoHasTakeView new];
    [_bottomWrapperView addSubview:_afterTakenBottomView];
    
    _beforeTakenBottomView = [YDPhotoTakenBottomView new];
    [_bottomWrapperView addSubview:_beforeTakenBottomView];
    
    CGFloat contentViewH = SCREEN_HEIGHT_V0 - YDTopLayoutH - DWF(kBottomViewH);
    if (IS_SCREEN_SIZE_5) {
        contentViewH = SCREEN_HEIGHT_V0 - YDTopLayoutH - DWF(kBottomViewH + 34.f);
    }
    _contentView = [[YDPhotoTakenContentView alloc] initWithFrame:CGRectMake(0.f, YDTopLayoutH, SCREEN_WIDTH_V0, contentViewH)];
    
    [self.view addSubview:_contentView];
    
    [self createViewConstraints];
}

//- (void)msNavBarInit:(YDNavigationBar *)navBar {
//    self.navBar.topItem.title = MSLocalizedString(@"拍照", nil);
//    self.navBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_login_back"] style:UIBarButtonItemStyleDone target:self action:@selector(yd_popUp)];
//    self.navBar.topItem.leftBarButtonItem.tintColor = YDC_TEXT;
//}

/**
 *  create constraints
 */
- (void)createViewConstraints {
    
    [_bottomWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        CGFloat bottomViewH = kBottomViewH;
        if (IS_SCREEN_SIZE_5) {
            bottomViewH += 34.f;
        }
        make.height.mas_equalTo(DWF(bottomViewH));
    }];
    
    [_beforeTakenBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_beforeTakenBottomView.superview);
        make.height.mas_equalTo(DEVICE_WIDTH_OF(kBottomViewH));
    }];
    
    [_afterTakenBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_afterTakenBottomView.superview);
        make.height.mas_equalTo(DEVICE_WIDTH_OF(kBottomViewH));
    }];
    
}

/**
 *  notification bind & touch events bind & delegate bind
 */
- (void)msBind {

    __weak typeof (self) wSelf = self;
    _beforeTakenBottomView.actionBlock = ^(YDPhotoTakeActionType type) {

//        TZAssetAuthorizationStatus status = [TZImageManager getCameraAuthorStatus];
//        if (status == TZAssetAuthorizationStatusNotAuthorized) {
//            [wSelf yd_alertConfirm:@"亲！您已经禁止了访问拍照权限" message:@"请前往设置->隐私->相机获取相册权限"];
//            [wSelf.navigationController popViewControllerAnimated:YES];
//            return ;
//        }
        
        if (type == YDPhotoTakeActionTypeTake) {
            [wSelf.contentView.takenView takePhotoThen:^(NSData *imgData, UIImage *img) {
                if (!img) {
                    return ;
                }
                
                [wSelf.contentView.takenView stopRunning];

                _isPreviewImg = YES;
                [wSelf displayViewWithPreviewFlag:wSelf.isPreviewImg];

                CGFloat imgOriginWidth = SCREEN_WIDTH_V0;
                CGFloat imgOriginHeight = SCREEN_HEIGHT_V0 - YDTopLayoutH - DWF(kBottomViewH);
                CGFloat ratio = img.size.width / imgOriginWidth;
                CGFloat imgHeight = imgOriginHeight *ratio;
                //有待不同的相机进行适配
                CGRect newFrame = CGRectMake(0.f, (YDTopLayoutH +18.f) *ratio, img.size.width, imgHeight);
                
//                UIImage *customImg = [YDTools fixOrientation:img];
                
//                if (wSelf.isCameraFront) {
//                    customImg = [customImg yd_imageByFlipHorizontal];
//                }
//
//                customImg = [YDTools cutImage:customImg withRect:newFrame];
//                wSelf.takeImg = customImg;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    wSelf.contentView.displayImgView.image = customImg;
//                    _takeImg = customImg;
//                });
            }];
        }
        else if (type == YDPhotoTakeActionTypeToggle) {
            UIButton *sender = wSelf.beforeTakenBottomView.cancelAndToggleBtnView.rightBtn;
            sender.tag = 1;
            [wSelf.contentView.takenView toggleCamera];
            wSelf.isCameraFront = !wSelf.isCameraFront;
        }else {
//            [wSelf yd_popUp];
        }
    };
    
    _afterTakenBottomView.actionBlock = ^(YDPhotoTakeActionType type) {
        __strong typeof (wSelf) strongSelf = wSelf;
        
        if (type == YDPhotoHasTakeActionTypeCancel) {
            strongSelf.isPreviewImg = NO;
            [strongSelf displayViewWithPreviewFlag:strongSelf.isPreviewImg];
            [strongSelf.contentView.takenView startRunning];
//            if ([strongSelf yd_isLoading]) {
//                [strongSelf yd_endLoading];
//            }
        }
        else {
//            TZAssetAuthorizationStatus status = [TZImageManager getAuthorizationStatus];
//            if (status == TZAssetAuthorizationStatusNotAuthorized) {
//                [wSelf yd_alertConfirm:@"亲！您已经禁止了访问相册权限" message:@"请前往设置->隐私->相册获取相册权限"];
//                if ([strongSelf yd_isLoading]) {
//                    [strongSelf yd_endLoading];
//                }
//                return ;
//            }
            
            if (type == YDPhotoHasTakeActionTypeEdit) {
//                if ([strongSelf yd_isLoading]) {
//                    [strongSelf yd_endLoading];
//                }
//                strongSelf.takeImg = [YDTools compressImageTo1M:strongSelf.takeImg];
//                WBGImageEditor *vc = [[WBGImageEditor alloc] initWithImage:strongSelf.takeImg delegate:strongSelf dataSource:wSelf];
//                [strongSelf presentViewController:vc animated:YES completion:nil];
            }
            else if (type == YDPhotoHasTakeActionTypeNext) {
                {
                    if (OBTAIN_MGR(YDAlbumMgr).selectedAssets.count >= kMaxChoiceImgNum) {
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [strongSelf yd_popText:@"图片选择数目已经达到上限"];
//                            if ([strongSelf yd_isLoading]) {
//                                [strongSelf yd_endLoading];
//                            }
                        });
                        return;
                    }
                    [[TZImageManager manager] savePhotoWithImage:strongSelf.takeImg completion:^(NSError *error) {
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [strongSelf yd_popText:@"保存图片失败"];
//                                if ([strongSelf yd_isLoading]) {
//                                    [strongSelf yd_endLoading];
//                                }
                            });
                            return ;
                        }
                        [OBTAIN_MGR(YDAlbumMgr) loadLastAssetComplete:^(TZAssetModel *lastAsset) {
                            if (!lastAsset) {
                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [strongSelf yd_popText:@"获取最新图片失败"];
//                                    if ([strongSelf yd_isLoading]) {
//                                        [strongSelf yd_endLoading];
//                                    }
                                });
                                return ;
                            }
                            lastAsset.isSelected = YES;
                            [OBTAIN_MGR(YDAlbumMgr).selectedAssets addObject:lastAsset];
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                if ([strongSelf yd_isLoading]) {
//                                    [strongSelf yd_endLoading];
//                                }
                                [wSelf dismissViewControllerAnimated:YES completion:nil];
                            });
                        }];
                    }];
                }
            }
        }
    };
}

- (void)adaptNavigationViewControllersWithVC:(UIViewController *)vc {
    NSMutableArray *vcs = @[].mutableCopy;
    [vcs addObjectsFromArray:self.navigationController.viewControllers];
    for (NSInteger index = vcs.count- 1; index <vcs.count; index--) {
//        if (![vcs[index] isKindOfClass:[YDCircleRootViewController class]]) {
//            [vcs removeObjectAtIndex:index];
//        }else {
//            break;
//        }
    }
    if (vcs.count > 0) {
        [vcs addObject:vc];
        self.navigationController.viewControllers = vcs;
    }else {
        [vcs addObject:self.navigationController.viewControllers[0]];
        [vcs addObject:vc];
        self.navigationController.viewControllers = vcs;
    }
}

/**
 *  data init
 */
- (void)msDataInit {
    
    [self waterImgInit];
}

/**
 *  static style
 */
- (void)msStyleInit {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  language init
 */
- (void)msLangInit {
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self msComInit];
    [self msDataInit];
    [self msBind];
    [self msStyleInit];
    [self msLangInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self displayViewWithPreviewFlag:_isPreviewImg];
    if (!_isPreviewImg) {
        [self.contentView.takenView startRunning];
    }else {
        self.contentView.displayImgView.image = _takeImg;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
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

- (void)waterImgInit {
//    [[YDWatermarkMgr sharedMgr] netLoadWalkWaterMakerImgs:nil];
}

#pragma mark -- load next img

//- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
//    NSData *data = UIImagePNGRepresentation(image);
//    MSLogD(@"gh- image :%@ , data length : %lu",image,(unsigned long)data.length);
//    __weak typeof (self) wSelf = self;
//    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        _isPreviewImg = YES;
//        [wSelf displayViewWithPreviewFlag:_isPreviewImg];
//        MSLogD(@"gh- set display view");
//        wSelf.contentView.displayImgView.image = image;
//        wSelf.takeImg = image;
//}

//- (void)filterSelectedView:(YDFilterSelectedView *)view didSeletedIndex:(NSInteger)index {
//    MSLogD(@"index = %@", @(index));
//}
//
//- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
//
//}

#pragma mark -- editory deal with

//- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
//    NSMutableArray *itemsArray = @[].mutableCopy;
//    NSArray *waterMakes = [[YDWatermarkMgr sharedMgr] getDownloadWatermarkImgs];
//    for (YDWatermark *m in waterMakes) {
//        NSString *title = m.name;
//        title = @"";
//        NSString *imgPath = @"";
//        UIImage *img = m.previewImg;
//        WBGMoreKeyboardItem *item = [WBGMoreKeyboardItem createByTitle:title imagePath:imgPath image:img];
//        item.trueImage = m.contentImg;
//        [itemsArray addObject:item];
//    }
//    return itemsArray.copy;
//}

- (void)displayViewWithPreviewFlag:(BOOL)previewImgFlag {
    self.contentView.takenView.hidden = previewImgFlag;
    self.beforeTakenBottomView.hidden = previewImgFlag;
    self.contentView.displayImgView.hidden = !previewImgFlag;
    self.afterTakenBottomView.hidden = !previewImgFlag;
}

- (void)dealloc {
}

@end
