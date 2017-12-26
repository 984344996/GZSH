//
//  MZIMMessageCellBodyText.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageCellBodyText.h"
#import "MZIMMessage.h"

@implementation MZIMMessageCellBodyText

#pragma mark - Overrite methods
- (void)initView{
    [super initView];
    
    CGSize frameSize = [[self class] getBodySize:self.message];
    self.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
    
    self.backgroundImage.frame = self.frame;
    self.backgroundImage.image = [[self class] getMessageBackgroundImage:self.message];
    
    ///消息文本显示
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize: kIMTextFont];
    if ([self.message isMessageFromSelf]) {
        [self.textLabel setTextColor:kIMTextSelfColor];
    }else{
        [self.textLabel setTextColor:kIMTextOtherColor];
    }
    
    CGFloat textMargin =  [self.message isMessageFromSelf] ? kIMTextMarginRectangle : kIMTextMarginTriangle;
    CGSize textSize = CGRectInset(self.frame, (kIMTextMarginRectangle + kIMTextMarginTriangle) / 2, kIMTextMarginTopBottom).size;
    self.textLabel.frame = CGRectMake(textMargin, kIMTextMarginTopBottom, textSize.width, textSize.height);
    [self addSubview:_textLabel];
}

- (void)setupView{
    [super setupView];
    self.textLabel.text = self.message ? self.message.text : @"";
}

+(CGSize)getBodySize:(MZIMMessage *)message{
    return [self getSizeForTextMessage:message];
}

@end
