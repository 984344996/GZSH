//
//  NSObject+CommonBlock.m
//  CommonLibrary
//
//  Created by Alexi on 3/11/14.
//  Copyright (c) 2014 CommonLibrary. All rights reserved.
//

#import "NSObject+CommonBlock.h"

@implementation NSObject (CommonBlock)

- (void)excuteBlock:(CommonBlock)block
{
    __weak id selfPtr = self;
    if (block) {
        block(selfPtr);
    }
}

- (void)performBlock:(CommonBlock)block
{
    if (block)
    {
        [self performSelector:@selector(excuteBlock:) withObject:block];
    }
}

- (void)performBlock:(CommonBlock)block afterDelay:(NSTimeInterval)delay
{
    if (block)
    {
        [self performSelector:@selector(excuteBlock:) withObject:block afterDelay:delay];
    }
}
@end
