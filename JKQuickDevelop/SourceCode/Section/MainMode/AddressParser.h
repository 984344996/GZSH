//
//  AddressParser.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/17.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface AddressParser : NSObject

@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *countries;

+ (AddressParser *)sharedInstance;
- (void)parseAddressArr;
- (NSMutableArray *)getArrayAddressNextLevel:(NSString *)parent_id level_type:(NSString *)level_type;

@end
