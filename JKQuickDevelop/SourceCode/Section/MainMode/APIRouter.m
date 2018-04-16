//
//  APIRouter.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "APIRouter.h"

/// login sign
NSString *const RLogin            = @"/sign/login";
NSString *const RRegister         = @"/sign/register";
NSString *const RVerify           = @"/sign/verify";
NSString *const RAccomplish       = @"/sign/accomplish";
NSString *const RResetPassword    = @"/sign/password";

/// main
NSString *const RBanner           = @"/public/banner";
NSString *const RSysInfo          = @"/public/sysInfo";
NSString *const RUpload           = @"/public/upload";
NSString *const RNews             = @"/news";
NSString *const RDemand           = @"/demand";
NSString *const RUserDemand       = @"/demand/userDemands";

/// contact
NSString *const RContact          = @"/user/contact";
NSString *const REnterprise       = @"/user/enterprise";

/// activity
NSString *const RMeeting          = @"/meeting";
NSString *const RMeetingDetail    = @"/meeting/detail";
NSString *const RMeetingJoin      = @"/meeting/join";

/// userinfo
NSString *const RUserInfo         = @"/user/info";
NSString *const REditEnterprise   = @"/user/editEnterprise";
NSString *const REditDemand       = @"/demand/edit";
NSString *const REditDemandUpdate = @"/demand/update";
NSString *const ROwnDemands       = @"/demand/ownDemands";
NSString *const RFeedback         = @"/public/feedback";

/// moment
NSString *const RCircle           = @"/circle";
NSString *const RCirclePost       = @"/circle/post";
NSString *const RCirclePraise     = @"/circle/praise";
NSString *const RCircleComment    = @"/circle/comment";
NSString *const RCircleDetail     = @"/circle/detail";
NSString *const RCircleNotice     = @"/circle/notice";

/// 新增
NSString *const RVip              = @"/vip";
NSString *const RFirstPay         = @"/vip/firstBuy";
NSString *const RDeleteUnpay      = @"/vip/removeUnpaid";
NSString *const RUnpay            = @"/vip/findUnpaid";
NSString *const RPay              = @"/vip/buy";
NSString *const RRenew            = @"/vip/renew";


