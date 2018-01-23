//
//  MySupplyAndDemandViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseTableViewController.h"

@interface MySupplyAndDemandViewController : JKBaseTableViewController

// UserId 自己的可以发布编辑 别人的只能展示
// 为空则为展示主页列表
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isSelf;
- (instancetype)initWithUserId:(NSString *)userId isSelf:(BOOL)isSelf;

@end
