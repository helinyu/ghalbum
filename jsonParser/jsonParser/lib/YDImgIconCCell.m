//
//  YDImgIconCCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgIconCCell.h"


@interface YDImgIconCCell ()

@end

static const CGFloat kIconTop = 10.f;
static const CGFloat kIconRight = 10.f;
static const CGFloat kIconLength = 24.f;

@implementation YDImgIconCCell

- (void)baseInit {
    [super baseInit];
    
    {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_iconBtn];
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _iconActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_iconActionBtn];
    }
    
    {
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(DEVICE_WIDTH_OF(kIconLength));
            make.top.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(kIconTop));
            make.right.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(-kIconRight));
        }];
        
        [_iconActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(DEVICE_WIDTH_OF(kIconLength + kIconTop *2));
            make.center.equalTo(_iconBtn);
        }];
    }
    
    {
        [_iconActionBtn addTarget:self action:@selector(onIconClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onIconClick:(id)sender {
    !_actionBlock? :_actionBlock();
}

@end
