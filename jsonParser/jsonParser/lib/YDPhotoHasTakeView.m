//
//  YDPhotoHasTakeView.m
//  SportsBar
//
//  Created by Aka on 2017/11/3.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPhotoHasTakeView.h"
#import "YDLeftRightBtnView.h"

@interface YDPhotoHasTakeView ()

@property (nonatomic, strong) YDLeftRightBtnView *cancelAndToggleBtnView;
@property (nonatomic, strong) UIButton *takeBtn;

@end

@implementation YDPhotoHasTakeView


- (void)baseInit {
    [super baseInit];
    {
        _cancelAndToggleBtnView = [YDLeftRightBtnView new];
        [self addSubview:_cancelAndToggleBtnView];
        
        _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_takeBtn];
    }
    
    {
        [_cancelAndToggleBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(self);
            make.height.mas_equalTo(DEVICE_WIDTH_OF(64.f));
        }];
        
        [_cancelAndToggleBtnView.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(DEVICE_WIDTH_OF(40.f));
        }];
        
        [_cancelAndToggleBtnView.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(DEVICE_WIDTH_OF(-40.f));
        }];
        
        [_takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(DEVICE_WIDTH_OF(74.f));
        }];
        
    }
    
    {
        self.backgroundColor = [UIColor whiteColor];
        _cancelAndToggleBtnView.backgroundColor = [UIColor clearColor];
        
        [_cancelAndToggleBtnView.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelAndToggleBtnView.leftBtn setTitleColor:YDC_TEXT forState:UIControlStateNormal];
        [_cancelAndToggleBtnView.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_cancelAndToggleBtnView.rightBtn setTitleColor:YD_TEXT_DEFAULT_GREEN forState:UIControlStateNormal];
        
        [_takeBtn setImage:[UIImage imageNamed:@"icon_circle_editor_preview"] forState:UIControlStateNormal];
        [_takeBtn setImage:[UIImage imageNamed:@"icon_circle_editor_preview_click"] forState:UIControlStateHighlighted];
    }
    
    {
        [_cancelAndToggleBtnView.leftBtn addTarget:self action:@selector(onCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelAndToggleBtnView.rightBtn addTarget:self action:@selector(onNextClick:) forControlEvents:UIControlEventTouchUpInside];
        [_takeBtn addTarget:self action:@selector(onPreviewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onCancelClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPhotoHasTakeActionTypeCancel);
}

- (void)onNextClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPhotoHasTakeActionTypeNext);
}

- (void)onPreviewClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPhotoHasTakeActionTypeEdit);
}

@end
