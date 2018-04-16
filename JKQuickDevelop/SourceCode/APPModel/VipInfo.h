//
//  VipInfo.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipInfo : NSObject
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *iconGray;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, assign) BOOL needCheck;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, assign) long *orderNum;
@end
