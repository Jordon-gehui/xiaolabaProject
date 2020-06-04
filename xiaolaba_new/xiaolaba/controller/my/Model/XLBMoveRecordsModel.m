//
//  XLBMoveRecordsModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMoveRecordsModel.h"

@implementation XLBMoveRecordsModel


+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"notice":@"self",
             @"createID":@"id",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
