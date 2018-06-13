//
//  YDImgPickerTakeCCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgPickerTakeCCell.h"

@interface YDImgPickerTakeCCell ()

@end

@implementation YDImgPickerTakeCCell

- (void)baseInit {
    [super baseInit];

    self.imgView.image = [UIImage imageNamed:@"icon_img_picker_take_bg"];
    self.iconImgView.image = [UIImage imageNamed:@"icon_img_picker_take"];
    self.descLabel.text = @"拍照";
}

@end
