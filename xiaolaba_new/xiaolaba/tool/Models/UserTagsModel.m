//
//  UserTagsModel.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/11/22.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "UserTagsModel.h"

@implementation UserTagsModel

- (NSString *)label {
    
    if(kNotNil(_label)) {
        return _label;
    }
    return @"";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end


@implementation UserAkiraModel

@end

@implementation UserAkiraCountModel

@end

@implementation UserAkiraVisitorModel

@end
