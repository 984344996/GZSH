//
//  MZIMMessageCellBodyAudio.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZIMMessageCellBodyBase.h"

#define kIMAudioLabelWidth (50)
#define kIMAudioLabelMarginLeftRight (10)
#define kIMAudioIconMarginLeftRight (15)

#define kIMAudioLabelTextColor [UIColor darkGrayColor]
#define kIMAudioLabelTextFontSize (11)

#define kIMAudioLabelTextFormat @"%ld'"
@interface MZIMMessageCellBodyAudio : MZIMMessageCellBodyBase
@property (nonatomic, strong) UIImageView  *imagePlay;
@property (nonatomic, strong) UILabel *labelDuration;

- (void)audioPlay;
- (void)audioStop;
- (BOOL)isAudioPlaying;
@end
