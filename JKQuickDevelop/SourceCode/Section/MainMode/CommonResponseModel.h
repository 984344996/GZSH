//
//  CommonResponseModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageData.h"

@interface CommonResponseModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) PageData *page;
@property (nonatomic, strong) id data;

- (BOOL)isSucceed;
- (BOOL)isFailure;
- (NSString *)getErrorMsg;

@end
