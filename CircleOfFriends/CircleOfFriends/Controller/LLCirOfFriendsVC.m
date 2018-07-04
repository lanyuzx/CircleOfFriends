//
//  LLCirOfFriendsVC.m
//  Massary仿朋友圈
//
//  Created by 周尊贤 on 2018/7/2.
//  Copyright © 2018年 周尊贤. All rights reserved.
//
#define textFieldH 40

#import "LLCirOfFriendsVC.h"
#import "LLCircleOfFriendsViewModel.h"
#import "LLCircleOfFriendsCell.h"
#import "LLCircleOfFriendsModel.h"
@interface LLCirOfFriendsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) LLCircleOfFriendsViewModel * viewModel;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,weak) NSIndexPath * currentEditingIndexthPath;
@property (nonatomic,assign) CGFloat totalKeybordHeight;
@end

@implementation LLCirOfFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"懒懒朋友圈";
      [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.viewModel.itemModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLCircleOfFriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLCircleOfFriendsCell" forIndexPath:indexPath];
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    cell.model = self.viewModel.itemModels[indexPath.row];
    __weak typeof(self) weak = self;
    cell.commentButtonClickedOperation = ^(LLCircleOfFriendsCell *cell) {
        [weak commentButtonClickedOperation:cell];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   

  LLCircleOfFriendsModel * model = self.viewModel.itemModels[indexPath.row];
//
//    return [tableView fd_heightForCellWithIdentifier:@"LLCircleOfFriendsCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        LLCircleOfFriendsCell * tempCell = (LLCircleOfFriendsCell*)cell;
//            tempCell.model = model;
//    }];

//    return [LLCircleOfFriendsCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
//        LLCircleOfFriendsCell * cell = (LLCircleOfFriendsCell*)sourceCell;
//        cell.model = model;
//    }];
    NSString *stateKey = nil;
    if (model.shouldShowMoreButton ) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }

    BOOL recalculate = false;

    if (model.commentItemsArray.count ||model.likeItemsArray.count) {
        recalculate = true;
    }else {
        recalculate = false;
    }

    CGFloat height = [LLCircleOfFriendsCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        LLCircleOfFriendsCell * cell = (LLCircleOfFriendsCell*)sourceCell;
        cell.model = model;
    } cache:^NSDictionary *{
        return @{kHYBCacheUniqueKey: [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section,(long)indexPath.row],
                 kHYBCacheStateKey : stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 kHYBRecalculateForStateKey : @(recalculate) // 标识不用重新更新
                 };
    }];
    return height;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        LLCircleOfFriendsModel *model = self.viewModel.itemModels[_currentEditingIndexthPath.row];
        model.isOpening = false;
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        
        LLCommentItemModel *commentItemModel = [LLCommentItemModel new];
        commentItemModel.firstUserName = @"GSD_iOS";
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = @"GSD_iOS";
        [temp addObject:commentItemModel];
        
        model.commentItemsArray = [temp copy];
        
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        
        return YES;
    }
    return NO;
}

-(void)commentButtonClickedOperation:(LLCircleOfFriendsCell *) cell {
    [self.textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 400;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[LLCircleOfFriendsCell class] forCellReuseIdentifier:@"LLCircleOfFriendsCell"];
    }
    return _tableView;
}

-(LLCircleOfFriendsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LLCircleOfFriendsViewModel new];
    }
    return _viewModel;
}

-(UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
        _textField.layer.borderWidth = 1;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor blackColor];
        _textField.returnKeyType = UIReturnKeySend;
        //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
        _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREEN_WIDTH, 40);
        [[UIApplication sharedApplication].keyWindow addSubview:_textField];
        
        [_textField becomeFirstResponder];
        [_textField resignFirstResponder];
    }
    return _textField;
}

@end
