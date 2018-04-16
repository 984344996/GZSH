//
//  JKSelectedListView.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/3/31.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKSelectedListView : UITableView
@property (nonatomic , strong ) NSArray* array;

/**
 已选中Block
 */
@property (nonatomic , copy ) void (^selectedBlock)(NSArray*);

/**
 选择改变Block (多选情况 当选择改变时调用)
 */
@property (nonatomic , copy ) void (^changedBlock)(NSArray*);

/**
 是否单选
 */
@property (nonatomic , assign ) BOOL isSingle;


/**
 title显示key
 */
@property (nonatomic, strong) NSString *titleKey;

/**
 完成选择 (多选会调用selectedBlock回调所选结果)
 */
- (void)finish;
@end
