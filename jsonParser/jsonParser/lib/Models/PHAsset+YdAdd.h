//
//  PHAsset+YdAdd.h
//  jsonParser
//
//  Created by mac on 15/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Photos/Photos.h>

typedef NS_OPTIONS(NSInteger, YDPHAssetType) {
    YDPHAssetTypeImage =1,
    YDPHAssetTypeLiveImage,
    YDPHAssetTypeImageGif,
    YDPHAssetTypeVideo,
    YDPHAssetTypeAudio
};

@interface PHAsset (YdAdd)

@property (nonatomic, strong) NSNumber *assetTypeObj;
- (YDPHAssetType)fetchAssetType; // configure the asset type

@end
