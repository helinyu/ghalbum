//
//  PHAsset+YdAdd.m
//  jsonParser
//
//  Created by mac on 15/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PHAsset+YdAdd.h"
#import "YDCategoriesMacro.h"
#import <objc/runtime.h>

@implementation PHAsset (YdAdd)

YDSYNTH_DYNAMIC_PROPERTY_OBJECT(assetTypeObj, setAssetTypeObj, RETAIN_NONATOMIC, NSNumber *);

- (YDPHAssetType)fetchAssetType {
    YDPHAssetType type = YDPHAssetTypeImage;
    if (self.mediaType == PHAssetMediaTypeVideo)
        type = YDPHAssetTypeVideo;
    else if (self.mediaType == PHAssetMediaTypeAudio)
        type = YDPHAssetTypeAudio;
    else if (self.mediaType == PHAssetMediaTypeImage) {
        if (AFTER_IOS9_1) {
            if (self.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                type = YDPHAssetTypeLiveImage;
            }
        }
        // Gif
        if ([[self valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = YDPHAssetTypeImageGif;
        }
    }
    return type;
}

@end
