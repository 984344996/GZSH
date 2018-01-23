//
//  DynamicMsg+CoreDataProperties.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//
//

#import "DynamicMsg+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DynamicMsg (CoreDataProperties)

+ (NSFetchRequest<DynamicMsg *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *opUserId;
@property (nullable, nonatomic, copy) NSString *opUsername;
@property (nullable, nonatomic, copy) NSString *opAvatar;
@property (nullable, nonatomic, copy) NSString *opContent;
@property (nullable, nonatomic, copy) NSString *opType;

@end

NS_ASSUME_NONNULL_END
