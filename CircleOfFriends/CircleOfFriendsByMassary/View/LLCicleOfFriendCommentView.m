//
//  LLCicleOfFriendCommentFooterView.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendCommentView.h"
#import "LLCicleOfFriendCommentCell.h"
#import "LLCircleOfFriendsModel.h"

@interface LLCicleOfFriendCommentView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView * likeCommentBgView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,weak) MASConstraint* commentHeight;
@end

@implementation LLCicleOfFriendCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
           self.commentHeight = make.height.mas_equalTo(40);
        }];
    }
    
    return self;
}



-(void)setupUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(60);
//        make.top.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).offset(-LLCellMargin);
//        //make.bottom.equalTo(self.contentView);
        make.edges.equalTo(self);
    }];
}




-(void)setCommentArray:(NSArray *)commentArray {
    _commentArray = commentArray;
    
    __block CGFloat totalHeight = 0.0;
    [commentArray enumerateObjectsUsingBlock:^(LLCommentItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.attributedContent) {
             obj.attributedContent = [self generateAttributedStringWithCommentItemModel:obj];
        }
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], 
                              };
        if (!obj.attributedContentHeight) {
             CGFloat attributedContentHeight = [[obj.attributedContent string] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 5;
            obj.attributedContentHeight = attributedContentHeight;
        }
        totalHeight += obj.attributedContentHeight;
    }];
    [self.commentHeight uninstall];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.commentHeight = make.height.mas_equalTo(totalHeight);
    }];
    [self.tableView reloadData];
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(LLCommentItemModel *)model
{
    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.commentString]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    if (model.secondUserName) {
        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCicleOfFriendCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLCicleOfFriendCommentCell"];
    LLCommentItemModel * model = self.commentArray[indexPath.row];
   cell.commentString = model.attributedContent;
    //cell.textLabel.attributedText = model.attributedContent;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  LLCommentItemModel * model = self.commentArray[indexPath.row];
    return model.attributedContentHeight;
//    return [LLCicleOfFriendCommentCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
//        LLCicleOfFriendCommentCell * cell = (LLCicleOfFriendCommentCell *) sourceCell;
//        LLCommentItemModel * model = self.commentArray[indexPath.row];
//        cell.commentString = model.attributedContent;
//    } cache:^NSDictionary *{
//        return  @{kHYBCacheUniqueKey: [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section,(long)indexPath.row],
//                  kHYBCacheStateKey : @"LLCicleOfFriendCommentCell",
//                  // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
//                  // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
//                  kHYBRecalculateForStateKey : @(NO) // 标识不用重新更新
//                  };
//    }];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[LLCicleOfFriendCommentCell class] forCellReuseIdentifier:@"LLCicleOfFriendCommentCell"];
    }
    return _tableView;
}

@end
