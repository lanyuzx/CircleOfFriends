//
//  LLCircleOfFriendsListVC.m
//  CircleOfFriends
//
//  Created by lanlan on 2018/7/6.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCircleOfFriendsListVC.h"
#import "LLCirOfFriendsVC.h"
#import "LLCicleOfFriendsByFrameVC.h"
@interface LLCircleOfFriendsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)UITableView * tableView;
@end

@implementation LLCircleOfFriendsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = indexPath.row == 0 ? @"纯代码Massary布局实现朋友圈(有点卡)":@"纯代码Frame布局实现朋友圈";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        [self.navigationController pushViewController:[LLCirOfFriendsVC new] animated:true];
        return;
    }
     [self.navigationController pushViewController:[LLCicleOfFriendsByFrameVC new] animated:true];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
