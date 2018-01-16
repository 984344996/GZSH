//
//  MomentNewsModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/13.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomentNewsModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *contentToBeComment;
@property (nonatomic, assign) CGFloat cellHeight;

@end
