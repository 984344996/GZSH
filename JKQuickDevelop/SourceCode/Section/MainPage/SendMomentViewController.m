//
//  SendMomentViewController.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/2.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "SendMomentViewController.h"
#import <UITextView+Placeholder.h>
#import "CirclePicCollectionViewCell.h"
#import <ZLPhotoActionSheet.h>
#import "UpLoadImagesEngine.h"
#import "HUDHelper.h"
#import "NSString+Commen.h"
#import <ReactiveObjC.h>

@interface SendMomentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *asserts;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UITextView *momentText;
@property (nonatomic, strong) ZLPhotoActionSheet *photoActionSheet;
@property (nonatomic, strong) NSString *content;
@end

@implementation SendMomentViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configView{
    [super configView];
    self.title = @"发动态";
    [self addUIBarButtonItemText:@"发布" isLeft:NO target:self action:@selector(publish:)];
    
    [self.view addSubview:self.momentText];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CirclePicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CirclePicCollectionViewCell"];
}

- (void)configEvent{
    [super configEvent];
    RAC(self , content) = [RACSignal merge:@[RACObserve(self.momentText, text),self.momentText.rac_textSignal]];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.momentText setFrame:CGRectMake(12, 12, JK_SCREEN_WIDTH - 24, 120)];
    [self.collectionView setFrame:CGRectMake(12, 144, JK_SCREEN_WIDTH - 24, 300)];
}

#pragma mark - Lazy loading

- (UITextView *)momentText{
    if (!_momentText) {
        _momentText = [[UITextView alloc] init];
        _momentText.font = kMainTextFieldTextFontMiddle;
        _momentText.textColor = kMainTextColor;
        _momentText.placeholder = @"发布你的动态";
        _momentText.placeholderLabel.font = kMainTextFieldTextFontMiddle;
    }
    return _momentText;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (JK_SCREEN_WIDTH  - 24 - 10 * 3)/ 4;
        _flowLayout.itemSize = CGSizeMake(itemW, itemW);
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (ZLPhotoActionSheet *)photoActionSheet{
    if (!_photoActionSheet) {
        _photoActionSheet = [[ZLPhotoActionSheet alloc] init];
        _photoActionSheet.sender = self;
        _photoActionSheet.configuration.navBarColor = kGreenColor;
        _photoActionSheet.configuration.navTitleColor = kWhiteColor;
        _photoActionSheet.configuration.allowSelectOriginal = NO;
        _photoActionSheet.configuration.maxSelectCount = 9;
        _photoActionSheet.configuration.allowSelectGif = NO;
        _photoActionSheet.configuration.allowSelectVideo = NO;
        _photoActionSheet.configuration.allowMixSelect = NO;
        
    }
    return _photoActionSheet;
}

- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray *)asserts{
    if (!_asserts) {
        _asserts = [NSMutableArray array];
    }
    return _asserts;
}

#pragma mark - Private methods

- (void)publish:(UIBarButtonItem *)sender{
    if ([self checkForPublish]) {
        SHUploadTask *task = [[SHUploadTask alloc] init];
        task.content = self.content;
        task.imgs = self.images;
        [[UpLoadImagesEngine sharedInstance] addTask:task];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkForPublish{
    if ([NSString isEmpty:self.content] && self.images.count == 0) {
        [[HUDHelper sharedInstance] tipMessage:@"发送内容不能为空" inView:self.view];
        return NO;
    }
    return YES;
}

- (void)selectPhoto{
    WEAKSELF
    self.photoActionSheet.arrSelectedAssets = self.asserts;
    [self.photoActionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        STRONGSELF
        strongSelf.images = [NSMutableArray arrayWithArray:images];
        strongSelf.asserts = [NSMutableArray arrayWithArray:assets];
        [strongSelf.collectionView reloadData];
    }];
    [self.photoActionSheet showPreviewAnimated:YES];
}


#pragma mark - Delegate and Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.images.count < 9) {
        return self.images.count + 1;
    }
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CirclePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CirclePicCollectionViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    WEAKSELF
    cell.DeleteTapped = ^(NSIndexPath *indexPath) {
        STRONGSELF
        [strongSelf.collectionView performBatchUpdates:^{
            [strongSelf.images removeObjectAtIndex:indexPath.row];
            [strongSelf.asserts removeObjectAtIndex:indexPath.row];
            [strongSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }completion:^(BOOL finished){
            [strongSelf.collectionView reloadData];
        }];
    };
    if (self.images.count < 9 && indexPath.row == self.images.count) {
        [cell.btnRemove setHidden:YES];
        cell.imagePic.image = [UIImage imageNamed:@"AlbumAdd"];
    }else{
        
        UIImage *image = self.images[indexPath.row];
        cell.imagePic.image = image;
        [cell.btnRemove setHidden:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.images.count < 9 && indexPath.row == self.images.count) {
        [self selectPhoto];
    }
}

@end

