//
//  MySupplyAndDemandEditViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseViewController.h"
#import "DemandInfo.h"

@interface MySupplyAndDemandEditViewController : JKBaseViewController

@property (nonatomic, copy) void(^SupplyEditedCallback)(DemandInfo* info);
- (instancetype)initWithDemandInfo:(DemandInfo *)model;

@end
