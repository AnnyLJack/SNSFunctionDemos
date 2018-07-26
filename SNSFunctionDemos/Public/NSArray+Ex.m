//
//  NSArray+Ex.m
//  SNS
//
//  Created by SohuSns on 11/1/16.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import "NSArray+Ex.h"
//#import "objc/runtime.h"
@implementation NSArray (Ex)

//+ (void)load {
//    [super load];
//    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
//    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(lxz_objectAtIndex:));
//    method_exchangeImplementations(fromMethod, toMethod);
//}
//
//- (id)lxz_objectAtIndex:(NSUInteger)index {
//    if (self.count > index) {
//        // 这里做一下异常处理，不然都不知道出错了。
//        @try {
//            return [self lxz_objectAtIndex:index];
//        }
//        @catch (NSException *exception) {
//            // 在崩溃后会打印崩溃信息，方便我们调试。
//            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
//            NSLog(@"%@", [exception callStackSymbols]);
//        }
//        @finally {}
//    } else {
//        return [self lxz_objectAtIndex:index];
//    }
//}

- (id)objectForKey:(id)aKey {
    
    return @"";
}

- (id)safeStringValueForKey:(id)aKey {
    
    return nil;
}
@end
