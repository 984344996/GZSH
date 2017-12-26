//
//  MZIMMessageTableViewCell.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZIMMessage.h"
#import "MZIMMessageCellBodyBase.h"

#pragma mark - UI define

#define kIMAvatarWidthHeight (40)
#define kIMNickNameHeight (14)
#define kIMTimestampHeight (15)
#define KIMSendingStatusViewWidthHeight (25)

#define kIMMessageMarginTop (10)
#define kIMTimestampMarginBottom (10)
#define kIMAvatarMarginLeft (10)
#define kIMAvatarMarginRight (5)
#define kIMNickNameMaxWidth (100)
#define kIMBodyAvatarDelta (15)

#define kIMNickNameFont 11
#define kIMTimestampFont 10

#define kIMTimestampColor [UIColor darkGrayColor]
#define kIMNickNameColor [UIColor darkGrayColor]

@class MZIMMessageTableViewCell;

typedef NS_ENUM(NSInteger,IMSendingFrom){
    IMSendingFromOther,
    IMSendingFromSelf
};

typedef NS_ENUM(NSInteger,IMAvatarType) {
    IMAvatarTypeRound,
    IMAvatarTypeRectangle
};

@protocol MZIMMessageTappedDelegate <NSObject>
@optional
/**
 头像单点事件
 */
- (void)didAvatarTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell;

/**
 头像长点事件
 */
- (void)didAvatarLongTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell;

/**
 消息体点击事件
 */
- (void)didMessageBodyTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell;

/**
 消息体双击事件
 */
- (void)didMessageBodyDoubleTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell;

/**
 消息体长点事件
 */
- (void)didMessageBodyLongTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell;
@end

@interface MZIMMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) MZIMMessage *message;
@property (nonatomic, assign) IMSendingFrom from;
@property (nonatomic, weak) id<MZIMMessageTappedDelegate>messageTappedDelegate;

@property (nonatomic, strong) UILabel *timestamp;
@property (nonatomic, strong) UIButton *avatar;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) MZIMMessageCellBodyBase *messageBody;

/**
 根据消息配置Cell

 @param message 消息
 @param displayTimestamp 是否显示时间
 */
- (void)configureCellWithMessage:(MZIMMessage *)message displayTimestamp:(BOOL)displayTimestamp;

/**
 获取cell高度

 @param message 消息
 @param displayTimestamp 是否显示时间
 @return Cell高度
 */
+ (CGFloat)getCellHeightByMessage:(MZIMMessage *)message displayTimestamp:(BOOL)displayTimestamp;
@end


