//
//  YDAlbumMgr.m
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDAlbumMgr.h"
#import <Photos/Photos.h>
#import "YDAlbumService.h"

@interface YDAlbumMgr ()

@end

@implementation YDAlbumMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedAssets = @[].mutableCopy;
    }
    return self;
}

#pragma mark -- for using

- (void)clearDatas {
    [_albums removeAllObjects];
    _selectedAlbum = nil;
    [_selectedAssets removeAllObjects];
    _sourceType = YDPhotoSourceTypeNone;
}

- (void)loadLastAssetComplete:(void(^)(TZAssetModel *lastAsset))complete {
//    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:YES completion:^(TZAlbumModel *model) {
//        [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
//            TZAssetModel *lastAsset = models.firstObject;
//            !complete? :complete(lastAsset);
//        }];
//    }];
}

@end
