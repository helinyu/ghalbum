//
//  YDImgZoomCCell.h
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseCollectionViewCell.h"

@interface YDImgZoomCCell : YDBaseCollectionViewCell

@property (nonatomic, strong) UIScrollView *zoomView;

@property (nonatomic, strong) UIView *imgBgView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIButton *indexBtn;

- (void)baseInit;

@end
