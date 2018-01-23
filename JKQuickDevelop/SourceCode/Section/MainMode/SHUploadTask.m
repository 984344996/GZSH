//
//  SHUploadTask.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHUploadTask.h"
#import "APIServerSdk.h"
#import "UpLoadModel.h"
#import "CommonResponseModel.h"
#import <MJExtension.h>
#import <JKCategories.h>

@implementation SHUploadTask

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lastSucceedIndex = -1;
        self.taskId = [NSString jk_UUIDTimestamp];
    }
    return self;
}

- (NSMutableArray *)imgUrls{
    if (!_imgUrls) {
        _imgUrls = [NSMutableArray array];
    }
    return _imgUrls;
}


// 开启任务
- (void)startTask{
    [self upLoadNextImage];
}

// 上传下一张图片
- (void)upLoadNextImage{
    if ((self.lastSucceedIndex < (NSInteger)self.imgs.count - 1) && self.imgs.count > 0) {
        NSUInteger indexToUpload = self.lastSucceedIndex + 1;
        UIImage *image = self.imgs[indexToUpload];
        
        WEAKSELF
        [APIServerSdk doUploadImage:image dir:@"circle" name:@"file" succeed:^(id obj) {
            STRONGSELF
            strongSelf.lastSucceedIndex += 1;
            CommonResponseModel *cObj = obj;
            UpLoadModel* upLoadModel = [UpLoadModel mj_objectWithKeyValues:cObj.data];
            [strongSelf.imgUrls addObject:upLoadModel.url];
            NSLog(@"====== upload success");
            [strongSelf upLoadNextImage];
        } failed:^(NSString *error) {
            STRONGSELF
            if (strongSelf.retryCount > kMaxRetry) {
                if (self.upLoadFailedHandler) {
                    self.upLoadFailedHandler(self.taskId);
                }
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf upLoadNextImage];
                });
            }
        }];
    }else{
        if (self.upLoadSuccessHandler) {
            self.upLoadSuccessHandler(self.taskId);
        }
    }
}

@end
