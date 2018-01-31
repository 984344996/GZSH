//
//  SHCircleViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SHCircleViewController.h"
#import "MomentTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <Masonry.h>
#import "Moment.h"
#import <MJExtension.h>
#import "MomentMacro.h"
#import "MomentHeaderView.h"
#import <ZLPhotoActionSheet.h>
#import "SendMomentViewController.h"
#import <ReactiveObjC.h>
#import "MomentNewsViewController.h"
#import "HUDHelper.h"
#import "APIServerSdk.h"
#import "DynamicInfo.h"
#import "ChatKeyBoard.h"
#import "ChatKeyBoardMacroDefine.h"
#import "NSString+Commen.h"
#import "AppDataFlowHelper.h"
#import <JKCategories.h>
#import "DynamicMsg+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineRefreshHeader.h"
#import "CommonResponseModel.h"
#import "PersonalInfoViewController.h"
#import <UIImageView+WebCache.h>

@interface SHCircleViewController ()<MomentCellDelegate,ChatKeyBoardDelegate>

@property (nonatomic, assign) BOOL isMainPage;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSMutableArray *momentModes;
@property (nonatomic, strong) Comment *lastResponseComment;

@property (nonatomic, strong) NSIndexPath *editIndexPath; // 当前正在编辑
@property (nonatomic, assign) CGFloat history_Y_offset;//记录table的offset.y
@property (nonatomic, assign) CGFloat seletedCellHeight;//记录点击cell的高度，高度由代理传过来
@property (nonatomic, assign) BOOL isShowKeyBoard;
@property (nonatomic, assign) BOOL needUpdateOffset;//控制是否刷新table的offset

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) MomentHeaderView *header;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, strong) SDTimeLineRefreshFooter *refreshFooter;
@property (nonatomic, strong) SDTimeLineRefreshHeader *refreshHeader;

@property (nonatomic, assign) NSInteger lastLoadPage;
@end

@implementation SHCircleViewController

- (instancetype)initWithMainPage:(BOOL) isMainPage userid:(NSString *)userid{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.userid = userid;
        self.isMainPage = isMainPage;
        self.isFirstLoad = YES;
        self.lastLoadPage = 1;
    }
    return self;
}

- (void)configView{
    [super configView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!self.momentId && self.hasAccessPermisson) {
        [self addUIBarButtonItemImage:@"Circle_Icon_Camera" size:CGSizeMake(24, 24) isLeft:NO target:self action:@selector(publishMoment:)];
    }
    
    if (self.isMainPage && self.hasAccessPermisson) {
        self.tableView.tableHeaderView = self.header;
    }
    
    [self.tableView registerClass:[MomentTableViewCell class] forCellReuseIdentifier:@"MomentTableViewCell"];
    
    // 上拉加载
    _refreshFooter = [SDTimeLineRefreshFooter refreshFooterWithRefreshingText:@"正在加载数据..."];
    WEAKSELF
    [_refreshFooter addToScrollView:self.tableView refreshOpration:^{
        STRONGSELF
        [strongSelf loadMoment:NO];
    }];
}

- (void)configData{
    [super configData];
    if (self.momentId) {
        [self loadMomentById:self.momentId];
        return;
    }
    
    NSString *avatar = [AppDataFlowHelper getLoginUserInfo].avatar;
    [self.header.imageAvtar sd_setImageWithURL:GetImageUrl(avatar) placeholderImage:kPlaceHoderHeaderImage];
    [self loadMoment:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.hasAccessPermisson) {
        [self showNoAccessPermissionDialog];
    }
    
    [self loadUnreadComment];
    if (!_refreshHeader.superview) {
        _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40, 45)];
        _refreshHeader.scrollView = self.tableView;
        WEAKSELF
        [_refreshHeader setRefreshingBlock:^{
            STRONGSELF
            [strongSelf loadMoment:YES];
        }];
        [self.tableView.superview addSubview:_refreshHeader];
    } else {
        [self.tableView.superview bringSubviewToFront:_refreshHeader];
    }
}

#pragma mark - Load data

