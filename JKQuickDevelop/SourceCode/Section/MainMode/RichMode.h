//
//  RichMode.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/9.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichMode : NSObject
// ["image", "text"]
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSUInteger *w;
@property (nonatomic, assign) NSUInteger *h;

@end
