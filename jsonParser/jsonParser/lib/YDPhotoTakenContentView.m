//
//  YDPhotoTakenView.m
//  SportsBar
//
//  Created by Aka on 2017/11/2.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPhotoTakenContentView.h"
#import "YDPhotoTakenView.h"

@interface YDPhotoTakenContentView ()

@property (nonatomic, strong) YDPhotoTakenView *takenView;
@property (nonatomic, strong) UIImageView *displayImgView;

@end

@implementation YDPhotoTakenContentView

- (void)baseInit {
    [super baseInit];
    
    {
        _takenView = [[YDPhotoTakenView alloc] initWithFrame:self.bounds];
        [self addSubview:_takenView];
        
        _displayImgView = [UIImageView new];
        [self addSubview:_displayImgView];
    }
    
    {
        [_displayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    _displayImgView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
