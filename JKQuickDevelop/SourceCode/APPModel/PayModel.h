//
//  PayModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject
@property (nonatomic, strong) NSString *channel; //{"alipay","wx"}
@property (nonatomic, strong) NSString *payData;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *appId;
@end
