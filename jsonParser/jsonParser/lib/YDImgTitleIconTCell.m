//
//  YDImgTitleIconTCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgTitleIconTCell.h"

@interface YDImgTitleIconTCell ()


@end

@implementation YDImgTitleIconTCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    {
        _imgView = [UIImageView new];
        [self.contentView addSubview:_imgView];
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        
        _iconImgView = [UIImageView new];
        [self.contentView addSubview:_iconImgView];
    }
    
    {
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(14.f));
            make.centerY.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(9.f));
            make.width.mas_equalTo(_imgView.mas_height);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_imgView.mas_right).offset(DEVICE_WIDTH_OF(13.f));
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(DEVICE_WIDTH_OF(-12.f));
            make.height.width.mas_equalTo(DEVICE_WIDTH_OF(13.f));
        }];
    }
    
    {
        _iconImgView.image = [UIImage imageNamed:@"icon_circle_right_all"];
    }
    
    {
        _titleLabel.textColor = YDC_TITLE;
        _titleLabel.font = YDF_DEFAULT_R_FIT(15.f);
        [_titleLabel sizeToFit];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)configureImgName:(NSString *)imgName title:(NSString *)title {
    _imgView.image = [UIImage imageNamed:imgName];
    _titleLabel.text = title;
}

- (void)configureImg:(UIImage *)img title:(NSString *)title {
    _imgView.image = img;
    _titleLabel.text = title;
}

@end
