//
//  MyCompanyInfoEditViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "MyCompanyInfoEditViewController.h"
#import <MyLayout.h>
#import "UITextView+Placeholder.h"
#import "JKTextField_Padding.h"
#import <IQKeyboardManager.h>
#import "RichMode.h"
#import "NSString+Commen.h"
#import <ZLPhotoActionSheet.h>
#import <ReactiveObjC.h>
#import "HUDHelper.h"
#import "EnterpriseModel.h"
#import "UploadRichEngine.h"
#import <MJExtension.h>
#import "APIServerSdk.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>

@interface MyCompanyInfoEditViewController ()<UITextViewDelegate>

@property (nonatomic, strong) ZLPhotoActionSheet* photoActionSheet;
@property (nonatomic, strong) MyLinearLayout *rootLiner;
@property (nonatomic, strong) MyLinearLayout *linerCompanyInfo;
@property (nonatomic, strong) MyLinearLayout *linerCompanyService;

@property (nonatomic, strong) NSMutableArray *companyInfoRich;
@property (nonatomic, strong) NSMutableArray *companyServiceRich;

@property (nonatomic, strong) JKTextField_Padding *inputMobile;
@property (nonatomic, strong) JKTextField_Padding *inputPhone;
@property (nonatomic, strong) JKTextField_Padding *inputEmail;
@property (nonatomic, strong) UITextView *inputAddress;
@property (nonatomic, assign) NSUInteger currentEdit;
@property (nonatomic, strong) EnterpriseModel *enterpriseModel;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, weak) UIWindow *window;

@end

@implementation MyCompanyInfoEditViewController

- (instancetype)initWithEnterpriseModel:(EnterpriseModel *)model{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (model) {
            self.enterpriseModel    = model;
            self.companyInfoRich    = [RichMode mj_objectArrayWithKeyValuesArray:self.enterpriseModel.desc];
            self.companyServiceRich = [RichMode mj_objectArrayWithKeyValuesArray:self.enterpriseModel.service];
        }
    }
    return self;
}

- (void)loadView{
    
    _currentEdit =  -1;
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.view = scrollView;
    _rootLiner = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _rootLiner.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    _rootLiner.myLeading = _rootLiner.myTrailing = 0;
    _rootLiner.heightSize.lBound(scrollView.heightSize, 10, 1);
    [scrollView addSubview:_rootLiner];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"编辑企业信息";
    
    UIBarButtonItem *itemPic = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStylePlain target:self action:@selector(insertPic:)];
    UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(editDone:)];
    self.navigationItem.rightBarButtonItems = @[itemDone,itemPic];
    
    [self configLiner];
    
    self.inputMobile.text = self.enterpriseModel.mobile;
    self.inputPhone.text = self.enterpriseModel.phone;
    self.inputEmail.text = self.enterpriseModel.email;
    self.inputAddress.text = self.enterpriseModel.address;
    
    [self reloadCompanyInfo];
    [self reloadCompanyService];
}

- (void)configData{
    [super configData];
}

- (void)configEvent{
    [super configEvent];
    RAC(self.enterpriseModel , mobile) = [RACSignal merge:@[RACObserve(self.inputMobile, text),self.inputMobile.rac_textSignal]];
    RAC(self.enterpriseModel , phone) = [RACSignal merge:@[RACObserve(self.inputPhone, text),self.inputPhone.rac_textSignal]];
    RAC(self.enterpriseModel , email) = [RACSignal merge:@[RACObserve(self.inputEmail, text),self.inputEmail.rac_textSignal]];
    RAC(self.enterpriseModel , address) = [RACSignal merge:@[RACObserve(self.inputAddress, text),self.inputAddress.rac_textSignal]];
}

- (void)configLiner{
    [self.rootLiner addSubview:[self createSectionLabel:@"企业概况："]];
    [self.rootLiner addSubview:self.linerCompanyInfo];
    
    [self.rootLiner addSubview:[self createSectionLabel:@"企业服务"]];
    [self.rootLiner addSubview:self.linerCompanyService];
    
    [self.rootLiner addSubview:[self createSectionLabel:@"电话号码："]];
    _inputMobile = [self createUITextField:@"请输入..."];
    _inputMobile.keyboardType = UIKeyboardTypePhonePad;
    [self.rootLiner addSubview:_inputMobile];
    
    [self.rootLiner addSubview:[self createSectionLabel:@"座机："]];
    _inputPhone = [self createUITextField:@"选填"];
    _inputPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.rootLiner addSubview:_inputPhone];
    
    [self.rootLiner addSubview:[self createSectionLabel:@"邮件："]];
    _inputEmail = [self createUITextField:@"请输入..."];
    _inputEmail.keyboardType = UIKeyboardTypeASCIICapable;
    [self.rootLiner addSubview:_inputEmail];
    

    [self.rootLiner addSubview:[self createSectionLabel:@"地址："]];
    _inputAddress = [self createTextView:@"请输入"];
    [self.rootLiner addSubview:_inputAddress];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

