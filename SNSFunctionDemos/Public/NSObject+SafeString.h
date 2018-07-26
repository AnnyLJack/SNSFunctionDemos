//
//  NSObject+SafeString.h
//  SNS
//
//  Created by huangjing on 15/6/1.
//  Copyright (c) 2015年 n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeString)
+ (void)load;

- (NSString *)safeString;

- (NSString *)sns_swizzleDebugDescription;
@end
