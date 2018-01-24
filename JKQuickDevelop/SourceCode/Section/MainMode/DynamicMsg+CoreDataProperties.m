//
//  DynamicMsg+CoreDataProperties.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//
//

#import "DynamicMsg+CoreDataProperties.h"

@implementation DynamicMsg (CoreDataProperties)

+ (NSFetchRequest<DynamicMsg *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DynamicMsg"];
}

@dynamic id;
@dynamic createTime;
@dynamic type;
@dynamic content;
@dynamic img;
@dynamic opUserId;
@dynamic opUsername;
@dynamic opAvatar;
@dynamic opContent;
@dynamic opType;
@dynamic dynamicId;
@end
