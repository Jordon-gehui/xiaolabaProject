//
//  PraiseListModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "PraiseListModel.h"

@implementation PraiseListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userID":@"id",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
