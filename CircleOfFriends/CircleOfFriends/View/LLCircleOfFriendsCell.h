//
//  LLCircleOfFriendsCell.h
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLCircleOfFriendsModel;
@interface LLCircleOfFriendsCell : UITableViewCell
@property (nonatomic,strong) LLCircleOfFriendsModel * model;
@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,weak) NSIndexPath * indexPath;

@property (nonatomic, copy) void (^commentButtonClickedOperation)(LLCircleOfFriendsCell * cell);
@end
