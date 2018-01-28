//
//  SHCircleViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseTableViewController.h"



@interface SHCircleViewController : JKBaseTableViewController

@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) NSString *momentId;
/**
 朋友圈初始化函数

 @param isMainPage 是不是主页面
 @param userid 用户ID
 @return VC
 */
- (instancetype)initWithMainPage:(BOOL) isMainPage userid:(NSString *)userid;
@end
