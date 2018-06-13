//
//  YDObtainManagerMgr.m
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDObtainManagerMgr.h"

@interface YDObtainManagerMgr()
{
    NSMutableDictionary *_mgrMap;
}
@end

@implementation YDObtainManagerMgr

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}


- (instancetype)init {
    self = [super init];
    if(self){
        _mgrMap = @{}.mutableCopy;
    }
    return self;
}

- (id)mgrWithClass:(Class)class {
    NSObject *mgr = _mgrMap[NSStringFromClass(class)];
    if(mgr == nil || [mgr isEqual:[NSNull null]]){
        mgr = [class new];
        [_mgrMap setObject:mgr forKey:NSStringFromClass(class)];
    }
    return mgr;
}

@end