- (void)loadMoment:(BOOL)isRefresh{
    if (isRefresh) {
        self.lastLoadPage = 1;
    }
    WEAKSELF
    [APIServerSdk doGetMoment:self.userid page:self.lastLoadPage succeed:^(id obj) {
        STRONGSELF
        if (isRefresh) {
            [strongSelf.momentModes removeAllObjects];
        }else{
            self.lastLoadPage++;
        }
        
        CommonResponseModel *model = obj;
        NSMutableArray *append = [Moment mj_objectArrayWithKeyValuesArray:model.data];
        [strongSelf.momentModes addObjectsFromArray:append];
        [strongSelf.tableView reloadData];
        strongSelf.isFirstLoad = NO;
        
        if (strongSelf.lastLoadPage == model.page.count) {
            [strongSelf.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [strongSelf.refreshFooter resetNoMoreData];
        }
        [strongSelf.refreshHeader endRefreshing];
    } needCache:self.isFirstLoad cacheSucceed:^(id obj) {
        STRONGSELF
        [strongSelf.momentModes removeAllObjects];
        CommonResponseModel *model = obj;
        NSMutableArray *append = [Moment mj_objectArrayWithKeyValuesArray:model.data];
        [strongSelf.momentModes addObjectsFromArray:append];
        [strongSelf.tableView reloadData];
        if (strongSelf.lastLoadPage == model.page.count) {
            [strongSelf.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [strongSelf.refreshFooter resetNoMoreData];
        }
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:@"加载失败" inView:self.view];
        [strongSelf.refreshHeader endRefreshing];
        [strongSelf.refreshFooter resetNoMoreData];
    }];
}

- (void)loadMomentById:(NSString *)momentId{
    WEAKSELF
    [APIServerSdk doGetMomentDetail:momentId succeed:^(id obj) {
        STRONGSELF
        Moment *moment         = [Moment mj_objectWithKeyValues:obj];
        [strongSelf.momentModes removeAllObjects];
        [strongSelf.momentModes addObject:moment];
        [strongSelf.tableView reloadData];
    } failed:^(NSString *error) {
    }];
}

- (void)loadUnreadComment{
    WEAKSELF
    [APIServerSdk doGetMomentNotice:^(id obj) {
        STRONGSELF
        [strongSelf saveDynamicMsg:obj];
    } failed:^(NSString *error) {
        
    }];
}

// 数据库操作
- (void)fetchCount{
    NSUInteger count = [DynamicMsg MR_countOfEntities];
    if (count > 0) {
        DynamicMsg *lastMsg = [DynamicMsg MR_findFirst];
        self.header.labelCommentName.text = lastMsg.opUsername;
        self.header.containerView.hidden = NO;
        self.header.labelCommentCount.text = [NSString stringWithFormat:@"%ld条评论",count];
    }else{
        self.header.containerView.hidden = YES;
    }
}

- (void)saveDynamicMsg:(NSMutableArray *)objs{
    if (objs.count == 0) {
        [self fetchCount];
        return;
    }
    
    NSArray *arrayToSave = [DynamicMsg MR_importFromArray:objs inContext:[NSManagedObjectContext MR_defaultContext]];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self fetchCount];
    }];
}

