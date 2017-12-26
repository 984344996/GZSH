//
//  MZIMMessageDispatcher.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/17.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageDispatcher.h"
#import "MZIMMessage.h"

@implementation MZIMMessageDispatcher

+ (MZIMMessageDispatcher *)sharedInstance{
    static MZIMMessageDispatcher *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MZIMMessageDispatcher alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public methods
- (void)newMessagesComing:(NSArray *)messages{
    if(self.observers.count < 1){
        return;
    }
    
    for (TIMMessage *message in messages){
        TIMConversationType type = [[message getConversation]getType];
        NSString *receiver = [[message getConversation]getReceiver];
        NSString *key = [self getIdentifier:type receiver:receiver];
        
        id<MZIMMessageDispatcherDelegate> object = [self.observers objectForKey:key];
        MZIMMessage *mzMessage = [[MZIMMessage alloc] initWithTIMMessage:message];
        if (message) {
            [object onNewMessage:mzMessage];
        }
    }
}

- (void)addConversationObserver:(TIMConversationType)type receiver:(NSString *)receiver delegate:(id<MZIMMessageDispatcherDelegate>)delegate{
    NSString *key = [self getIdentifier:type receiver:receiver];
    if ([self.observers objectForKey: key]) {
        [self.observers removeObjectForKey:key];
    }
    [self.observers setValue:delegate forKey:key];
}

- (void) removeConversationObserver:(TIMConversationType)type receiver:(NSString *)receiver{
    NSString *key = [self getIdentifier:type receiver:receiver];
    [self.observers removeObjectForKey:key];
}

#pragma mark - Private methods
- (NSString *)getIdentifier:(TIMConversationType)type receiver:(NSString *)receiver{
    NSString *identfier = [NSString stringWithFormat:(@"%ld%@"), (long)type,receiver];
    return identfier;
}

@end
