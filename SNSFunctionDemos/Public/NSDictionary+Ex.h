//
//  NSDictionary+Ex.h
//  SNS
//
//  Created by 黄 敬 on 14-10-16.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ex)
- (NSString *)safeStringValueForKey:(NSString *)key;
- (void)setSafeValue:(id)value forKey:(NSString *)key;
@end
