//
//  YDImgPickerVCTitleView.h
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseView.h"

@interface YDImgPickerVCTitleView : YDBaseView

@property (nonatomic, copy) BoolBlock actionBlock;

- (void)configureWithTitle:(NSString *)title isUpDirection:(BOOL)flag;
- (void)configureWithTitle:(NSString *)title isUpDirection:(BOOL)flag then:(BoolBlock)actionBlock;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UIButton *overBtn;
@property (nonatomic, assign, readonly) BOOL isUpDirection;

@end
