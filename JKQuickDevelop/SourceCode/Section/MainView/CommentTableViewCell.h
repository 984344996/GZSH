//
//  CommentTableViewCell.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/7.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentTableViewCell : UITableViewCell

- (void)configCellWithModel:(Comment *)model;

@end
