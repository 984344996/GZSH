//
//  MZIMChatInputBar.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMChatInputBar.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "KVOController.h"
#import "UIView+JKFrame.h"

#define kMZIMRecordViewSize CGSizeMake(130,130)
@implementation MZIMRecordView
- (void)dealloc
{
    [self.KVOController unobserveAll];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self addOwnViews];
        [self prepareForUse];
    }
    return self;
}

- (void)addOwnViews
{
    self.image = [UIImage imageNamed:@"sound_record"];
    [self setJk_size:kMZIMRecordViewSize];
    
    self.imageTip = [[UIImageView alloc] init];
    [self.imageTip setJk_size:CGSizeMake(kMZIMRecordViewSize.width / 2,kMZIMRecordViewSize.height / 2)];
    [self.imageTip setCenter:self.center];
    self.imageTip.contentMode = UIViewContentModeCenter;
    [self addSubview:self.imageTip];
    
    self.tip = [[UILabel alloc] init];
    [self.tip setJk_size:CGSizeMake(120, 20)];
    [self.tip setCenter:CGPointMake(kMZIMRecordViewSize.width / 2, kMZIMRecordViewSize.height - 20)];
    self.tip.textColor = kWhiteColor;
    self.tip.font = [UIFont systemFontOfSize:12];
    self.tip.textAlignment = NSTextAlignmentCenter;
    self.tip.layer.cornerRadius = 2;
    [self addSubview:self.tip];
}

- (void)kvoSoundRecorder:(MZIMChatInputBar *)inputBar
{
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    __weak MZIMRecordView *ws = self;
    [self.KVOController observe:inputBar keyPath:@"recordPeak" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onRecorderPeakChanged:(MZIMChatInputBar *)object];
    }];
    
    [self.KVOController observe:inputBar keyPath:@"recordState" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [ws onRecorderPeakStateChanged:(MZIMChatInputBar *)object];
    }];
}

-(void)prepareForUse{
    self.imageTip.image = [UIImage imageNamed:@"microphone1"];
    self.tip.backgroundColor = kClearColor;
    self.tip.text = @"手指上滑，取消发送";
}

- (void)fadeIn:(BOOL)fadeIn duration:(NSTimeInterval)duration{
    CGFloat fromAlpha = 1.0;
    CGFloat toAlpha = 0;
    if (fadeIn) {
        fromAlpha = 0;
        toAlpha = 1.0;
    }
    
    self.alpha = fromAlpha;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = toAlpha;
    }];
}

- (void)onRecorderPeakChanged:(MZIMChatInputBar *)inputBar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger peak = inputBar.recordPeak;
        NSString *tip = [NSString stringWithFormat:@"microphone%d",(int)peak];
        self.imageTip.image = [UIImage imageNamed:tip];
    });
}

- (void)onRecorderPeakStateChanged:(MZIMChatInputBar *)inputBar
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (inputBar.recordState) {
            case MZIMRecordViewStatusUpToCancel:
                self.tip.text = @"手指上滑，取消发送";
                self.tip.backgroundColor = kClearColor;
                break;
            case MZIMRecordViewStatusReleaseToCancel:
                self.tip.text = @"松开手指，取消发送";
                self.tip.backgroundColor = kRedColor;
                break;
            default:
                break;
        }
    });
}


@end

@implementation MZIMChatInputBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = RGBAOF(0xEEEEEE, 1);
        [self initView];
    }
    return self;
}

#pragma mark - Public methods
- (CGFloat)proposalInputHeight{
    return kButtonSize + 2 * kVerMargin;
}

-(void)showRecordView{
    UIViewController *topViewController = [AppDelegate sharedAppDelegate].topViewController;
    if (!_recordView)
    {
        _recordView = [[MZIMRecordView alloc] init];
        [_recordView kvoSoundRecorder:self];
        
        UIView *view = topViewController.view;
        [view addSubview:_recordView];
        _recordView.center = view.center;
    }
    
    //禁用导航栏上右侧按钮
    UIBarButtonItem *rightItem = topViewController.navigationItem.rightBarButtonItem;
    rightItem.enabled = NO;
    
    [self.recordView prepareForUse];
    [self.recordView fadeIn:YES duration:0.2];
}

-(void)hideRecordView{
    //启用导航栏上右侧按钮
    UIBarButtonItem *rightItem = [AppDelegate sharedAppDelegate].topViewController.navigationItem.rightBarButtonItem;
    rightItem.enabled = YES;
    [self.recordView fadeIn:NO duration:0.2];
}

