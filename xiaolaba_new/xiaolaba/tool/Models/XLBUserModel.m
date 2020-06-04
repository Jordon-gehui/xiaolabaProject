//
//  XLBUserModel.m
//  xiaolaba
//
//  Created by lin on 2017/8/9.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBUserModel.h"

//static XLBUserModel *user;

@implementation XLBUserModel

- (NSString *)img {
    
    if(kNotNil(_img)) {
        if([_img containsString:@"http"]) {
            return _img;
        }
        return [NSString stringWithFormat:@"%@%@",kImagePrefix,_img];
    }
    else if (kNotNil(_headimgurl)) {
        return _headimgurl;
    }
    return @"weitouxiang";
}

- (NSString *)headimgurl {
    
    if(kNotNil(_headimgurl)) {
        return _headimgurl;
    }
    else if (kNotNil(_img)) {
        if([_img containsString:@"http"]) {
            return _img;
        }
        return [NSString stringWithFormat:@"%@%@",kImagePrefix,_img];
    }
    return @"weitouxiang";
}



- (NSString *)signature {
    
    if(kNotNil(_signature)) {
        return _signature;
    }
    return @"";
}

- (NSArray<NSString *> *)allKeys {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    
    free(properties);
    return props;
}

+ (NSArray<NSString *> *)allKeys {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    
    free(properties);
    return props;
}

@end
