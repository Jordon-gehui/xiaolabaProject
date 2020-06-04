//
//  PayCheTieModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/7/14.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "PayCheTieModel.h"

@implementation PayCheTieModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"commodityID":@"id",
             
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
