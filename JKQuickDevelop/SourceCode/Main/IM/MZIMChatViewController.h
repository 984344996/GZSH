//
//  MZIMChatViewController.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/18.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MZIMComm.h"

@interface MZIMChatViewController : UIViewController
@property (nonatomic, strong) NSDictionary *materialInfo;
/**
 私聊
 */
- (instancetype)initWithUser:(NSString *)receiver;

/**
 群聊
 */
- (instancetype)initWithGroup:(NSString *)receiver;

/**
 创建私聊或者群聊
 */
- (instancetype)initWithTypeAndReceiver:(TIMConversationType)type receiver:(NSString *)receiver;
@end
