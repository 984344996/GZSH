//
//  Moment.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "Moment.h"

@implementation Moment

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"praiseList":@"MomentUser",
             @"commentList":@"Comment"
             };
}


@end
