//
//  DynamicInfo.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicInfo : NSObject
@property (nonatomic, strong) NSString *dynamicId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL hasPraised;

@end
