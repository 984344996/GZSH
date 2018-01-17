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

@end
