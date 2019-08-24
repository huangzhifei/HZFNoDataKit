//
//  HZFCustomPlaceholderView.m
//  HZFNoDataKit
//
//  Created by huangzhifei on 2019/8/24.
//  Copyright © 2019 eric. All rights reserved.
//

#import "HZFCustomPlaceholderView.h"

@interface HZFCustomPlaceholderView ()

@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation HZFCustomPlaceholderView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configSubviews];
}

- (void)configSubviews {
    self.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    [self addSubview:self.reloadButton];
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.center;
        _reloadButton.layer.cornerRadius = 75.0;
        [_reloadButton setTitle:@"暂无数据，点击重新加载!" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 50;
        _reloadButton.frame = rect;
    }
    return _reloadButton;
}

- (void)reloadClick:(UIButton *)button {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}

@end
