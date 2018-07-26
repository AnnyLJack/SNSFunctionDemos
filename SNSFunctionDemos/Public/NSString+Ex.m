//
//  NSString+Ex.m
//  SNS
//
//  Created by 黄 敬 on 14-10-13.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import "NSString+Ex.h"
#import <UIKit/UIKit.h>
#import "constants.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (Ex)

- (id)safeStringValueForKey:(id)aKey {
    return nil;
}
- (NSString*)md5String
{
    if (self == nil) {
        return nil;
    }
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//去掉常规语气助词、表情、符号，剩余字数小于5，为纯转发
- (BOOL)isCommentRepeat
{
    /*
     NSArray *arr = @[[NSCharacterSet characterSetWithCharactersInString:@"[]{}#%^*+=•¥£€><~|\_-?.,!'/:;()$&@\" "],[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
     NSString *str = self;
     for (NSCharacterSet *set in arr) {
     str = [[str componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
     }
     return str.length > 5? YES : NO;*/
    
    
    //字符集不够，需要扩展注意全角和半角都要考虑
    NSArray *setArr = @[[NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""],[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *string = [self copy];
    
    for (NSCharacterSet *set in setArr) {
        string = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    }
    NSInteger emojiNumber = [self stringContainsEmojiNumber:string];
    //需要增加对语气助词的剔除
    int remainNum = (int)(string.length - 2 * emojiNumber);
    return remainNum > 5? YES : NO;
}

-(NSInteger)stringContainsEmojiNumber:(NSString *)string {
    __block NSInteger emojiNumber = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     emojiNumber++;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 emojiNumber++;
             }
             
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 emojiNumber++;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 emojiNumber++;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 emojiNumber++;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 emojiNumber++;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 emojiNumber++;
             }
         }
     }];
    return emojiNumber;
}


- (float)getSizeLengthWihtFont:(float)x
{
    return [self sizeWithFont:[UIFont systemFontOfSize:x * fontTrans] constrainedToSize:CGSizeMake(2000, 2000) lineBreakMode:NSLineBreakByCharWrapping].width;
}
- (BOOL)isPhoneNumber {
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //移动
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$";
    //联通
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //电信
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    //小灵通
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];//此处的self是需要验证的电话号码字符串
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//汉字转拼音
- (NSString *)pinYin
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (CFMutableStringRef)[NSMutableString stringWithString:self]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    return [(__bridge  NSMutableString *)string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];
}
- (NSString *)getCityCode
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:SNSFileName(@"cityNumberList.plist")];
    return dic[self];
}
- (NSString *)getCityName
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:SNSFileName(@"cityNumberList2.plist")];
    return dic[self]?dic[self]:self;
}

- (NSString *)timeChange
{
    //"2014-10-09 11:24:37.000"
    //    1.小于1分钟:刚刚; 2.大于1分钟,小于1小时:x分钟前 3.大于1小时,小于1天:xx小时前 4.大于1天:xxxx/xx/xx更新,如2014/12/12
    NSString *str = [self componentsSeparatedByString:@"."][0];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [inputFormatter setLocale:[NSLocale currentLocale]];
    
    NSDate* compareDate = [inputFormatter dateFromString:str];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if ((temp = timeInterval/60) <60) {
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if ((temp = temp/60) <24) {
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else {
        [inputFormatter setDateFormat:@"yyyy/MM/dd"];
        result =[inputFormatter stringFromDate:compareDate];
    }
    return  result;
}

- (NSArray *)getRangeArrayWihtSubString:(NSString *)subStr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSString *temp = [NSString stringWithFormat:@"%@",self];
    
    int length = 0;
    
    NSRange subRange = [temp rangeOfString:subStr];
    
    while (subRange.location != NSNotFound) {
        
        [arr addObject:NSStringFromRange(NSMakeRange(subRange.location + length,subRange.length))];
        
        length += subRange.location + subRange.length;
        
        temp = [temp substringFromIndex:subRange.location + subRange.length];
        
        subRange = [temp rangeOfString:subStr];
        
    }
    
    return arr;
    
}
static NSString *sharedInstance;
+ (NSString *)sharedInstanceFaceNameArray
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSArray *array = [NSArray arrayWithContentsOfFile:MainBundle(@"newsEmoticons.plist")];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSString *str = obj[@"chi"];
            str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
            str = [NSString stringWithFormat:@"\\%@\\]",str];
            [arr addObject:str];
        }];
        sharedInstance = [[NSString alloc] initWithString:[arr componentsJoinedByString:@"|"]];
    });
    return sharedInstance;
}

- (NSString *)faceRegexString
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:[NSString sharedInstanceFaceNameArray] options:0 error:nil];
    //    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:0 error:nil];
    return [regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@"1"];
}

- (NSArray *)getRangeOfFace
{
    return [[NSRegularExpression regularExpressionWithPattern:[NSString sharedInstanceFaceNameArray] options:0 error:nil] matchesInString:self
                                                                                                                                  options:NSMatchingWithTransparentBounds
                                                                                                                                    range:NSMakeRange(0, self.length)];
    
}

