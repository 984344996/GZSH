//
//  DynamicMsg+CoreDataClass.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/22.
//  Copyright © 2018年 dengjie. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicMsg : NSManagedObject
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END

#import "DynamicMsg+CoreDataProperties.h"
