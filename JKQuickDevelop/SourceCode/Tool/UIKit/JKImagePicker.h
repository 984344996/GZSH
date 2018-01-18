//
//  JKImagePicker.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/17.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKImagePicker : NSObject
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, copy) void(^PickCallback)(UIImage *image);

+ (JKImagePicker *)sharedInstance;


/**
 从拍照 相册 选择一张照片

 @param vc 当前控制器
 @param allowedEdit 是否允许选取后编辑
 @param callback 选取照片成功回调
 */
- (void)showPopView:(UIViewController *)vc allowedEdit:(BOOL)allowedEdit callback:(void(^)(UIImage *image))callback;
@end
