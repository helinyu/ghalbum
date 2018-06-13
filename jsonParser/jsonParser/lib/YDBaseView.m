//
//  YDBaseView.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseView.h"

@implementation YDBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
