//
//  UIView+Ex.h
//  SNS
//
//  Created by 黄 敬 on 14-10-9.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "UIButton+Ex.h"
@interface UIView (Ex)
/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 *  Shortcut for right to superview
 *  Sets frame.origin.x = superview.width - rightToSuper -frame.size.width
 */
@property (nonatomic) CGFloat rightToSuper;

/**
 *  shortcut for bottom to superview
 *  set frame.origin.y = superview.height - bottomToSuper - frame.size.height
 */
@property (nonatomic) CGFloat bottomToSuper;

- (void)removeAllSubviews;
- (void)setCornerRadius:(float)num;

- (void)setLableTitleColor:(NSInteger)hexValue andFont:(float)font;
- (void)setLableTitleColor:(NSInteger)hexValue andFont:(float)font andText:(NSString *)text;

//获取单行文字高度
- (float)getLabelHegiht;
- (CGSize)getSizeWithFontSize:(float)font andString:(NSString *)str;
- (UIView *)addNightCoverWithAlpha:(CGFloat)alpha;
- (UIView *)addNightCover;
- (UIButton *)addCellClickNightCover;
- (void)removeNightCover;
- (void)setStatus:(int)type;
- (float)minDistanceCanReleaseToReload;
- (void)setDelegate:(id)delegate;
@end
