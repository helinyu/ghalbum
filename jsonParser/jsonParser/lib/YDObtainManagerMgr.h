//
//  YDObtainManagerMgr.h
//  SportsBar
//
//  Created by Aka on 2017/10/27.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OBTAIN_MGR(classname) ((classname *)[[YDObtainManagerMgr shared] mgrWithClass:classname.class])

@interface YDObtainManagerMgr : NSObject

+ (instancetype)shared;
- (id)mgrWithClass:(Class)class;

@end

//#import "YDAlbumMgr.h"

//#import "YDCircleEditorMgr.h"
//#import "YDCircleDetailMgr.h"
//#import "YDCommonVideoPlayerService.h"

