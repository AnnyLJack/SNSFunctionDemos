//
//  UIView+Ex.m
//  SNS
//
//  Created by 黄 敬 on 14-10-9.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import "UIView+Ex.h"
#import "constants.h"
@implementation UIView (Ex)

- (CGFloat)left {
    
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)rightToSuper {
    
    return self.superview.bounds.size.width - self.frame.size.width - self.frame.origin.x;
}

- (void)setRightToSuper:(CGFloat)rightToSuper {
    
    CGRect frame = self.frame;
    
    frame.origin.x =  self.superview.bounds.size.width - self.frame.size.width  - rightToSuper;
    self.frame = frame;
}

- (CGFloat)bottomToSuper {
    
    return self.superview.bounds.size.height - self.frame.size.height - self.frame.origin.y;
}

- (void)setBottomToSuper:(CGFloat)bottomToSuper {
    
    CGRect frame = self.frame;
    
    frame.origin.y =  self.superview.bounds.size.height - self.frame.size.height  - bottomToSuper;
    self.frame = frame;
}

- (void)removeAllSubviews {
    
    while (self.subviews.count)
    {
        UIView* child = self.subviews.lastObject;
        
        if ([child isKindOfClass:[UIImageView class]])
        {
            ((UIImageView*)child).image = nil;
        }
        
        [child removeFromSuperview];child = nil;
    }
}

- (void)setCornerRadius:(float)num
{
    self.layer.cornerRadius = num;
    self.clipsToBounds = YES;
}


- (void)setLableTitleColor:(NSInteger)hexValue andFont:(float)font
{
    UILabel *nameLabel = (UILabel *)self;
    nameLabel.textColor = [UIColor colorWithHex:hexValue];
    nameLabel.font = [UIFont systemFontOfSize:font * fontTrans];
    nameLabel.backgroundColor = [UIColor clearColor];
}

- (void)setLableTitleColor:(NSInteger)hexValue andFont:(float)font andText:(NSString *)text
{
    UILabel *nameLabel = (UILabel *)self;
    nameLabel.text = text;
    [self setLableTitleColor:hexValue andFont:font];
}
//获取单行文字高度
- (float)getLabelHegiht
{
    UILabel *tempLabel = (UILabel *)self;
    CGSize tempSize = [@"高度" sizeWithFont:tempLabel.font
                        constrainedToSize:CGSizeMake(100, 2000)
                            lineBreakMode:NSLineBreakByWordWrapping];
    return tempSize.height;
}

- (CGSize)getSizeWithFontSize:(float)font andString:(NSString *)str
{
    return [str sizeWithFont:[UIFont systemFontOfSize:font]
           constrainedToSize:CGSizeMake(2000, 2000)
               lineBreakMode:NSLineBreakByWordWrapping];
}
- (UIView *)addNightCover
{
    return [self addNightCoverWithAlpha:.5];
}

- (UIView *)addNightCoverWithAlpha:(CGFloat)alpha
{
    if (![self viewWithTag:888]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.userInteractionEnabled = NO;
        view.tag = 888;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = alpha;
        [view.layer setMasksToBounds:YES];
        view.layer.cornerRadius = self.layer.cornerRadius;
        [self addSubview:view];
    }
    return [self viewWithTag:888];
}

- (UIButton *)addCellClickNightCover
{
    if (![self viewWithTag:888]) {
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.userInteractionEnabled = NO;
        [view setBackgroundImage:[[UIColor blackColor] createImageWithRect:CGRectMake(0, 0, 10, 10)] forState:UIControlStateNormal];
        view.tag = 888;
        view.alpha = 0.5;
        [view.layer setMasksToBounds:YES];
        view.layer.cornerRadius = self.layer.cornerRadius;
        [self addSubview:view];
    }
    return [self viewWithTag:888];
}

- (void)removeNightCover
{
    [[self viewWithTag:888] removeFromSuperview];
}

- (void)setDelegate:(id)delegate {
    
}

- (float)minDistanceCanReleaseToReload {
    return 0.0f;
}
- (void)setStatus:(int)type {
    
}
@end
