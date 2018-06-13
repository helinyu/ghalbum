//
//  YDCommonImgDescCCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDComImgDescCCell.h"

@interface YDComImgDescCCell ()

@end

static const CGFloat kIconToDescSpace = 8.8;

@implementation YDComImgDescCCell

- (void)baseInit {
    [super baseInit];
    
    {
        _iconImgView = [UIImageView new];
        [self.contentView addSubview:_iconImgView];
        
        _descLabel = [UILabel new];
        [self.contentView addSubview:_descLabel];
    }
    
    {
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(_iconImgView.mas_bottom).offset(DEVICE_WIDTH_OF(kIconToDescSpace));
            make.right.left.lessThanOrEqualTo(self.contentView);
        }];
    }
    
    {
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        _descLabel.textColor = YD_WHITE(1.f);
        _descLabel.font = YDF_DEFAULT_R_FIT(15.f);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        [_descLabel sizeToFit];
    }
    
}

@end
