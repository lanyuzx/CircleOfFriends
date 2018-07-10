//
//  LLCicleOfFriendsByFrameCell.h
//  CircleOfFriends
//
//  Created by lanlan on 2018/7/6.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLCircleOfFriendsByFrameModel;
@interface LLCicleOfFriendsByFrameCell : UITableViewCell
@property(nonatomic ,strong)LLCircleOfFriendsByFrameModel * model;
@property(nonatomic ,weak)UITableView * tableView;
@property(nonatomic ,weak)NSIndexPath * indexPath;
@end
