//
//  YDPhotoTakeView.h
//  SportsBar
//
//  Created by Aka on 2017/10/30.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseView.h"
@class YDLeftRightBtnView;

typedef NS_ENUM(NSInteger, YDPhotoTakeActionType) {
    YDPhotoTakeActionTypeCancel = 0,
    YDPhotoTakeActionTypeToggle = 1,
    YDPhotoTakeActionTypeTake,
    YDPhotoTakeActionTypeNext = YDPhotoTakeActionTypeToggle,
    YDPhotoTakeActionTypePreview = YDPhotoTakeActionTypeTake,
};

@interface YDPhotoTakenBottomView : YDBaseView

@property (nonatomic, strong) IntegerBlock actionBlock;

@property (nonatomic, strong, readonly) UIButton *takeBtn;
@property (nonatomic, strong, readonly) YDLeftRightBtnView *cancelAndToggleBtnView;

@end
