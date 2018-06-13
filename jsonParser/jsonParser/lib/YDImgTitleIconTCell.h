//
//  YDImgTitleIconTCell.h
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDImgTitleIconTCell : UITableViewCell

- (void)configureImg:(UIImage *)img title:(NSString *)title;
- (void)configureImgName:(NSString *)imgName title:(NSString *)title;

- (void)baseInit;

//  -- 尽量不要变量直接使用
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImgView;

@end
