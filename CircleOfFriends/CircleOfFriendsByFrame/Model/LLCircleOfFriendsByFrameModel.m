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

    if (!self.picNamesArray.count ) {
        _pictureFrame =  CGRectMake(CGRectGetMinX(_nameLableFrame), CGRectGetMaxY(_showMoreBtnFrame), 0, 0);
    }else {
        CGFloat itemW = [self itemWidthForPicPathArray:_picNamesArray];
        CGFloat itemH = 0;
        if (_picNamesArray.count == 1) {
            UIImage *image = [UIImage imageNamed:self.picNamesArray.firstObject];
            if (image.size.width) {
                itemH = image.size.height / image.size.width * itemW;
            }
        } else {
            itemH = itemW;
        }
        long perRowItemCount = [self perRowItemCountForPicPathArray:_picNamesArray];
        CGFloat margin = 5;
        CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
        int columnCount = ceilf(_picNamesArray.count * 1.0 / perRowItemCount);
        CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
        _pictureFrame =  CGRectMake(CGRectGetMinX(_nameLableFrame), CGRectGetMaxY(_showMoreBtnFrame)+margin, w, h);
    }
    CGFloat likeCommentsMagin = LLCellWidthMargin;
    if (!_likeItemsArray.count && !_commentItemsArray.count) {
        likeCommentsMagin = 0;
    }
     _likeCommentsFrame = CGRectMake(CGRectGetMinX(_nameLableFrame), CGRectGetMaxY(_pictureFrame)+likeCommentsMagin,SCREEN_WIDTH - 70, [self getLikeAttributedStringHeight]+[self getCommentAttributedStringHeight]);

    _cellHeight = CGRectGetMaxY(_likeCommentsFrame) + LLCellMargin;
    
    return _cellHeight ;
    
    
}

-(CGFloat)getLikeAttributedStringHeight {
      NSMutableAttributedString * likeAttributedString = [self getLikeAttributedString];
    if (!likeAttributedString) {
        return 0;
    }
     CGSize likeFrame = [self textHeightWithString:[likeAttributedString string] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} withSize:CGSizeMake(SCREEN_WIDTH - 80 , MAXFLOAT)];
    
    return likeFrame.height+LLCellMargin;
}

-(CGFloat)getCommentAttributedStringHeight {
    __block CGFloat totalHeight = 0.0;
    [_commentItemsArray enumerateObjectsUsingBlock:^(LLCommentItemByFrameModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.attributedContent) {
            obj.attributedContent = [self generateAttributedStringWithCommentItemModel:obj];
        }
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                              };
        CGFloat attributedContentHeight = [[obj.attributedContent string] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height +LLCellMargin;
            obj.attributedContentHeight = attributedContentHeight;
      
        totalHeight += obj.attributedContentHeight;
    }];
    
    return totalHeight + LLCellMargin;
}

-(NSMutableAttributedString *)getLikeAttributedString {
    if (!_likeItemsArray.count) {
        return nil;
    }
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < _likeItemsArray.count; i++) {
        LLLikeItemByFrameModel *model = _likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        [attributedText appendAttributedString:model.attributedContent];
    }
    return attributedText;
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

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(LLLikeItemByFrameModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
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

