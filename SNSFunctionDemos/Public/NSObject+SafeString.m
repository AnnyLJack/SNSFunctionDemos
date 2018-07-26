//
//  NSObject+SafeString.m
//  SNS
//
//  Created by huangjing on 15/6/1.
//  Copyright (c) 2015年 n. All rights reserved.
//

#import "NSObject+SafeString.h"
#import <objc/runtime.h>
#import "SNSBaseEntity.h"
@implementation NSObject (SafeString)
+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(debugDescription)), class_getInstanceMethod([self class], @selector(sns_swizzleDebugDescription)));
}
- (NSString *)sns_swizzleDebugDescription {
    
    if (![self isKindOfClass:[SNSBaseEntity class]]) {
        return [self sns_swizzleDebugDescription];
    }
    
    NSMutableDictionary *dictoinary = [NSMutableDictionary dictionary];
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0 ; i < count ; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?:@"nil";
        [dictoinary setObject:value forKey:name];
    }
    free(properties);
    return [NSString stringWithFormat:@"<%@:%p> -- %@",[self class],self,dictoinary];
}
- (NSString *)safeString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else {
        return (NSString *)[NSString stringWithFormat:@"%@",self];
    }
}
@end
