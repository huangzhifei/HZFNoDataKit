//
//  UITableView+HZFPlaceholder.m
//  HZFNoDataKit
//
//  Created by huangzhifei on 2019/8/24.
//  Copyright © 2019 eric. All rights reserved.
//

#import "UITableView+HZFPlaceholder.h"
#import "NSObject+HZFSwizzling.h"
#import "HZFCustomPlaceholderView.h"
#import <objc/runtime.h>

@implementation UITableView (HZFPlaceholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData)
                               bySwizzledSelector:@selector(sure_reloadData)];
    });
}

- (void)sure_reloadData {
    if (!self.hzf_firstReload) {
        [self checkEmpty];
    }
    self.hzf_firstReload = NO;
    [self sure_reloadData];
}

- (void)checkEmpty {
    BOOL isEmpty = YES; //flag标示

    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1; //默认一组
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self] - 1; //获取当前TableView组数
    }

    for (NSInteger i = 0; i <= sections; i++) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i]; //获取当前TableView各组行数
        if (rows) {
            isEmpty = NO; //若行数存在，不为空
        }
    }
    if (isEmpty) { //若为空，加载占位图
        //默认占位图
        if (!self.hzf_placeholderView) {
            [self makeDefaultPlaceholderView];
        }
        self.hzf_placeholderView.hidden = NO;
        [self addSubview:self.hzf_placeholderView];
    } else { //不为空，移除占位图
        self.hzf_placeholderView.hidden = YES;
    }
}

- (void)makeDefaultPlaceholderView {
    self.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    HZFCustomPlaceholderView *placeholderView = [[HZFCustomPlaceholderView alloc] initWithFrame:self.bounds];
    __weak typeof(self) weakSelf = self;
    [placeholderView setReloadClickBlock:^{
        if (weakSelf.hzf_reloadBlock) {
            weakSelf.hzf_reloadBlock();
        }
    }];
    self.hzf_placeholderView = placeholderView;
}

- (UIView *)hzf_placeholderView {
    return objc_getAssociatedObject(self, @selector(hzf_placeholderView));
}

- (void)setHzf_placeholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(hzf_placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hzf_firstReload {
    return [objc_getAssociatedObject(self, @selector(hzf_firstReload)) boolValue];
}

- (void)setHzf_firstReload:(BOOL)firstReload {
    objc_setAssociatedObject(self, @selector(hzf_firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(void))hzf_reloadBlock {
    return objc_getAssociatedObject(self, @selector(hzf_reloadBlock));
}

- (void)setHzf_reloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(hzf_reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
