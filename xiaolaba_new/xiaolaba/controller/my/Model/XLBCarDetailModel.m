//
//  XLBCarDetailModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarDetailModel.h"

@implementation XLBCarDetailModel

@end

@implementation XLBCarDetailChildModel


@end

@implementation XLBMeCarQRCodeModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carId":@"id",
             
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end

@implementation XLBMeCarDetailModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"carId":@"id",
             
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
