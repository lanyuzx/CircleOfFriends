//
//  LLCicleOfFriendsByFrameVC.m
//  CircleOfFriends
//
//  Created by lanlan on 2018/7/6.
//  Copyright © 2018年 周尊贤. All rights reserved.
//

#import "LLCicleOfFriendsByFrameVC.h"
#import "LLCircleOfFriendsByFrameViewModel.h"
#import "LLCircleOfFriendsByFrameModel.h"
#import "LLCicleOfFriendsByFrameCell.h"
@interface LLCicleOfFriendsByFrameVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)UITableView * tableView;
@property(nonatomic ,strong) LLCircleOfFriendsByFrameViewModel* viewModel;
@end

@implementation LLCicleOfFriendsByFrameVC

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
    
    return self.viewModel.itemModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLCicleOfFriendsByFrameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLCicleOfFriendsByFrameCell"];
    cell.model = _viewModel.itemModels[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.itemModels[indexPath.row].cellHeight ;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[LLCicleOfFriendsByFrameCell class] forCellReuseIdentifier:@"LLCicleOfFriendsByFrameCell"];
    }
    return _tableView;
}
-(LLCircleOfFriendsByFrameViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LLCircleOfFriendsByFrameViewModel new];
    }
    return _viewModel;
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
