//
//  MZIMAudioPlayHelper.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/29.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMAudioPlayHelper.h"
#import "MZIMMessage.h"
#import "MZIMMessageTableViewCell.h"
#import "MZIMMessageCellBodyAudio.h"
#import "PathUtility.h"
#import <ImSDK/ImSDK.h>


@interface MZIMAudioPlayHelper ()<AVAudioPlayerDelegate>
@end

@implementation MZIMAudioPlayHelper
+ (instancetype)sharedInstance{
    static MZIMAudioPlayHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MZIMAudioPlayHelper alloc] init];
    });
    
    return instance;
}

- (void)playMessageWithCell:(MZIMMessage *)message andCell:(MZIMMessageTableViewCell *)cell{
    [self stopPlay];
    
    self.message  = message;
    self.playCell = cell;
    
    [self getAudioPathOrDownLoad:^(NSString *path){
        NSURL *audioUrl = [NSURL URLWithString:path];
        NSError *error  = nil;

        self.player     = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&error];
        self.player.delegate = self;
        [self.player prepareToPlay];
        [self.player play];
        
        MZIMMessageCellBodyAudio *audio = (MZIMMessageCellBodyAudio *)self.playCell.messageBody;
        [audio audioPlay];
    }];
    
}

- (void)getAudioPathOrDownLoad:(void(^)(NSString *path)) callback{
    if ([PathUtility isExistFile:self.message.audioRecordPath]) {
        return callback(self.message.audioRecordPath);
    }
    
    if ([PathUtility isExistFile:self.message.audioLocalPath]) {
        return callback(self.message.audioLocalPath);
    }
    
    [self.message.audioElem getSoundToFile:self.message.audioLocalPath succ:^{
        return callback(self.message.audioLocalPath);
    } fail:^(int code, NSString *msg) {
    }];
}

- (void)stopPlay{
    [self.player stop];
    MZIMMessageCellBodyAudio *audio = (MZIMMessageCellBodyAudio *)self.playCell.messageBody;
    [audio audioStop];
    
    self.message = nil;
    self.playCell = nil;
    self.player = nil;
}


- (BOOL)isAudioMessagePlaying:(MZIMMessage *)message{
    if (message.messageType != MZIMMessageTypeAudio || !self.message) {
        return NO;
    }
    
    if ([message.timMessage.msgId isEqualToString:self.message.timMessage.msgId]) {
        return YES;
    }
    return NO;
}
#pragma mark - Delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlay];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self stopPlay];
}

@end
