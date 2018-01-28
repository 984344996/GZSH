//
//  MemberCenterTableViewHeaderView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/6.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface MemberCenterTableViewHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyPositionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconVipImage;
@property (weak, nonatomic) IBOutlet UILabel *vipInfoLabel;

- (void)setUserInfo:(UserInfo *)userInfo;

@end
