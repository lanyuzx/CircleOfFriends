//
//  LLCircleOfFriendsModel.h
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//


#import <Foundation/Foundation.h>
@class LLLikeItemByFrameModel;
@class LLCommentItemByFrameModel;
@interface LLCircleOfFriendsByFrameModel : NSObject
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<LLLikeItemByFrameModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<LLCommentItemByFrameModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign) BOOL shouldShowMoreButton;

@property (nonatomic, assign) BOOL folding;

@property (nonatomic,assign) BOOL recalculateHeight;

@property(nonatomic ,assign)CGRect iconViewFrame;
@property(nonatomic ,assign)CGRect nameLableFrame;
@property(nonatomic ,assign)CGRect contenLableFrame;
@property(nonatomic ,assign)CGRect showMoreBtnFrame;
@property(nonatomic ,assign)CGRect pictureFrame;

@property(nonatomic ,assign)CGRect likeCommentsFrame;

@property(nonatomic ,assign)CGFloat cellHeight;
@end


@interface LLLikeItemByFrameModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface LLCommentItemByFrameModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@property (nonatomic,assign) CGFloat  attributedContentHeight;

@end
