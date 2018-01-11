//
//  CommentTableViewCell.m
//  JKQuickDevelop
//
//  Created by dengjie on 2018/1/7.
//  Copyright © 2018年 dengjie. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <YYText.h>
#import <Masonry.h>
#import "MomentMacro.h"

@interface CommentTableViewCell()
@property (nonatomic, strong) YYLabel *contentLabel;
@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.preservesSuperviewLayoutMargins = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(8.0);
        make.right.equalTo(self.contentView).with.offset(-8.0);
        make.top.equalTo(self.contentView).with.offset(5);
    }];
    self.backgroundColor = [UIColor clearColor];
    self.hyb_lastViewInCell = self.contentLabel;
    self.hyb_bottomOffsetToCell = 0;
}

- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = kCommentFont;
        _contentLabel.preferredMaxLayoutWidth = kMomentCommentWidth;
    }
    return _contentLabel;
}

#pragma mark - Public

- (void)configCellWithModel:(Comment *)model{
    
    NSString *str;
    if (model.userB) {
        str = [NSString stringWithFormat:@"%@回复%@：%@",model.userA.name,model.userB.name,model.content];
    }else{
        str = [NSString stringWithFormat:@"%@：%@",model.userA.name,model.content];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc] init];
    if ([text.string isMoreThanOneLineWithSize:CGSizeMake(kMomentCommentWidth, CGFLOAT_MAX) font:kCommentFont lineSpaceing:5.0]) {
         muStyle.lineSpacing = 5.0;//设置行间距离
    }else{
         muStyle.lineSpacing = CGFLOAT_MIN;//设置行间距离
    }
    [text addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, text.length)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:kMomentHightTextColor
                 range:NSMakeRange(0,model.userA.name.length)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:kMomentHightTextColor
                 range:NSMakeRange(model.userA.name.length + 2, model.userB.name.length)];
    self.contentLabel.attributedText = text;
}
@end
