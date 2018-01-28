//
//  DemandInfo.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandInfo : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSString *demandId;
@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *username;

@end
