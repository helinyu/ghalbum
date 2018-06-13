//
//  YDAlbumCell.h
//  SportsBar
//
//  Created by mac on 8/1/18.
//  Copyright © 2018年 yuedong. All rights reserved.
//

#import "YDImgTitleIconTCell.h"
@class TZAlbumModel;

@interface YDAlbumTCell :YDImgTitleIconTCell

@property (nonatomic, strong) TZAlbumModel *model;
//@property (weak, nonatomic) UIButton *selectedCountButton;

@end
