//
//  LLCicleOfFriendsOriginalView.h
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//
@class LLCircleOfFriendsModel;
@protocol LLCicleOfFriendsOriginalViewDelegate<NSObject>
-(void)cicleOfFriendsOriginalViewShouldShowMoreDelegate;

-(void)cicleOfFriendsOriginalViewLikeButtonClickDelegate;

-(void)cicleOfFriendsOriginalViewCommentButtonClickDelegate;
@end
#import <UIKit/UIKit.h>

@interface LLCicleOfFriendsOriginalView : UIView
@property (nonatomic,strong) LLCircleOfFriendsModel * model;
@property (nonatomic,weak) id <LLCicleOfFriendsOriginalViewDelegate>  delegate;
@end
