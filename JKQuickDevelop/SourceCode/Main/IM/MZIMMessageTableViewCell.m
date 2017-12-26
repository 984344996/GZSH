//
//  MZIMMessageTableViewCell.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+JKFrame.h"
#import "NSString+JKSize.h"
#import "MZIMMessageCellBodyText.h"
#import "MZIMMessageCellBodyAudio.h"
#import "MZIMMessageCellBodyImage.h"

static IMAvatarType avatarType = IMAvatarTypeRectangle;

@interface  MZIMMessageTableViewCell()
@property (nonatomic, assign)BOOL displayTimestamp;

- (void)initView;
- (void)initEvent;
- (MZIMMessageCellBodyBase *)createMessageBodyWithMessage:(MZIMMessage *)message;
- (void)layoutViews;
- (void)addTapEventsToMessageBody;
@end

@implementation MZIMMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initView];
        [self initEvent];
    }
    
    return self;
}

#pragma mark - Public methods
- (void)configureCellWithMessage:(MZIMMessage *)message displayTimestamp:(BOOL)displayTimestamp{
    
    self.message = message;
    self.displayTimestamp = displayTimestamp;
    
    ///配置消息体
    if (self.messageBody) {
        [self.messageBody removeFromSuperview];
        self.messageBody = nil;
    }
    self.messageBody = [self createMessageBodyWithMessage:message];
    [self.contentView addSubview:self.messageBody];
    [self addTapEventsToMessageBody];
    
    ///设置昵称
    NSString *nick = self.message.userInfo.name ? self.message.userInfo.name :@"匿名";
    CGFloat width =  [nick jk_widthWithFont:[UIFont systemFontOfSize:kIMNickNameFont] constrainedToHeight:40];
    self.nickName.jk_width = width;
    self.nickName.text = nick;
    
    ///加载头像
    [self.avatar setImage:[UIImage imageNamed:@"headerPlaceHolder"] forState:UIControlStateNormal];
    NSString *urlString = self.message.userInfo.headerImage;
    NSURL *url = [NSURL URLWithString:urlString];
    if(url){
        [self.avatar.imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            WEAKSELF
            if(image)
                [weakSelf.avatar setImage:image forState: UIControlStateNormal];
        } ];
    }
    
    [self layoutViews];
    
}

+(CGFloat)getCellHeightByMessage:(MZIMMessage *)message displayTimestamp:(BOOL)displayTimestamp{
    
    CGFloat messageBodyheight = 0;
    switch (message.messageType) {
        case MZIMMessageTypeText:
            messageBodyheight = [MZIMMessageCellBodyText getBodySize:message].height;
            break;
        case MZIMMessageTypeAudio:
            messageBodyheight = [MZIMMessageCellBodyAudio getBodySize:message].height;
            break;
        case MZIMMessageTypeImage:
            messageBodyheight = [MZIMMessageCellBodyImage getBodySize:message].height;
            break;
        default:
            break;
    }
    
    CGFloat messageHeight = kIMMessageMarginTop;
    if (displayTimestamp) {
        messageHeight += kIMTimestampHeight + kIMTimestampMarginBottom;
    }
    
    messageHeight += kIMAvatarWidthHeight + messageBodyheight - kIMBodyAvatarDelta;
    return messageHeight;
}

#pragma mark - Private methods
-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    ///TimeStamp
    self.timestamp = [[UILabel alloc] init];
    self.timestamp.textColor = kIMTimestampColor;
    self.timestamp.font = [UIFont systemFontOfSize: kIMTimestampFont];
    [self.contentView addSubview:self.timestamp];
    
    ///Avatar
    self.avatar = [[UIButton alloc] init];
    [self.avatar setImage:[UIImage imageNamed:@"headerPlaceHolder"] forState:UIControlStateNormal];
    self.avatar.jk_size = CGSizeMake(kIMAvatarWidthHeight, kIMAvatarWidthHeight);
    
    if (avatarType == IMAvatarTypeRound) {
        self.avatar.imageView.layer.cornerRadius = kIMAvatarWidthHeight / 2;
        self.avatar.imageView.layer.masksToBounds = true;
    }
    [self.contentView addSubview:self.avatar];
    
    ///NickName
    self.nickName = [[UILabel alloc] init];
    self.nickName.jk_size = CGSizeMake(0, kIMNickNameHeight);
    self.nickName.font = [UIFont systemFontOfSize:kIMNickNameFont];
    self.nickName.textColor = kIMNickNameColor;
    [self.contentView addSubview:self.nickName];
    ///SendStatus
}

