//
//  LLCommentLikeByFrameView.m
//  CircleOfFriends
//
//  Created by lanlan on 2018/7/9.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendCommentLikeByFrameView.h"
#import "MLLinkLabel.h"
#import "LLCircleOfFriendsByFrameModel.h"
#import "LLCicleOfFriendCommentCell.h"
@interface LLCicleOfFriendCommentLikeByFrameView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView * likeCommentBgView;
@property (nonatomic,strong) MLLinkLabel * likeLabel;
@property(nonatomic ,strong)UIView * likeBottomLine;
@property(nonatomic ,weak)NSArray * likeArray;
@property(nonatomic ,weak)NSArray * commmentArray;
@property(nonatomic ,strong)UITableView * tableView;

@end

@implementation LLCicleOfFriendCommentLikeByFrameView

-(void)setModel:(LLCircleOfFriendsByFrameModel *)model {
    _model = model;
    self.likeArray = model.likeItemsArray;
    self.commmentArray = model.commentItemsArray;
    if (!self.likeArray.count && !self.commmentArray.count) { //没评论 没点赞
        self.hidden = true;
    }else if (self.likeArray.count && !self.commmentArray.count) { //没评论 有点赞
        self.hidden = false;
        self.likeBottomLine.hidden = true;
        self.likeLabel.hidden = false;
        self.tableView.hidden = true;
        
        self.likeLabel.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, [self getLikeAttributedStringHeight]+10);
        self.tableView.frame = CGRectZero;
        
    }else if(!self.likeArray.count && self.commmentArray.count) { //有评论 没点赞
        self.hidden = false;
        self.likeBottomLine.hidden = true;
        self.likeLabel.hidden = true;
        self.tableView.hidden = false;
        self.likeLabel.frame = CGRectZero;
        self.tableView.frame = CGRectMake(5, 10, CGRectGetWidth(self.frame), [self getCommentAttributedStringHeight]);
       
    }else { //有评论 有点赞
        self.hidden = false;
        self.likeBottomLine.hidden = false;
        self.likeLabel.hidden = false;
        self.tableView.hidden = false;
        self.likeLabel.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, [self getLikeAttributedStringHeight]+10);
        self.likeBottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.likeLabel.frame), CGRectGetWidth(self.frame), 1);
        self.tableView.frame = CGRectMake(5, CGRectGetMaxY(self.likeBottomLine.frame)+3, CGRectGetWidth(self.frame), [self getCommentAttributedStringHeight]);
    }
   
}



-(void)setLikeArray:(NSArray *)likeArray {
    _likeArray = likeArray;
    
    if (!likeArray.count) {
        self.likeBottomLine.hidden = true;
        return;
    }
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeArray.count; i++) {
        LLLikeItemByFrameModel *model = likeArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
          model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        [attributedText appendAttributedString:model.attributedContent];
    }
    
    _likeLabel.attributedText = attributedText;
}

-(void)setCommmentArray:(NSArray *)commmentArray {
    _commmentArray = commmentArray;
    [self.tableView reloadData];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.likeCommentBgView.frame = self.bounds;
}

-(void)setupUI {
    self.likeCommentBgView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.likeCommentBgView.image = bgImage;
    [self addSubview:self.likeCommentBgView];
//    [self.likeCommentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    self.likeLabel.numberOfLines = 0;
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : LLHighlightedColor};
    _likeLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 90;
    [self.likeCommentBgView addSubview:_likeLabel];
//    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.likeCommentBgView).offset(5);
//        make.right.equalTo(self.likeCommentBgView).offset(-5);
//        make.top.equalTo(self.likeCommentBgView).offset(5);
//    }];
    
    UIView * likeLableBottomLine = [UIView new];
    self.likeBottomLine = likeLableBottomLine;
    likeLableBottomLine.backgroundColor = SDColor(210, 210, 210, 1.0f);
    [_likeCommentBgView addSubview:likeLableBottomLine];
//    [likeLableBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.likeCommentBgView);
//        make.top.equalTo(self.likeLabel.mas_bottom);
//        make.height.mas_equalTo(1);
//    }];
    
    [_likeCommentBgView addSubview:self.tableView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.top.equalTo(likeLableBottomLine.mas_bottom);
//        make.bottom.equalTo(self.likeCommentBgView);
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLCicleOfFriendCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLCicleOfFriendCommentCell"];
    LLCommentItemByFrameModel * model = self.commmentArray[indexPath.row];
    cell.commentString = model.attributedContent;
    //cell.textLabel.attributedText = model.attributedContent;
    cell.contentView.backgroundColor = indexPath.row == 0 ? [UIColor redColor] :[UIColor orangeColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LLCommentItemByFrameModel * model = self.commmentArray[indexPath.row];
//    return model.attributedContentHeight;
    return [tableView fd_heightForCellWithIdentifier:@"LLCicleOfFriendCommentCell" cacheByIndexPath:indexPath configuration:^(LLCicleOfFriendCommentCell * cell) {
        LLCommentItemByFrameModel * model = self.commmentArray[indexPath.row];
        cell.commentString = model.attributedContent;
    }];
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(LLLikeItemByFrameModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

-(CGFloat)getCommentAttributedStringHeight {
    __block CGFloat totalHeight = 0.0;
    [self.commmentArray enumerateObjectsUsingBlock:^(LLCommentItemByFrameModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //if (!obj.attributedContent) {
            obj.attributedContent = [self generateAttributedStringWithCommentItemModel:obj];
        //}
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                              };
        CGFloat attributedContentHeight = [[obj.attributedContent string] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height +6 ;
            obj.attributedContentHeight = attributedContentHeight;
        
        totalHeight += obj.attributedContentHeight;
    }];
    
    return totalHeight ;
}

-(CGFloat)getLikeAttributedStringHeight {
    NSMutableAttributedString * likeAttributedString = [self getLikeAttributedString];
    if (!likeAttributedString) {
        return 0;
    }
    CGFloat likeHeight = [self textHeightWithString:[likeAttributedString string] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} withSize:CGSizeMake(SCREEN_WIDTH - 90 , MAXFLOAT)];
    
    return likeHeight ;
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(LLCommentItemByFrameModel *)model
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

-(NSMutableAttributedString *)getLikeAttributedString {
    if (!_likeArray.count) {
        return nil;
    }
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < _likeArray.count; i++) {
        LLLikeItemByFrameModel *model = _likeArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        [attributedText appendAttributedString:model.attributedContent];
    }
    return attributedText;
}

-(CGFloat)textHeightWithString:(NSString *)string attributes:(NSDictionary*)attributes withSize:(CGSize)textSize {
    // @{NSFontAttributeName:[UIFont systemFontOfSize:font]}
    CGSize strSize = [string boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return strSize.height;
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