- (void)configEvent{
    [super configEvent];
    
    //注册键盘出现NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(momentSendSucceed:)
                                                 name:kJKMomentSendSucceed object:nil];
    
    self.header.userInteractionEnabled               = YES;
    self.header.containerView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.header.containerView addGestureRecognizer:tap];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        MomentNewsViewController *vc = [[MomentNewsViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
    
    UITapGestureRecognizer *gen = [[UITapGestureRecognizer alloc] init];
    [self.header.imageAvtar addGestureRecognizer:gen];
    [[gen rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        NSString *userId                   = [AppDataFlowHelper getLoginUserInfo].userId;
        PersonalInfoViewController *infoVc = [[PersonalInfoViewController alloc] initWithUserId:userId];
        self.hidesBottomBarWhenPushed      = YES;
        [self.navigationController pushViewController:infoVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
}

- (NSMutableArray *)momentModes{
    if (!_momentModes) {
        _momentModes = [[NSMutableArray alloc] init];
    }
    return _momentModes;
}


- (MomentHeaderView *)header{
    if (!_header) {
        _header = [[MomentHeaderView alloc] init];
        [_header sizeToFit];
    }
    return _header;
}

#pragma mark - Private methods

- (void)momentSendSucceed:(NSNotification *)notification{
    [self loadMoment:YES];
}

- (void)publishMoment:(UIBarButtonItem *)sender{
    SendMomentViewController *vc = [[SendMomentViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - TableView Delegate and Datasource

- (BOOL)showEmptyView{
    return !self.hasAccessPermisson;
}

- (UIImage *)emptyImage{
    return [UIImage imageNamed:@"sorry"];
}

- (NSString *)emptyTitle{
    return @"抱歉，您不是商会会员不能查看此内容";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.hasAccessPermisson) {
        return 0;
    }
    return self.momentModes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentTableViewCell" forIndexPath:indexPath];
    Moment *model = self.momentModes[indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Moment *moment = self.momentModes[indexPath.row];
    CGFloat h = [MomentTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        MomentTableViewCell *cell = (MomentTableViewCell *)sourceCell;
        [cell configCellWithModel:moment indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : moment.dynamicInfo.dynamicId,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(moment.shouldUpdateCache)};
        moment.shouldUpdateCache = NO;
        return cache;
    }];
    return h;
}

#pragma mark - Private methods

- (void)reloadEditIndex{
    Moment *moment = self.momentModes[self.editIndexPath.row];
    moment.shouldUpdateCache = YES;
    [self.tableView reloadRowsAtIndexPaths:@[self.editIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (MomentUser *)convertSelfToMomentUser{
    MomentUser *user = [[MomentUser alloc] init];
    UserInfo *info = [AppDataFlowHelper getLoginUserInfo];
    user.userId = info.userId;
    user.avatar = info.avatar;
    user.name = info.userName;
    return user;
}

- (NSString *)getSelfId{
    UserInfo *info = [AppDataFlowHelper getLoginUserInfo];
    return info.userId;
}
#pragma mark - MomentCell Delegate

// 重新加载高度
- (void)reloadCellHeightForModel:(Moment *)model atIndexPath:(NSIndexPath *)indexPath{
    
}

// 点击评论时
- (void)passCellHeight:(CGFloat)cellHeight indexPath:(NSIndexPath *)indexPath commentModel:(Comment *)commentModel commentCell:(CommentTableViewCell *)cell momentCell:(MomentTableViewCell *)momentCell{
    
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return;
    }
    
    // 不能自己评论自己
    if ([commentModel.userA.userId isEqualToString:[self getSelfId]]) {
        return;
    }
    
    self.editIndexPath = indexPath;
    self.lastResponseComment = commentModel;
    self.needUpdateOffset = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.history_Y_offset = [cell convertRect:cell.bounds toView:window].origin.y;
    self.seletedCellHeight = cellHeight;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",commentModel.userA.name];
    [self.chatKeyBoard keyboardUpforComment];
}

// 评论点击
- (void)btnCommentTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return;
    }
    
    self.seletedCellHeight = 0.0;
    self.needUpdateOffset = YES;
    self.editIndexPath = indexPath;
    
    Moment *moment = self.momentModes[indexPath.row];
    UIWindow *view = [UIApplication sharedApplication].keyWindow;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论%@",moment.momentUser.name];
    self.history_Y_offset = [button convertRect:button.bounds toView:view].origin.y;
    [self.chatKeyBoard keyboardUpforComment];
}

// 喜欢
- (void)btnLikeTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return;
    }
    
    self.editIndexPath = indexPath;
    Moment *moment = self.momentModes[indexPath.row];
    
    WEAKSELF
    [APIServerSdk doPraiseMoment:moment.dynamicInfo.dynamicId succeed:^(id obj) {
        STRONGSELF
        Moment *moment = strongSelf.momentModes[self.editIndexPath.row];
        moment.dynamicInfo.hasPraised = YES;
        [moment.praiseList addObject:[strongSelf convertSelfToMomentUser]];
        [strongSelf reloadEditIndex];
    } failed:^(NSString *error) {
        /// 重复点赞 网络不通
    }];
}

// 显示更多文字
- (void)btnMoreTextTapped:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return;
    }
    
    Moment *moment = self.momentModes[indexPath.row];
    moment.isExpand = !moment.isExpand;
    moment.shouldUpdateCache = YES;
    [self.tableView reloadData];
}

// 九宫格图片点击
- (void)jggViewTapped:(NSUInteger)index dataource:(NSArray *)datasource{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return;
    }
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sender = self;
    actionSheet.configuration.navBarColor = kGreenColor;
    actionSheet.configuration.navTitleColor = kWhiteColor;
    NSMutableArray *urls = [NSMutableArray array];
    [datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *url = GetImageString(obj);
            [urls addObject:url];
        }
    }];
    [actionSheet previewPhotos:urls index:index hideToolBar:YES  complete:^(NSArray * _Nonnull photos) {
        
    }];
}

