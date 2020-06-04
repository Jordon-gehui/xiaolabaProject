//
//  LittleHornTableViewModel.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleHornTableViewModel.h"

@implementation LittleHornTableViewModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"tags":[UserTagsModel class]};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end

@implementation Imgs

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
