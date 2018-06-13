//
//  YDCommonImgBrowser.h
//  SportsBar
//
//  Created by Aka on 2017/11/20.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDCommonImgBrowserView.h"

@class YDBrowserImgModel;
@class TZAssetModel;
@class YDBaseCollectionView;

typedef NS_ENUM(NSInteger, YDImgsType) {
    YDImgsTypeImgNotSure = -1,
    YDImgsTypeImg = 0,
    YDImgsTypeImgName,
    YDImgsTypeImgUrlStrings,
    YDImgsTypeImgBrowserModel,
    //    注意这里分割 img 上面、 asset的在下面
    YDImgsTypeAssetNotSure,
    YDImgsTypeAssetImg,
    YDImgsTypeAssetVideo,
};

typedef NS_ENUM(NSInteger, YDNavBarRightItemType) {
    YDNavBarRightItemTypeNone = 0,
    YDNavBarRightItemTypeSelected,
};

@interface YDCommonImgBrowser : UIViewController

@property (nonatomic, strong, readonly) YDCommonImgBrowserView *view;

//@property (nonatomic, strong, readonly) YDBaseCollectionView *collectionView;

- (TZAssetModel *)getAssetBeforeEditor;
- (void)replaceBeforeEditorAsset:(TZAssetModel *)asset0 withAsset:(TZAssetModel *)asset1;
- (void)replaceBeforeEditorAssetATSelected:(TZAssetModel *)asset0 withAsset:(TZAssetModel *)asset1;

//- (void)configureWithImgs:(NSArray<UIImage *> *) imgs toIndex:(NSInteger)toIndex;
//- (void)configureWithImgNames:(NSArray<NSString *> *)imgNames toIndex:(NSInteger)toIndex;
//- (void)configureWithImgUrlStrings:(NSArray<NSString *> *)imgUrlStrings toIndex:(NSInteger)toIndex;
//- (void)configureWithImgs:(NSArray *)imgs type:(YDImgsType)type toIndex:(NSInteger)toIndex;
//- (void)configureWithBrowserImgs:(NSArray <YDBrowserImgModel *> *)imgs toIndex:(NSInteger)toIndex;
@end
