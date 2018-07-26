//
//  UIColor+Hex.m
//  sohukan
//
//  Created by riven  on 12-9-10.
//
//

#import "UIColor+Hex.h"
#import "constants.h"
@implementation UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue
{
    return [UIColor colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue
{
    return [UIColor colorWithHex:0x000000 alpha:alphaValue];
}
- (UIImage *)createImageWithRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - color
+ (UIColor *)grayOne
{
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)grayTwo
{
    return [UIColor colorWithHex:0x454545];
}

+ (UIColor *)grayThree
{
    return [UIColor colorWithHex:0x929292];
}

+ (UIColor *)grayFour
{
    return [UIColor colorWithHex:0xfffff];
}

+ (UIColor *)grayFive
{
    return [UIColor colorWithHex:0xdadada];
}

+ (UIColor *)graySix
{
    return [UIColor colorWithHex:0xf1f1f1];
}

+ (UIColor *)graySeven
{
    return [UIColor colorWithHex:0xf9f9f9];
}

+ (UIColor *)grayEight
{
    return [UIColor colorWithHex:0xffffff];
}

+ (UIColor *)grayNine
{
    return [UIColor colorWithHex:0xe2e2e2];
}

+ (UIColor *)redOne
{
    return [UIColor colorWithHex:0xee2f10];
}

+ (UIColor *)buleOne
{
    return [UIColor colorWithHex:0x3d5699];
}

+ (UIColor *)greenOne
{
    return [UIColor colorWithHex:0x59d141];
}

+ (UIColor *)yellowOne
{
    return [UIColor colorWithHex:0xfdd536];
}

+ (UIColor *)orangeOne
{
    return [UIColor orangeColor];
}

+ (UIColor *)nightOne
{
    return [UIColor colorWithHex:0x4e4e4e];
}

+ (UIColor *)nightTwo
{
    return [UIColor colorWithHex:0x343434];
}
+ (UIColor *)nightThree
{
    return [UIColor colorWithHex:0x1a1a1a];
}
+ (UIColor *)nightFour
{
    return [UIColor colorWithHex:0x1f1f1f];
}

+ (UIColor *)redOneNight
{
    return [UIColor colorWithHex:0x6e2a2a];
}
+ (UIColor *)buleOneNight
{
    return [UIColor colorWithHex:0x282f43];
}
+ (UIColor *)greenOneNight
{
    return [UIColor colorWithHex:0x35662b];
}
+ (UIColor *)yellowOneNight
{
    return [UIColor colorWithHex:0x645414];
}
+ (UIColor *)orangeOneNight
{
    return [UIColor colorWithHex:0xb45600];
}
+ (UIColor *)fontOne
{
    return [UIColor grayOne];
}
+ (UIColor *)fontTwo
{
    return [UIColor grayTwo];
}
+ (UIColor *)fontThree
{
    return [UIColor grayThree];
}
+ (UIColor *)fontFour
{
    return [UIColor grayEight];
}
+ (UIColor *)backgroundOne
{
    return [UIColor colorWithHex:0xe5e5e5]; //dadada
}
+ (UIColor *)backgroundTwo
{
    return [UIColor graySix];
}
+ (UIColor *)backgroundThree
{
    return [UIColor graySeven];
}
+ (UIColor *)backgroundFour
{
    return [UIColor graySeven];
}

+ (UIColor *)grayOneTheme
{
    return IsNight?[UIColor nightOne] : [UIColor grayOne];
}

+ (UIColor *)grayTwoTheme
{
    return IsNight?[UIColor nightOne] : [UIColor grayTwo];
}

+ (UIColor *)grayThreeTheme
{
    return IsNight?[UIColor nightTwo] : [UIColor grayThree];
}

+ (UIColor *)lineTheme
{
    return IsNight?[UIColor nightTwo] : [UIColor backgroundOne];
}
@end
