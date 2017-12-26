//
//  MZIMRecorderHelper.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/29.
//  Copyright © 2016年 infomedia. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "MZIMRecorderHelper.h"
#import "NSTimer+JKBlocks.h"
#import "PathUtility.h"

#define kRecordMaxDuration 60

@interface  MZIMRecorderHelper()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic, assign)BOOL isCanceled;

- (BOOL)activeSession;
- (BOOL)initRecorder;
- (void)startRecording;
- (void)resetRecorderAndTimer;
- (NSInteger)getAudioDuration;
@end

@implementation MZIMRecorderHelper
static MZIMRecorderHelper *_sharedInstance = nil;

#pragma mark - Life circle
+ (instancetype )sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MZIMRecorderHelper alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Public methods
-(void)prepareAndRecordWithPath:(NSString *)path delegate:(id<MZIMRecorderHelperDelegate>)delegate{
    self.recordPath = path;
    self.delegate = delegate;
    self.isCanceled = NO;
    
    BOOL result = NO;
    result = [self activeSession];
    if (!result) {
        [delegate recordDidFailed:@"Session初始化失败"];
    }
    
    result = [self initRecorder];
    if (!result) {
        [delegate recordDidFailed:@"录音机初始化失败"];
    }
    
    [self startRecording];
}

-(void)stopRecord{
    [self.recorder stop];
}

-(void)cancelRecord{
    self.isCanceled = YES;
    [self.recorder stop];
}
#pragma mark - Private methods
- (BOOL)activeSession{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (sessionError) {
        return NO;
    }
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [session setActive:YES error:&sessionError];
    if (sessionError) {
        return NO;
    }
    return YES;
}

- (BOOL)initRecorder{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    NSURL *url = [NSURL fileURLWithPath:self.recordPath];
    
    NSError *error = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    if (error) {
        return NO;
    }
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    if ([self.recorder prepareToRecord]) {
        return YES;
    }
    
    return NO;
}

- (void)startRecording{
    if (!self.recorder.isRecording) {
        [self.recorder recordForDuration:kRecordMaxDuration];
        _timer = [NSTimer jk_scheduledTimerWithTimeInterval:0.2 block:^{
            WEAKSELF
            [weakSelf audioPowerChanged];
        } repeats:YES];
    }
}

- (void)audioPowerChanged{
    [self.recorder updateMeters];
    
    CGFloat peakPower = 0;
    peakPower = [_recorder peakPowerForChannel:0];
    peakPower = pow(10, (0.05 * peakPower));
    
    NSInteger peak = (NSInteger)((peakPower * 100)/20 + 1);
    if (peak < 1)
    {
        peak = 1;
    }
    else if (peak > 5)
    {
        peak = 5;
    }
    
    [self.delegate recordDidPowerChanged:peak];
}

- (void)resetRecorderAndTimer{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.recorder stop];
    self.recorder = nil;
}

- (NSInteger)getAudioDuration{
    NSError *error;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.recordPath] error:&error];
    if (error) {
        return 0;
    }else{
        return round(audioPlayer.duration);
    }
}

#pragma mark - Delegate
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    [self.delegate recordDidFailed:@"编码错误"];
    [self resetRecorderAndTimer];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if(self.isCanceled){
        [self.delegate recordDidCancled];
        [self.recorder deleteRecording];
        [self resetRecorderAndTimer];
        return;
    }
    
    if(![PathUtility isExistFile:self.recordPath]){
        [self.delegate recordDidFailed:@"录音文件丢失"];
        [self resetRecorderAndTimer];
        return;
    }
    
    NSInteger duration = [self getAudioDuration];
    if (duration <= 0) {
        [self.delegate recordDidFailed:@"录音时间太短"];
        [self resetRecorderAndTimer];
        return;
    }
    
    [self.delegate recordDidSuccess:self.recordPath duration:duration];
    [self resetRecorderAndTimer];
}
@end
