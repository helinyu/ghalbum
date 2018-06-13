//
//  YDCommonImgBrowserView.m
//  SportsBar
//
//  Created by mac on 18/4/18.
//  Copyright © 2018年 yuedong. All rights reserved.
//

#import "YDCommonImgBrowserView.h"
#import "YDPreviewBottomView.h"

@interface YDCommonImgBrowserView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) YDPreviewBottomView *bottomView;

@end

@implementation YDCommonImgBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    self.backgroundColor = [UIColor blackColor];

    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_BOUNDS collectionViewLayout:flowLayout];
//        _collectionView.backgroundColor = [UIColor blackColor];
//        _collectionView.pagingEnabled = YES;
        [self addSubview:_collectionView];
    }
    
    {
        _titleView = [UIView new];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(DWF(kTopH) +YDTopFix);
        }];
        
        _titleLabel = [UILabel new];
        [_titleView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_titleView);
        }];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = YDF_DEFAULT_R_FIT(18.f);
        [_titleLabel sizeToFit];
    }
    
    _bottomView = [YDPreviewBottomView new];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-YDBottomFix);
        make.height.mas_equalTo(DWF(kBottomH));
    }];
}


@end
