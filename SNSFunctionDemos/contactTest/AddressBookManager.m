//
//  AddressBookManager.m
//  CoreDataTest
//
//  Created by SohuSns on 10/10/15.
//  Copyright © 2015 shenjx. All rights reserved.
//

#import "AddressBookManager.h"
#import "FileManager.h"
#import "NSString+Ex.h"
#define kAddressBookFile   @"addressBookFile"

@interface AddressBookManager()
@property (assign,nonatomic) ABAddressBookRef addressBook;//通讯录
@property (nonatomic,strong) CNContactStore *contactStore;//iOS9使用
@end

@implementation AddressBookManager
+ (instancetype)shareInstance {
    static AddressBookManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}
- (id)init {
    
    self = [super init];
    if (self)
    {
        if (iOS9) {
            self.contactStore = [[CNContactStore alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactDidChange:) name:CNContactStoreDidChangeNotification object:nil];
        }
        else {
            self.addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, ContactsChangeCallback, (__bridge void *)(self));
        }
    }
    return self;
}
/*
 回调函数，实现自己的逻辑。
 */
void ContactsChangeCallback (ABAddressBookRef addressBook,
                             CFDictionaryRef info,
                             void *context){
//    id obj = objc_unretainedObject(context);
//    if (obj && [obj isKindOfClass:[AddressBookManager class]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemContactDidChange" object:nil];
//    }
}
- (void)contactDidChange:(NSNotification *)notify {
    NSLog(@"posted change times");
    [[NSNotificationCenter defaultCenter] postNotificationName:SystemContactDidChangeNotification object:nil];
}

- (void)dealloc {
    if (!iOS9) {
      ABAddressBookUnregisterExternalChangeCallback(_addressBook, ContactsChangeCallback, nil);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
#pragma mark PublicMethod
/**
 *  获取所有需要上传到服务端的手机号
 *
 *  @param complete
 */
- (void)getNeedsUploadPhonesComplete:(void(^)(NSMutableArray *uploadPhoneArray))complete {

    __weak typeof (self) weakSelf = self;
    if (iOS9)
    {
        [self getContacts:^(NSArray *contacts, NSError *error) {
            [weakSelf getNeedUploadWithDevices:[NSMutableArray arrayWithArray:contacts] complete:^(NSMutableArray *deveicePhones) {
                if (complete) {
                    complete(deveicePhones);
                }
            }];
        }];
    }
    else
    {
        [self getDevicePhoneArrayComplet:^(NSMutableArray *deveicePhones) {
            [weakSelf getNeedUploadWithDevices:[NSMutableArray arrayWithArray:deveicePhones] complete:^(NSMutableArray *deveicePhones) {
                if (complete) {
                    complete(deveicePhones);
                }
            }];
        }];
    }
}
/**
 *  通过手机号获取用户姓名，只取第一个匹配的
 *
 *  @param phoneNum
 *  @param complete
 */
- (void)getNameWithPhone:(NSString *)phoneNum complete:(void (^)(NSString *))complete {
//    if (iOS9)
//    {
        //can't do this ,because the new sdk just support some Predicate like these:
        /*
         + predicateForContactsMatchingName:
         + predicateForContactsWithIdentifiers:
         + predicateForContactsInGroupWithIdentifier:
         + predicateForContactsInContainerWithIdentifier;
         */
//    }
//    else
//    {
//        if (!self.devicePhones)
//        {
//            CFArrayRef allPeople= ABAddressBookCopyArrayOfAllPeople(self.addressBook);
//            self.devicePhones = [NSMutableArray arrayWithArray:(__bridge NSMutableArray *)allPeople];
//            CFRelease(allPeople);
//        }
//        [self.devicePhones enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            ABRecordRef recordRef = (__bridge ABRecordRef)obj;
//            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
//            firstName = firstName?firstName:@"";
//            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
//            lastName = lastName?lastName:@"";
//            NSString *fullName = @"";
//            if ([firstName length])
//            {
//                fullName = [lastName stringByAppendingFormat:@"%@",firstName];
//            }
//            else if([lastName length])
//            {
//                fullName = lastName;
//            }
//            BOOL isHave = NO;
//            ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
//            for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
//            {
//                NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
//                phone = [self formatPhoneNum:phone];
//                if ([phone isEqualToString:phoneNum])
//                {
//                    isHave = YES;
//                    break;
//                }
//            }
//            if (isHave)
//            {
//                *stop = YES;
//                if (complete)
//                {
//                    complete(fullName);
//                }
//            }
//        }];
//    }
}
#pragma mark - PrivateMethods
/**
 *  IOS9以下获取通迅录所有手机号
 *
 *  @param complete
 */
- (void)getDevicePhoneArrayComplet:(void(^)(NSMutableArray *deveicePhones))complete {

    __block NSMutableArray *devicePhoneNums = [NSMutableArray array];
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"未获得通讯录访问权限！");
        }
        ABAuthorizationStatus authorization= ABAddressBookGetAuthorizationStatus();
        if (authorization!=kABAuthorizationStatusAuthorized) {
            NSLog(@"尚未获得通讯录访问授权！");
            return ;
        }
        CFArrayRef allPeople= ABAddressBookCopyArrayOfAllPeople(self.addressBook);
        NSMutableArray *devicePhones = [NSMutableArray arrayWithArray:(__bridge NSMutableArray *)allPeople];
        
        [devicePhones enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ABRecordRef recordRef = (__bridge ABRecordRef)obj;
            ABMultiValueRef phoneNumbersRef= ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
            ContactEntity *newEntity = [ContactEntity new];
            newEntity.firstName = firstName?:@"";
            newEntity.lastName = lastName?:@"";
            long count= ABMultiValueGetCount(phoneNumbersRef);
            for(int i = 0;i < count;i++) {
                NSString *phoneNumber=(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbersRef, i));
                NSString *formatePhone = [self formatPhoneNum:phoneNumber];
                if([formatePhone isPhoneNumber]) {
                    newEntity.phoneNum = formatePhone;
                    [devicePhoneNums addObject:newEntity];
                }
            }
        }];
        if (complete) {
            complete(devicePhoneNums);
        }
        CFRelease(allPeople);
    });
}
/**
 *  IOS9及以上获取通迅录所有手机号
 *
 *  @param completion
 */
