//
//  YDImgPickerVCTitleView.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgPickerVCTitleView.h"

@interface YDImgPickerVCTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *overBtn;

@property (nonatomic, assign) BOOL isUpDirection;

@end

@implementation YDImgPickerVCTitleView

- (void)baseInit {
    [super baseInit];
    
    {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        
        _iconView = [UIImageView new];
        [self addSubview:_iconView];
        
        _overBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_overBtn];
    }
    
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(DEVICE_WIDTH_OF(13.f));
            make.height.mas_equalTo(DEVICE_WIDTH_OF(11.f));
        }];
        
        [_overBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.right.equalTo(_iconView);
            make.top.bottom.equalTo(self);
        }];
    }
    
    {
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = YD_BLACK(1.f);
        _titleLabel.font = YDF_DEFAULT_R_FIT(18.f);
        [_titleLabel sizeToFit];
        
        _iconView.image = [UIImage imageNamed:@"icon_img_picker_title_down"];
        [self addSubview:_iconView];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    {
        [_overBtn addTarget:self action:@selector(onToggleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onToggleClick:(id)sender {
    _isUpDirection = !_isUpDirection;
    [self _updateDirectionIcon];
    !_actionBlock? :_actionBlock(_isUpDirection);
}

- (void)configureWithTitle:(NSString *)title isUpDirection:(BOOL)flag then:(BoolBlock)actionBlock {
    _isUpDirection = flag;
    _titleLabel.text = title;
    _actionBlock = actionBlock;
}

- (void)configureWithTitle:(NSString *)title isUpDirection:(BOOL)flag {
    _isUpDirection = flag;
    [self _updateDirectionIcon];
    _titleLabel.text = title;
}

- (void)_updateDirectionIcon {
    if (_isUpDirection) {
        _iconView.image = [UIImage imageNamed:@"icon_img_picker_title_up"];
    }
    else {
        _iconView.image = [UIImage imageNamed:@"icon_img_picker_title_down"];
    }
}

@end
