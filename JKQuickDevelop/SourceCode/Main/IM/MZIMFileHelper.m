//
//  MZIMFileHelper.m
//  MuZhiStudio
//
//  Created by dengjie on 2016/11/29.
//  Copyright © 2016年 infomedia. All rights reserved.
//

#import "MZIMFileHelper.h"
#import "PathUtility.h"

#define kMZIMAttmentsSaveDir @"/im/attachements/"
#define kMZIMDownloadsDir @"/im/downloads/"

@implementation MZIMFileHelper

+ (NSString *)getIMSavePath:(BOOL)isDownload{
    NSString *relativePath;
    if (isDownload) {
        relativePath = kMZIMDownloadsDir;
    }else{
        relativePath = kMZIMAttmentsSaveDir;
    }
    
    [PathUtility createDirectoryAtDocument:relativePath];
    NSMutableString *path = [NSMutableString stringWithString:[PathUtility getDocumentPath]];
    [path appendString:relativePath];
    return path;
}

+(NSString *)getRecommendImagePath{
    NSString *dir  = [self getIMSavePath:NO];
    NSString *path = [NSString stringWithFormat:@"%@%@.png",dir,[self uuid]];
    [PathUtility deleteFileAtPath:path];
    return path;
}

+ (NSString *)getRecommendAudioPath{
    NSString *dir  = [self getIMSavePath:NO];
    NSString *path = [NSString stringWithFormat:@"%@%@.aac",dir,[self uuid]];
    [PathUtility deleteFileAtPath:path];
    return path;
}

+(NSString *)getRecommendAudioStoreMessage:(NSString *)uuid{
    NSString *dir  = [self getIMSavePath:YES];
    NSString *path = [NSString stringWithFormat:@"%@%@.aac",dir,uuid];
    [PathUtility deleteFileAtPath:path];
    return path;
}

+(NSString *)getRecommendVideoStoreMessage:(NSString *)uuid{
    NSString *dir  = [self getIMSavePath:YES];
    NSString *path = [NSString stringWithFormat:@"%@%@.mp4",dir,uuid];
    [PathUtility deleteFileAtPath:path];
    return path;
}

+ (NSString *)uuid{
    CFUUIDRef uuid      = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strUuid = CFUUIDCreateString(kCFAllocatorDefault,uuid);
    NSString * str      = [NSString stringWithString:(__bridge NSString *)strUuid];
    CFRelease(strUuid);
    CFRelease(uuid);
    return  str;
}
@end
