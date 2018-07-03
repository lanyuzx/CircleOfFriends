//
//  LLCicleOfFriendLikeCommentView.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendLikeView.h"
#import "MLLinkLabel.h"
#import "LLCircleOfFriendsModel.h"
#import "LLCicleOfFriendCommentCell.h"
#import "LLCicleOfFriendCommentView.h"
@interface LLCicleOfFriendLikeView()
@property (nonatomic,strong) UIImageView * likeCommentBgView;
@property (nonatomic,strong) MLLinkLabel * likeLabel;
@property (nonatomic,strong) NSArray * likeArray;

@property (nonatomic,strong) NSArray * commenArray;

@property (nonatomic,weak)  MASConstraint* likeCommentConstraint;

@property (nonatomic,weak)  MASConstraint* commentConstraintTop;

@property (nonatomic,weak) UIView * likeBottomLine;

@property (nonatomic,strong) LLCicleOfFriendCommentView * commentView;
@end

@implementation LLCicleOfFriendLikeView

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentArray:(NSArray *)commentArray; {
    self.likeArray = likeItemsArray;
    self.commenArray = commentArray;
    self.likeBottomLine.hidden = !commentArray.count;
    [self layoutIfNeeded];
     [self.likeCommentConstraint uninstall];
    [self.commentConstraintTop uninstall];
    if (!likeItemsArray.count && !commentArray.count) { //没评论 没点赞
        self.hidden = true;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.likeCommentConstraint = make.bottom.equalTo(self.likeLabel.mas_top).offset(-5);
        }];
        return;
    }else if (likeItemsArray.count && !commentArray.count) { //没评论 有点赞
        self.hidden = false;
        self.likeBottomLine.hidden = true;
         self.likeLabel.hidden = false;
        self.commentView.hidden = true;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.likeCommentConstraint = make.bottom.equalTo(self.likeLabel.mas_bottom).offset(1);
        }];
    }else if(!likeItemsArray.count && commentArray.count) { //有评论 没点赞
        self.hidden = false;
        self.likeLabel.hidden = true;
        self.likeBottomLine.hidden = true;
        self.commentView.hidden = false;
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.commentConstraintTop =   make.top.equalTo(self.likeCommentBgView.mas_top).offset(5);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.likeCommentConstraint = make.bottom.equalTo(self.commentView.mas_bottom).offset(1);
        }];
        
    }else { //有评论 有点赞
        self.hidden = false;
        self.likeLabel.hidden = false;
        self.likeBottomLine.hidden = false;
        self.commentView.hidden = false;
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.commentConstraintTop =   make.top.equalTo(self.likeBottomLine .mas_bottom);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            self.likeCommentConstraint = make.bottom.equalTo(self.commentView.mas_bottom).offset(1);
        }];
        
    }
}

-(void)setLikeArray:(NSArray *)likeArray {
    _likeArray = likeArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeArray.count; i++) {
        LLLikeItemModel *model = likeArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        }
        [attributedText appendAttributedString:model.attributedContent];
    }
    
    _likeLabel.attributedText = [attributedText copy];
}

-(void)setCommenArray:(NSArray *)commenArray {
    _commenArray = commenArray;
    self.commentView.commentArray = commenArray;
}



- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(LLLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    self.likeCommentBgView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.likeCommentBgView.image = bgImage;
    [self addSubview:self.likeCommentBgView];
    [self.likeCommentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60);
        make.right.equalTo(self).offset(-LLCellMargin);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    self.likeLabel.numberOfLines = 0;
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : LLHighlightedColor};
    _likeLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 70;
    [self.likeCommentBgView addSubview:_likeLabel];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.likeCommentBgView);
        make.top.equalTo(self.likeCommentBgView).offset(5);
    }];
    
    UIView * likeLableBottomLine = [UIView new];
    self.likeBottomLine = likeLableBottomLine;
    likeLableBottomLine.backgroundColor = SDColor(210, 210, 210, 1.0f);
    [_likeCommentBgView addSubview:likeLableBottomLine];
    [likeLableBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.likeCommentBgView);
        make.top.equalTo(self.likeLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
   
    
    self.commentView = [LLCicleOfFriendCommentView new];
    [self.likeCommentBgView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.likeCommentBgView);
     self.commentConstraintTop =   make.top.equalTo(likeLableBottomLine.mas_bottom).offset(5);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.likeCommentConstraint = make.bottom.equalTo(self.commentView.mas_bottom);
    }];
}





@end
