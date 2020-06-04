//
//  XLBCarBrandHandleModel.m
//  xiaolaba
//
//  Created by lin on 2017/7/20.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarBrandHandleModel.h"
#import "BQLChineseString.h"

@implementation XLBCarBrandHandleModel

+ (void)requestCarBrand:(void(^)(NSArray <NSString *>*indexs, NSArray <NSArray <XLBCarBrandModel *>*>*models))success failure:(void(^)(NSError *error))failure {
    
    [[NetWorking network] POST:kBrands params:nil cache:NO success:^(id result) {
        
        NSArray *data = (NSArray *)result;
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *all = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBCarBrandModel *model = [XLBCarBrandModel mj_objectWithKeyValues:obj];
            model.numberID = [obj objectForKey:@"id"];
            [array addObject:model.spell];
            [all addObject:model];
        }];
        NSArray *indexsArray = [BQLChineseString IndexArray:array];
        NSArray *lettersArray = [BQLChineseString LetterSortArray:array];
        NSArray *modelsArray = [self carBrandModels:lettersArray all:all];
        success(indexsArray,modelsArray);
        
    } failure:^(NSString *description) {
        
        failure(nil);
    }];
}

+ (NSArray <NSArray <XLBCarBrandModel *>*>*)carBrandModels:(NSArray <NSArray *>*)letters
                                                       all:(NSArray <XLBCarBrandModel *>*)all {
    
    NSMutableArray *lettersArray = [NSMutableArray array];
    [letters enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableArray *items = [NSMutableArray array];
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *spell = obj;
            [all enumerateObjectsUsingBlock:^(XLBCarBrandModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if([obj.spell isEqualToString:spell]) {
                    
                    [items addObject:obj];
                    *stop = YES;
                }
            }];
        }];
        [lettersArray addObject:items];
    }];
    return lettersArray;
}

@end






