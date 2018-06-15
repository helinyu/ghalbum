//
//  YDAlbumAssetProtocol.h
//  jsonParser
//
//  Created by mac on 15/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHFetchResult;

@protocol YDAlbumAssetProtocol <NSObject>

// Decide asset show or not't
// 决定照片显示与否
- (BOOL)isAssetCanSelect:(id)asset;

@end

@protocol YDAlbumPickerProtocol <NSObject>

// Decide album show or not't
// 决定相册显示与否 albumName:相册名字 result:相册原始数据
- (BOOL)isAlbumCanPick:(NSString *)albumName result:(PHFetchResult *)result;

@end
