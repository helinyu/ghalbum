//
//  YDPreviewBottomView.h
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDLeftRightBtnView.h"

typedef NS_ENUM(NSInteger, YDPreviewActionType) {
    YDPreviewActionTypeLeft = 0,
    YDPreviewActionTypeRight,
    YDPreviewActionTypeVideoSelect,
};

@interface YDPreviewBottomView : YDLeftRightBtnView

@property (nonatomic, strong) IntegerBlock actionBlock;

- (void)configureLeftBtnTitle:(NSString *)title then:(IntegerBlock)actionBlock;
- (void)configureRightBtnTitle:(NSString *)title then:(IntegerBlock)actionBlock;
- (void)configureLeftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle then:(IntegerBlock)actionBlock;

- (void)updateLeftBtnHidden:(BOOL)hidden;
- (void)updateBtnEnable:(BOOL)status;
- (void)updateRightBtnEnable:(BOOL)status;
- (void)updateRightBtnTitlte:(NSString *)title;

- (void)updateRightBtncorner;

@end
