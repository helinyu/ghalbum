//
//  YDCommonImgBrowserView.h
//  SportsBar
//
//  Created by mac on 18/4/18.
//  Copyright © 2018年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDPreviewBottomView;

static const CGFloat kTopH = 50.f;
static const CGFloat kBottomH = 50.f;

@interface YDCommonImgBrowserView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *titleView;
@property (nonatomic, strong, readonly) YDPreviewBottomView *bottomView;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@end
