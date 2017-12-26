//
//  MZIMChatViewController.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "UIView+JKFrame.h"
#import "MZIMChatViewController.h"
#import "MZIMManager.h"
#import "MZIMConversation.h"
#import "MZIMMessageDispatcher.h"
#import "MZIMMessage.h"
#import "MZIMModeExtra.h"
#import "MZIMMessageTableViewCell.h"
#import "MZIMChatInputBar.h"
#import "MZIMTableViewController.h"
#import <MJExtension/MJExtension.h>
#import "MBProgressHUD.h"
#import "MZIMRecorderHelper.h"
#import "MZIMFileHelper.h"
#import "MZIMAudioPlayHelper.h"

///测试信息
#define kMessageLoadCount 30
#define kMZIMMessageTableViewCellIdentfier @"kMZIMMessageTableViewCellIdentfier"

@interface  MZIMChatViewController()<MZIMMessageDispatcherDelegate,MZIMChatInputBarDelegate,MZIMTableViewDelegate,MZIMRecorderHelperDelegate>
///Views
@property (nonatomic, strong) MZIMTableViewController *tableViewController;
@property (nonatomic, strong) MZIMChatInputBar *inputBar;
///Data
@property (nonatomic, assign) TIMConversationType chatType;
@property (nonatomic, copy) NSString* receiver;
@property (nonatomic, strong) MZIMConversation *conversation;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, assign) BOOL keyboardIsShow;

@property (nonatomic, strong) MZIMMessage *playingMessage;
@property (nonatomic, strong) MZIMMessage *longPressedMessage;

- (void)initView;
- (void)initEvents;
- (void)layoutViews;
- (void)checkLogin;
- (void)initConversation;
- (void)loadMessages:(BOOL) isRefresh;
- (void)addNotifications;
@end

@implementation MZIMChatViewController

#pragma mark - Getter and Setter
- (MZIMChatInputBar *)inputBar{
    if (!_inputBar) {
        _inputBar = [[MZIMChatInputBar alloc] initWithFrame:CGRectZero];
        _inputBar.delegate = self;
    }
    return _inputBar;
}

#pragma mark - LifeCircle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    [self initEvents];
    [self layoutViews];
    [self checkLogin];
    [self initConversation];
    [self sendShareMessageIfNeeded];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[MZIMMessageDispatcher sharedInstance] addConversationObserver:self.chatType receiver:self.receiver delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[MZIMMessageDispatcher sharedInstance] removeConversationObserver:self.chatType receiver:self.receiver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}


#pragma mark - Public methods
- (instancetype)initWithUser:(NSString *)receiver{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _chatType = TIM_C2C;
        _receiver = receiver;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithGroup:(NSString *)receiver{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _chatType = TIM_GROUP;
        _receiver = receiver;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTypeAndReceiver:(TIMConversationType)type receiver:(NSString *)receiver{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _chatType = type;
        _receiver = receiver;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _playingMessage = nil;
    _messages = [[NSMutableArray alloc] init];
}

#pragma mark - Private methods
- (void)initView{
    self.playingMessage = nil;
    self.tableViewController = [[MZIMTableViewController alloc] init];
    self.tableViewController.delegate = self;
    [self.tableViewController willMoveToParentViewController:self];
    [self addChildViewController:self.tableViewController];
    [self.tableViewController didMoveToParentViewController:self];
    [self.view addSubview:self.tableViewController.view];
    
    [self.view addSubview:self.inputBar];
}

-(void)initEvents{
    [self addNotifications];
}

- (void)layoutViews{
    self.inputBar.frame = CGRectMake(0, JK_SCREEN_HEIGHT - self.inputBar.proposalInputHeight, JK_SCREEN_WIDTH, self.inputBar.proposalInputHeight);
    
    self.tableViewController.view.frame = CGRectMake(0, 0, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT - self.inputBar.proposalInputHeight);
    self.tableViewController.tableView.frame = CGRectMake(0, 0, JK_SCREEN_WIDTH, JK_SCREEN_HEIGHT - self.inputBar.proposalInputHeight);
}

-(void)checkLogin{
    if(![[MZIMManager sharedManager] isUserLogin]){
        [[MZIMManager sharedManager] quickLogin:nil];
    }
}

-(void)initConversation{
    self.conversation = [[MZIMManager sharedManager] loadConversation:self.chatType andReceiver:self.receiver];
    [self loadMessages:YES];
}

- (void)sendShareMessageIfNeeded{
    if(self.materialInfo){
        MZIMMaterialInfo *info = [MZIMMaterialInfo mj_objectWithKeyValues:self.materialInfo];
        [self messageSending];
        [self.conversation sendCustomMessage:info mzCallback:^(BOOL isSuccess, NSString *message) {
            [self messageSendBack];
        }];
    }
}

-(void)loadMessages:(BOOL) isRefresh{
    if (self.conversation){
        [self.conversation setAllMessageRead];
        MZIMMessage *lastMessage;
        if(!isRefresh){
             lastMessage = self.messages.count > 0 ? [self.messages objectAtIndex:0] : nil;
        }
        
        [self.conversation loadMessages:kMessageLoadCount lastMessage:lastMessage messageListCallback:^(BOOL isSuccess, NSString *message, NSArray *messages) {
            [self.tableViewController endRefreshing];
            if(isSuccess && messages.count > 0){
                if (isRefresh) {
                    [self.messages removeAllObjects];
                }
                
                 NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                 NSMakeRange(0,[messages count])];
                [self.messages insertObjects:messages atIndexes:indexes];
                [self.tableViewController refreshMessages:self.messages scrollToBottom:isRefresh animated:NO];
            }
        }];
    }
}

-(void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kMZIMMessageNotificationLoginSuccess object:nil];
}



