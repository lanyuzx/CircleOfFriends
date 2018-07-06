//
//  LLCircleOfFriendsModel.m
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCircleOfFriendsByFrameModel.h"

@implementation LLCircleOfFriendsByFrameModel

static const CGFloat nameLableHeight = 20;

static const CGFloat LLCellWidthMargin = 5;

-(CGFloat)cellHeight {
    
    if (_cellHeight) {
        return _cellHeight;
    }
    _iconViewFrame = CGRectMake(LLCellMargin, LLCellMargin, 40, 40);
    
    CGFloat nameLableWidth = [self textHeightWithString:self.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} withSize:CGSizeMake(MAXFLOAT, nameLableHeight)].width;
    _nameLableFrame = CGRectMake(CGRectGetMaxX(_iconViewFrame)+LLCellMargin, LLCellMargin, nameLableWidth, nameLableHeight);
    
    CGFloat contentLableHeight = [self textHeightWithString:self.msgContent attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} withSize:CGSizeMake(SCREEN_WIDTH - 70, MAXFLOAT)].height;
    
    _contenLableFrame = CGRectMake(CGRectGetMinX(_nameLableFrame), CGRectGetMaxY(_nameLableFrame) +LLCellWidthMargin, SCREEN_WIDTH - 70, contentLableHeight);
    
    _showMoreBtnFrame = CGRectMake(CGRectGetMinX(_nameLableFrame), CGRectGetMaxY(_contenLableFrame), 35, 25);
    
    _cellHeight = CGRectGetMaxY(_showMoreBtnFrame) + 10;
    
    CGFloat jgg_Width = SCREEN_WIDTH-2*LLCellMargin-kAvatar_Size-70;
    CGFloat image_Width = (jgg_Width-2*LLCellMargin)/3;
    CGFloat jgg_height = 0;
    if (self.picNamesArray.count==0) {
        jgg_height = 0;
    }else if (self.picNamesArray.count<=3) {
        jgg_height = image_Width;
    }else if (self.picNamesArray.count>3&&self.picNamesArray.count<=6){
        jgg_height = 2*image_Width+LLCellMargin;
    }else  if (self.picNamesArray.count>6&&self.picNamesArray.count<=9){
        jgg_height = 3*image_Width+2*LLCellMargin;
    }
    
    _pictureFrame =  CGRectMake(CGRectGetMinX(_nameLableFrame), CGRectGetMaxY(_showMoreBtnFrame)+LLCellWidthMargin, jgg_Width, jgg_height);
    
    _cellHeight = CGRectGetMaxY(_pictureFrame)+LLCellWidthMargin;
    
    return _cellHeight;
    
    
}

-(CGSize)textHeightWithString:(NSString *)string attributes:(NSDictionary*)attributes withSize:(CGSize)textSize {
   // @{NSFontAttributeName:[UIFont systemFontOfSize:font]}
    CGSize strSize = [string boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return strSize;
}

@end


@implementation LLLikeItemByFrameModel

@end


@implementation LLCommentItemByFrameModel

@end

