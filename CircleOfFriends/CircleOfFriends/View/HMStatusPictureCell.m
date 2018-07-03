//
//  HMStatusPictureCell.m
//  Weibo11
//
//  Created by 刘凡 on 15/12/11.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "HMStatusPictureCell.h"


@implementation HMStatusPictureCell {
    UIImageView *_imageView;
   // UIImageView *_gifIconView;
}

#pragma mark - 设置数据
- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    //[_imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"icon4.jpg"]];
    _imageView.image = [UIImage imageNamed:imageURL];
    
    // 根据图片的扩展名确定是否显示 GIF 图标
    //_gifIconView.hidden = ![imageURL.absoluteString.pathExtension.lowercaseString isEqualToString:@"gif"];
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)setupUI {
    
    // 0. 创建控件
    _imageView = [[UIImageView alloc] init];
    //_gifIconView = [UIImageView  new];
    
    // 设置图片拉伸模式
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    // 1. 添加控件
    [self.contentView addSubview:_imageView];
    //[self.contentView addSubview:_gifIconView];
    
    // 2. 自动布局
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
//    [_gifIconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView);
//    }];
}

@end
