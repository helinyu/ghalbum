//
//  YDImgPickerView.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgPickerView.h"
#import "YDPickerBottomView.h"

@interface YDImgPickerView ()

@property (nonatomic, strong) YDBaseView *pickerBgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@end

static const CGFloat kPickerBottomH = 50.f;

@implementation YDImgPickerView

- (void)baseInit {
    [super baseInit];
    
    {
        _pickerBgView = [YDBaseView new];
        [self addSubview:_pickerBgView];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        [_pickerBgView addSubview:_collectionView];
        
        _pickerButtomView = [YDPickerBottomView new];
        [_pickerBgView addSubview:_pickerButtomView];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tableView];
    }
    
    {
        [_pickerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_pickerBgView.superview);
            make.height.mas_equalTo(DWF(kPickerBottomH) + YDBottomFix);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.superview).offset(YDTopLayoutH);
            make.left.right.equalTo(_collectionView.superview);
            make.bottom.equalTo(_collectionView.superview).offset(-DWF(kPickerBottomH)-YDBottomFix);
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_tableView.superview);
            make.top.equalTo(_tableView.superview).offset(YDTopLayoutH);
            make.bottom.equalTo(_tableView.superview).offset(-DWF(kPickerBottomH) -YDBottomFix);
        }];
        
        [_pickerButtomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_pickerButtomView.superview);
            make.height.mas_equalTo(DWF(kPickerBottomH));
        }];
        
    }
    _collectionView.backgroundColor = YD_WHITE(0.f);
    _pickerBgView.backgroundColor = [UIColor grayColor];
}

- (void)showViewWithIsAsset:(BOOL)isAsset {
    if (isAsset) {
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
    }
    else {
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
    }
}

@end
