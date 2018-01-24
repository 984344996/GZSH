//
//  RichMode.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/9.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RichModelUpload.h"

@interface RichMode : NSObject
// ["image", "text"]
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *inputContent;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger tagForView;

+ (NSMutableArray *)turnToRichModeUpload:(NSMutableArray *)richModel;
@end
