//
//  YDBrowserImgModel.h
//  SportsBar
//
//  Created by mac on 31/1/18.
//  Copyright © 2018年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YDBrowserImgType) {
    YDBrowserImgTypeUrl = 0,
    YDBrowserImgTypeName,
    YDBrowserImgTypeImg,
};

@interface YDBrowserImgModel : NSObject

@property (nonatomic, assign) YDBrowserImgType type;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, strong) UIImage *img;

@end
