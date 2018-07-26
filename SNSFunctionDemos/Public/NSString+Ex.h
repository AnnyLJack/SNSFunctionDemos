//
//  NSString+Ex.h
//  SNS
//
//  Created by 黄 敬 on 14-10-13.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Ex)
- (id)safeStringValueForKey:(id)aKey;
- (BOOL)isCommentRepeat;  //判断是否评论转发
- (float)getSizeLengthWihtFont:(float)x;
- (BOOL)isPhoneNumber;
- (NSString*)md5String;
- (NSString *)pinYin;
- (NSString *)getCityCode;
- (NSString *)getCityName;
- (NSString *)timeChange;
- (NSArray *)getRangeArrayWihtSubString:(NSString *)subStr;
- (NSString *)faceRegexString;
- (NSArray *)getRangeOfFace;
- (NSString *)numberChange;
- (NSArray *)getLinesArrayWith:(UIFont *)font andRect:(CGRect)rect;
- (NSArray *)getWithNotfaceRangeArrayWithLocation:(int)location AtArray:(NSArray *)array;
- (NSArray *)getRangeArrayWithLocation:(int)location AtArray:(NSArray *)array;
- (NSArray *)getRangeArrayWithLocation:(int)location AtArray:(NSArray *)array isReply:(BOOL)isReply;
- (NSDate *)changeTodate;

- (NSString *)URLEncode;

- (NSString *)URLDecoded;
+ (NSInteger)getlineCountWihtAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width;
+ (float)getLastlinewidthAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width;
@end
