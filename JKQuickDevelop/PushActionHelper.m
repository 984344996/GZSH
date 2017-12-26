//
//  PushActionHelper.m
//  JKQuickDevelop
//
//  Created by dengjie on 2017/3/31.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "PushActionHelper.h" 
NSString * const NotificationPushReceived = @"notificationPushReceived";
NSString * const NotificationActionTapped = @"notificationActionTapped";

@implementation PushActionItem

-(instancetype)initWithType:(ActionItemType)actionType andIdentifier:(NSString *)actionIdentifier andUserInfo:(NSDictionary *)userInfo andIsFromRemote:(BOOL)isFromRemote{
    if (self = [super init]){
        self.actionType       = actionType;
        self.actionIdentifier = actionIdentifier;
        self.userInfo         = userInfo;
        self.isFromRemote     = isFromRemote;
    }
    return self;
}
@end


@implementation PushActionHelper

+ (PushActionHelper *)sharedHelper{
    static PushActionHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PushActionHelper alloc] init];
    });
    
    return instance;
}

#pragma mark - Public methods
- (void)handActionTapped:(NSString *)actionIdentifier  userInfo:(NSDictionary *)userInfo isFromRemote:(BOOL)isFromRemote;{
    self.actionWaitToDeal = [[PushActionItem alloc] initWithType:ActionItemTypeActionTapped
                                                   andIdentifier:actionIdentifier
                                                     andUserInfo:userInfo
                                                 andIsFromRemote:isFromRemote];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationActionTapped object:nil];
    DLog("ActionTapped Identifier%@,info:%@",actionIdentifier,userInfo);
}

- (void)handPushReceived:(NSDictionary *)userInfo isFromRemote:(BOOL)isFromRemote{
    self.actionWaitToDeal = [[PushActionItem alloc] initWithType:ActionItemTypePush
                                                   andIdentifier:nil
                                                     andUserInfo:userInfo
                                                 andIsFromRemote:isFromRemote];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPushReceived object:nil];
    DLog("ActionReceived info:%@",userInfo);
}

#pragma mark - Private methods

@end
