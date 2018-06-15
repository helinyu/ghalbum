//
//  YDAlbumModel.h
//  jsonParser
//
//  Created by mac on 15/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHFetchResult;
@class PHAsset;

@interface YDAlbumModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) PHFetchResult *result;
@property (nonatomic, strong) NSArray<PHAsset *> *assets;
@property (nonatomic, strong) NSArray<PHAsset *> *selectedAssets;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, assign) BOOL isCameraRoll;

- (void)setResult:(id)result needFetchAssets:(BOOL)needFetchAssets;

@end
