//
//  MZIMMessageCellBodyBase.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageCellBodyBase.h"
#import "MZIMMessage.h"
#import "NSString+JKSize.h"

@interface  MZIMMessageCellBodyBase()
@end

@implementation MZIMMessageCellBodyBase
#pragma mark - Public methods
-(instancetype)initWithMessage:(MZIMMessage *)message{
    self     = [super initWithFrame:CGRectZero];
    if(self){
    _message = message;
        [self initView];
        [self setupView];
    }
    return self;
}

+ (CGSize)getSizeForTextMessage:(MZIMMessage *)message{
    NSString *text              = message.text ? message.text : @"";
    CGFloat maxWidth            = kIMMaxTextScreenRatio * JK_SCREEN_WIDTH - kIMTextMarginTriangle - kIMTextMarginRectangle;
    
    CGFloat messageOneLineWidth = [text jk_widthWithFont:[UIFont systemFontOfSize:kIMTextFont] constrainedToHeight:20];
    CGFloat textHeight          = [text jk_heightWithFont:[UIFont systemFontOfSize:kIMTextFont] constrainedToWidth:maxWidth];
    CGFloat textWidth           = messageOneLineWidth > maxWidth ? maxWidth : messageOneLineWidth + kIMTextMarginTriangle + kIMTextMarginRectangle;
    return CGSizeMake(textWidth, textHeight + 2 * kIMTextMarginTopBottom);
}

+(CGSize)getSizeForImageMessage:(MZIMMessage *)message{
    CGSize originalSize = message.imageOriginalSize;
    if (CGSizeEqualToSize(originalSize, CGSizeZero)){
    UIImage *image      = [UIImage imageWithContentsOfFile:message.imageLocalPath];
        if(image){
    originalSize        = image.size;
        }else{
    originalSize        = CGSizeMake(kIMPhotoWidthHeight, kIMPhotoWidthHeight);
        }
    }

    CGFloat ratio       = originalSize.width / originalSize.height;
    if(ratio > 1){
        return CGSizeMake(kIMPhotoWidthHeight, kIMPhotoWidthHeight / ratio);
    }
    return CGSizeMake(kIMPhotoWidthHeight * ratio, kIMPhotoWidthHeight);
}

+(CGSize)getSizeForAudioMessage:(MZIMMessage *)message{
    NSInteger second = message.audioSecond;
    CGFloat ratio    = 1 - pow(0.9, second);
    CGFloat width    = MIN(100 + ratio * 160, kIMMaxAudioWidth);
    return CGSizeMake(width, kIMAudioHeight);
}

+ (UIImage *)getMessageBackgroundImage:(MZIMMessage *)message{
    NSMutableString *imageName = [NSMutableString stringWithString: @"message_buddy"];
    if ([message isMessageFromSelf]) {
        [imageName appendString:@"_sending"];
    }else{
        [imageName appendString:@"_receiving"];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(30, 28, 85, 28);
    return [image resizableImageWithCapInsets:edgeInset resizingMode:UIImageResizingModeStretch];
}

-(CGSize)getBodySize{
    return self.frame.size;
}

+(CGSize)getBodySize:(MZIMMessage *)message{
    return CGSizeZero;
}
#pragma mark - Private methods
-(void)initView{
    self.backgroundImage = [[UIImageView alloc] init];
    [self addSubview:self.backgroundImage];
}

-(void)setupView{

}

@end
