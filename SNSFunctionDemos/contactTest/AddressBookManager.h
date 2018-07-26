//
//  AddressBookManager.h
//  CoreDataTest
//
//  Created by SohuSns on 10/10/15.
//  Copyright © 2015 shenjx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <UIKit/UIKit.h>
#import "ContactEntity.h"
#define iOS9     ([[UIDevice currentDevice].systemVersion intValue] >= 9?YES:NO)
#define SystemContactDidChangeNotification @"SystemContactDidChange"
@interface AddressBookManager : NSObject

+ (instancetype)shareInstance;

- (void)getNeedsUploadPhonesComplete:(void(^)(NSMutableArray *uploadPhoneArray))complete;

@end