// 点击头像
- (void)labelNameTapped:(MomentUser *)user{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return;
    }
    PersonalInfoViewController *infoVc = [[PersonalInfoViewController alloc] initWithUserId:user.userId];
    UIViewController *parentVC = self.parentViewController;
    NSUInteger count = self.navigationController.childViewControllers.count;
    if (count > 1) {
        parentVC.hidesBottomBarWhenPushed = YES;
        [parentVC.navigationController pushViewController:infoVc animated:YES];
        parentVC.hidesBottomBarWhenPushed = YES;
    }else{
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - Key board

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithParentViewBounds:self.tableView.bounds];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        _chatKeyBoard.bottomMargin = self.bottomMargin;
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

- (void)chatKeyBoardSendText:(NSString *)text{
    if ([NSString isEmpty:text]) {
        [[HUDHelper sharedInstance] tipMessage:@"评论不能为空" inView:self.view];
        return;
    }
    
    Moment *moment = self.momentModes[self.editIndexPath.row];
    WEAKSELF
    [APIServerSdk doComment:moment.dynamicInfo.dynamicId content:text userId:self.lastResponseComment.userA.userId succeed:^(id obj) {
        STRONGSELF
        [strongSelf reloadWhenCommentSucceed:text];
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] tipMessage:@"评论失败" inView:strongSelf.view];
        strongSelf.lastResponseComment = nil;
    }];
    self.chatKeyBoard.placeHolder = nil;
    [self.chatKeyBoard keyboardDownForComment];
}

- (void)reloadWhenCommentSucceed:(NSString *)content{
    Moment *momment = self.momentModes[self.editIndexPath.row];
    Comment *newComment = [[Comment alloc] init];
    newComment.userA = [self convertSelfToMomentUser];
    newComment.userB = self.lastResponseComment.userA;
    newComment.content = content;
    newComment.commentId = [NSString jk_UUIDTimestamp];
    [momment.commentList addObject:newComment];
    self.lastResponseComment = nil;
    [self reloadEditIndex];
}

#pragma mark keyboardWillShow

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.isShowKeyBoard    = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue        = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    if (keyboardHeight == 0) {
        // 解决搜狗输入法三次调用此方法的bug、
        // IOS8.0之后可以安装第三方键盘，如搜狗输入法之类的。
        // 获得的高度都为0.这是因为键盘弹出的方法:- (void)keyBoardWillShow:(NSNotification
        // *)notification需要执行三次,你如果打印一下,你会发现键盘高度为:第一次:0;第二次:216:第三次
        // :282.并不是获取不到高度,而是第三次才获取真正的高度.
        return;
    }
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = 0.0;
    if (self.seletedCellHeight){ //点击某行row，进行回复某人
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-self.seletedCellHeight - kChatToolBarHeight - 2);
    }else{ //点击评论按钮
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-kChatToolBarHeight-24-10);//24为评论按钮高度，10为评论按钮上部的5加评论按钮下部的5
    }
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    if (self.needUpdateOffset) {
        [self.tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark keyboardWillHide

- (void)keyboardWillHide:(NSNotification *)notification {
    self.isShowKeyBoard = NO;
    self.needUpdateOffset = NO;
    
    CGFloat cH = self.tableView.contentSize.height;
    CGFloat fH = self.tableView.frame.size.height;
    CGFloat oY = self.tableView.contentOffset.y;
    
    if (cH > fH && cH - oY < fH)
    {
        CGPoint offset = CGPointMake(0, cH - fH);
        [self.tableView setContentOffset:offset animated:YES];
    }
    if (cH < fH) {
        CGPoint offset = CGPointMake(0, 0);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

@end
