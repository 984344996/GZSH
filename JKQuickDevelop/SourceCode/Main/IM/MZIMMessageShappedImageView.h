//
//  MZIMMessageShappedImageView.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/21.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kShappedMargin 10
#define kShappedRadius 8

#define kShappedTringleSize 8
#define kShappedTopSize 4
#define kShappedMarginTop 5

@interface MZIMMessageShappedImageView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL *isComing;
@end
