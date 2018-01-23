//
//  SortBaseObject.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortBaseObject : NSObject
//letter = [@"1", @"~"] -> letterShow = @"#";

@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSString *letterShow;
@property (nonatomic, strong) NSString *pingyin;
@end
