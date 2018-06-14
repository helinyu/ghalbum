
//
//  YDAlbumCell.m
//  SportsBar
//
//  Created by mac on 8/1/18.
//  Copyright © 2018年 yuedong. All rights reserved.
//

#import <Photos/Photos.h>
#import "YDAlbumTCell.h"
#import "YDAlbumService.h"

@interface YDAlbumTCell ()

@property (nonatomic, strong) UILabel *assetNumLabel;
//@property (nonatomic, strong) UILabel *selectedNumLabel;

@end

//static const CGFloat kSelectNumLabelRightSpace = 12.f;
//static const CGFloat kSelectNumLabelLength = 30.f;
static const CGFloat kAssetNumLabelLeftSpace = 12.f;

@implementation YDAlbumTCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)baseInit {
    [super baseInit];
    
    [self.contentView setClipsToBounds:YES];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    
    {
        _assetNumLabel = [UILabel new];
        [self.contentView addSubview:_assetNumLabel];
        
        [_assetNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(DWF(kAssetNumLabelLeftSpace));
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    {
//        _selectedNumLabel = [UILabel new];
//        [self.contentView addSubview:_selectedNumLabel];
//        _selectedNumLabel.backgroundColor = YDC_G2;
//        _selectedNumLabel.textColor = YD_WHITE(1.f);
//
//        [_selectedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.iconImgView.mas_left).offset(DWF(-12.f));
//            make.centerY.equalTo(self.contentView);
//            make.height.width.mas_equalTo(kSelectNumLabelLength);
//        }];
        
//        _selectedNumLabel.layer.cornerRadius = DWF(kSelectNumLabelLength/2.f);
//        _selectedNumLabel.layer.masksToBounds = YES;
//        _selectedNumLabel.textAlignment = NSTextAlignmentCenter;

//        _selectedNumLabel.text = @"9";
    }
}

- (void)setModel:(TZAlbumModel *)model {
    _model = model;
//    self.titleLabel.text = model.name;
//    self.assetNumLabel.text = [NSString stringWithFormat:@"%zd",model.count];
//    
//    [[TZImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
//        self.imgView.image = postImage;
//    }];
}

@end
