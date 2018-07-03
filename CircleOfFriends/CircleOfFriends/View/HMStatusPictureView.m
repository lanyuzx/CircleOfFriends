//
//  HMStatusPictureView.m
//  Weibo11
//
//  Created by 刘凡 on 15/12/11.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "HMStatusPictureView.h"
#import "HMStatusPictureCell.h"

#pragma mark - 常量定义
/// 每列图片数量
#define kPicViewColCount 3
/// 图片间距
#define kPicViewItemMargin 5
/// 可重用标识符
NSString *const kStatusPictureCellId = @"StatusPictureCellId";

@interface HMStatusPictureView() <UICollectionViewDataSource>

@end

@implementation HMStatusPictureView

#pragma mark - 设置数据

-(void)setPicArray:(NSArray *)picArray {
    _picArray = picArray;
    
    // 更新尺寸约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcViewSize]);
    }];
    
    // 刷新数据
    [self reloadData];
}

/// 计算视图大小
///
/// @return 配图视图的大小
- (CGSize)calcViewSize {

    // 1. 配图数量
    NSInteger count = _picArray.count;
   
    // 如果没有图片，直接返回
    if (count == 0) {
        return CGSizeZero;
    }
    
    // 2. 基本数据计算
    // 单个 cell 的宽高
    CGFloat picWidth = SCREEN_WIDTH -70;
    // 设置布局 item 大小
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (count == 1) {
        CGFloat itemW = [self itemWidthForPicPathArray:_picArray];
        UIImage *image = [UIImage imageNamed:_picArray.firstObject];
        CGFloat itemH =  image.size.height / image.size.width * itemW;
         layout.itemSize = CGSizeMake(itemW, itemH);
        return CGSizeMake(itemW, itemH);
    }

   
     CGFloat itemWH = (picWidth- (kPicViewColCount - 1) * (LLCellMargin + LLCellMargin)) / kPicViewColCount;
     layout.itemSize = CGSizeMake(itemWH, itemWH);
    // 列数
    NSInteger col = count == 4 ? 2 : (count >= kPicViewColCount ? kPicViewColCount : count);
    // 行数
    NSInteger row = (count - 1) / kPicViewColCount + 1;
    
    // 3. 计算宽高
    CGFloat width = ceil(col * itemWH + (col - 1) * LLCellMargin);
    CGFloat height = ceil(row * itemWH + (row - 1) * LLCellMargin);
    
    return CGSizeMake(width, height);
}

#pragma mark - 构造函数
- (instancetype)init {
    // 设置 layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {        
        // 设置 layout
        layout.minimumInteritemSpacing = kPicViewItemMargin;
        layout.minimumLineSpacing = kPicViewItemMargin;
        
        // 注册 Cell
        [self registerClass:[HMStatusPictureCell class] forCellWithReuseIdentifier:kStatusPictureCellId];
        
        // 设置数据源
        self.dataSource = self;
        
        // *** 禁用滚动到顶部，在一个界面中，只允许最外侧的 scrollsToTop = YES
        // *** 如果内部的 scrollsToTop 如果也为 YES，用户点击状态栏，不会滚动到顶部
        self.scrollsToTop = NO;
    }
    return self;
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HMStatusPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStatusPictureCellId forIndexPath:indexPath];
    cell.imageURL = self.picArray[indexPath.row];
    
    return cell;
}

@end

