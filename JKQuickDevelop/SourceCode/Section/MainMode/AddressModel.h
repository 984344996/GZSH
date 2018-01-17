//
//  AddressModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/17.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *level_type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *short_name;
@property (nonatomic, strong) NSString *merger_name;
@property (nonatomic, strong) NSString *pinyin;

@end
