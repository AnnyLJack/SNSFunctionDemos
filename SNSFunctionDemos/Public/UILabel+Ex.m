//
//  UILabel+Ex.m
//  SNS
//
//  Created by 黄 敬 on 14-11-5.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import "UILabel+Ex.h"
#import <CoreText/CoreText.h>
@implementation UILabel (Ex)
//- (NSArray *)getLinesArray
//{
//    NSString *text = [self text];
//    UIFont   *font = [self font];
//    CGRect    rect = [self frame];
//    
//    
//    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,
//                                            font.pointSize,
//                                            NULL);
//    
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
//    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
//    
//    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
//    
//    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
//    
//    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
//    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
//    
//    for (id line in lines)
//    {
//        CTLineRef lineRef = (__bridge CTLineRef )line;
//        CFRange lineRange = CTLineGetStringRange(lineRef);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//        
//        NSString *lineString = [text substringWithRange:range];
//        [linesArray addObject:lineString];
//    }
//    
//    return (NSArray *)linesArray;
//}
@end
