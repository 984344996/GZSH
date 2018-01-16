//
//  APIRouter.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

/// sign
extern NSString *const RLogin; // mobile & password
extern NSString *const RRegister; // mobile & verifyCode
extern NSString *const RVerify; // mobile & type [register, reset_password]
extern NSString *const RAccomplish;
extern NSString *const RResetPassword; /// mobile verification password


/// main
extern NSString *const RBanner;
extern NSString *const RSysInfo;
extern NSString *const RUpload;
extern NSString *const RNews;
extern NSString *const RDemand;
extern NSString *const RUserDemand;

/// contact
extern NSString *const RContact;
extern NSString *const REnterprise;

/// activity
extern NSString *const RMeeting;
extern NSString *const RMeetingDetail;
extern NSString *const RMeetingJoin;

/// userinfo
extern NSString *const RUserInfo;
extern NSString *const REditEnterprise;
extern NSString *const REditDemand;
extern NSString *const REditDemandUpdate;
extern NSString *const ROwnDemands;
extern NSString *const RFeedback;

/// moment

extern NSString *const RCircle;
extern NSString *const RCirclePost;
extern NSString *const RCirclePraise;
extern NSString *const RCircleComment;
extern NSString *const RCircleDetail;
extern NSString *const RCircleNotice;








