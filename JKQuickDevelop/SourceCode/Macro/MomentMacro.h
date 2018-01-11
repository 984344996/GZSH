//
//  MomentMacro.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#ifndef MomentMacro_h
#define MomentMacro_h

#define kAvatar_Size 36
#define kGAP 24

#define kMomentHightTextColor RGB(139,165,139)
#define kMomentTitleTextColor RGB(31,185,34)
#define kMomentDetailTextColor RGB(49,49,49)
#define kMomentCommentBGTextColor RGB(242,242,242)

#define kMomentTitleFont [UIFont boldSystemFontOfSize:14]
#define kMomentDetailFont [UIFont systemFontOfSize:14]
#define kCommentFont [UIFont systemFontOfSize:12]

#define kMomentCommentWidth (JK_SCREEN_WIDTH - kGAP - kAvatar_Size - 2*kGAP - 16)
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "NSString+Extension.h"


#endif /* MomentMacro_h */
