//
//  YDPhotoHasTakeView.h
//  SportsBar
//
//  Created by Aka on 2017/11/3.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseView.h"

typedef NS_ENUM(NSInteger, YDPhotoHasTakeActionType) {
    YDPhotoHasTakeActionTypeCancel = 0,
    YDPhotoHasTakeActionTypeEdit = 1,
    YDPhotoHasTakeActionTypeNext,
};

@interface YDPhotoHasTakeView : YDBaseView

@property (nonatomic, strong) IntegerBlock actionBlock;
@property (nonatomic, strong, readonly) UIButton *takeBtn;

@end
