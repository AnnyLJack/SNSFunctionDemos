//
//  UIColor+Hex.h
//  sohukan
//
//  Created by riven  on 12-9-10.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;
+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue;
- (UIImage *)createImageWithRect:(CGRect)rect;

+ (UIColor *)fontOne;
+ (UIColor *)fontTwo;
+ (UIColor *)fontThree;
+ (UIColor *)fontFour;
+ (UIColor *)backgroundOne;
+ (UIColor *)backgroundTwo;
+ (UIColor *)backgroundThree;
+ (UIColor *)backgroundFour;


+ (UIColor *)grayOne;
+ (UIColor *)grayTwo;
+ (UIColor *)grayThree;
+ (UIColor *)grayFour;
+ (UIColor *)grayFive;
+ (UIColor *)graySix;
+ (UIColor *)graySeven;
+ (UIColor *)grayEight;
+ (UIColor *)grayNine;
+ (UIColor *)nightOne;
+ (UIColor *)nightTwo;
+ (UIColor *)nightThree;
+ (UIColor *)nightFour;
+ (UIColor *)redOne;
+ (UIColor *)buleOne;
+ (UIColor *)greenOne;
+ (UIColor *)yellowOne;
+ (UIColor *)orangeOne;
+ (UIColor *)redOneNight;
+ (UIColor *)buleOneNight;
+ (UIColor *)greenOneNight;
+ (UIColor *)yellowOneNight;
+ (UIColor *)orangeOneNight;


+ (UIColor *)grayOneTheme;
+ (UIColor *)grayTwoTheme;
+ (UIColor *)grayThreeTheme;
+ (UIColor *)lineTheme;
@end
