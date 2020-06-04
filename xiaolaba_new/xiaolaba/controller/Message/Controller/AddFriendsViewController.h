//
//  AddFriendsViewController.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/9.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "SearchViewController.h"
enum {
    ABHelperCanNotConncetToAddressBook,
    ABHelperExistSpecificContact,
    ABHelperNotExistSpecificContact
};
typedef NSUInteger ABHelperCheckExistResultType;
//　　ABHelperCanNotConncetToAddressBook -> 连接通讯录失败（iOS6之后访问通讯录需要用户许可）
//　　ABHelperExistSpecificContact　　　　-> 号码已存在
//　　ABHelperNotExistSpecificContact　　-> 号码不存在

@interface AddFriendsViewController : SearchViewController

@property (nonatomic, strong) NSDictionary *callNODic;

@end
