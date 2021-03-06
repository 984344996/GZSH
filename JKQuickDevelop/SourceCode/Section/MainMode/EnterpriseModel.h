//
//  EnterpriseModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortBaseObject.h"

@interface EnterpriseModel : SortBaseObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *eld;
@property (nonatomic, strong) NSString *avatar;

@end
