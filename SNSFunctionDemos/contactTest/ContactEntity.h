//
//  ContactEntity.h
//  SNSFunctionDemos
//
//  Created by SohuSns on 2/2/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSBaseEntity.h"
@interface ContactEntity : SNSBaseEntity

@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;

- (void)anlayWithData:(id)sourceData;
@end
