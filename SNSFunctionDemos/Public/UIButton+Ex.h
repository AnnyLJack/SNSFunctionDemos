//
//  UIButton+Ex.h
//  SNS
//
//  Created by 黄 敬 on 14-10-11.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

typedef void (^ActionBlock)();

@interface UIButton (Ex)

- (void)titleLeft:(float)left;
- (void)titleRight:(float)right;
- (void)loadTitleColor:(UIColor *)color;
- (void)addSingleActionWithBlock:(ActionBlock)block;
@end
