//
//  DynamicMsg.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicMsg : NSObject

@property (nonatomic, strong) NSString *dId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *dynamicId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *opUserId;
@property (nonatomic, strong) NSString *opUsername;
@property (nonatomic, strong) NSString *opAvatar;
@property (nonatomic, strong) NSString *opContent;
@property (nonatomic, strong) NSString *opType;  /// 点赞：LIKE，评论：COMMENT

@end
