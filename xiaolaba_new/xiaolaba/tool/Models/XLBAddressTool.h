//
//  XLBAddressTool.h
//  xiaolaba
//
//  Created by 斯陈 on 2019/4/11.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSUInteger, ABHelperCheckExistResultType) {
//    ABHelperCanNotConncetToAddressBook,
//    ABHelperExistSpecificContact,
//    ABHelperNotExistSpecificContact
//};

enum {
    BHelperCanNotConncetToAddressBook,
    BHelperExistSpecificContact,
    BHelperNotExistSpecificContact
};
typedef NSUInteger BHelperCheckExistResultType;
//　　ABHelperCanNotConncetToAddressBook -> 连接通讯录失败（iOS6之后访问通讯录需要用户许可）
//　　ABHelperExistSpecificContact　　　　-> 号码已存在
//　　ABHelperNotExistSpecificContact　　-> 号码不存在

@interface XLBAddressTool : NSObject

+ (instancetype)addressToolShared;

@property (nonatomic, strong) NSDictionary *dict;

- (void)creatPhoneNumber;
@end

NS_ASSUME_NONNULL_END
