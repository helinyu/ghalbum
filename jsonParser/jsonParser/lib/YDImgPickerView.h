//
//  YDImgPickerView.h
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseView.h"
@class YDPickerBottomView;

@interface YDImgPickerView : YDBaseView 

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) YDPickerBottomView *pickerButtomView;

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)updateDisplayViewWithIsUP:(BOOL)flag;

@end
