//
//  XLBCarBrandModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/20.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarBrandModel.h"

@implementation XLBCarBrandModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"numberID":@"id",
             
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
