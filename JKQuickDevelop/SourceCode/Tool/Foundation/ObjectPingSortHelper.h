//
//  ObjectPingSortHelper.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectPingSortHelper : NSObject

@property (nonatomic, strong) NSMutableArray *objectsToSort;
@property (nonatomic, strong) NSMutableArray *sortedLetters;
// {["a":[],"b":[],#:[]}
@property (nonatomic, strong) NSMutableArray *sortedObjects;

// 每次调用以上三个参数数组都将更新
- (NSMutableArray *)sortObjects:(NSMutableArray *)objects key:(NSString *)keyPath;

@end