- (void)getContacts:(void (^)(NSArray * contacts, NSError * error))completion
{
    NSError * _contactError = [NSError errorWithDomain:@"WCSContactsErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Not authorized to access Contacts."}];
    switch ( [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] )
    {
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted: {
            completion(nil, _contactError);
            break;
        }
        case CNAuthorizationStatusNotDetermined:
        {
            [self.contactStore requestAccessForEntityType:CNEntityTypeContacts
                                    completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                        if (!granted ) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                completion(nil, _contactError);
                                            });
                                        }
                                        else
                                            [self getContacts:completion];
                                    }];
            break;
        }
        case CNAuthorizationStatusAuthorized:
        {
            NSMutableArray * _contactsTemp = [NSMutableArray new];
            CNContactFetchRequest * _contactRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self contactKeys]];
            [self.contactStore enumerateContactsWithFetchRequest:_contactRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                if (contact.phoneNumbers.count > 0)
                {
                    ContactEntity *newEntity = [ContactEntity new];
                    newEntity.firstName = contact.givenName?:@"";
                    newEntity.lastName = contact.familyName?:@"";
                    NSString *phoneStr = ((CNPhoneNumber *)((CNLabeledValue *)contact.phoneNumbers[0]).value).stringValue;
                    NSString *formatePhone = [self formatPhoneNum:phoneStr];
                    if([formatePhone isPhoneNumber]) {
                        newEntity.phoneNum = formatePhone;
                        [_contactsTemp addObject:newEntity];
                    }
                }
            }];
                completion(_contactsTemp, nil);
            break;
        }
    }
}
- (NSArray*)contactKeys
{
    return @[CNContactPhoneNumbersKey,
             CNContactGivenNameKey,
             CNContactFamilyNameKey];
//    return @[CNContactNamePrefixKey,
//             CNContactGivenNameKey,
//             CNContactMiddleNameKey,
//             CNContactFamilyNameKey,
//             CNContactPreviousFamilyNameKey,
//             CNContactNameSuffixKey,
//             CNContactNicknameKey,
//             CNContactPhoneticGivenNameKey,
//             CNContactPhoneticMiddleNameKey,
//             CNContactPhoneticFamilyNameKey,
//             CNContactOrganizationNameKey,
//             CNContactDepartmentNameKey,
//             CNContactJobTitleKey,
//             CNContactBirthdayKey,
//             CNContactNonGregorianBirthdayKey,
//             CNContactNoteKey,
//             CNContactImageDataKey,
//             CNContactThumbnailImageDataKey,
//             CNContactImageDataAvailableKey,
//             CNContactTypeKey,
//             CNContactPhoneNumbersKey,
//             CNContactEmailAddressesKey,
//             CNContactPostalAddressesKey,
//             CNContactDatesKey,
//             CNContactUrlAddressesKey,
//             CNContactRelationsKey,
//             CNContactSocialProfilesKey,
//             CNContactInstantMessageAddressesKey];
}
/**
 *  设备手机号跟本地存储的手机号对比，将新手机号返回
 *
 *  @param deveicePhones 设备所有手机号
 *  @param complete
 */
