//
//  YDImgIconCCell.h
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDSingleImgCCell.h"

@interface YDImgIconCCell : YDSingleImgCCell

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UIButton *iconActionBtn;

@property (nonatomic, copy) VoidBlock actionBlock;

@end
