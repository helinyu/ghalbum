//
//  YDAlbumMgr.h
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//


#import <Foundation/Foundation.h>

@class TZAssetModel;
@class TZAlbumModel;

typedef NS_ENUM(NSInteger, YDPhotoSourceType) {
    YDPhotoSourceTypeNone =0,
    YDPhotoSourceTypeAlbum ,
    YDPhotoSourceTypeAlbumDidSelected,
};

@interface YDAlbumMgr : NSObject

@property (nonatomic, strong) NSMutableArray<TZAlbumModel *> *albums;
@property (nonatomic, strong) TZAlbumModel *selectedAlbum;

@property (nonatomic, strong) NSMutableArray<TZAssetModel *> *selectedAssets;
@property (nonatomic, assign) YDPhotoSourceType sourceType;

- (void)clearDatas;

- (void)loadLastAssetComplete:(void(^)(TZAssetModel *lastAsset))complete;

@end
