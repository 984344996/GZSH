//
//  Contact.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SortBaseObject.h"

@interface Contact : SortBaseObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *enterprise;
@property (nonatomic, strong) NSString *avatar;

@end
