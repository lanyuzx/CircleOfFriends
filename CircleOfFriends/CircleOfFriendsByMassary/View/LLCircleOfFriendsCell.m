//
//  LLCircleOfFriendsCell.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCircleOfFriendsCell.h"
#import "LLCicleOfFriendsOriginalView.h"
#import "LLCircleOfFriendsModel.h"
#import "LLCicleOfFriendLikeView.h"
@interface LLCircleOfFriendsCell()<LLCicleOfFriendsOriginalViewDelegate>
@property (nonatomic,strong) LLCicleOfFriendsOriginalView * originalView;
@property (nonatomic,strong) LLCicleOfFriendLikeView * likeCommnetView;
@end
@implementation LLCircleOfFriendsCell

-(void)setModel:(LLCircleOfFriendsModel *)model {
    _model = model;
    self.originalView.model = model;
    
    [self.likeCommnetView setupWithLikeItemsArray:model.likeItemsArray commentArray:model.commentItemsArray];
    self.hyb_lastViewInCell = self.likeCommnetView;
    self.hyb_bottomOffsetToCell = 5;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
-(void)setupUI {
    self.originalView = [LLCicleOfFriendsOriginalView new];
    self.originalView.delegate = self;
    [self.contentView addSubview:self.originalView];
    [self.originalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    self.likeCommnetView = [LLCicleOfFriendLikeView new];
    [self.contentView addSubview:self.likeCommnetView];
    [self.likeCommnetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.originalView.mas_bottom).offset(5);
        //make.bottom.equalTo(self.contentView).priorityHigh();
    }];
}

-(void)cicleOfFriendsOriginalViewShouldShowMoreDelegate {
    
    [UIView animateWithDuration:0.0 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

-(void)cicleOfFriendsOriginalViewLikeButtonClickDelegate {
    self.model.isOpening = false;
    self.model.recalculateHeight = true;
    [UIView animateWithDuration:0.0 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

-(void)cicleOfFriendsOriginalViewCommentButtonClickDelegate {
     self.model.recalculateHeight = true;
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation(self);
    }
}

@end
