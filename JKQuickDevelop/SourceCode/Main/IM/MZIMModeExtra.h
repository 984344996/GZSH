//
//  MZIMModeExtra.h
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/22.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZIMModeExtra : NSObject

@end

@interface IMUserInfo : NSObject
+ (void)updateIMUserInfo;
- (BOOL)saveToLocal;

@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * telephone;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSNumber * level;
@property (nonatomic,strong) NSString * headerImage;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSNumber * tim_accountType;
@property (nonatomic,strong) NSString * imuid;
@end

@interface MZIMMaterialInfo : NSObject
@property (nonatomic, strong) NSString *material_id;
@property (nonatomic, strong) NSString *material_type;
@property (nonatomic, strong) NSString *material_title;
@property (nonatomic, strong) NSString *material_url;
@end
