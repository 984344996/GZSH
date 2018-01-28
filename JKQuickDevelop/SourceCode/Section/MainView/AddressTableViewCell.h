//
//  AddressTableViewCell.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "EnterpriseModelExt.h"

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;

- (void)setupCellData:(Contact *)data;
- (void)setupCellDataEnterprise:(EnterpriseModelExt *)data;

@end
