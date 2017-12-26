//
//  NSObject+CommonBlock.h
//  CommonLibrary
//
//  Created by Alexi on 3/11/14.
//  Copyright (c) 2014 CommonLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CommonVoidBlock)();
typedef void (^CommonBlock)(id selfPtr);

@interface NSObject (CommonBlock)

- (void)excuteBlock:(CommonBlock)block;

- (void)performBlock:(CommonBlock)block;

- (void)performBlock:(CommonBlock)block afterDelay:(NSTimeInterval)delay;
@end
