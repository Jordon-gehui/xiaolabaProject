//
//  SFHFKeychainUtils.h
//  BQLDemo
//
//  Created by lin on 2016/10/31.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFHFKeychainUtils : NSObject

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;
+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;

@end
