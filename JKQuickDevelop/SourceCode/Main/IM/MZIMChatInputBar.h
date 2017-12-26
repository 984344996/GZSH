//
//  MZIMChatInputBar.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonSize 36
#define kTextViewMaxHeight 72

#define kVerMargin 7
#define kHorMargin 8

#define CHAT_BAR_MIN_H 36
#define CHAT_BAR_MAX_H 72


/**
 输入类型

 - MZIMInputTypeText: 文本
 - MZIMInputTypeAudio: 语音
 */
typedef NS_ENUM(NSInteger,MZIMInputType){
    MZIMInputTypeText,
    MZIMInputTypeAudio
};

/**
 录音显示状态

 - MZIMRecordViewStatusReleaseToCancel: 手指松开,取消发送
 - MZIMRecordViewStatusUpToCancel: 手指上滑,取消发送
 */
typedef NS_ENUM(NSInteger,MZIMRecordViewStatus){
    MZIMRecordViewStatusReleaseToCancel,
    MZIMRecordViewStatusUpToCancel
};

/**
 键盘事件代理
 */
@protocol MZIMChatInputBarDelegate <NSObject>
@optional
- (void)inputBarTextFieldReturn:(NSString *)text;
- (void)inputBarMoreClick;
- (void)inputBarEmojClick;
- (void)inputTypeChanged:(MZIMInputType)type;
@required
- (void)inputBarRecordStart;
- (void)inputBarRecordStop;
- (void)inputBarRecordCancel;
@end

/**
 录音动画显示View
 */
@class MZIMChatInputBar;
@interface MZIMRecordView : UIImageView
@property (nonatomic, strong) UIImageView *imageTip;
@property (nonatomic, strong) UILabel *tip;

- (void)kvoSoundRecorder:(MZIMChatInputBar *)inputBar;
- (void)prepareForUse;
- (void)fadeIn:(BOOL)fadeIn duration:(NSTimeInterval)duration;
@end


@interface MZIMChatInputBar : UIView<UITextViewDelegate>
/**
 推荐高度
 */
@property (nonatomic, weak) id<MZIMChatInputBarDelegate> delegate;
@property (nonatomic, assign) CGFloat proposalInputHeight;
@property (nonatomic, assign) MZIMInputType inputType;
@property (nonatomic, assign) NSInteger recordPeak;
@property (nonatomic, assign) MZIMRecordViewStatus recordState;

@property (nonatomic, strong) MZIMRecordView *recordView;
@property (nonatomic, strong) UIButton *btnChangeInputType;
@property (nonatomic, strong) UIButton *btnAudio;
@property (nonatomic, strong) UITextView *textViewInput;
@property (nonatomic, strong) UIButton *btnEmoj;
@property (nonatomic, strong) UIButton *btnMore;

- (void)showRecordView;
- (void)hideRecordView;
@end
