//
//  CharmTitleModel.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/30.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharmTitleModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, copy) NSString *chamTitle;
@property (nonatomic, assign) NSInteger level;

- (instancetype)initWithChamTitle:(NSString *)title;

@end
