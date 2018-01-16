//
//  UpLoadModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadModel : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSString *basePath;

@end
