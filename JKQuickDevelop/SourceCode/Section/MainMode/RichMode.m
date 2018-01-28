//
//  RichMode.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/9.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "RichMode.h"
#import "NSString+Commen.h"
#import <MJExtension.h>
@implementation RichMode

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        RichMode *toCompare = object;
        if (toCompare.tagForView == self.tagForView) {
            return YES;
        }
    }
    return NO;
}

+ (NSMutableArray *)turnToRichModeUpload:(NSMutableArray *)richModel{
    NSMutableArray *newArr = [NSMutableArray array];
    for (RichMode *model in richModel) {
        if (!model.imageUrl && [NSString isEmpty:model.inputContent]) {
            continue;
        }
        RichModelUpload *upload = [[RichModelUpload alloc] init];
        upload.inputContent     = model.inputContent;
        upload.imageUrl         = model.imageUrl;
        upload.width            = model.width;
        upload.height           = model.height;
        [newArr addObject:[upload mj_keyValues]];
    }
    return newArr;
}

- (NSString *)type{
    if (self.image || self.imageUrl) {
        return @"image";
    }
    return @"text";
}

@end
