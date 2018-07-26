//
//  UITextField+Ex.m
//  SNS
//
//  Created by SohuSns on 11/1/16.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import "UITextField+Ex.h"

@implementation UITextField (Ex)

- (BOOL)checkForMaxLength:(NSInteger)maxLength {
    NSString *toBeString = self.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) // 简体中文输入，包括简体拼音，健体五笔，简体手写
    {
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        if (!position)
        {
            if (toBeString.length > maxLength)
            {
                self.text = [toBeString substringToIndex:maxLength];
                return YES;
            }
        }
    }
    else if ([self.text length] > maxLength)
    {
        self.text = [toBeString substringToIndex:maxLength];
        return YES;
    }
    return NO;
}
@end
