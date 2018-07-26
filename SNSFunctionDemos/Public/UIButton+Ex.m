//
//  UIButton+Ex.m
//  SNS
//
//  Created by 黄 敬 on 14-10-11.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import "UIButton+Ex.h"
#import "constants.h"
#import <objc/runtime.h>

static void *key = "key";

@implementation UIButton (Ex)
- (void)titleLeft:(float)left
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0,left, 0, 0);
}
- (void)titleRight:(float)right
{
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, right);
}

- (void)loadTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:[color colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
}

- (void)addSingleActionWithBlock:(ActionBlock)block
{
    [self addTarget:self action:@selector(touch:event:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, key, block, OBJC_ASSOCIATION_COPY);
}

- (void)touch:(id)sender event:(UIEvent *)event
{
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.tapCount == 1) {
        ActionBlock block = objc_getAssociatedObject(self, key);
        block();
    }
}

@end
