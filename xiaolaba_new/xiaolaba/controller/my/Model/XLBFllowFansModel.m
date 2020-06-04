//
//  XLBFllowFansModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFllowFansModel.h"

@implementation XLBFllowFansModel

@end

@implementation FllowFansUserModel

- (NSString *)img {
    
    return [NSString stringWithFormat:@"%@",_img];
}

- (NSArray<NSString *> *)carimg {
    
    NSMutableArray <NSString *>*cars = [NSMutableArray array];
    [_carimg enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *n = [NSString stringWithFormat:@"%@",obj];
        [cars addObject:n];
    }];
    return cars;
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


@implementation PraiseModel


@end
