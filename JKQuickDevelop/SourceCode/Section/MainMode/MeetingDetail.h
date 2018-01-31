//
//  MeetingDetail.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/30.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MettingModel.h"

@interface MeetingDetail : NSObject
@property (nonatomic, strong) MettingModel *meeting;
@property (nonatomic, assign) BOOL alreadyApply;
@property (nonatomic, strong) NSString *url;
@end
