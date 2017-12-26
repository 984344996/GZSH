//
//  MZIMMessageCellBodyText.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZIMMessageCellBodyBase.h"

#define kIMTextSelfColor ([UIColor whiteColor])
#define kIMTextOtherColor ([UIColor darkGrayColor])

@interface MZIMMessageCellBodyText : MZIMMessageCellBodyBase
@property (nonatomic, strong) UILabel *textLabel;
@end
