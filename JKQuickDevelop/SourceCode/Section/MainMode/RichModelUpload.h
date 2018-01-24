//
//  RichModelUpload.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/24.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichModelUpload : NSObject
@property (nonatomic, strong) NSString *inputContent;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end
