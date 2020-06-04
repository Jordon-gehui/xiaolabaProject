//
//  EarningsListModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "EarningsListModel.h"

@implementation EarningsListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"earningListId":@"id",
             
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
