//
//  LLOperationMenuView.h
//  CircleOfFriends
//
//  Created by 周尊贤 on 2018/7/3.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLOperationMenuView : UIView
@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)(void);
@property (nonatomic, copy) void (^commentButtonClickedOperation)(void);

@end
