//
//  UIImage+Ex.h
//  SNS
//
//  Created by 黄 敬 on 14-12-31.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface UIImage (Ex)
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)compressImageWithQuality:(CGFloat)quality;
- (UIImage *)compressImage;
- (NSData *)compressForAllSizeImage;
- (UIImage *)timelinePhotoCompressImageWithPercent:(CGFloat)percent;
//等比例压缩 按宽度
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
//等比例压缩 按size
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
//按屏幕大小等比例压缩后，图片的rect
- (CGRect)scaleImageRectForScreenSize:(UIImage *)sourceImage;

+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor ;


+ (UIImage *)imageFromColor:(UIColor *)customColor;

+ (UIImage *)imageFromColor:(UIColor *)customColor imageSize:(CGSize)size;

- (BOOL)isLongImage; //判断是不是长图

+ (ALAssetsLibrary *)defaultAssetsLibrary;

- (UIImage *)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (UIImage *)fixOrientation;
@end
