//
//  SHAnimationalManager.h
//  SohuInk
//
//  Created by xinchundou on 16/3/23.
//  Copyright © 2016年 Sohu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
typedef enum : NSUInteger {
    AnimationType_Fade = 1,                   //淡入淡出
    AnimationType_Push,                       //推挤
    AnimationType_Reveal,                     //揭开
    AnimationType_MoveIn,                     //覆盖
    AnimationType_Cube,                       //立方体
    AnimationType_SuckEffect,                 //吮吸
    AnimationType_OglFlip,                    //翻转
    AnimationType_RippleEffect,               //波纹
    AnimationType_PageCurl,                   //翻页
    AnimationType_PageUnCurl,                 //反翻页
    AnimationType_CameraIrisHollowOpen,       //开镜头
    AnimationType_CameraIrisHollowClose,      //关镜头
    AnimationType_CurlDown,                   //下翻页
    AnimationType_CurlUp,                     //上翻页
    AnimationType_FlipFromLeft,               //左翻转
    AnimationType_FlipFromRight,              //右翻转
} AnimationType;
@interface SHAnimationalManager : NSObject

+(SHAnimationalManager *)sharedInstance;

/**
 *  获取一个转场动画
 *
 *  @param type AnimationType
 *  @param subType kCATransitionFromRight,kCATransitionFromLeft,kCATransitionFromTop or kCATransitionFromBottom
 *
 *  @return CATransaction
 */
- (CATransition *)animationWithType:(AnimationType )type subType:(NSString *)subType;

- (void)removeAnimationalFromLayer:(CALayer *)destLayer byKey:(NSString *)animationalKey afterDelay:(NSTimeInterval )delayTime;

@end
