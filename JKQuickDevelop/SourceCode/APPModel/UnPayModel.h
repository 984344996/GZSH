//
//  UnPayModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnPayModel : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *vipId;
@property (nonatomic, strong) NSString *vipName;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *endTime;

@end
