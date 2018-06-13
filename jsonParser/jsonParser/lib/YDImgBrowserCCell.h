//
//  YDImgBrowserCCell.h
//  SportsBar
//
//  Created by Aka on 2017/11/20.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgZoomCCell.h"
@class TZAssetModel;
@class AVPlayerLayer;

@interface YDImgBrowserCCell : YDImgZoomCCell

@property (nonatomic, copy) VoidBlock longPressBlock;
@property (nonatomic, copy) VoidBlock tapBlock;
@property (nonatomic, copy) VoidBlock tapPlayVideoblock;

- (void)configureWithImg:(UIImage *)img longPress:(VoidBlock)longPressBlock tap:(VoidBlock)tapBlock;

// for the TZAssetModel
@property (nonatomic, strong) TZAssetModel *assetItem;
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
- (void)showVideoWithPlayerLayer:(AVPlayerLayer *)playerLayer;
- (void)showImg;

@end
