//
//  UpLoadImagesEngine.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHUploadTask.h"

@interface UpLoadImagesEngine : NSObject

+ (UpLoadImagesEngine *)sharedInstance;

- (void)createAndAddTask:(NSString *)content imgs:(NSMutableArray *)imgs;
- (void)addTask:(SHUploadTask *)task;
- (void)addTasks:(NSMutableArray *)tasks;
@end
