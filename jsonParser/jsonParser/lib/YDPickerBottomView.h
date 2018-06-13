//
//  YDPickerBottomView.h
//  SportsBar
//
//  Created by Aka on 2017/11/1.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPreviewBottomView.h"

NS_ASSUME_NONNULL_BEGIN


@interface YDPickerBottomView : YDPreviewBottomView

// 使用条件，就是一定要有左右两个按钮

// max =2 (这个要符合预览的按钮格式)
// action left 0 2 *** leftLast
//        right 1 rightLast **** leftLast
//- (void)configureLeftBtnTitles:(NSArray<NSString *> *)leftTitles rightBtnTitle:(NSArray<NSString *> *)rightTitles then:(IntegerBlock)actionBlock;

- (void)configureLeftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle videoBtnTitle:(NSString *)videoTitle then:(IntegerBlock)actionBlock;

- (void)updateVideoSelectBtnHidden:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
