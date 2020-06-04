//
//  BannersModel.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/8.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BannersModel.h"

@implementation BannersModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"url":@"url",
             @"image":@"image",
             @"type":@"type"
             };
}

@end
