//
//  BannerModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject
@property (nonatomic, strong) NSString *type; //[NONE,LINK]
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *priority;
@end
