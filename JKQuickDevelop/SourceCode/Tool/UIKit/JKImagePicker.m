//
//  JKImagePicker.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/17.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "JKImagePicker.h"
#define System_Version ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface JKImagePicker()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, assign) BOOL allowedEdit;
@end

@implementation JKImagePicker

+ (JKImagePicker *)sharedInstance{
    static JKImagePicker *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JKImagePicker alloc] init];
    });
    return instance;
}


- (void)showPopView:(UIViewController *)vc allowedEdit:(BOOL)allowedEdit callback:(void(^)(UIImage *image))callback
{
    self.vc = vc;
    self.PickCallback = callback;
    NSString *cancelButtonTitle = @"取消";
    NSString *destructiveButtonTitle =  @"拍照";
    NSString *otherTitle = @"从相册中选取";
    
    if(System_Version <  8.0f)
    {
        __weak id weakSelf = self;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:weakSelf
                                      cancelButtonTitle: cancelButtonTitle
                                      destructiveButtonTitle: destructiveButtonTitle
                                      otherButtonTitles: otherTitle,nil];
        actionSheet.actionSheetStyle = UIBarStyleDefault;
        [actionSheet showInView:vc.view];
#pragma clang diagnostic pop
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self onCancel];
        }];
        
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style: UIAlertActionStyleDestructive  handler:^(UIAlertAction *action) {
            [self onFromCamera];
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self onPhotoAlbum];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:destructiveAction];
        [alertController addAction:otherAction];
        
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)onCancel
{
    
}

- (void)onFromCamera
{
    __weak id weakSelf = self;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        [self.vc presentViewController:picker animated:YES completion:^{}];
        
    }else {
        if (self.PickCallback) {
            self.PickCallback(nil);
        }
    }
}

- (void)onPhotoAlbum
{
    __weak id weakSelf = self;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = weakSelf;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    picker.allowsEditing = YES;
    [self.vc presentViewController:picker animated:YES completion:^{}];
}


#pragma mark - Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    self.PickCallback(nil);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *selectedImage;
    if (info[UIImagePickerControllerEditedImage]) {
        selectedImage = info[UIImagePickerControllerEditedImage];
        self.PickCallback(selectedImage);
        return;
    }
    selectedImage = info[UIImagePickerControllerOriginalImage];
    self.PickCallback(selectedImage);
}

@end
