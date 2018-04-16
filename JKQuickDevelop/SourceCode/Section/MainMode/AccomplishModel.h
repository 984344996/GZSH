//
//  AccomplishModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/16.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccomplishModel : NSObject

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *proName;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *countyId;
@property (nonatomic, strong) NSString *countyName;
@property (nonatomic, strong) NSString *enterpriseName;
@property (nonatomic, strong) NSString *enterpriseTitle;
@property (nonatomic, strong) NSString *enterpriseDescription;
@property (nonatomic, strong) NSString *recommend;
@property (nonatomic, strong) NSString *supplement;
@property (nonatomic, assign) BOOL selfbuying;
@end