#pragma mark - Lazy loading

- (UIWindow *)window{
    if (!_window) {
        _window = [[AppDelegate sharedAppDelegate] window];
    }
    return _window;
}

- (MyLinearLayout *)linerCompanyInfo{
    if (!_linerCompanyInfo) {
        _linerCompanyInfo = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _linerCompanyInfo.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _linerCompanyInfo.layer.borderWidth = 1;
        _linerCompanyInfo.myLeading = 0;
        _linerCompanyInfo.myTrailing = 0;
        _linerCompanyInfo.myTop = 5;
        _linerCompanyInfo.heightSize.min(80);
        _linerCompanyInfo.gravity = MyGravity_Horz_Fill;
    }
    return _linerCompanyInfo;
}

- (MyLinearLayout *)linerCompanyService{
    if (!_linerCompanyService) {
        _linerCompanyService = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _linerCompanyService.layer.borderColor = kMainTextFieldBorderColor.CGColor;
        _linerCompanyService.layer.borderWidth = 1;
        _linerCompanyService.myLeading = 0;
        _linerCompanyService.myTrailing = 0;
        _linerCompanyService.myTop = 5;
        _linerCompanyService.heightSize.min(80);
        _linerCompanyService.gravity = MyGravity_Horz_Fill;
    }
    return _linerCompanyService;
}

- (NSMutableArray *)companyInfoRich{
    if (!_companyInfoRich) {
        _companyInfoRich = [NSMutableArray array];
    }
    return _companyInfoRich;
}

- (NSMutableArray *)companyServiceRich{
    if (!_companyServiceRich) {
        _companyServiceRich = [NSMutableArray array];
    }
    return _companyServiceRich;
}

- (ZLPhotoActionSheet *)photoActionSheet{
    if (!_photoActionSheet) {
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        _photoActionSheet.sender = self;
        _photoActionSheet.configuration.navBarColor = kGreenColor;
        _photoActionSheet.configuration.navTitleColor = kWhiteColor;
        _photoActionSheet.configuration.maxSelectCount = 1;
        _photoActionSheet.configuration.allowSelectGif = NO;
        _photoActionSheet.configuration.allowSelectVideo = NO;
        _photoActionSheet.configuration.allowMixSelect = NO;
        _photoActionSheet.configuration.allowEditImage = YES;
        _photoActionSheet.configuration.allowSelectOriginal = NO;
    }
    return _photoActionSheet;
}

- (EnterpriseModel *)enterpriseModel{
    if (!_enterpriseModel) {
        _enterpriseModel = [[EnterpriseModel alloc] init];
    }
    return _enterpriseModel;
}
#pragma mark - Private methods

- (void)reloadCompanyInfo{
    [self.linerCompanyInfo removeAllSubviews];
    
    [self.companyInfoRich addObject:[self createBlankTextRich]];
    [self.companyInfoRich enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichMode *model = obj;
        model.tagForView = viewTagNow++;
        if ([model.type isEqualToString:@"text"]){
            UITextView *textView = [self createTextViewRich:model];
            CGFloat h            = [textView sizeThatFits:CGSizeMake(kRichCompanyWidth, CGFLOAT_MAX)].height;
            textView.myHeight    = h;
            [self.linerCompanyInfo addSubview:textView];
        }else{
            UIImageView *imageView = [self createImageRich:model];
            [self.linerCompanyInfo addSubview:imageView];
        }
    }];
}

- (void)reloadCompanyService{
    [self.linerCompanyService removeAllSubviews];
    
    [self.companyServiceRich addObject:[self createBlankTextRich]];
    [self.companyServiceRich enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichMode *model = obj;
        model.tagForView = viewTagNow++;
        if ([model.type isEqualToString:@"text"]){
            UITextView *textView = [self createTextViewRich:model];
            CGFloat h            = [textView sizeThatFits:CGSizeMake(kRichCompanyWidth, CGFLOAT_MAX)].height;
            textView.myHeight    = h;
            [self.linerCompanyService addSubview:textView];
        }else{
            UIImageView *imageView = [self createImageRich:model];
            [self.linerCompanyService addSubview:imageView];
        }
    }];
}

