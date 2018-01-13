//
//  CirclePicCollectionViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/13.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "CirclePicCollectionViewCell.h"

@implementation CirclePicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnRemove addTarget:self action:@selector(removeCurrentCell) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeCurrentCell{
    if (self.DeleteTapped) {
        self.DeleteTapped(self.indexPath);
    }
}

@end
