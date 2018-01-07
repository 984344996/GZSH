//
//  Moment.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MomentUser;
@class DynamicInfo;
@class Comment;

@interface Moment : NSObject

@property (nonatomic, strong) MomentUser *momentUser;
@property (nonatomic, strong) DynamicInfo *dynamicInfo;
@property (nonatomic, strong) NSArray<MomentUser *> *praiseList;
@property (nonatomic, strong) NSArray<Comment *> *commentList;
@property (nonatomic, strong) NSArray<NSString *> *content;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *momentId;

@end
