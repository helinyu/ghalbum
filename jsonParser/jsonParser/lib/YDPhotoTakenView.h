//
//  YDPhotoTakenView.h
//  SportsBar
//
//  Created by Aka on 2017/11/2.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBaseView.h"

@interface YDPhotoTakenView : YDBaseView

- (void)stopRunning;
- (void)startRunning;
- (void)toggleRunning;
- (void)takePhotoThen:(void(^)(NSData *imgData,UIImage *img))then;
- (void)toggleCamera;

@end
