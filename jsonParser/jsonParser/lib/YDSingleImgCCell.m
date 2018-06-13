//
//  YDSingleImgCCell.m
//  SportsBar
//
//  Created by Aka on 2017/9/28.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDSingleImgCCell.h"

@interface YDSingleImgCCell ()

@end

@implementation YDSingleImgCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_origin_circle_mycircle_placeholder.jpg"]];
    [self.contentView addSubview:_imgView];
    self.contentView.layer.masksToBounds = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
