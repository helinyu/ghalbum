//
//  YDImgPickerView.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDImgPickerView.h"
//#import "YDBaseCollectionView.h"
//#import "YDBaseTableView.h"
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

        _tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS];
        [self addSubview:_tableView];
    }
    
    {
        [_pickerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_pickerBgView.superview);
        }];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.superview).offset(YDTopLayoutH);
            make.left.right.equalTo(_collectionView.superview);
            if (IS_SCREEN_SIZE_5) {
                make.bottom.equalTo(_collectionView.superview).offset(DWF(-(kPickerBottomH +YDBottomFix)));
            }
            else {
                make.bottom.equalTo(_collectionView.superview).offset(DWF(-kPickerBottomH));
            }
        }];
        
        [_pickerButtomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_pickerButtomView.superview);
            if (IS_SCREEN_SIZE_5) {
                make.height.mas_equalTo(DEVICE_WIDTH_OF(kPickerBottomH+YDBottomFix));
            }
            else {
                make.height.mas_equalTo(DEVICE_WIDTH_OF(kPickerBottomH));
            }
        }];
    }
    
    {
        _tableView.contentInset = UIEdgeInsetsMake(YDTopLayoutH, 0.f, 0.f, 0.f);
        _tableView.contentOffset = CGPointMake(0.f, -YDTopLayoutH);
    }
    {
        _collectionView.backgroundColor = YD_WHITE(0.f);
    }
}

- (void)updateDisplayViewWithIsUP:(BOOL)flag {
    if (flag) {
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
    }
    else {
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
    }
}

@end
