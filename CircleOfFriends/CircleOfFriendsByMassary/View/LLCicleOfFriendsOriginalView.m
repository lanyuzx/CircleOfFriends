//
//  LLCicleOfFriendsOriginalView.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendsOriginalView.h"
#import "LLCircleOfFriendsModel.h"
#import "HMStatusPictureView.h"
#import "LLOperationMenuView.h"
@interface LLCicleOfFriendsOriginalView()
@property (nonatomic,strong) UIImageView * iconImageView;
@property (nonatomic,strong) UILabel * nameLable;
@property (nonatomic,strong) UILabel * contentLable;
@property (nonatomic,strong) UIButton * moreBtn;
@property (nonatomic,strong) HMStatusPictureView * pictureView;
@property (nonatomic,strong) UILabel * timeLable;

@property (nonatomic,strong) UIButton * operationButton;

@property (nonatomic,strong) LLOperationMenuView * operationView;

@property (nonatomic,weak) MASConstraint * timeConstraint;

@end

@implementation LLCicleOfFriendsOriginalView

-(void)setModel:(LLCircleOfFriendsModel *)model {
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.iconName];
    self.nameLable.text = model.name;
    self.contentLable.text = model.msgContent;
    self.moreBtn.selected = model.shouldShowMoreButton;
    if (model.shouldShowMoreButton) {
        self.contentLable.numberOfLines = 0;
    }else {
        self.contentLable.numberOfLines = 2;
    }
    self.pictureView.hidden = !(model.picNamesArray.count);
    self.operationView.show = model.isOpening;
    self.pictureView.picArray = model.picNamesArray;
    [self.timeConstraint uninstall];
    if (model.picNamesArray.count) {
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
      self.timeConstraint =  make.top.equalTo(self.pictureView.mas_bottom).offset(5);
        }];
    }else {
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
          self.timeConstraint =    make.top.equalTo(self.moreBtn.mas_bottom);
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LLCellMargin);
        make.top.equalTo(self).offset(LLCellMargin);
        make.width.height.mas_equalTo(40);
    }];
    
    self.nameLable = [UILabel new];
    [self addSubview:self.nameLable];
    self.nameLable.textColor = LLNameTextColor;
    self.nameLable.font = [UIFont systemFontOfSize:15];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.iconImageView.mas_right).offset(LLCellMargin);
        make.top.equalTo(self.iconImageView);
    }];
    
    self.contentLable = [UILabel new];
    [self addSubview:self.contentLable];
    self.contentLable.numberOfLines = 2;
    self.contentLable.preferredMaxLayoutWidth = SCREEN_WIDTH - LLCellMargin *2;
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable);
        make.right.equalTo(self).offset(-LLCellMargin);
        make.top.equalTo(self.nameLable.mas_bottom).offset(LLCellMargin);
    }];
    
    self.moreBtn = [UIButton new];
    [self addSubview:self.moreBtn];
    [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.moreBtn setTitleColor:LLHighlightedColor forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:LLHighlightedColor forState:UIControlStateSelected];
    [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLable);
        make.top.equalTo(self.contentLable.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    
    self.pictureView = [HMStatusPictureView new];
    [self addSubview:self.pictureView];
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreBtn);
       // make.size.mas_equalTo(CGSizeMake(90, 90));
        make.top.equalTo(self.moreBtn.mas_bottom);
    }];

    self.timeLable = [UILabel new];
    [self addSubview:self.timeLable];
    self.timeLable.text = @"一分钟前";
    self.timeLable.font = [UIFont systemFontOfSize:12];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreBtn);
       self.timeConstraint = make.top.equalTo(self.pictureView.mas_bottom).offset(5);
    }];

    self.operationButton = [UIButton new];
    [self addSubview:self.operationButton];
    [self.operationButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [self .operationButton addTarget:self action:@selector(operationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LLCellMargin);
        make.centerY.equalTo(self.timeLable);
    }];

    self.operationView = [LLOperationMenuView new];
    [self setupOpreationViewButtonClick];
    [self addSubview:self.operationView];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.operationButton.mas_left).offset(-5);
        make.centerY.equalTo(self.operationButton);
        make.height.mas_equalTo(36);
    }];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLable.mas_bottom);
    }];

}

-(void)setupOpreationViewButtonClick {
    __weak typeof(self) weak = self;
    self.operationView.commentButtonClickedOperation = ^{
        if ([weak.delegate respondsToSelector:@selector(cicleOfFriendsOriginalViewCommentButtonClickDelegate)]) {
            [weak.delegate cicleOfFriendsOriginalViewCommentButtonClickDelegate];
        }
        
    };
    
    self.operationView.likeButtonClickedOperation = ^{
        NSMutableArray * tempLikes = [NSMutableArray arrayWithArray:weak.model.likeItemsArray];
        NSArray *namesArray = @[@"GSD_iOS",
                                @"风口上的猪",
                                @"当今世界网名都不好起了",
                                @"我叫郭德纲",
                                @"Hello Kitty"];
        LLLikeItemModel * likeModel = [LLLikeItemModel new];
        int index = arc4random_uniform((int)namesArray.count);
        likeModel.userName = namesArray[index];
        likeModel.userId = namesArray[index];
        [tempLikes addObject:likeModel];
        weak.model.likeItemsArray = [tempLikes mutableCopy];
        
        if ([weak.delegate respondsToSelector:@selector(cicleOfFriendsOriginalViewLikeButtonClickDelegate)]) {
            [weak.delegate cicleOfFriendsOriginalViewLikeButtonClickDelegate];
        }
    };
}

-(void)moreBtnClick {
    self.model.shouldShowMoreButton = !self.model.shouldShowMoreButton;
    if ([self.delegate respondsToSelector:@selector(cicleOfFriendsOriginalViewShouldShowMoreDelegate)]) {
        [self.delegate cicleOfFriendsOriginalViewShouldShowMoreDelegate];
    }

}

-(void)operationButtonClick {
    self.operationView.show = !self.operationView.show;
    
    self.model.isOpening = self.operationView.show;
}

@end
