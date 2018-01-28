//
//  MyCompanyInfoViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseTableViewController.h"
#import "EnterpriseModel.h"

@interface MyCompanyInfoViewController : JKBaseViewController

- (instancetype)initWithEnterpriseModel:(EnterpriseModel *)model isSelf:(BOOL)isSelf;
- (instancetype)initWithUserId:(NSString *)userId isSelf:(BOOL)isSelf;
@end
