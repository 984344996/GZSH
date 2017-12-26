//
//  NotificationService.m
//  JKCustomPushService
//
//  Created by dengjie on 2017/4/25.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler              = contentHandler;
    self.bestAttemptContent          = [request.content mutableCopy];

    // Modify the notification content here...
    self.bestAttemptContent.title    = @"我是修改之后的标题";
    self.bestAttemptContent.subtitle = @"我是修改之后的子标题";
    self.bestAttemptContent.body     = @"来自JKQuickDevelop";
    
    NSDictionary *dict     = self.bestAttemptContent.userInfo;
    NSDictionary *notiDict = dict[@"aps"];
    NSString *imageUrl     = notiDict[@"imageUrl"];
    
    if(!imageUrl.length){
        return self.contentHandler(self.bestAttemptContent);
    }
    
    [self loadAttachmentForUrlString:imageUrl withType:@"jpg" completionHandle:^(UNNotificationAttachment *attach) {
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
    }];
}


/**
 下载附件

 @param urlStr 附件地址
 @param type 类型
 @param completionHandler 下载完成回调
 */
- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"notificationImage" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    completionHandler(attachment);
                }] resume];
}

- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
