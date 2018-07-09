//
//  LLCicleOfFriendCommentCell.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendCommentCell.h"
#import "MLLinkLabel.h"
@interface LLCicleOfFriendCommentCell()
@property (nonatomic,strong) MLLinkLabel * commentLable;
@end
@implementation LLCicleOfFriendCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCommentString:(NSAttributedString *)commentString {
    _commentString =commentString;
    
    self.commentLable.attributedText = commentString;
//    self.hyb_lastViewInCell = self.commentLable;
//    self.hyb_bottomOffsetToCell = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.commentLable.frame = self.bounds;
}

-(void)setupUI {
    self.commentLable = [MLLinkLabel new];
    [self.contentView addSubview:self.commentLable];
    self.commentLable.numberOfLines = 0;
    self.commentLable.font = [UIFont systemFontOfSize:14];
    self.commentLable.textColor = [UIColor blackColor];
    self.commentLable.preferredMaxLayoutWidth = SCREEN_WIDTH - 80;
//    [self.commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(3);
//        make.right.equalTo(self.contentView).offset(-3);
//        make.top.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView);
//    }];
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.commentLable.mas_bottom);
//    }];
}
@end
