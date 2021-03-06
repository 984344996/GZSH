//
//  MettingModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MettingModel : NSObject
@property (nonatomic, strong) NSString *meetingId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *state; // AVAILABLE OVERDUE
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL allowApply;
@end
