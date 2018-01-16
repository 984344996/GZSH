//
//  MySupplyAndDemandEditViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MySupplyAndDemandEditViewController.h"
#import <MyLayout.h>
#import "UITextView+Placeholder.h"
#import "JKTextField_Padding.h"
#import <IQKeyboardManager.h>
#import "RichMode.h"
#import "NSString+Commen.h"

@interface MySupplyAndDemandEditViewController ()<UITextViewDelegate>
@property (nonatomic, strong) MyLinearLayout *rootLiner;
@property (nonatomic, strong) MyLinearLayout *linerContent;
@property (nonatomic, strong) NSMutableArray *supplyRich;
@property (nonatomic, assign) NSUInteger currentEdit;

@property (nonatomic, strong) JKTextField_Padding *inputTitle;
@property (nonatomic, strong) JKTextField_Padding *inputCompany;
@property (nonatomic, strong) JKTextField_Padding *inputPhone;
@end

@implementation MySupplyAndDemandEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)loadView{
    _currentEdit = -1;
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    _rootLiner = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _rootLiner.myLeading = _rootLiner.myTrailing = 0;
    _rootLiner.heightSize.lBound(scrollView.heightSize, 10, 1);
    [scrollView addSubview:_rootLiner];
}


- (void)configView{
    [super configView];
    self.title = @"编辑供求信息";
    UIBarButtonItem *itemPic = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStylePlain target:self action:@selector(insertPic:)];
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(insertPic:)];
    self.navigationItem.rightBarButtonItems = @[itemDone,itemPic];
    [self configLiner];
    [self reloadContentInfo];
}

- (void)configLiner{
    _inputTitle = [self makeLinerTitleWithInput:@"标题:" placeHolder:@"请输入..."];
    _inputCompany = [self makeLinerTitleWithInput:@"发布单位:" placeHolder:@"请输入..."];
    _inputPhone = [self makeLinerTitleWithInput:@"联系方式:" placeHolder:@"请输入..."];
    _linerContent = [self makeLinerContent:@"内容:"];
}

#pragma mark - Lazy loading

- (NSMutableArray *)supplyRich{
    if (!_supplyRich) {
        _supplyRich = [NSMutableArray array];
        [_supplyRich addObject:[self createBlankTextRich]];
    }
    return _supplyRich;
}

#pragma mark - Private methods

- (void)reloadContentInfo{
    [self.linerContent removeAllSubviews];
    [self.supplyRich enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichMode *model = obj;
        if ([model.type isEqualToString:@"text"]){
            UITextView *textView = [self createTextViewRich:model];
            [self.linerContent addSubview:textView];
        }else{
            UIImageView *imageView = [self createImageRich:model];
            [self.linerContent addSubview:imageView];
        }
    }];
}

- (UITextView *)createTextViewRich:(RichMode *)model{
    UITextView  *textView = [[UITextView alloc] init];
    textView.tag = model.tagForView;
    
    WEAKSELF
    textView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    textView.delegate = weakSelf;
    textView.scrollEnabled = NO;
    textView.text = model.inputContent;
    textView.font = kMainTextFieldTextFontMiddle;
    textView.textColor = kMainTextColor;
    textView.placeholder = @"请输入...";
    textView.placeholderLabel.font = kMainTextFieldTextFontMiddle;
    textView.myHeight = 24;
    textView.myTop = 0;
    textView.myLeading = 0;
    textView.myTrailing = 0;
    return textView;
}

- (UIImageView *)createImageRich:(RichMode *)model{
    CGFloat height = kRichSupplyWidth * (model.height / model.width);
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.tag = model.tagForView;
    
    imageView.layer.masksToBounds = YES;
    imageView.image = model.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.myTop = 0;
    imageView.myLeading = 2;
    imageView.myTrailing = 2;
    imageView.myHeight = height;
    imageView.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"AlbumCancel"]
            forState:UIControlStateNormal];
    
    WEAKSELF
    [button addTarget:weakSelf action:@selector(imageDel:) forControlEvents:UIControlEventTouchUpInside];
    button.useFrame = YES;
    [button setFrame:CGRectMake(0, 0, 25, 25)];
    [imageView addSubview:button];
    
    return imageView;
}

#pragma mark - Events

- (void)insertPic:(UIBarButtonItem *)sender{
    
    /// TODO选照片
    RichMode *newRich = [self createTestImageRich];
    UIImageView *imageView = [self createImageRich:newRich];
    /// 筛选前面添加的View  如果文字不为空则插入
    if (self.currentEdit == 1) {
        /// 最后一个是否为空
        RichMode *lastModel = [self.supplyRich lastObject];
        UITextView *lastText = [self.view viewWithTag:lastModel.tagForView];
        if ([NSString isEmpty:lastText.text]) {
            [self.linerContent insertSubview:imageView atIndex:self.linerContent.subviews.count - 1];
            [self.supplyRich insertObject:newRich atIndex:self.supplyRich.count - 1];
            [lastText becomeFirstResponder];
        }else{
            RichMode *newTextModel=  [self createBlankTextRich];
            UITextView *textView = [self createTextViewRich:newTextModel];
            [self.linerContent addSubview:imageView];
            [self.linerContent addSubview:textView];
            [self.supplyRich addObject:newRich];
            [self.supplyRich addObject:newTextModel];
            [textView becomeFirstResponder];
        }
    }
}

