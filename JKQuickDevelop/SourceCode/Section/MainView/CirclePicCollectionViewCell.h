//
//  CirclePicCollectionViewCell.h
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/13.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclePicCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;

/// 当删除照片按钮点击时
@property (nonatomic, copy) void(^DeleteTapped)(NSIndexPath *indexPath);

@end
