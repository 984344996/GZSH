//
//  AddressParser.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/17.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "AddressParser.h"
#import <MJExtension.h>

@implementation AddressParser

+ (AddressParser *)sharedInstance{
    static AddressParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AddressParser alloc] init];
        [instance parseAddressArr];
    });
    return instance;
}

-  (void)parseAddressArr{
    NSData *friendsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"comm_areas" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:friendsData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *array = [AddressModel mj_objectArrayWithKeyValuesArray:JSONDic[@"records"]];
    [array enumerateObjectsUsingBlock:^(AddressModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.level_type isEqualToString:@"1"]) {
            [self.provinces addObject:obj];
        }else if ([obj.level_type isEqualToString:@"2"]){
            [self.provinces addObject:obj];
        }else{
            [self.countries addObject:obj];
        }
    }];
}

- (NSMutableArray *)getArrayAddressNextLevel:(NSString *)parent_id level_type:(NSString *)level_type{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *arrayFrom;
    if ([level_type isEqualToString:@"0"]) {
        return self.provinces;
    }else if ([level_type isEqualToString:@"1"]){
        arrayFrom = self.cities;
    }else{
        arrayFrom = self.countries;
    }
    
    [arrayFrom enumerateObjectsUsingBlock:^(AddressModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.parent_id isEqualToString:parent_id]) {
            [array addObject:obj];
        }
    }];
    return array;
}
@end
