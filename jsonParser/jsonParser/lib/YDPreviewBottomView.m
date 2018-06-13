
//
//  YDPreviewBottomView.m
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPreviewBottomView.h"

@implementation YDPreviewBottomView

- (void)baseInit {
    [super baseInit];
    
    {
        [self.leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = YDF_DEFAULT_R_FIT(17.f);
        [self.leftBtn setTitleColor:YD_TEXT_DEFAULT_GREEN forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:YDC_TEXT forState:UIControlStateDisabled];
        [self.leftBtn addTarget:self action:@selector(onLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = YDF_DEFAULT_R_FIT(15.f);
        self.rightBtn.backgroundColor = YD_TEXT_DEFAULT_GREEN;
        [self.rightBtn addTarget:self action:@selector(onRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn.contentEdgeInsets = UIEdgeInsetsMake(DWF(8.f), DWF(14.f), DWF(7.f), DWF(13.f));
        self.rightBtn.layer.cornerRadius = DWF(3.f);
        [self.rightBtn sizeToFit];
    }
}

- (void)configureLeftBtnTitle:(NSString *)title then:(IntegerBlock)actionBlock {
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
}

- (void)configureRightBtnTitle:(NSString *)title then:(IntegerBlock)actionBlock {
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateRightBtnTitlte:(NSString *)title {
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
}

- (void)configureLeftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle then:(IntegerBlock)actionBlock {
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    self.leftBtn.tag = YDPreviewActionTypeLeft;
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    self.rightBtn.tag = YDPreviewActionTypeRight;
    _actionBlock = actionBlock;
}

- (void)updateBtnEnable:(BOOL)status {
    [self updateLeftBtnEnable:status rightBtnEnable:status];
}

- (void)updateRightBtnEnable:(BOOL)status {
    self.rightBtn.enabled = status;
    if (status) {
        self.rightBtn.backgroundColor = YD_TEXT_DEFAULT_GREEN;
    }else {
        self.rightBtn.backgroundColor = YD_SAME_RGB(204.f);
    }
}

- (void)updateLeftBtnEnable:(BOOL)lStatus rightBtnEnable:(BOOL)rStatus {
    self.leftBtn.enabled = lStatus;
    self.rightBtn.enabled = rStatus;
    if (rStatus) {
        self.rightBtn.backgroundColor = YD_TEXT_DEFAULT_GREEN;
    }else {
        self.rightBtn.backgroundColor = YD_SAME_RGB(204.f);
    }
}

- (void)updateLeftBtnHidden:(BOOL)hidden {
    self.leftBtn.hidden = hidden;
}

- (void)onLeftBtnClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPreviewActionTypeLeft);
}

- (void)onRightBtnClick:(id)sender {
    !_actionBlock? :_actionBlock(YDPreviewActionTypeRight);
}

- (void)updateRightBtncorner {
    CGFloat corner = floorf(CGRectGetHeight(self.rightBtn.bounds)/2);
    self.rightBtn.layer.cornerRadius = corner;
}

@end
