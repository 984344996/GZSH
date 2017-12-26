//
//  MZIMMessageCellBodyImage.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZIMMessageShappedImageView.h"
#import "MZIMMessageCellBodyBase.h"

@interface MZIMMessageCellBodyImage : MZIMMessageCellBodyBase

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MZIMMessageShappedImageView *shappedImageView;
@end