- (void)getNeedUploadWithDevices:(NSMutableArray *)deveicePhones complete:(void(^)(NSMutableArray *deveicePhones))complete {
     NSArray *localPhoneArray = [self getLocalPhoneArray];
    __block NSMutableArray *resultPhoneArray = [NSMutableArray array];
    if (deveicePhones.count > 0)
    {
        if (localPhoneArray && localPhoneArray.count > 0)
        {
            NSMutableArray *mutiLocalArray = [NSMutableArray arrayWithArray:localPhoneArray];
            [deveicePhones enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj && [obj isKindOfClass:[ContactEntity class]]) {
                    ContactEntity *contactEntity = (ContactEntity *)obj;
                    NSString *deviceNum = contactEntity.phoneNum;
                    __block BOOL isHave = NO;
                    [localPhoneArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj && [obj isKindOfClass:[ContactEntity class]]) {
                            ContactEntity *localEntity = (ContactEntity *)obj;
                            NSString *localNum = localEntity.phoneNum;
                            if ([deviceNum isEqualToString:localNum]) {
                                isHave = YES;
                                *stop = YES;
                            }
                        }
                    }];
                    if (!isHave) {
                        [resultPhoneArray addObject:contactEntity];
                        [mutiLocalArray addObject:contactEntity];
                    }
                }
                
            }];
            if (complete) {
                complete(resultPhoneArray);
            }
            [self saveAddressBook:mutiLocalArray];
        }
        else
        {
            if (complete) {
                complete(deveicePhones);
            }
            [self saveAddressBook:deveicePhones];
        }
    }
}

- (NSArray *)getLocalPhoneArray {
    return  [FileManager obtainDataForKey:kAddressBookFile operator:LoginUserDefaults];
}
/**
 *  保存到本地
 *
 *  @param phoneNums <#phoneNums description#>
 */
- (void)saveAddressBook:(NSArray *)phoneNums {
    
    if (phoneNums.count)
    {
        [FileManager setData:phoneNums forKey:kAddressBookFile operator:LoginUserDefaults];
    }
    
}
/**
 *  获取手机号格式化
 *
 *  @param phoneNum <#phoneNum description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)formatPhoneNum:(NSString *)phoneNum {
    
    NSString *resultStr = @"";
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([phoneNum length] >= 11)
    {
        resultStr = [NSMutableString stringWithString:[phoneNum substringFromIndex:([phoneNum length]-11)]];
    }
    return resultStr;
}
#pragma mark -
#pragma mark Common Operations
/**
 *  从指定组里删除指定的记录 iOS9及以上
 *
 *  @param recordRef 要删除的记录
 */
- (void)removePersonWithContact:(CNContact *)contact {
    CNSaveRequest *saveRequest = [CNSaveRequest new];
    [saveRequest deleteContact:contact.mutableCopy];
    [self.contactStore executeSaveRequest:saveRequest error:nil];
}
/**
 *  删除指定的记录
 *
 *  @param recordRef 要删除的记录
 */
-(void)removePersonWithRecord:(ABRecordRef)recordRef {
    ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);//删除
    ABAddressBookSave(self.addressBook, NULL);//删除之后提交更改
}
/**
 *  根据姓名删除匹配的所有记录
 */
