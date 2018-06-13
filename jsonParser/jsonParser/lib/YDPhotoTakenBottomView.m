
//
//  YDPhotoTakeView.m
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPhotoTakenBottomView.h"
#import "YDLeftRightBtnView.h"

@interface YDPhotoTakenBottomView ()

@property (nonatomic, strong) YDLeftRightBtnView *cancelAndToggleBtnView;
@property (nonatomic, strong) UIButton *takeBtn;

@end

@implementation YDPhotoTakenBottomView

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
        
        [_cancelAndToggleBtnView.rightBtn setImage:[UIImage imageNamed:@"icon_toggle_camera_direction"] forState:UIControlStateNormal];
        
        [_takeBtn setImage:[UIImage imageNamed:@"icon_img_picker_normal"] forState:UIControlStateNormal];
        [_takeBtn setImage:[UIImage imageNamed:@"icon_img_picker_selected"] forState:UIControlStateHighlighted];
    }
    
    {
        [_cancelAndToggleBtnView.leftBtn addTarget:self action:@selector(onCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelAndToggleBtnView.rightBtn addTarget:self action:@selector(onToggleCameraDirectionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_takeBtn addTarget:self action:@selector(onTakePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onCancelClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPhotoTakeActionTypeCancel);
}

- (void)onToggleCameraDirectionClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPhotoTakeActionTypeToggle);
}

- (void)onTakePhotoClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPhotoTakeActionTypeTake);
}

@end
