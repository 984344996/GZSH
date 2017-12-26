//
//  MZIMListener.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/17.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZIMComm.h"

@interface MZIMListener : NSObject<TIMMessageListener,TIMConnListener,TIMUserStatusListener>


/**
 监听器 全局唯一

 @return 单例对象
 */
+ (MZIMListener *)sharedInstance;
@end
