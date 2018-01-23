//
//  SHWebViewViewController.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/20.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKBaseViewController.h"

@interface SHWebViewViewController : JKBaseViewController
@property (nonatomic, strong) NSString *loadUrl;
- (instancetype)initWithUrl:(NSString *)loadUrl;

@end
