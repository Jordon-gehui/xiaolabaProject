//
//  FaceListModel.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/27.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "FaceListModel.h"

@implementation FaceListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userID":@"id",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

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
@end

@implementation FaceWallListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userId":@"id",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end

@implementation VoiceActorListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"voiceId":@"id",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

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

@end

