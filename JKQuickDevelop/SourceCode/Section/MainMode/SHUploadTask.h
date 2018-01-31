//
//  SHUploadTask.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMaxRetry 2

@interface SHUploadTask : NSObject

@property (nonatomic, strong) NSString* taskId; // 任务编号
@property (nonatomic, assign) NSUInteger retryCount; // 重试次数
@property (nonatomic, assign) BOOL isSucceed; // 任务是否完成

#pragma mark - 商会圈
@property (nonatomic, copy) NSString* content; // 朋友圈文字
@property (nonatomic, assign) NSInteger lastSucceedIndex;
@property (nonatomic, strong) NSMutableArray *imgs; // 图片数组
@property (nonatomic, strong) NSMutableArray *imgUrls; // 图片远程路径

@property (nonatomic, copy) void(^upLoadSuccessHandler)(NSString *taskId); // 成功回调
@property (nonatomic, copy) void(^upLoadFailedHandler)(NSString *taskId); // 失败

- (void)startTask;
@end
