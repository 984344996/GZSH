//
//  MySupplyDetailViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/25.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseViewController.h"
#import "DemandInfo.h"

@interface MySupplyDetailViewController : JKBaseViewController
@property (nonatomic, strong) DemandInfo *demand;
@property (nonatomic, assign) BOOL isSelf;

- (instancetype)initWithDemand:(DemandInfo *)demand isSelf:(BOOL)isSelf;
@end
