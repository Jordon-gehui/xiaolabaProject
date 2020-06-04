//
//  XLBAddressTool.m
//  xiaolaba
//
//  Created by 斯陈 on 2019/4/11.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import "XLBAddressTool.h"
#import <AddressBook/AddressBook.h>

@interface XLBAddressTool ()<UIAlertViewDelegate>

@end
@implementation XLBAddressTool

+ (instancetype)addressToolShared {
    static XLBAddressTool *adressTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        adressTool = [[self.class alloc] init];
    });
    return adressTool;
}

- (void)creatPhoneNumber {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //用户授权
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (!error) {
            if (granted) {//允许
                if ([[self.dict allKeys] containsObject:@"callNOList"]) {
                    NSArray *list = [self.dict objectForKey:@"callNOList"];
                    if ([self existPhone:list[0]] !=BHelperExistSpecificContact) {
                        [self creatNewRecord];
                    }
                }else{
                    if ([self existPhone:@"(025)69514650"] !=BHelperExistSpecificContact) {
                        [self creatNewRecord];
                    }
                }
            }else{//拒绝
                NSLog(@"拒绝");
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"小喇叭需要您的同意，才能访问您的通讯录，开启后可以免费拨打及接听平台挪车电话，也可以查找通讯录联系人并添加好友" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去设置", nil];
                    [alertV show];
                });
            }
        }else{
            NSLog(@"错误!");
        }
    });
}

- (void) creatNewRecord
{
    CFErrorRef error = NULL;
    
    //创建一个通讯录操作对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    //创建一条新的联系人纪录
    ABRecordRef newRecord = ABPersonCreate();
    
    //为新联系人记录添加属性值
    if ([[self.dict allKeys] containsObject:@"callName"]) {
        ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)[self.dict objectForKey:@"callName"], &error);
    }else{
        ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)@"小喇叭平台", &error);
    }
    
    //创建一个多值属性
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if ([[self.dict allKeys] containsObject:@"callNOList"]) {
        NSArray *list = [self.dict objectForKey:@"callNOList"];
        for (NSString *number in list) {
            ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)number, kABPersonPhoneMobileLabel, NULL);
        }
    }else{
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514650", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514651", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514652", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514653", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514654", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514655", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514656", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514657", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514658", kABPersonPhoneMobileLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"(025)69514659", kABPersonPhoneIPhoneLabel, NULL);
    }
    
    //将多值属性添加到记录
    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
    CFRelease(multi);
    
    //添加记录到通讯录操作对象
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    
    //保存通讯录操作对象
    ABAddressBookSave(addressBook, &error);
    CFRelease(newRecord);
    CFRelease(addressBook);
}
// 指定号码是否已经存在
- (BHelperCheckExistResultType)existPhone:(NSString*)phoneNum
{
    ABAddressBookRef addressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    CFArrayRef records;
    if (addressBook) {
        // 获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    }else{
#ifdef DEBUG
        NSLog(@"can not connect to address book");
#endif
        return BHelperCanNotConncetToAddressBook;
    }
    
    // 遍历全部联系人，检查是否存在指定号码
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFStringRef nameLabel = ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *name = (__bridge NSString *)nameLabel;
        NSLog(@"联系人%@  %@",nameLabel,name);
        
        if ([name isEqualToString:@"小喇叭平台"]) {
            ABAddressBookRemoveRecord(addressBook, record, nil);
            ABAddressBookSave(addressBook, nil);
            return BHelperNotExistSpecificContact;
        }
//        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
//        if (phoneNums) {
//            for (int j=0; j<CFArrayGetCount(phoneNums); j++) {
//                NSString *phone = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
//                if ([phone isEqualToString:phoneNum]) {
//                    return BHelperExistSpecificContact;
//                }else {
//                    if ([name isEqualToString:@"小喇叭平台"]) {
//                        ABAddressBookRemoveRecord(addressBook, record, nil);
//                        ABAddressBookSave(addressBook, nil);
//                        return BHelperNotExistSpecificContact;
//                    }
//                }
//            }
//        }
    }
    
    CFRelease(addressBook);
    CFRelease(records);
    return BHelperNotExistSpecificContact;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
