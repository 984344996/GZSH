//
//  MZIMMessageCellBodyAudio.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageCellBodyAudio.h"
#import "MZIMMessage.h"
#import "MZIMAudioPlayHelper.h"

@interface  MZIMMessageCellBodyAudio()
- (NSArray *)getImageArray;
@end

@implementation MZIMMessageCellBodyAudio

#pragma mark - Overrite methods
- (void)initView{
    [super initView];
    CGSize frameSize                 = [[self class] getBodySize:self.message];
    [self setJk_size:frameSize];

    self.backgroundImage.image       = [[self class] getMessageBackgroundImage:self.message];

    [self addSubview:self.imagePlay];

    self.labelDuration               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kIMAudioLabelWidth, self.jk_height)];
    self.labelDuration.textColor     = kIMAudioLabelTextColor;
    self.labelDuration.font          = [UIFont systemFontOfSize:kIMAudioLabelTextFontSize];
    self.labelDuration.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.labelDuration];
    
    [self layoutViews];
}

-(void)setupView{
    [super setupView];
    NSInteger second = self.message.audioSecond;
    self.labelDuration.text = [NSString stringWithFormat:kIMAudioLabelTextFormat,second];
    
    if ([[MZIMAudioPlayHelper sharedInstance] isAudioMessagePlaying:self.message]) {
        [self audioPlay];
    }else{
        [self audioStop];
    }
}

- (UIImageView *)imagePlay{
    if (!_imagePlay) {
        _imagePlay =  [[UIImageView alloc] initWithFrame:CGRectMake(0, (kIMAudioHeight - kIMAudioIconHeight) / 2, kIMAudioIconWidth, kIMAudioIconHeight)];
        
        if ([self.message isMessageFromSelf]) {
            _imagePlay.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
        }else{
            _imagePlay.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
        }
        
        _imagePlay.contentMode = UIViewContentModeScaleAspectFit;
        _imagePlay.animationDuration = 1;
        _imagePlay.animationRepeatCount = 0;
        _imagePlay.animationImages = [self getImageArray];
        [_imagePlay stopAnimating];
        
    }
    
    return _imagePlay;
}

+(CGSize)getBodySize:(MZIMMessage *)message{
    return [self getSizeForAudioMessage:message];
}
#pragma mark - Public methods;
- (void)audioPlay{
    [self.imagePlay startAnimating];
}

- (void)audioStop{
    [self.imagePlay stopAnimating];
}

- (BOOL)isAudioPlaying{
    return [self.imagePlay isAnimating];
}

#pragma mark - Private methods
- (void)layoutViews{
    BOOL isSelf = [self.message isMessageFromSelf];
    self.labelDuration.jk_left =  isSelf ? 0 : self.jk_width - kIMAudioLabelWidth;
    self.imagePlay.jk_left = isSelf ? kIMAudioLabelWidth + kIMAudioLabelMarginLeftRight +kIMAudioIconMarginLeftRight : self.jk_width - kIMAudioLabelWidth - kIMAudioLabelMarginLeftRight - kIMAudioIconMarginLeftRight;
    
    [self.backgroundImage setFrame:isSelf ? CGRectMake(kIMAudioLabelWidth + kIMAudioLabelMarginLeftRight, 0, self.jk_width - kIMAudioLabelWidth - kIMAudioLabelMarginLeftRight ,self.jk_height) : CGRectMake(0, 0, self.jk_width - kIMAudioLabelWidth - kIMAudioLabelMarginLeftRight, self.jk_height)];
}

- (NSArray *)getImageArray{
    NSString *imagePrefix;
    if ([self.message isMessageFromSelf]) {
        imagePrefix = @"Sender";
    }else{
        imagePrefix = @"Receiver";
    }
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[imagePrefix stringByAppendingFormat:@"VoiceNodePlaying00%ld", (long)i]];
        if (image)
            [imageArray addObject:image];
    }
    return imageArray;
}
@end