static int viewTagNow = 1001;

- (RichMode *)createBlankTextRich{
    RichMode *mode = [[RichMode alloc] init];
    mode.type = @"text";
    mode.tagForView = viewTagNow ++;
    return mode;
}

- (RichMode *)createImageRichModel:(UIImage *)image{
    RichMode *mode = [[RichMode alloc] init];
    mode.type = @"image";
    mode.image = image;
    mode.width = image.size.width;
    mode.height = image.size.height;
    mode.tagForView = viewTagNow++;
    return mode;
}

- (UILabel*)createSectionLabel:(NSString*)title
{
    UILabel *sectionLabel  = [UILabel new];
    sectionLabel.text      = title;
    sectionLabel.font      = kMainTextFieldTextFontMiddle;
    sectionLabel.textColor = kSecondTextColor;
    [sectionLabel sizeToFit];
    sectionLabel.myTop     = 12;
    return sectionLabel;
}

- (JKTextField_Padding *)createUITextField:(NSString *)placeHolder{
    JKTextField_Padding *textField = [[JKTextField_Padding alloc] init];
    textField.borderColor          = kMainTextFieldBorderColor;
    textField.font                 = kMainTextFieldTextFontMiddle;
    textField.textColor            = kMainTextColor;
    textField.borderW              = 1;
    textField.placeholder          = placeHolder;
    textField.leftPadding          = 5;

    textField.myHeight             = 24;
    textField.myTop                = 5;
    textField.myLeading            = 0;
    textField.myTrailing           = 0;
    return textField;
}

- (UITextView *)createTextView:(NSString *)placeHolder{
    UITextView  *textView = [[UITextView alloc] init];
    textView.font                  = kMainTextFieldTextFontMiddle;
    textView.textColor             = kMainTextColor;
    textView.layer.borderColor     = kMainTextFieldBorderColor.CGColor;
    textView.layer.borderWidth     = 1;
    textView.placeholder           = placeHolder;
    textView.placeholderLabel.font = kMainTextFieldTextFontMiddle;

    textView.myHeight              = 80;
    textView.myTop                 = 5;
    textView.myLeading             = 0;
    textView.myTrailing = 0;
    return textView;
}

- (UITextView *)createTextViewRich:(RichMode *)model{
    UITextView  *textView = [[UITextView alloc] init];
    textView.tag                   = model.tagForView;

    WEAKSELF
    textView.contentInset          = UIEdgeInsetsMake(0, 2, 0, 2);
    textView.delegate              = weakSelf;
    textView.scrollEnabled         = NO;
    textView.text                  = model.inputContent;
    textView.font                  = kMainTextFieldTextFontMiddle;
    textView.textColor             = kMainTextColor;
    textView.placeholder           = @"请输入...";
    textView.placeholderLabel.font = kMainTextFieldTextFontMiddle;
    textView.myHeight              = 30;
    textView.myTop                 = 0;
    textView.myLeading             = 0;
    textView.myTrailing            = 0;
    return textView;
}

