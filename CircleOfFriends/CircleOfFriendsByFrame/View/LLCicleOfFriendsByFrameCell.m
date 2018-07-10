//
//  LLCicleOfFriendsByFrameCell.m
//  CircleOfFriends
//
//  Created by lanlan on 2018/7/6.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendsByFrameCell.h"
#import "LLCircleOfFriendsByFrameModel.h"
#import "SDWeiXinPhotoContainerView.h"
#import "LLCicleOfFriendCommentLikeByFrameView.h"
//#import "LLStatusPictureByFrameView.h"
@interface LLCicleOfFriendsByFrameCell()
@property (nonatomic,strong) UIImageView * iconImageView;
@property (nonatomic,strong) UILabel * nameLable;
@property (nonatomic,strong) UILabel * contentLable;
@property (nonatomic,strong) UIButton * moreBtn;
//
@property(nonatomic ,strong)SDWeiXinPhotoContainerView * pictureView;

@property(nonatomic ,strong)LLCicleOfFriendCommentLikeByFrameView * likeCommentView;
@end
@implementation LLCicleOfFriendsByFrameCell

CGFloat maxContentLabelHeight;

-(void)setModel:(LLCircleOfFriendsByFrameModel *)model {
    _model = model;
    //此处调用防止cell先走 行高后走
    [model cellHeight];
    _iconImageView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    _contentLable.text = model.msgContent;
    _pictureView.picPathStringsArray = model.picNamesArray;
  
    
    _iconImageView.frame = model.iconViewFrame;
    _nameLable.frame = model.nameLableFrame;
    _contentLable.frame = model.contenLableFrame;
    _moreBtn.frame = model.showMoreBtnFrame;
    _pictureView.frame = model.pictureFrame;
    
    _likeCommentView.frame = model.likeCommentsFrame;
    
     _likeCommentView.model = model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI {
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    self.nameLable = [UILabel new];
    [self.contentView addSubview:self.nameLable];
    self.nameLable.textColor = LLNameTextColor;
    self.nameLable.font = [UIFont systemFontOfSize:15];
    
    self.contentLable = [UILabel new];
    [self addSubview:self.contentLable];
    self.contentLable.font = [UIFont systemFontOfSize:14];
    self.contentLable.numberOfLines = 0;
    self.contentLable.lineBreakMode = NSLineBreakByCharWrapping;
    if (maxContentLabelHeight==0) {
         maxContentLabelHeight = _contentLable.font.lineHeight*2;
    }
   

    self.moreBtn = [UIButton new];
    [self addSubview:self.moreBtn];
    [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
    self.moreBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.moreBtn setTitleColor:LLHighlightedColor forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:LLHighlightedColor forState:UIControlStateSelected];
    [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    self.pictureView = [SDWeiXinPhotoContainerView new];
    [self.contentView addSubview:self.pictureView];
    
    
    self.likeCommentView = [LLCicleOfFriendCommentLikeByFrameView new];
    [self.contentView addSubview:self.likeCommentView];
    
}

-(void)moreBtnClick {
    _model.folding = !_model.folding;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