#pragma mark - Private methods
-(void)setInputType:(MZIMInputType)inputType{
    _inputType = inputType;
    switch (inputType) {
        case MZIMInputTypeText:
            [_btnChangeInputType setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
            [self.textViewInput setHidden:NO];
            [self.btnAudio setHidden:YES];
            break;
        default:
            [_btnChangeInputType setImage:[UIImage imageNamed:@"chat_toolbar_keyboard_nor"] forState:UIControlStateNormal];
            [self.textViewInput setHidden:YES];
            [self.btnAudio setHidden:NO];
            break;
    }
    [self.delegate inputTypeChanged:inputType];
}

- (void)initView{
    _inputType = MZIMInputTypeText;
    
    _btnChangeInputType = [[UIButton alloc] init];
    [_btnChangeInputType setImage:[UIImage imageNamed:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
    [_btnChangeInputType addTarget:self action:@selector(onClickChangeType:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnChangeInputType];
    
    // 语音按钮
    _btnAudio = [[UIButton alloc] init];
    _btnAudio.layer.cornerRadius = 6;
    _btnAudio.layer.borderColor = kGrayColor.CGColor;
    _btnAudio.layer.shadowColor = kBlackColor.CGColor;
    _btnAudio.layer.shadowOffset = CGSizeMake(1, 1);
    _btnAudio.layer.borderWidth = 0.5;
    _btnAudio.layer.masksToBounds = YES;
    [_btnAudio setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[_btnAudio setBackgroundImage:[UIImage imageWithColor:RGBAOF(0xEEEEEE, 1)] forState:UIControlStateNormal];
    //[_btnAudio setBackgroundImage:[UIImage imageWithColor:kLightGrayColor] forState:UIControlStateSelected];
    
    [_btnAudio setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_btnAudio setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    _btnAudio.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_btnAudio addTarget:self action:@selector(onClickRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_btnAudio addTarget:self action:@selector(onClickRecordDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_btnAudio addTarget:self action:@selector(onClickRecordDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_btnAudio addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_btnAudio addTarget:self action:@selector(onClickRecordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnAudio.hidden = YES;
    [self addSubview:_btnAudio];
    
    _textViewInput = [[UITextView alloc] init];
    _textViewInput.frame = CGRectMake(0, 0, self.frame.size.width, CHAT_BAR_MIN_H);
    _textViewInput.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textViewInput.scrollEnabled = YES;
    _textViewInput.returnKeyType = UIReturnKeySend;
    _textViewInput.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _textViewInput.delegate = self;
    _textViewInput.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _textViewInput.layer.borderWidth = 0.6;
    _textViewInput.layer.cornerRadius = 6;
    _textViewInput.font = [UIFont systemFontOfSize:16];
    
    _textViewInput.textContainerInset = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:_textViewInput];
    
    _btnEmoj = [[UIButton alloc] init];
    [_btnEmoj setImage:[UIImage imageNamed:@"chat_toolbar_smile_nor"] forState:UIControlStateNormal];
    [_btnEmoj setImage:[UIImage imageNamed:@"chat_toolbar_smile_press"] forState:UIControlStateHighlighted];
    [_btnEmoj addTarget:self action:@selector(onClickEmoj:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnEmoj];
    
    
    _btnMore = [[UIButton alloc] init];
    [_btnMore setImage:[UIImage imageNamed:@"chat_toolbar_more_nor"] forState:UIControlStateNormal];
    [_btnMore setImage:[UIImage imageNamed:@"chat_toolbar_more_press"] forState:UIControlStateHighlighted];
    [_btnMore addTarget:self action:@selector(onClickMore:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnMore];
}

- (void)startRecord
{
    // 获取麦克风权限
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        [avSession requestRecordPermission:^(BOOL available) {
            WEAKSELF
            if (!available)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”中允许访问麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate inputBarRecordStart];
                });
            }
        }];
    }
}


#pragma mark - Events dealing
- (void)onClickChangeType:(UIButton *)button{
    if (self.inputType == MZIMInputTypeText) {
        self.inputType = MZIMInputTypeAudio;
    }else{
        self.inputType = MZIMInputTypeText;
    }
}

- (void)onClickRecordTouchDown:(UIButton *)button
{
    [self startRecord];
}

- (void)onClickRecordDragExit:(UIButton *)button
{
    self.recordState = MZIMRecordViewStatusReleaseToCancel;
}

- (void)onClickRecordDragEnter:(UIButton *)button
{
    self.recordState = MZIMRecordViewStatusUpToCancel;
}

- (void)onClickRecordTouchUpOutside:(UIButton *)button
{
    [self.delegate inputBarRecordCancel];
}

- (void)onClickRecordTouchUpInside:(UIButton *)button
{
    [self.delegate inputBarRecordStop];
}


- (void)onClickEmoj:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(inputBarEmojClick)]) {
        [self.delegate inputBarEmojClick];
    }
}

- (void)onClickMore:(UIButton *)button{
    
}

#pragma mark- UITextFieldDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([self.delegate respondsToSelector:@selector(inputBarTextFieldReturn:)])
        {
            if (textView.text.length > 0)
            {
                [self.delegate inputBarTextFieldReturn:textView.text];
            }
            self.textViewInput.text = @"";
        }
        
        return NO;
    }
    return YES;
}



#pragma mark - Overrite methods
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize parentSize = self.bounds.size;
    self.btnChangeInputType.frame = CGRectMake(kHorMargin, parentSize.height - kVerMargin - kButtonSize, kButtonSize, kButtonSize);
    
    self.btnMore.frame = CGRectMake(parentSize.width - kHorMargin - kButtonSize, parentSize.height - kVerMargin - kButtonSize, kButtonSize, kButtonSize);
    self.btnEmoj.frame = CGRectMake(parentSize.width - kHorMargin * 2 - kButtonSize * 2, parentSize.height - kVerMargin - kButtonSize, kButtonSize, kButtonSize);
    
    self.btnAudio.frame = CGRectMake(kHorMargin * 2 + kButtonSize, parentSize.height - kVerMargin - kButtonSize, parentSize.width - kHorMargin * 5 - kButtonSize * 3, kButtonSize);
    
    CGRect rect = self.bounds;
    CGRect apframe = self.btnAudio.frame;
    
    rect.origin.x = apframe.origin.x;
    rect.origin.y = kVerMargin;
    rect.size.height -=  2 * kVerMargin;
    rect.size.width = apframe.size.width;
    self.textViewInput.frame = rect;
}

@end
