//
//  NotificationViewController.m
//  JKCustomPushContent
//
//  Created by dengjie on 2017/4/25.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property (weak, nonatomic) IBOutlet UIImageView *notificationImage;
@property (weak, nonatomic) IBOutlet UILabel *notificationTitle;
@property (weak, nonatomic) IBOutlet UILabel *notificationContent;
@property (weak, nonatomic) IBOutlet UILabel *notificationTime;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


/**
 收到通知调用此函数，进行自定义View数据配置

 @param notification 通知消息
 */
- (void)didReceiveNotification:(UNNotification *)notification {
    self.notificationTitle.text = notification.request.content.title;
    self.notificationContent.text = notification.request.content.subtitle;
    UNNotificationAttachment *attachment = notification.request.content.attachments.firstObject;
    if (attachment && [attachment.identifier isEqualToString:@"notificationImage"]){
        if(attachment.URL.startAccessingSecurityScopedResource){
            NSURL *url = attachment.URL;
            UIImage *image = [UIImage imageWithContentsOfFile:url.path];
            self.notificationImage.image = image;
        }
    }
}

@end
