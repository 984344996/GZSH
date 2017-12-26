//
//  MZIMModeExtra.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/22.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMModeExtra.h"
#import "MJExtension.h"

#define kIMUserInfo @"IM_User_Info"
@implementation MZIMModeExtra

@end

@implementation IMUserInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"ID",
             @"telephone" : @"telephone",
             @"name" : @"name",
             @"level" : @"level",
             @"headerImage" : @"headerImage",
             @"sex" : @"sex",
             @"tim_accountType" : @"tim_accountType",
             @"imuid" : @"imuid"
             };
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.ID = [coder decodeObjectForKey:@"ID"];
        self.telephone = [coder decodeObjectForKey:@"telephone"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.level = [coder decodeObjectForKey:@"level"];
        self.headerImage = [coder decodeObjectForKey:@"headerImage"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.tim_accountType = [coder decodeObjectForKey:@"tim_accountType"];
        self.imuid = [coder decodeObjectForKey:@"imuid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.ID forKey:@"ID"];
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.level forKey:@"level"];
    [coder encodeObject:self.headerImage forKey:@"headerImage"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.tim_accountType forKey:@"tim_accountType"];
    [coder encodeObject:self.imuid forKey:@"imuid"];
}

+ (IMUserInfo*)userInfoFromLocal
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData * udObject = nil;
    udObject = [ud objectForKey:kIMUserInfo];
    IMUserInfo * userInfo = nil;
    
    if(udObject)
    {
        userInfo  = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    }
    return userInfo;
}

- (BOOL)saveToLocal
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ud setObject:udObject forKey:kIMUserInfo];
    return YES;
}
@end

@implementation MZIMMaterialInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
                @"material_id":@"material_id",
                @"material_type":@"material_type",
                @"material_title":@"material_title",
                @"material_url":@"material_url"
             };
}
@end
