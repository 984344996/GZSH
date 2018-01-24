//
//  UploadRichEngine.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/24.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "UploadRichEngine.h"
#import "APIServerSdk.h"
#import "UpLoadModel.h"
#import <MJExtension.h>

#define kMaxRetry 2
@interface UploadRichEngine()
@property (nonatomic, assign) NSUInteger retryCount;
@property (nonatomic, strong) NSMutableArray *riches; // 需要上传的富文本数组
@property (nonatomic, assign) NSInteger lastSucceedIndex;
@property (nonatomic, copy) void(^upLoadSuccessHandler)(NSMutableArray *riches);
@property (nonatomic, copy) void(^upLoadFailedHandler)();
@end

@implementation UploadRichEngine

+ (UploadRichEngine *)sharedInstance{
    static UploadRichEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UploadRichEngine alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.lastSucceedIndex = -1;
    }
    return self;
}

#pragma mark - Public methods

- (void)upLoadRiches:(NSMutableArray *)riches succeed:(void (^)(NSMutableArray *))succeed failed:(void (^)())failed{
    self.riches = riches;
    self.upLoadSuccessHandler = succeed;
    self.upLoadFailedHandler = failed;
    [self startTask];
}

#pragma mark - Private methods

- (void)startTask{
    self.retryCount = 0;
    self.lastSucceedIndex = -1;
    [self upLoadNext];
}

// 上传下一张图片
- (void)upLoadNext{
    if ((self.lastSucceedIndex < (NSInteger)self.riches.count - 1) && self.riches.count > 0){
        NSUInteger indexToUpload = self.lastSucceedIndex + 1;
        RichMode *model = self.riches[indexToUpload];
        if (!model.image) {
            self.lastSucceedIndex += 1;
            [self upLoadNext];
            return;
        }
        
        WEAKSELF
        [APIServerSdk doUploadImage:model.image dir:@"richtext" name:@"file" succeed:^(id obj) {
            STRONGSELF
            strongSelf.lastSucceedIndex += 1;
            CommonResponseModel *cObj   = obj;
            UpLoadModel* upLoadModel    = [UpLoadModel mj_objectWithKeyValues:cObj.data];
            model.imageUrl              = upLoadModel.url;
            [strongSelf upLoadNext];
        } failed:^(NSString *error) {
            STRONGSELF
            if (strongSelf.retryCount > kMaxRetry) {
                if (self.upLoadFailedHandler) {
                    self.upLoadFailedHandler();
                }
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf upLoadNext];
                    strongSelf.retryCount++;
                });
            }
        }];
    }else{
        if (self.upLoadSuccessHandler) {
            self.upLoadSuccessHandler(self.riches);
        }
    }
}


@end
