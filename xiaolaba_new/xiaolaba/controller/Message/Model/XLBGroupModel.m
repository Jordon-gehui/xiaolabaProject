//
//  XLBGroupModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupModel.h"

@implementation XLBGroupModel

@end

@implementation XLBGroupSubModel

@end

@implementation XLBGroupListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"groupID":@"id",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
