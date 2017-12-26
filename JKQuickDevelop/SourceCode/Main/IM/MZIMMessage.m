//
//  MZIMManager.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/16.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessage.h"
#import "MZIMModeExtra.h"
#import <MJExtension/MJExtension.h>
#import "MZIMFileHelper.h"

@interface MZIMMessage ()
- (BOOL)parseTIMMessage:(TIMMessage*)message;

- (BOOL)parseTextElement:(TIMElem*)elem;
- (BOOL)parseAudioElement:(TIMElem*)elem;
- (BOOL)parseImageElement:(TIMElem*)elem;
- (BOOL)parseCustomElement:(TIMElem*)elem;
- (BOOL)parseUserInfoElement:(TIMElem *)elem;
@end

@implementation MZIMMessage

#pragma mark - Implement methods
-(instancetype)initWithTIMMessage:(TIMMessage *)message{
    self = [super init];
    if(self){
        if (message.elemCount < 2){
            return nil;
        }
        
        self.timMessage = message;
        BOOL result = [self parseTIMMessage:message];
        if (!result){
            return nil;
        }
    }
    
    return self;
}

- (BOOL)isMessageFromSelf{
    return self.timMessage.isSelf;
}

- (NSString *)messageShowInConversationList{
    switch (self.messageType) {
        case MZIMMessageTypeText:
            return self.text;
        case MZIMMessageTypeAudio:
            return @"[语音]";
        case MZIMMessageTypeImage:
            return @"[图片]";
        default:
            return @"未知消息";
    }
}


#pragma mark - Private methods
- (BOOL)parseTIMMessage:(TIMMessage *)message{
    TIMElem *elemFirst = [message getElem:0];
    BOOL isSuccess = NO;
    
    if ([elemFirst isKindOfClass:[TIMTextElem class]]) {
        isSuccess = [self parseTextElement:elemFirst];
    }else if ([elemFirst isKindOfClass:[TIMSoundElem class]]){
        isSuccess = [self parseAudioElement:elemFirst];
    }else if([elemFirst isKindOfClass:[TIMImageElem class]]){
        isSuccess = [self parseImageElement:elemFirst];
    }else if([elemFirst isKindOfClass:[TIMCustomElem class]]){
        isSuccess = [self parseCustomElement:elemFirst];
    }else{
        isSuccess = NO;
    }
    
    isSuccess = [self parseUserInfoElement:[message getElem:1]];
    return isSuccess;
}

- (BOOL)parseTextElement:(TIMElem *)elem{
    self.messageType = MZIMMessageTypeText;
    TIMTextElem *elemText = (TIMTextElem *)elem;
    self.text = elemText.text;
    
    return YES;
}

-(BOOL)parseAudioElement:(TIMElem *)elem{
    self.messageType = MZIMMessageTypeAudio;
    TIMSoundElem *elemSound = (TIMSoundElem *)elem;
    self.audioSecond = elemSound.second;
    self.audioRecordPath = elemSound.path;
    self.audioElem = elemSound;
    ///同时设置语音存储路径
    self.audioLocalPath = [MZIMFileHelper getRecommendAudioStoreMessage:elemSound.uuid];
    return YES;
}

-(BOOL)parseImageElement:(TIMElem *)elem{
    self.messageType = MZIMMessageTypeImage;
    TIMImageElem *elemImage = (TIMImageElem *)elem;
    NSArray *imageList = elemImage.imageList;
    self.imageLocalPath = elemImage.path;
    
    for (TIMImage *image in imageList) {
        switch (image.type) {
            case TIM_IMAGE_TYPE_THUMB:
                self.imageThumbnailUrl = image.url;
                break;
            case TIM_IMAGE_TYPE_LARGE:
                self.imageLargeUrl = image.url;
                break;
            default:
                self.imageOriginalUrl = image.url;
                self.imageOriginalSize = CGSizeMake(image.width, image.height);
                break;
        }
    }
    return YES;
}

-(BOOL)parseCustomElement:(TIMElem *)elem{
    TIMCustomElem *elecustom = (TIMCustomElem *)elem;
    NSData *data = elecustom.data;
    
    MZIMMaterialInfo *material = [MZIMMaterialInfo mj_objectWithKeyValues:data];
    if (material.material_id == nil) {
        return NO;
    }
    
    self.matericalInfo = material;
    return YES;
}

-(BOOL)parseUserInfoElement:(TIMElem *)elem{
    if (![elem isKindOfClass:[TIMTextElem class]]){
        return NO;
    }
    
    NSString *infoString = ((TIMTextElem *)elem).text;
    IMUserInfo *userInfo = [IMUserInfo mj_objectWithKeyValues:infoString];
    if(!userInfo){
        return NO;
    }
    self.userInfo = userInfo;
    return YES;
}

@end
