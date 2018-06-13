//
//  YDImgPIckerCCell.h
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgIconCCell.h"
@class TZAssetModel;


@interface YDImgPickerCCell : YDImgIconCCell

- (void)configureWithImgView:(NSString *)imgName isChoice:(BOOL)isChoice;
- (void)configureWithImgView:(NSString *)imgName isChoice:(BOOL)isChoice then:(VoidBlock)block;

- (void)configureWithImg:(UIImage *)img isChoice:(BOOL)isChoice;
- (void)configureWithImg:(UIImage *)img isChoice:(BOOL)isChoice then:(VoidBlock)block;

- (void)configureWithAsset:(TZAssetModel *)item then:(VoidBlock)block;

/// 只装配图片
- (void)configureWithImge:(UIImage *)img;


//version 2.0
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@end
