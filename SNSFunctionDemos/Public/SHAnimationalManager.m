//
//  SHAnimationalManager.m
//  SohuInk
//
//  Created by xinchundou on 16/3/23.
//  Copyright © 2016年 Sohu. All rights reserved.
//

#import "SHAnimationalManager.h"
#import <UIKit/UIKit.h>
@implementation SHAnimationalManager

+(SHAnimationalManager *)sharedInstance{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SHAnimationalManager alloc] init];
    });
    
    return _sharedInstance;
}


-(CATransition *)animationWithType:(AnimationType)type subType:(NSString *)subType{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = 0.5f;
    //设置运动type
    switch (type) {
        case AnimationType_OglFlip:
            animation.type = @"oglFlip";
            break;
            
        default:
            break;
    }
    //设置子类型
    animation.subtype = subType;
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    return animation;
}

-(void)removeAnimationalFromLayer:(CALayer *)destLayer byKey:(NSString *)animationalKey afterDelay:(NSTimeInterval)delayTime{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime);
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(destLayer){
            [destLayer removeAnimationForKey:animationalKey];
        }
    });
}



@end
