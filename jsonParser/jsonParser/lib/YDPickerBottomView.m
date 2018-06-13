//
//  YDPickerBottomView.m
//  SportsBar
//
//  Created by Aka on 2017/11/1.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDPickerBottomView.h"
#import "UIView+YYAdd.h"

@interface YDPickerBottomView ()

//@property (nonatomic, strong) NSMutableArray<UIButton *> *mBtns;

@property (nonatomic, strong) UILabel *videoLabel;
@property (nonatomic, strong) UIImageView *videoImgView;
@property (nonatomic, strong) UIButton *hoverBtn;

@end

static CGFloat const kImgMarginLeft = 20.f;
static CGFloat const kImgToLabelSpace = 8.f;

@implementation YDPickerBottomView

- (void)baseInit {
    [super baseInit];
    
    _videoLabel = [UILabel new];
    _videoImgView = [UIImageView new];
    _hoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self yd_addSubviews:@[_videoImgView,_videoLabel,_hoverBtn]];
    
    [_videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBtn.mas_right).offset(DWF(kImgMarginLeft));
        make.centerY.equalTo(self.leftBtn);
    }];
    
    [_videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_videoImgView.mas_right).offset(DWF(kImgToLabelSpace));
        make.centerY.equalTo(self.leftBtn);
    }];
    
    [_hoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_videoImgView);
        make.right.equalTo(self.videoLabel);
        make.top.bottom.equalTo(self);
    }];
    
    _videoImgView.image = [UIImage imageNamed:@"icon_only_see_video_normal"];
    _videoImgView.contentMode = UIViewContentModeScaleAspectFit;
    _videoLabel.text = @"只看视频";
    _videoLabel.textColor = YDC_TEXT;
    [_hoverBtn addTarget:self action:@selector(onBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setVideoSelectBtnHidden:YES];
}

- (void)onBtnAction:(UIButton *)sender {
    _hoverBtn.selected = !_hoverBtn.selected;
    if (_hoverBtn.selected) {
        _videoImgView.image = [UIImage imageNamed:@"icon_only_see_video_selected"];
        _videoLabel.textColor = YDC_TEXT_DARK;
    }
    else {
        _videoImgView.image = [UIImage imageNamed:@"icon_only_see_video_normal"];
        _videoLabel.textColor = YDC_TEXT;
    }
    !self.actionBlock? :self.actionBlock(YDPreviewActionTypeVideoSelect);
}

- (void)configureLeftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle videoBtnTitle:(NSString *)videoTitle then:(IntegerBlock)actionBlock;
{
    [self configureLeftBtnTitle:leftTitle rightBtnTitle:rightTitle then:nil];
    if (videoTitle.length <=0) {
        [self setVideoSelectBtnHidden:YES];
    }
    else {
        [self setVideoSelectBtnHidden:NO];
    }
    self.actionBlock = actionBlock;
}

- (void)setVideoSelectBtnHidden:(BOOL)flag {
    _videoImgView.hidden = flag;
    _videoLabel.hidden = flag;
    _hoverBtn.hidden = flag;
}

- (void)updateVideoSelectBtnHidden:(BOOL)flag {
    [self setVideoSelectBtnHidden:flag];
}


//- (void)configureLeftBtnTitles:(NSArray<NSString *> *)leftTitles rightBtnTitle:(NSArray<NSString *> *)rightTitles then:(InOtegerBlock)actionBlock {
//    _mBtns = @[].mutableCopy;
//
//    if (leftTitles.count <=0) {
//        MSLogD(@"leftTitles Num is zero");
//        return;
//    }
//    if (rightTitles.count <=0) {
//        MSLogD(@"rightTitles Num is Zero");
//        return;
//    }
//
//    NSString *leftFirstTitle = leftTitles.firstObject;
//    NSString *rightFirstTitle = rightTitles.firstObject;
//
//    [self configureLeftBtnTitle:leftFirstTitle rightBtnTitle:rightFirstTitle then:nil];
//
//    if (leftTitles.count >1) {
//        for (NSInteger leftIndex=1; leftIndex <leftTitles.count; leftIndex++) {
//            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self addSubview:leftBtn];
//            leftBtn.tag = leftIndex+1; // 除去左右两个tag
//            UIButton *lastLeftBtn;
//            if (_mBtns.count <=0) {
//                lastLeftBtn = self.leftBtn;
//            }
//            else {
//                lastLeftBtn = self.mBtns.lastObject;
//            }
//
//            [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(lastLeftBtn);
//                make.centerY.equalTo(lastLeftBtn);
//            }];
//            [leftBtn addTarget:self action:@selector(onBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//            [_mBtns addObject:leftBtn];
//        }
//    }
//
//    if (rightTitles.count >1) {
//        for (NSInteger rightIndex =rightTitles.count-1; rightIndex >0; rightIndex--) {
//            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self addSubview:rightBtn];
//            UIButton *lastRightBtn;
//            if (_mBtns.count == leftTitles.count-1) {
//                lastRightBtn = self.rightBtn;
//            }
//            else {
//                lastRightBtn = _mBtns.lastObject;
//            }
//            [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(lastRightBtn);
//                make.centerY.equalTo(lastRightBtn);
//            }];
//            rightBtn.tag = leftTitles.count +1;
//            [rightBtn addTarget:self action:@selector(onBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//            [_mBtns addObject:rightBtn];
//        }
//    }
//
//    self.actionBlock = actionBlock;
//}
//
//- (void)onBtnAction:(UIButton *)sender {
//    self.actionBlock? : self.actionBlock(sender.tag);
//}

@end
