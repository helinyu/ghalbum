//
//  YDImgPIckerCCell.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgPickerCCell.h"
#import "TZAssetModel.h"
#import "YDAlbumService.h"
#import "UIView+YYAdd.h"

@interface YDImgPickerCCell ()

@property (nonatomic, strong) TZAssetModel *item;

//@property (nonatomic, strong) UIImageView *playIconImgView;
@property (nonatomic, strong) UILabel *videoDurationLabel;

@end

@implementation YDImgPickerCCell

- (void)baseInit {
    [super baseInit];
    
//    {
//        _playIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circle_bofang"]];
//        [self.contentView addSubview:_playIconImgView];
//        [_playIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(DWF(5.f));
//            make.bottom.equalTo(self.contentView);
//            make.width.height.mas_equalTo(DWF(20.f));
//        }];
//        _playIconImgView.hidden = YES;
//    }
    
    {
        _videoDurationLabel = [UILabel new];
        [self.contentView addSubview:_videoDurationLabel];
        [_videoDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView).offset(DWF(-4.f));
        }];
        
        _videoDurationLabel.textColor = [UIColor whiteColor];
        _videoDurationLabel.backgroundColor = [UIColor clearColor];
        _videoDurationLabel.font = YDF_DEFAULT_R_FIT(13.f);
        [_videoDurationLabel sizeToFit];
    }
    
    [self.iconBtn setImage:[UIImage imageNamed:@"icon_img_picker_no_choice"] forState:UIControlStateNormal];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _videoDurationLabel.text = nil;
//    _playIconImgView.hidden = YES;
}

- (void)configureWithImgView:(NSString *)imgName isChoice:(BOOL)isChoice {
    self.imgView.image = [UIImage imageNamed:imgName];
    [self _configureIsChoice:isChoice];
}

- (void)configureWithImgView:(NSString *)imgName isChoice:(BOOL)isChoice then:(VoidBlock)block {
    [self configureWithImgView:imgName isChoice:isChoice];
    self.actionBlock = block;
}

- (void)configureWithImg:(UIImage *)img isChoice:(BOOL)isChoice {
    self.imgView.image = img;
    [self _configureIsChoice:isChoice];
}

- (void)configureWithImg:(UIImage *)img isChoice:(BOOL)isChoice then:(VoidBlock)block {
    [self configureWithImg:img isChoice:isChoice];
    self.actionBlock = block;
}

- (void)_configureIsChoice:(BOOL)isChoice {
    if (isChoice) {
        [self.iconBtn setImage:[UIImage imageNamed:@"icon_img_picker_has_choice"] forState:UIControlStateNormal];
    }else {
        [self.iconBtn setImage:[UIImage imageNamed:@"icon_img_picker_no_choice"] forState:UIControlStateNormal];
    }
}

- (void)configureWithAsset:(TZAssetModel *)item then:(VoidBlock)block {
    _item = item;
    if (item.type == TZAssetModelMediaTypeVideo) {
        _videoDurationLabel.hidden = NO;
        _videoDurationLabel.text = [NSString stringWithFormat:@" %@ ",item.timeLength];
    }
    
    self.representedAssetIdentifier = [[TZImageManager manager] getAssetIdentifier:item.asset];
    int32_t imageRequestID = [[TZImageManager manager] getPhotoWithAsset:item.asset photoWidth:self.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imgView.alpha = 1.0;
        if ([self.representedAssetIdentifier isEqualToString:[[TZImageManager manager] getAssetIdentifier:item.asset]]) {
            [self configureWithImg:photo isChoice:item.isSelected then:block];
        } else {
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];

    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
}

- (void)configureWithImge:(UIImage *)img {
    self.imgView.image = img;
}

@end