-(void)initEvent{
    //Add Long Press
    [self.avatar setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleAvatarLongPressed:)];
    longPress.minimumPressDuration = 1;
    longPress.delegate = self;
    [self.avatar addGestureRecognizer:longPress];
    
    //Add Single Press
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAvatarPressed:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.avatar addGestureRecognizer:tapGesture];
}

-(MZIMMessageCellBodyBase *)createMessageBodyWithMessage:(MZIMMessage *)message{
    MZIMMessageCellBodyBase *bodyBase;
    switch (message.messageType) {
        case MZIMMessageTypeText:
            bodyBase = [[MZIMMessageCellBodyText alloc] initWithMessage:message];
            break;
        case MZIMMessageTypeAudio:
            bodyBase = [[MZIMMessageCellBodyAudio alloc] initWithMessage:message];
            break;
        case MZIMMessageTypeImage:
            bodyBase = [[MZIMMessageCellBodyImage alloc] initWithMessage:message];
            break;
        default:
            bodyBase = [[MZIMMessageCellBodyText alloc] initWithMessage:message];
            break;
    }
    return bodyBase;
}

-(void)layoutViews{
    
    BOOL isSelf = [self.message isMessageFromSelf];
    
    CGFloat width = self.frame.size.width;
    CGFloat offsetY = kIMMessageMarginTop;
    ///头像
    self.avatar.jk_origin = isSelf ? CGPointMake(width - kIMAvatarMarginLeft - kIMAvatarWidthHeight, offsetY) : CGPointMake(kIMAvatarMarginLeft, offsetY);
    
    ///昵称
    CGFloat nickNameWidth = self.nickName.jk_width;
    self.nickName.jk_origin = isSelf ? CGPointMake(width -  kIMAvatarMarginLeft - kIMAvatarWidthHeight - kIMAvatarMarginRight - nickNameWidth, offsetY): CGPointMake(kIMAvatarMarginLeft + kIMAvatarMarginRight + kIMAvatarWidthHeight, offsetY);
    
    ///消息体
    CGSize size = [self.messageBody getBodySize];
    offsetY += kIMAvatarWidthHeight - kIMBodyAvatarDelta;
    self.messageBody.jk_origin = isSelf ? CGPointMake(width - kIMAvatarMarginLeft - kIMAvatarWidthHeight - kIMAvatarMarginRight - size.width, offsetY) : CGPointMake(kIMAvatarMarginLeft + kIMAvatarWidthHeight + kIMAvatarMarginRight, offsetY);
}

- (void)addTapEventsToMessageBody{
    [self.messageBody setUserInteractionEnabled:true];
    
    UILongPressGestureRecognizer *longTapRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(messageBodyLongTapped:)];
    [self.messageBody addGestureRecognizer:longTapRec];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageBodyTapped:)];
    [self.messageBody addGestureRecognizer:tapRec];
}

#pragma mark - Events dealing
- (void)handleAvatarLongPressed:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if([self.messageTappedDelegate respondsToSelector:@selector(didAvatarLongTapped:cell:)]){
            [self.messageTappedDelegate didAvatarLongTapped:self.message cell:self];
        }
    }
}

- (void)handleAvatarPressed:(id)sender{
    
}

- (void)messageBodyLongTapped:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan){
        if([self.messageTappedDelegate respondsToSelector:@selector(didMessageBodyLongTapped:cell:)]){
            [self.messageTappedDelegate didMessageBodyLongTapped:self.message cell:self];
        }
    }
}

- (void)messageBodyTapped:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        if([self.messageTappedDelegate respondsToSelector:@selector(didMessageBodyTapped:cell:)]){
            [self.messageTappedDelegate didMessageBodyTapped:self.message cell:self];
        }
    }
}

@end
