//
//  RichMode.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/9.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "RichMode.h"

@implementation RichMode

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        RichMode *toCompare = object;
        if (toCompare.tagForView == self.tagForView) {
            return YES;
        }
    }
    return NO;
}
@end
