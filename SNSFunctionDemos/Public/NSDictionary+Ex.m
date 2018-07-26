//
//  NSDictionary+Ex.m
//  SNS
//
//  Created by 黄 敬 on 14-10-16.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import "NSDictionary+Ex.h"

@implementation NSDictionary (Ex)
- (NSString *)safeStringValueForKey:(NSString *)key
{
    if ([self objectForKey:key] && ![[self objectForKey:key] isKindOfClass:[NSNull class]]) {
        return [NSString stringWithFormat:@"%@",[self objectForKey:key]];
    } else {
        return @"";
    }
}
- (void)setSafeValue:(id)value forKey:(NSString *)key
{
    if (value && value != nil && ![value isKindOfClass:[NSNull class]]) {
        [self setValue:value forKey:key];
    } else {
        [self setValue:@"" forKey:key];
    }
}
@end
