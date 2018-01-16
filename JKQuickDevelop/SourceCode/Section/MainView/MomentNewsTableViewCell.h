//
//  MomentNewsTableViewCell.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/13.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentNewsModel.h"

@interface MomentNewsTableViewCell : UITableViewCell

@property (nonatomic, strong) MomentNewsModel *newsModel;
+ (CGFloat)heightWithMode:(MomentNewsModel *)newsModel;
@end
