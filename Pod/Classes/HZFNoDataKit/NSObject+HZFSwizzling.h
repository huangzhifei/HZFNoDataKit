//
//  NSObject+HZFSwizzling.h
//  HZFNoDataKit
//
//  Created by huangzhifei on 2019/8/24.
//  Copyright © 2019 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HZFSwizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
