//
//  LLOperationMenuView.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/3.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLOperationMenuView.h"

@interface LLOperationMenuView()
@property (nonatomic,strong) UIButton * likeButton;
@property (nonatomic,strong) UIButton * commentButton;

@property (nonatomic,weak) MASConstraint * menuWidthAttraint;
@end

@implementation LLOperationMenuView

-(void)setShow:(BOOL)show {
    _show = show;
    [self.menuWidthAttraint uninstall];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (show) {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                self.menuWidthAttraint = make.width.mas_equalTo(200);
            }];
            [self layoutIfNeeded];
        }else {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                self.menuWidthAttraint = make.width.mas_equalTo(0);
            }];
            [self layoutIfNeeded];
        }
    }];
   
    [UIView commitAnimations];
  
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
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = SDColor(69, 74, 76, 1);
       CGFloat margin = 5;
    self.likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"AlbumLike"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
     [self addSubview:self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(self);
    }];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    [self addSubview:centerLine];
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(1);
    }];
    
    self.commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLine.mas_right).offset(margin);
        make.width.height.mas_equalTo(self.likeButton);
        make.centerY.equalTo(self);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.menuWidthAttraint = make.width.mas_equalTo(0);
    }];
    
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

-(void)commentButtonClicked {
    self.show = false;
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
}

-(void)likeButtonClicked {
     self.show = false;
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
}



@end
