//
//  HZFCustomPlaceholderView.h
//  HZFNoDataKit
//
//  Created by huangzhifei on 2019/8/24.
//  Copyright © 2019 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZFCustomPlaceholderView : UIView

@property (nonatomic, copy) void (^reloadClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