-(void)removePersonWithName:(NSString *)personName {
    if (iOS9)
    {
        NSArray *contacts = [self getRecordsWithName:personName];
        __block CNSaveRequest *saveRequest = [CNSaveRequest new];
        [contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [saveRequest deleteContact:obj];
        }];
        [self.contactStore executeSaveRequest:saveRequest error:nil];
    }
    else
    {
        CFStringRef personNameRef=(__bridge CFStringRef)(personName);
        CFArrayRef recordsRef= ABAddressBookCopyPeopleWithName(self.addressBook, personNameRef);//根据人员姓名查找
        CFIndex count= CFArrayGetCount(recordsRef);//取得记录数
        for (CFIndex i=0; i<count; ++i) {
            ABRecordRef recordRef=CFArrayGetValueAtIndex(recordsRef, i);//取得指定的记录
            ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);//删除
        }
        ABAddressBookSave(self.addressBook, NULL);//删除之后提交更改
        CFRelease(recordsRef);
    }
}

/**
 *  添加一条记录
 *
 *  @param firstName  名
 *  @param lastName   姓
 *  @param iPhoneName iPhone手机号
 */
-(void)addPersonWithFirstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber{
    if (iOS9)
    {
        CNMutableContact *newContact = [CNMutableContact new];
        newContact.givenName = firstName;
        newContact.familyName = lastName;
        newContact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:CNLabelWork value:[CNPhoneNumber phoneNumberWithStringValue:workNumber]]];
        CNSaveRequest *saveRequest = [CNSaveRequest new];
        [saveRequest addContact:newContact toContainerWithIdentifier:nil];
        [self.contactStore executeSaveRequest:saveRequest error:nil];
    }
    else
    {
        //创建一条记录
        ABRecordRef recordRef= ABPersonCreate();
        ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL);//添加名
        ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), NULL);//添加姓
        
        ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);//添加设置多值属性
        ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(workNumber), kABWorkLabel, NULL);//添加工作电话
        ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
        
        //添加记录
        ABAddressBookAddRecord(self.addressBook, recordRef, NULL);
        
        //保存通讯录，提交更改
        ABAddressBookSave(self.addressBook, NULL);
        //释放资源
        CFRelease(recordRef);
        CFRelease(multiValueRef);
    }
}
- (id)getRecordsWithName:(NSString *)fullName {
    if (iOS9)
    {
        NSPredicate *namePredicte = [CNContact predicateForContactsMatchingName:fullName];
        NSArray *contacts = [self.contactStore unifiedContactsMatchingPredicate:namePredicte keysToFetch:[self contactKeys] error:nil];
        if (contacts.count == 0) {
            NSLog(@"no matches contacts");
        }
        else
        {
            return contacts;
        }
    }
    else
    {
        CFStringRef personNameRef=(__bridge CFStringRef)(fullName);
        CFArrayRef recordsRef= ABAddressBookCopyPeopleWithName(self.addressBook, personNameRef);//根据人员姓名查找
        CFIndex count= CFArrayGetCount(recordsRef);//取得记录数
        //        for (CFIndex i=0; i<count; ++i) {
        //            ABRecordRef recordRef=CFArrayGetValueAtIndex(recordsRef, i);//取得指定的记录
        //            ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);//删除
        //        }
        //        ABAddressBookSave(self.addressBook, NULL);//删除之后提交更改
        //        CFRelease(recordsRef);
        if (count > 0) {
            return (__bridge id)(recordsRef);
        }
    }
    return @"";
}
/**
 *  根据RecordID修改联系人信息
 *
 *  @param recordID   记录唯一ID
 *  @param firstName  姓
 *  @param lastName   名
 *  @param homeNumber 工作电话
 */
- (void)modifyPersonWithContact:(CNContact *)contact firstName:(NSString *)firstName lastName:(NSString *)lastName workNmuber:(NSString *)workNmuber {
    CNMutableContact *newContact = contact.mutableCopy;
    newContact.givenName = firstName;
    newContact.familyName = lastName;
    if (newContact.phoneNumbers.count > 0)
    {
        CNLabeledValue *workLabel = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:[CNPhoneNumber phoneNumberWithStringValue:workNmuber]];
        
        newContact.phoneNumbers= @[workLabel];
    }
    CNSaveRequest *saveRequest = [CNSaveRequest new];
    [saveRequest updateContact:newContact];
}

-(void)modifyPersonWithRecordID:(ABRecordID)recordID firstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber{
    
    ABRecordRef recordRef=ABAddressBookGetPersonWithRecordID(self.addressBook,recordID);
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL);//添加名
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), NULL);//添加姓
    
    ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(workNumber), kABWorkLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    //保存记录，提交更改
    ABAddressBookSave(self.addressBook, NULL);
    //释放资源
    CFRelease(multiValueRef);
}
@end
