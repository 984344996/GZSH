//
//  MZIMConversation.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMConversation.h"
#import "MZIMMessage.h"
#import "MZIMMessageFactory.h"

@implementation MZIMConversation
#pragma mark - Public methods

- (instancetype)initWithTIMConversation:(TIMConversation *)conversation{
    self = [super init];
    if (self){
        self.timConversation = conversation;
    }
    return self;
}

- (instancetype)initWithType:(TIMConversationType)type andReceiver:(NSString *)receiver{
    TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:type receiver:receiver];
    if (!conversation){
        return nil;
    }
    
    return [self initWithTIMConversation:conversation];
}

- (void)loadMessages:(int)count lastMessage:(MZIMMessage *)message messageListCallback:(MZIMMessageListCallback)callback{
    [self.timConversation getMessage:count last:message.timMessage succ:^(NSArray *msgs) {
        NSArray *mzMessages = [self turnTimMessagesToMZMessages:msgs reverse:YES];
        callback(YES,nil,mzMessages);
    } fail:^(int code, NSString *msg) {
        callback(NO,msg,nil);
    }];
}

- (void)loadLocalMessages:(int)count lastMessage:(MZIMMessage *)message messageListCallback:(MZIMMessageListCallback)callback{
    [self.timConversation getLocalMessage:count last:message.timMessage succ:^(NSArray *msgs) {
        NSArray *mzMessages = [self turnTimMessagesToMZMessages:msgs reverse:YES];
        callback(YES,nil,mzMessages);
    } fail:^(int code, NSString *msg) {
        callback(NO,msg,nil);
    }];
}

- (void)loadLastMessage:(MZIMMessageListCallback)callback{
    NSArray *messages = [self loadLastMessages:1];
    if (messages.count >= 1){
        callback(YES,nil,messages);
    }else{
        [self loadMessages:1 lastMessage:nil messageListCallback:callback];
    }
}

- (NSArray *)loadLastMessages:(int)count{
    NSArray *messages = [self.timConversation getLastMsgs:count];
    return [self turnTimMessagesToMZMessages:messages reverse:NO];
}

-(void)setAllMessageRead{
    [self.timConversation setReadMessage];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMZIMMessageNotificationConversationReaded object:nil];
}

/**
 重写isEqual
 */
- (BOOL)isEqual:(id)object{
    if ([object isMemberOfClass:[MZIMConversation class]]){
        MZIMConversation *conversation = object;
        if ([conversation.timConversation getType] == [self.timConversation getType] &&
            [conversation.timConversation getReceiver] == [self.timConversation getReceiver]){
            return  YES;
        }
        return NO;
    }
    return NO;
}

#pragma mark - SendMessage
- (void)sendTextMessage:(NSString *)text mzCallback:(MZIMCallback)callback{
    TIMMessage *message = [[MZIMMessageFactory sharedInstance] makeTextMessage: text];
    if (!message) {
        return callback(NO,@"消息构造异常");
    }
    
    [self.timConversation sendMessage:message succ:^{
        callback(YES,nil);
    } fail:^(int code, NSString *msg){
        callback(NO,msg);
    }];
}

-(void)sendAudioMessage:(NSString *)audioPath second:(int)second mzCallback:(MZIMCallback)callback{
    TIMMessage *message = [[MZIMMessageFactory sharedInstance]makeAudioMessage:audioPath second:second];
    if (!message) {
        return callback(NO,@"消息构造异常");
    }
    
    [self.timConversation sendMessage:message succ:^{
        callback(YES,nil);
    } fail:^(int code, NSString *msg){
        callback(NO,msg);
    }];
}

-(void)sendImageMessage:(NSString *)imagePath mzCallback:(MZIMCallback)callback{
    TIMMessage *message = [[MZIMMessageFactory sharedInstance]makeImageMessage:imagePath];
    if (!message) {
        return callback(NO,@"消息构造异常");
    }
    
    [self.timConversation sendMessage:message succ:^{
        callback(YES,nil);
    } fail:^(int code, NSString *msg){
        callback(NO,msg);
    }];
}


- (void)sendCustomMessage:(MZIMMaterialInfo *)materialInfo mzCallback:(MZIMCallback) callback{
    TIMMessage *message = [[MZIMMessageFactory sharedInstance] makeCustomMaterialMessage:materialInfo];
    if (!message) {
        return callback(NO,@"消息构造异常");
    }
    
    [self.timConversation sendMessage:message succ:^{
        callback(YES,nil);
    } fail:^(int code, NSString *msg){
        callback(NO,msg);
    }];
}

#pragma mark - Private methods
- (NSArray *)turnTimMessagesToMZMessages:(NSArray *)timMesages reverse:(BOOL)reverse{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    
    if(reverse){
        for (id element in [timMesages reverseObjectEnumerator]) {
            [copyArray addObject:element];
        }
    }else{
        copyArray = timMesages.copy;
    }
    
    for (TIMMessage *timMessage in copyArray) {
        MZIMMessage *mzMessage = [[MZIMMessage alloc] initWithTIMMessage:timMessage];
        if (mzMessage){
            [array addObject: mzMessage];
        }
    }
    return array;
}

@end
