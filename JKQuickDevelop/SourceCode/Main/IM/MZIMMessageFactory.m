//
//  MZIMMessageFactory.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageFactory.h"


@implementation MZIMMessageFactory

+ (MZIMMessageFactory *)sharedInstance{
    static MZIMMessageFactory *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MZIMMessageFactory alloc] init];
    });
    
    return instance;
}

-(TIMMessage *)makeTextMessage:(NSString *)text{
    TIMMessage *message = [[TIMMessage alloc] init];
    
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    textElem.text = text;
    [message addElem:textElem];
    
    BOOL hasInfo = [self addUserInfoElem:message];
    if (hasInfo) {
        return message;
    }
    return nil;
}

-(TIMMessage *)makeImageMessage:(NSString *)imagePath{
    TIMMessage *message = [[TIMMessage alloc]init];
    
    TIMImageElem *imageElem = [[TIMImageElem alloc] init];
    imageElem.path =  imagePath;
    imageElem.level = TIM_IMAGE_COMPRESS_HIGH;
    [message addElem:imageElem];
    
    BOOL hasInfo = [self addUserInfoElem:message];
    if (hasInfo) {
        return message;
    }
    return nil;
}


-(TIMMessage *)makeAudioMessage:(NSString *)audioPath second:(int)second{
    TIMMessage *message = [[TIMMessage alloc]init];
    
    TIMSoundElem *audioElem = [[TIMSoundElem alloc] init];
    audioElem.path = audioPath;
    audioElem.second = second;
    [message addElem:audioElem];
    
    BOOL hasInfo = [self addUserInfoElem:message];
    if (hasInfo) {
        return message;
    }
    return nil;
}

- (TIMMessage *)makeCustomMaterialMessage:(MZIMMaterialInfo *)materialInfo{
    TIMMessage *message = [[TIMMessage alloc] init];
    
    NSData *data = [materialInfo mj_JSONData];
    TIMCustomElem *customElem = [[TIMCustomElem alloc] init];
    customElem.data = data;
    [message addElem:customElem];
    
    BOOL hasInfo = [self addUserInfoElem:message];
    if (hasInfo) {
        return message;
    }
    return nil;
}

-(BOOL)addUserInfoElem:(TIMMessage *)message{
    IMUserInfo *info = [[IMUserInfo alloc] init];
    if (!info || !info.ID || !info.imuid) {
        return NO;
    }
    
    NSString *jsonString =  [info mj_JSONString];
    TIMTextElem *elem =  [[TIMTextElem alloc] init];
    elem.text = jsonString;
    [message addElem:elem];
    
    return YES;
}
@end
