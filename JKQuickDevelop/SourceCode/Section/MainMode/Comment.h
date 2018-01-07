//
//  Comment.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentUser.h"

@interface Comment : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) MomentUser *userA;
@property (nonatomic, strong) MomentUser *userB;

@end
