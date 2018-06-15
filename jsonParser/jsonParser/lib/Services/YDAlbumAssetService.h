//
//  YDAlbumService.h
//  jsonParser
//
//  Created by mac on 14/6/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDAlbumAssetProtocol.h"
#import "YDAlbumModel.h"

@interface YDAlbumAssetService : NSObject

//基础的获取相册的函数
- (void)base_getAllAlbumsWithAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage needFetchAssets:(BOOL)needFetchAssets completion:(void(^)(NSArray <YDAlbumModel *>*albums, NSArray<YDAlbumModel *> *videoAlbums, NSArray<YDAlbumModel *> *imageAlbums))then;

/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

@property (nonatomic, weak) id<YDAlbumPickerProtocol> albumPickerDelegate;


- (BOOL)isCameraRollAlbum:(id)metadata;

#pragma mark - image properties

@property (nonatomic, assign) CGFloat imagePreviewMaxWidth;// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat imageWidth; // The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽

@property (nonatomic, assign) CGSize assetGridThumbnailSize; // 缩略图的大小
@property (nonatomic, assign) BOOL shouldFixOrientation; // 是否需要修正图片的方向

#pragma mark - cover image
- (void)getDefaultCoverImageWithAlbumItem:(YDAlbumModel *)albumItem then:(void (^)(UIImage *))then;
- (void)getCoverImageCustomSizeWithAlbumItem:(YDAlbumModel *)albumItem CGSize:(CGSize *)size then:(void (^)(UIImage *))then;


#pragma mark - deal with image
- (UIImage *)fixImageOrientation:(UIImage *)aImage;
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

@end
