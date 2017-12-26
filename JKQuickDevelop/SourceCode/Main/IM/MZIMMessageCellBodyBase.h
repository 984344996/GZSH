//
//  MZIMMessageCellBodyBase.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDImageCache.h>
#import "UIView+JKFrame.h"

#pragma mark - UI Define

#define kIMMaxAudioWidth 260
#define kIMAudioHeight 40
#define kIMPhotoWidthHeight 140
#define kIMMaxTextScreenRatio 0.6

#define kIMTextFont 14
#define kIMTextMarginTriangle 14
#define kIMTextMarginRectangle 10
#define kIMTextMarginTopBottom 10

#define kIMAudioIconWidth 15
#define kIMAudioIconHeight 20

@class MZIMMessage;
@interface MZIMMessageCellBodyBase : UIView
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) MZIMMessage *message;

- (instancetype)initWithMessage:(MZIMMessage *)message;

/**
 初始化视图 继承实现
 */
- (void)initView;

/**
 配置视图 继承实现
 */
- (void)setupView;

/**
 消息体大小
 @return CGSize
 */
- (CGSize)getBodySize;

/**
 消息体大小
 */
+ (CGSize)getBodySize:(MZIMMessage *)message;

/**
 文字消息体View大小
 */
+ (CGSize)getSizeForTextMessage:(MZIMMessage *)message;

/**
 图片消息体View大小
 */
+ (CGSize)getSizeForImageMessage:(MZIMMessage *)message;

/**
 语音消息体View大小
 */
+ (CGSize)getSizeForAudioMessage:(MZIMMessage *)message;

/**
 指定消息的背景图大小
 */
+ (UIImage *)getMessageBackgroundImage:(MZIMMessage *)message;
@end
