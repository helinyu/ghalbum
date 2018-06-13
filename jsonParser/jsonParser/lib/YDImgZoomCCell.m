//
//  YDImgZoomCCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgZoomCCell.h"

@interface YDImgZoomCCell ()<UIScrollViewDelegate>

@end

static const CGFloat kIndexBtnMarginTop = 33.f;
static const CGFloat kIndexBtnMarginRight = 14.f;
static const CGFloat kIndexBtnLength = 24.f;

@implementation YDImgZoomCCell

- (void)baseInit {
    
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _zoomView = [UIScrollView new];
        [self.contentView addSubview:_zoomView];
        
        _imgBgView = [UIView new];
        [_zoomView addSubview:_imgBgView];
        
        _imgView = [UIImageView new];
        [_imgBgView addSubview:_imgView];
        
        _indexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_indexBtn];
    }
    
    {
        [_zoomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_zoomView.superview);
        }];
        
        [_imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_imgBgView.superview);
        }];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_imgView.superview);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
        
        [_indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(kIndexBtnMarginTop));
            make.right.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(-kIndexBtnMarginRight));
            make.width.height.mas_equalTo(DEVICE_WIDTH_OF(kIndexBtnLength));
        }];
    }
    
    {
        _indexBtn.layer.cornerRadius = DEVICE_WIDTH_OF(kIndexBtnLength/2);
        [_indexBtn setClipsToBounds:YES];
    }
    
    {
        _zoomView.delegate = self;
        _zoomView.minimumZoomScale = 1.f;
        _zoomView.maximumZoomScale = 3.f;
        _zoomView.bouncesZoom = YES;
        _zoomView.scrollEnabled = YES;
    }
}

#pragma mark -- delegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}

@end
