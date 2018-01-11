//
//  MineCompanyTextTableViewCell.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/11.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCompanyTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

- (void)setCellData:(NSDictionary *)dic;

@end
