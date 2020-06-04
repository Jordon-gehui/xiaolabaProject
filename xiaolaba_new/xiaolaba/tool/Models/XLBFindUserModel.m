//
//  XLBFindUserModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/15.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFindUserModel.h"

@implementation XLBFindUserModel

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

- (NSArray<NSString *> *)carimg {
    
    NSMutableArray <NSString *>*cars = [NSMutableArray array];
    [_carimg enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
            [string appendFormat:@"%@",obj];
        }else {
            [string appendFormat:@"%@,",obj];
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

- (NSArray<NSString *> *)vehicleAreas {
    
    NSMutableArray <NSString *>*areas = [NSMutableArray array];
    [_vehicleAreas enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *n = [NSString stringWithFormat:@"%@%@",kImagePrefix,obj];
        [areas addObject:n];
    }];
    return areas;
}

@end

@implementation FindScreenModel
@end
@implementation FindScreenDetailModel

- (NSString *)url {
    
    if(kNotNil(_url)) {
        return _url;
    }
    return @"";
}
@end
