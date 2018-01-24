//
//  UpLoadImagesEngine.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "UpLoadImagesEngine.h"
#import "JKNetworkHelper.h"
#import "SHUploadTask.h"
#import "APIServerSdk.h"
#import "HUDHelper.h"
#import "AppDelegate.h"

@interface UpLoadImagesEngine()
@property (nonatomic, strong) NSMutableDictionary *currentTasks;
@property (nonatomic, strong) SHUploadTask *runningTask;
/// 保持单个运行
@property (nonatomic, assign) BOOL isRunning;
@end

@implementation UpLoadImagesEngine

+ (UpLoadImagesEngine *)sharedInstance{
    static UpLoadImagesEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UpLoadImagesEngine alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *)currentTasks{
    if (!_currentTasks) {
        _currentTasks = [[NSMutableDictionary alloc] init];
    }
    return _currentTasks;
}


- (void)addTask:(SHUploadTask *)task{
    [self.currentTasks setObject:task forKey:task.taskId];
    [self setTaskHandler:task];
    [self startRunning];
}

- (void)addTasks:(NSMutableArray *)tasks{
    for(SHUploadTask *task in tasks){
        [self.currentTasks setObject:task forKey:task.taskId];
        [self setTaskHandler:task];
    }
    [self startRunning];
}


#pragma mark - Private methods

- (void)setTaskHandler:(SHUploadTask *)task{
    WEAKSELF
    task.upLoadSuccessHandler = ^(NSString *taskId) {
        STRONGSELF
        SHUploadTask *task = strongSelf.currentTasks[taskId];
        [self.currentTasks removeObjectForKey:taskId];
        [strongSelf sendMoment:task];
    };
    
    task.upLoadFailedHandler = ^(NSString *taskId){
        STRONGSELF
        [strongSelf.currentTasks removeObjectForKey:taskId];
        UIView *view = [[AppDelegate sharedAppDelegate] topViewController].view;
        [[HUDHelper sharedInstance] tipMessage:@"动态发送失败" inView:view];
    };
}

- (void)startRunning{
    if (self.isRunning) {
        return;
    }
    
    self.isRunning = YES;
    [self.currentTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, SHUploadTask*  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!obj.isSucceed){
            self.runningTask = obj;
            *stop = YES;
        }
    }];
    [self.runningTask startTask];
}


#pragma mark - Api逻辑

// 发送朋友圈回调

- (void)sendMoment:(SHUploadTask *)task{
    
    NSString *type = @"TEXT";
    if (task.imgUrls.count > 0) {
        type = @"IMAGE_TEXT";
    }
    
    [APIServerSdk doSendMoment:type text:task.content imgs:task.imgUrls succeed:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJKMomentSendSucceed object:nil];
    } failed:^(NSString *error) {
        UIView *view = [[AppDelegate sharedAppDelegate] topViewController].view;
        [[HUDHelper sharedInstance] tipMessage:@"动态发送失败" inView:view];
    }];
}

@end