- (UIImageView *)createImageRich:(RichMode *)model{
    CGFloat height = kRichCompanyWidth * (model.height / model.width);
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.tag = model.tagForView;
    imageView.layer.masksToBounds = YES;
    imageView.image = model.image;
    if (model.imageUrl) {
        [imageView sd_setImageWithURL:GetImageUrl(model.imageUrl) placeholderImage:kPlaceHoderBannerImage];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.myTop       = 0;
    imageView.myLeading   = 2;
    imageView.myTrailing  = 2;
    imageView.myHeight    = height;
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


- (void)addPic:(UIImage *)image{
    RichMode *newRich = [self createImageRichModel:image];
    UIImageView *imageView = [self createImageRich:newRich];
    // 筛选前面添加的View  如果文字不为空则插入
    if (self.currentEdit == 1) {
        ///最后一个是否为空
        RichMode *lastModel = [self.companyInfoRich lastObject];
        UITextView *lastText = [self.view viewWithTag:lastModel.tagForView];
        if ([NSString isEmpty:lastText.text]) {
            [self.linerCompanyInfo insertSubview:imageView atIndex:self.linerCompanyInfo.subviews.count - 1];
            [self.companyInfoRich insertObject:newRich atIndex:self.companyInfoRich.count - 1];
            [lastText becomeFirstResponder];
        }else{
            RichMode *newTextModel=  [self createBlankTextRich];
            UITextView *textView = [self createTextViewRich:newTextModel];
            [self.linerCompanyInfo addSubview:imageView];
            [self.linerCompanyInfo addSubview:textView];
            [self.companyInfoRich addObject:newRich];
            [self.companyInfoRich addObject:newTextModel];
            [textView becomeFirstResponder];
        }
    }else if(self.currentEdit == 2){
        ///最后一个是否为空
        RichMode *lastModel = [self.companyServiceRich lastObject];
        UITextView *lastText = [self.view viewWithTag:lastModel.tagForView];
        if ([NSString isEmpty:lastText.text]) {
            [self.linerCompanyService insertSubview:imageView atIndex:self.linerCompanyService.subviews.count - 1];
            [self.companyServiceRich insertObject:newRich atIndex:self.companyServiceRich.count - 1];
            [lastText becomeFirstResponder];
        }else{
            RichMode *newTextModel=  [self createBlankTextRich];
            UITextView *textView = [self createTextViewRich:newTextModel];
            [self.linerCompanyService addSubview:imageView];
            [self.linerCompanyService addSubview:textView];
            [self.companyServiceRich addObject:newRich];
            [self.companyServiceRich addObject:newTextModel];
            [textView becomeFirstResponder];
        }
    }
}

#pragma mark - Check And Data dealing

- (BOOL)checkForSubmit{
    NSString *tipMsg;
    BOOL isSucceed = YES;
    if (![self checkForComanyRich:self.companyInfoRich] && isSucceed) {
        tipMsg = @"企业概况不能为空";
        isSucceed = NO;
    }
    if (![self checkForComanyRich:self.companyServiceRich] && isSucceed) {
        tipMsg = @"企业服务不能为空";
        isSucceed = NO;
    }
    if ([NSString isEmpty:self.enterpriseModel.mobile] && isSucceed) {
        tipMsg = @"电话号码不能为空";
        isSucceed = NO;
    }
    if ([NSString isEmpty:self.enterpriseModel.email] && isSucceed) {
        tipMsg = @"邮箱不能为空";
        isSucceed = NO;
    }
    
    if ([NSString isEmpty:self.enterpriseModel.address] && isSucceed) {
        tipMsg = @"地址不能为空";
        isSucceed = NO;
    }
    
    if (!isSucceed) {
        [[HUDHelper sharedInstance] tipMessage:tipMsg inView:self.view];
    }
    return isSucceed;
}

- (BOOL)checkForComanyRich:(NSMutableArray *)richs{
    if (richs.count == 1) {
        RichMode *mode = richs[0];
        UITextView *textView = [self.view viewWithTag:mode.tagForView];
        if ([NSString isEmpty:textView.text]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Events

- (void)insertPic:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    WEAKSELF
    [self.photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        STRONGSELF
        UIImage *image = images[0];
        if (image) {
            [strongSelf addPic:image];
        }
    }];
    [self.photoActionSheet showPreviewAnimated:YES];
}

- (void)editDone:(UIBarButtonItem *)sender{
    if ([self checkForSubmit]) {
        WEAKSELF
        self.hud = [[HUDHelper sharedInstance] loading:@"更新中" inView:self.window];
        [[UploadRichEngine sharedInstance] upLoadRiches:self.companyInfoRich succeed:^(NSMutableArray *riches) {
            STRONGSELF
            strongSelf.companyInfoRich = riches;
            WEAKSELF
            [[UploadRichEngine sharedInstance] upLoadRiches:self.companyServiceRich succeed:^(NSMutableArray *riches) {
                STRONGSELF
                strongSelf.companyServiceRich = riches;
                [strongSelf submitToAPIServer];
            } failed:^{
                STRONGSELF
                [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
                [[HUDHelper sharedInstance] tipMessage:@"上传失败" inView:strongSelf.window];
            }];
        } failed:^{
            STRONGSELF
            [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
            [[HUDHelper sharedInstance] tipMessage:@"上传失败" inView:strongSelf.window];
        }];
    }
}

- (void)submitToAPIServer{
    for (RichMode *mode in self.companyInfoRich) {
        if ([mode.type isEqualToString:@"text"]) {
            UITextView *textView = [self.view viewWithTag:mode.tagForView];
            mode.inputContent = textView.text;
        }
    }
    for (RichMode *mode in self.companyServiceRich) {
        if ([mode.type isEqualToString:@"text"]) {
            UITextView *textView = [self.view viewWithTag:mode.tagForView];
            mode.inputContent = textView.text;
        }
    }
    
    NSMutableArray *uploadInfo = [RichMode turnToRichModeUpload:self.companyInfoRich];
    NSMutableArray *uploadService = [RichMode turnToRichModeUpload:self.companyServiceRich];
    
    NSString *infoString = [uploadInfo mj_JSONString];
    NSString *serviceString = [uploadService mj_JSONString];
    
    self.enterpriseModel.service = serviceString;
    self.enterpriseModel.desc = infoString;
    
    WEAKSELF
    [APIServerSdk doEditEnterpriseInfo:self.enterpriseModel succeed:^(id obj) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        [[HUDHelper sharedInstance] tipMessage:@"更新成功" inView:strongSelf.window];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    } failed:^(NSString *error) {
        STRONGSELF
        [[HUDHelper sharedInstance] stopLoading:strongSelf.hud];
        [[HUDHelper sharedInstance] tipMessage:@"上传失败" inView:strongSelf.window];
    }];
}

- (void)imageDel:(UIButton *)sender{
    UIImageView *imageView = (UIImageView *)sender.superview;
    [imageView removeFromSuperview];
    
    NSInteger tag = imageView.tag;
    NSInteger index = -1;
    
    index = [self findIndexByTag:tag richArray:self.companyInfoRich];
    if (index != -1) {
        [self.companyInfoRich removeObjectAtIndex:index];
        return;
    }
    
    index = [self findIndexByTag:tag richArray:self.companyServiceRich];
    if (index != -1) {
        [self.companyServiceRich removeObjectAtIndex:index];
    }
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
    if (textView.superview == self.linerCompanyInfo) {
        NSInteger index = [self findIndexByTag:tag richArray:self.companyInfoRich];
        if (index == 0 && self.companyInfoRich.count == 1) {
            return;
        }
        
        if (index < self.companyInfoRich.count - 1) {
            [textView removeFromSuperview];
            [self.companyInfoRich removeObjectAtIndex:index];
            RichMode *lastMode = [self.companyInfoRich lastObject];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
            return;
        }
        
        RichMode *lastMode = [self.companyInfoRich objectAtIndex:index - 1];
        if ([lastMode.type isEqualToString:@"image"]) {
            [self.companyInfoRich removeObjectAtIndex:index - 1];
            [[self.view viewWithTag:lastMode.tagForView] removeFromSuperview];
        }
        
        if ([lastMode.type isEqualToString:@"text"]) {
            [textView removeFromSuperview];
            [self.companyInfoRich removeObjectAtIndex:index];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
        }
    }
    
    if(textView.superview == self.linerCompanyService){
        NSInteger index = [self findIndexByTag:tag richArray:self.companyServiceRich];
        if (index == 0 && self.companyServiceRich.count == 1) {
            return;
        }
        
        if (index < self.companyServiceRich.count - 1) {
            [textView removeFromSuperview];
            [self.companyServiceRich removeObjectAtIndex:index];
            RichMode *lastMode = [self.companyServiceRich lastObject];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
            return;
        }

        RichMode *lastMode = [self.companyServiceRich objectAtIndex:index - 1];
        if ([lastMode.type isEqualToString:@"image"]) {
            [self.companyServiceRich removeObjectAtIndex:index - 1];
            [[self.view viewWithTag:lastMode.tagForView] removeFromSuperview];
        }
        
        if ([lastMode.type isEqualToString:@"text"]) {
            [textView removeFromSuperview];
            [self.companyServiceRich removeObjectAtIndex:index];
            [[self.view viewWithTag:lastMode.tagForView] becomeFirstResponder];
        }
    }
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    CGFloat h = [textView sizeThatFits:CGSizeMake(kRichCompanyWidth, CGFLOAT_MAX)].height;
    textView.myHeight = h;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location == 0 && range.length == 0 && text.length == 0) {
        [self dealEmptyTextViewDel:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.superview isEqual:self.linerCompanyInfo]) {
        self.currentEdit = 1;
    }else if([textView.superview isEqual:self.linerCompanyService]){
        self.currentEdit = 2;
    }else{
        self.currentEdit = -1;
    }
}

@end
