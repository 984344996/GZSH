//
//  MZIMManager.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMManager.h"
#import "MZIMConversation.h"
#import "MZIMListener.h"

@implementation MZIMManager

+(MZIMManager *)sharedManager{
    static MZIMManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[MZIMManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timManager = [TIMManager sharedInstance];
    }
    return self;
}

#pragma mark - Public methods
-(void)initSdk{
    [self addEventListeners];
    [self.timManager initSdk:kTIMAppID accountType:kTIMAccountType];
}

-(BOOL)isUserLogin{
    return self.timManager.getLoginUser == nil ? NO : YES;
}

- (void)quickLogin:(MZIMCallback)callback{
    /*
    UserInfo *userInfo = [UserInfo userInfoFromLocal];
    ThirdPartUserInfo *thirdPartInfo = [ThirdPartUserInfo localInfo];
    
    if (userInfo && thirdPartInfo) {
        NSString *imID = thirdPartInfo.mzchatInfo.imuid;
        NSString *imSign = thirdPartInfo.mzchatInfo.tim_userSig;
        [self login: imID userSign:imSign callbcack:callback];
    }else{
        if(callback){
            callback(NO,@"用户未登陆");
        }
    }
    */
}

- (void)login:(NSString *)imID userSign:(NSString *)userSign callbcack:(MZIMCallback)callback{
    if ([self isUserLogin]){
        if (callback){
            [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationLoginSuccess object:nil];
            return callback(YES,nil);
        }
    }
    
    [self.timManager login:imID userSig:userSign succ:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationLoginSuccess object:nil];
        if(callback){
            return callback(YES,nil);
        }
    } fail:^(int code, NSString *msg) {
        ///用户被踢下线需要再次登录
        if(code == ERR_IMSDK_KICKED_BY_OTHERS){
            [self login:imID userSign:userSign callbcack:callback];
        }else{
            if(callback){
                return callback(NO,msg);
            }
        }
    }];
}

-(NSArray *)loadAllConversations:(NSArray *)filterTypes{
    NSInteger count = [self.timManager ConversationCount];
    NSMutableArray *conversations = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        TIMConversation *conversation = [self.timManager getConversationByIndex:i];
        if(![filterTypes containsObject:[NSNumber numberWithInteger:[conversation getType]]]){
            continue;
        }
        
        MZIMConversation *mzConversation = [[MZIMConversation alloc] initWithTIMConversation:conversation];
        if (mzConversation){
            [conversations addObject: mzConversation];
        }
    }
    return conversations;
}

-(NSInteger)getMessageUnreadTotalNum:(NSArray *)filterTypes{
    NSInteger count = [self.timManager ConversationCount];
    NSInteger unreadMessageCount = 0;
    
    for (int i = 0; i < count; i++) {
        TIMConversation *conversation = [self.timManager getConversationByIndex:i];
        if(![filterTypes containsObject:[NSNumber numberWithInteger:[conversation getType]]]){
            continue;
        }
        unreadMessageCount += [conversation getUnReadMessageNum];
    }
    return unreadMessageCount;
}


- (MZIMConversation *)loadConversation:(TIMConversationType)type andReceiver:(NSString *)receiver{
    TIMConversation *conversation = [self.timManager getConversation:type receiver:receiver];
    if(!conversation){
        return nil;
    }
    
    MZIMConversation *mzConversation = [[MZIMConversation alloc] initWithTIMConversation:conversation];
    return mzConversation;
}

-(BOOL)deleteConversation:(MZIMConversation *)conversation  deleteMessages:(BOOL)deleteMessages{
    TIMConversation *timConversation = conversation.timConversation;
    return  [self deleteConversation:[timConversation getType] andReceiver:[timConversation getReceiver] deleteMessages:deleteMessages];
}

-(BOOL)deleteConversation:(TIMConversationType)type andReceiver:(NSString *)receiver deleteMessages:(BOOL)deleteMessages{
    BOOL result = NO;
    if (deleteMessages){
        result =  [self.timManager deleteConversationAndMessages:type receiver:receiver];
    }else{
        result =  [self.timManager deleteConversation:type receiver:receiver];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationConversationDeleted object:nil];
    return result;
}

#pragma mark - Private methods
- (void)addEventListeners{
    [self.timManager setMessageListener:[MZIMListener sharedInstance]];
    [self.timManager setConnListener:[MZIMListener sharedInstance]];
    [self.timManager setUserStatusListener:[MZIMListener sharedInstance]];
}

@end
