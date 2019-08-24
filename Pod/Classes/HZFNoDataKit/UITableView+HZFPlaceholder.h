//
//  UITableView+HZFPlaceholder.h
//  HZFNoDataKit
//
//  Created by huangzhifei on 2019/8/24.
//  Copyright © 2019 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HZFPlaceholder)

@property (nonatomic, assign) BOOL hzf_firstReload;
@property (nonatomic, strong) UIView *hzf_placeholderView;
@property (nonatomic, copy) void (^hzf_reloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
