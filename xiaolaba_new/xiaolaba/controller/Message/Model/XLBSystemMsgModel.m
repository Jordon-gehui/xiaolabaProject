//
//  XLBSystemMsgModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBSystemMsgModel.h"

@implementation XLBSystemMsgModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"sysNewId":@"id",
             
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