#pragma mark - Event delal
-(void)loginSuccess{
    [self initConversation];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    self.keyboardIsShow = YES;
    NSDictionary *userinfo = notification.userInfo;
    NSValue *value = [userinfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    if (value.CGRectValue.size.height <= 0) {
        return;
    }
    
    NSValue *keyBoardFrameValue =  [userinfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = keyBoardFrameValue.CGRectValue.size.height;
    NSNumber *duration = [userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        WEAKSELF
        CGFloat inputBarY = weakSelf.view.jk_bottom - keyboardHeight - weakSelf.inputBar.proposalInputHeight;
        weakSelf.inputBar.jk_top = inputBarY;
        weakSelf.tableViewController.view.jk_height = inputBarY;
        weakSelf.tableViewController.tableView.jk_height = inputBarY;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration.doubleValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self.tableViewController.tableView scrollToBottom:YES];
    });
}

- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardIsShow = NO;
    NSDictionary *userinfo = notification.userInfo;
    NSNumber *duration = [userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        WEAKSELF
        CGFloat inputBarY = self.view.jk_bottom - weakSelf.inputBar.proposalInputHeight;
        self.inputBar.jk_top = inputBarY;
        weakSelf.tableViewController.view.jk_top  = 0;
        weakSelf.tableViewController.tableView.jk_top = 0;
        weakSelf.tableViewController.view.jk_height = inputBarY;
        weakSelf.tableViewController.tableView.jk_height = inputBarY;
    }];
}

- (void)playUserAudio:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell{
    [[MZIMAudioPlayHelper sharedInstance] playMessageWithCell:message andCell:cell];
}

#pragma mark- SendMessage
- (void)messageSending{
    [self loadMessages:true];
}

- (void)messageSendBack{
    [self loadMessages:true];
}

- (void)sendTextMessage:(NSString *)text{
    [self.inputBar.textViewInput endEditing:YES];
    [self messageSending];
    [self.conversation sendTextMessage:text mzCallback:^(BOOL isSuccess, NSString *message) {
        WEAKSELF
        [weakSelf messageSendBack];
    }];
}

- (void)sendAudioMessage:(NSString *)path second:(int)second{
    [self messageSending];
    [self.conversation sendAudioMessage:path second:second mzCallback:^(BOOL isSuccess, NSString *message) {
        WEAKSELF
        [weakSelf messageSendBack];
    }];
}

///发送审核消息
- (void)sendMaterialExamine:(NSString *)material_user material_name:(NSString *)material_name examine_result:(NSString *)examine_result{
    NSString *formatter = @"@%@ #%@# %@";
    NSString *result = [NSString stringWithFormat:formatter,material_user,examine_result,material_name];
    [self sendTextMessage:result];
}

#pragma mark - Delegate
#pragma mark- MZIMMessageDispatcherDelegate
-(void)onNewMessage:(MZIMMessage *)message{
    [self.messages addObject:message];
    if (self.messages.count > 500) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 450; i < self.messages.count; i++) {
            [array addObject:[self.messages objectAtIndex:i]];
        }
        self.messages = array;
    }
    
    [self.conversation setAllMessageRead];
    [self.tableViewController refreshMessages:self.messages scrollToBottom:NO animated:YES];
}

#pragma mark- MZIMRecorderHelperDelegate
-(void)recordDidFailed:(NSString *)msg{
    [self.inputBar hideRecordView];
}

-(void)recordDidCancled{
    [self.inputBar hideRecordView];
}

-(void)recordDidSuccess:(NSString *)path duration:(NSInteger)duration{
    [self.inputBar hideRecordView];
    [self sendAudioMessage:path second:(int)duration];
}

-(void)recordDidPowerChanged:(NSInteger)power{
    self.inputBar.recordPeak = power;
}

#pragma mark- MZIMChatInputBarDelegate
- (void)inputBarTextFieldReturn:(NSString *)text{
    [self sendTextMessage:text];
}

- (void)inputTypeChanged:(MZIMInputType)type{
    if (type == MZIMInputTypeText) {
        [self openOrCloseKeyBoard:YES];
    }else{
        [self openOrCloseKeyBoard:NO];
    }
}

- (void)inputBarRecordStart{
    [self.inputBar showRecordView];
    NSString *path = [MZIMFileHelper getRecommendAudioPath];
    [[MZIMRecorderHelper sharedInstance] prepareAndRecordWithPath:path delegate:self];
}

- (void)inputBarRecordStop{
    [[MZIMRecorderHelper sharedInstance] stopRecord];
}

- (void)inputBarRecordCancel{
    [[MZIMRecorderHelper sharedInstance] cancelRecord];
}

#pragma mark- MZIMTableViewDelegate
-(void)didAvatarLongTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell{
    NSString *appendString = [NSString stringWithFormat:@"@%@",message.userInfo.name];
    NSMutableString *mutableString = [NSMutableString stringWithString:self.inputBar.textViewInput.text];
    [mutableString appendString:appendString];
    
    [self.inputBar.textViewInput setText:mutableString];
}


-(void)didMessageBodyLongTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell{
    self.longPressedMessage = message;
}

- (void)didMessageBodyTapped:(MZIMMessage *)message cell:(MZIMMessageTableViewCell *)cell{
    if (message.messageType == MZIMMessageTypeAudio) {
        [self playUserAudio:message cell:cell];
    }
}

- (void)loadMore{
    [self loadMessages:false];
}


-(void)openOrCloseKeyBoard:(BOOL)open{
    if (open) {
        [self.inputBar.textViewInput becomeFirstResponder];
    }else{
        [self.inputBar.textViewInput resignFirstResponder];
    }
}

@end
