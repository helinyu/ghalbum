//
//  YDImgPickerViewController.h
//  SportsBar
//
//  Created by Aka on 2017/10/26.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDImgPickerViewController : UIViewController

- (void)configureSelectedAssets:(NSArray *)assets then:(void(^)(NSArray *assets, BOOL change))then;

@end
