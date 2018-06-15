//
//  YDImgPickerViewController.h
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, YDAlbumAssetType) {
    YDAlbumAssetTypeAlbumAssetBoth = 1<<0, // 在一个vc里面展示两种切换
    YDAlbumAssetTypeAlbumListOnly = 1<<1, //只是展示相册
    YDAlbumAssetTypeAssetFlowOnly = 1<<2, //只是展示相册里面的图片
};

@interface YDImgPickerViewController : UIViewController
@property (nonatomic, assign) YDAlbumAssetType albumAssetType; //展示能力 (必须要设置)
- (void)configureSelectedAssets:(NSArray *)assets then:(void(^)(NSArray *assets, BOOL change))then;

//test
- (void)configureVariables;

@end
