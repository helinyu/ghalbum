//
//  YDLeftRightBtnView.m
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDLeftRightBtnView.h"

@interface YDLeftRightBtnView ()

@end

static const CGFloat leftMargin = 14.f;
static const CGFloat rightMargin = 14.f;

@implementation YDLeftRightBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rightBtn];
    }
    
    {
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(DEVICE_WIDTH_OF(leftMargin));
            make.top.equalTo(self).offset(DWF(8.f));
        }];
        
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
            make.top.equalTo(self).offset(DWF(8.f));
            make.right.equalTo(self).offset(DEVICE_WIDTH_OF(-rightMargin));
        }];
    }
        
    }
    return self;
}

@end
