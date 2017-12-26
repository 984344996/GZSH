//
//  MZIMMessageCellBodyImage.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMMessageCellBodyImage.h"


@implementation MZIMMessageCellBodyImage

- (void)initView{
    [super initView];
    
    CGSize frameSize           = [[self class] getBodySize:self.message];
    self.jk_size               = frameSize;

    self.backgroundImage.image = nil;
    self.imageView             = [[UIImageView alloc] init];
    self.shappedImageView      = [[MZIMMessageShappedImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.shappedImageView];
}

- (void)setupView{
    [super setupView];
}

+(CGSize)getBodySize:(MZIMMessage *)message{
    return [[self class] getSizeForImageMessage:message];
}

@end