/*
 人数显示规则
 转发为0时,不显示数字,仅显示标示 1万以内,正常显示,例如:2345 大于1万,小于10万显示一位小数点,例如:5.2万 大于10万,小于亿时,只显示xx万,例如234万 过亿时,显示一位小数点,例如:1.1亿
 */
- (NSString *)numberChange
{
    double number = [self doubleValue];
    NSString *tempstr;
    if (number > 9999) {
        tempstr = [NSString stringWithFormat:@"%.1f万",number/10000];
        
        if (number > 100000) {
            tempstr = [NSString stringWithFormat:@"%.1f万",number/10000];
            if (number > 100000000) {
                tempstr = [NSString stringWithFormat:@"%.1f亿",number/100000000];
            }
        }
        
    } else {
        tempstr = [NSString stringWithFormat:@"%.0f",number];
    }
    return tempstr;
    
}

- (NSArray *)getLinesArrayWith:(UIFont *)font andRect:(CGRect)rect
{
    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [self substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return (NSArray *)linesArray;
}

+ (NSInteger)getlineCountWihtAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, width, 100000));
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFArrayRef array = CTFrameGetLines(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    CFIndex count = CFArrayGetCount(array);
    CFRelease(frame);
    return (NSInteger)count;
}

+ (float)getLastlinewidthAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, width, 100000));
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frame);
    CTLineRef lineRef = CFArrayGetValueAtIndex(lines,CFArrayGetCount(lines) - 1);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CTLineGetStringRange(lineRef), NULL, CGSizeMake(width, 100000), NULL);
    CFRelease(frameSetter);
    CFRelease(frame);
    CFRelease(path);
    return suggestedSize.width;
}


- (NSArray *)getWithNotfaceRangeArrayWithLocation:(int)location AtArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSInteger nameLength = 0;
    NSInteger begin = 0;
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        begin = [dic[@"i"] intValue];
        if (begin > self.length) {
            continue;
        }
        NSArray *tempArr = dic[@"u"];
        for (NSInteger j = 0; j < tempArr.count; j++) {
            NSDictionary *user = tempArr[j];
            if ([user isKindOfClass:[NSDictionary class]]) {
                NSString *userName = user[@"userName"];
                //                if (tempArr.count > 1 && j != tempArr.count - 1) {
                userName = [NSString stringWithFormat:@"%@ ",userName];
                //                }
                [result addObject:NSStringFromRange(NSMakeRange(location + begin + nameLength, userName.length + 1))];
                nameLength += userName.length + 1;
            }
        }
    }
    return result;
}
- (NSArray *)getRangeArrayWithLocation:(int)location AtArray:(NSArray *)array isReply:(BOOL)isReply
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *arr = [self getRangeOfFace];
    NSInteger nameLength = 0;
    NSInteger begin = 0;
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        begin = [dic[@"i"] intValue];
        if (begin > (int)self.length) {
            continue;
        }
        for (NSTextCheckingResult *obj in arr) {
            if (obj.range.location < [dic[@"i"] intValue]) {
                begin -= (obj.range.length - 1);
            }
        }
        NSArray *tempArr = dic[@"u"];
        for (NSInteger j = 0; j < tempArr.count; j++) {
            NSDictionary *user = tempArr[j];
            if ([user isKindOfClass:[NSDictionary class]]) {
                NSString *userName = user[@"userName"];
                if (isReply && j == 0 && i == 0)
                {
                   userName = [NSString stringWithFormat:@"%@",userName];
                    [result addObject:NSStringFromRange(NSMakeRange(location + begin + nameLength, userName.length + 1))];
                    nameLength += userName.length;
                }
                else
                {
                    userName = [NSString stringWithFormat:@"%@ ",userName];
                    NSInteger offset = isReply?1:0;
                    [result addObject:NSStringFromRange(NSMakeRange(location + begin + nameLength + offset, userName.length + 1))];
                    nameLength += userName.length + 1;
                }
            }
        }
    }
    return result;
}

- (NSArray *)getRangeArrayWithLocation:(int)location AtArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *arr = [self getRangeOfFace];
    NSInteger nameLength = 0;
    NSInteger begin = 0;
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        begin = [dic[@"i"] intValue];
        if (begin > (int)self.length) {
            continue;
        }
        for (NSTextCheckingResult *obj in arr) {
            if (obj.range.location < [dic[@"i"] intValue]) {
                begin -= (obj.range.length - 1);
            }
        }
        NSArray *tempArr = dic[@"u"];
        for (NSInteger j = 0; j < tempArr.count; j++) {
            NSDictionary *user = tempArr[j];
            if ([user isKindOfClass:[NSDictionary class]]) {
                NSString *userName = user[@"userName"];
//                if (tempArr.count > 1 && j != tempArr.count - 1) {
                    userName = [NSString stringWithFormat:@"%@ ",userName];
//                }
                [result addObject:NSStringFromRange(NSMakeRange(location + begin + nameLength, userName.length + 1))];
                nameLength += userName.length + 1;
            }
        }
    }
    return result;
}
- (NSDate *)changeTodate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    return [dateFormatter dateFromString:self];
}

- (NSString *)URLEncode {
    
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                                                CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

- (NSString *)URLDecoded {
    
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
