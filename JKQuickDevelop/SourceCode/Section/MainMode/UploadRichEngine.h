//
//  UploadRichEngine.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/24.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RichMode.h"

@interface UploadRichEngine : NSObject

+ (UploadRichEngine *)sharedInstance;

// 单任务 完成一个才能下一个
- (void)upLoadRiches:(NSMutableArray *)riches succeed:(void(^)(NSMutableArray *riches))succeed failed:(void(^)())failed;

@end
