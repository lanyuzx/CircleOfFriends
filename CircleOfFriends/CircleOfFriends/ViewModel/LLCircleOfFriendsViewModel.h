//
//  LLCircleOfFriendsViewModel.h
//  Massary仿朋友圈
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LLCircleOfFriendsModel;
@interface LLCircleOfFriendsViewModel : NSObject
@property (nonatomic,strong) NSMutableArray <LLCircleOfFriendsModel*> * itemModels;
@end