- (void)imageDel:(UIButton *)sender{
    UIImageView *imageView = (UIImageView *)sender.superview;
    [imageView removeFromSuperview];
    
    NSInteger tag = imageView.tag;
    NSInteger index = -1;
    
    index = [self findIndexByTag:tag richArray:self.supplyRich];
    if (index != -1) {
        [self.supplyRich removeObjectAtIndex:index];
        return;
    }
    
    index = [self findIndexByTag:tag richArray:self.supplyRich];
    if (index != -1) {
        [self.supplyRich removeObjectAtIndex:index];
    }
}


static int viewTagNow = 1001;

- (RichMode *)createBlankTextRich{
    RichMode *mode = [[RichMode alloc] init];
    mode.type = @"text";
    mode.tagForView = viewTagNow ++;
    return mode;
}

- (RichMode *)createTestImageRich{
    RichMode *mode = [[RichMode alloc] init];
    mode.type = @"image";
    mode.image = [UIImage imageNamed:@"placeholder"];
    mode.width = 640;
    mode.height = 300;
    mode.tagForView = viewTagNow++;
    return mode;
}

- (JKTextField_Padding *)makeLinerTitleWithInput:(NSString *)title placeHolder:(NSString *)placeHolder{
    
    MyLinearLayout *liner = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    liner.myLeading = liner.myTrailing = 0;
    liner.myHeight = 24;
    liner.myTop = 28;
    
    JKTextField_Padding *textField =  [[JKTextField_Padding alloc] init];
    textField.borderColor = kMainTextFieldBorderColor;
    textField.font = kMainTextFieldTextFontMiddle;
    textField.textColor = kMainTextColor;
    textField.borderW = 1;
    textField.placeholder = placeHolder;
    textField.leftPadding = 5;
    textField.myHeight = 24;
    textField.myLeft = 20;
    textField.weight = 1;
    textField.myTrailing = 12;
    
    UILabel *sectionLabel = [self makeTitleLabel:title];
    [liner addSubview:sectionLabel];
    [liner addSubview:textField];
    [self.rootLiner addSubview:liner];
    return textField;
}

- (UILabel *)makeTitleLabel:(NSString *)title{
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = title;
    sectionLabel.textAlignment = NSTextAlignmentRight;
    sectionLabel.font = kMainTextFieldTextFontMiddle;
    sectionLabel.textColor = kSecondTextColor;
    [sectionLabel sizeToFit];
    sectionLabel.myLeft = 12;
    sectionLabel.myWidth = 65;
    sectionLabel.myHeight = 24;
    return sectionLabel;
}

- (MyLinearLayout *)makeLinerContent:(NSString *)title{
    MyLinearLayout *liner = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    liner.myLeading = liner.myTrailing = 0;
    liner.myHeight = 24;
    liner.myTop = 28;
    liner.wrapContentHeight = YES;
    
    UILabel *sectionLabel = [self makeTitleLabel:title];
    
    MyLinearLayout *linerCotent = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    linerCotent.layer.borderColor = kMainTextFieldBorderColor.CGColor;
    linerCotent.layer.borderWidth = 1;
    linerCotent.heightSize.min(80);
    linerCotent.myLeft = 20;
    linerCotent.myTrailing = 12;
    linerCotent.weight = 1;
    
    [liner addSubview:sectionLabel];
    [liner addSubview:linerCotent];
    [self.rootLiner addSubview:liner];
    return linerCotent;
}

- (NSInteger)findIndexByTag:(NSInteger)tag richArray:(NSMutableArray *)array{
    __block NSInteger index = -1;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichMode *rich = obj;
        if (rich.tagForView == tag) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)dealEmptyTextViewDel:(UITextView *)textView{
    NSInteger tag = textView.tag;
    if (textView.superview == self.linerContent) {
        NSInteger index = [self findIndexByTag:tag richArray:self.supplyRich];
        if (index == 0 && self.supplyRich.count == 1) {
            return;
        }
        
        if (index < self.supplyRich.count - 1) {
            [textView removeFromSuperview];
            [self.supplyRich removeObjectAtIndex:index];
            RichMode *lastMode = [self.supplyRich lastObject];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
            return;
        }
        
        RichMode *lastMode = [self.supplyRich objectAtIndex:index - 1];
        if ([lastMode.type isEqualToString:@"image"]) {
            [self.supplyRich removeObjectAtIndex:index - 1];
            [[self.view viewWithTag:lastMode.tagForView] removeFromSuperview];
        }
        
        if ([lastMode.type isEqualToString:@"text"]) {
            [textView removeFromSuperview];
            [self.supplyRich removeObjectAtIndex:index];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
        }
    }
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    CGFloat h = [textView sizeThatFits:CGSizeMake(kRichSupplyWidth, CGFLOAT_MAX)].height;
    textView.myHeight = h;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location == 0 && range.length == 0 && text.length == 0) {
        [self dealEmptyTextViewDel:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.superview isEqual:self.linerContent]) {
        self.currentEdit = 1;
    }else{
        self.currentEdit = -1;
    }
}


@end
