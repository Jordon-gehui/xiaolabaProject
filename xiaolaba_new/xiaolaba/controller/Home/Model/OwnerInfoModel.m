//
//  OwnerInfoModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "OwnerInfoModel.h"

@implementation OwnerInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (NSString *)img {
    if([_img containsString:@"http"]) {
        return _img;
    }
    return [NSString stringWithFormat:@"%@%@-circle",kImagePrefix,_img];
}

- (NSString *)serieImg {
    if([_serieImg containsString:@"http"]) {
        return _serieImg;
    }
    return [NSString stringWithFormat:@"%@%@",kImagePrefix,_serieImg];
}

- (NSString *)brandImg {
    if([_brandImg containsString:@"http"]) {
        return _brandImg;
    }
    return [NSString stringWithFormat:@"%@%@",kImagePrefix,_brandImg];
}


- (NSArray <NSString *>*)pick {
    
    NSMutableArray <NSString *>*cars = [NSMutableArray array];
    [_pick enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //        NSString *n = [NSString stringWithFormat:@"%@%@",kImagePrefix,obj];
        [cars addObject:obj];
    }];
    return cars;
}

- (NSString *)picks {
    
    NSArray <NSString *>*array = [_picks componentsSeparatedByString:@","];
    NSMutableString *string = [NSMutableString string];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(idx == array.count - 1) {
            [string appendFormat:@"%@",[JXutils judgeImageheader:obj Withtype:IMGMoment]];
        }else {
            [string appendFormat:@"%@,",[JXutils judgeImageheader:obj Withtype:IMGMoment]];
        }
    }];
    return string;
}

- (NSString *)signature {
    
    if(kNotNil(_signature)) {
        return _signature;
    }
    return @"";
}


@end
