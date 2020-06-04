//
//  MessageNetWorking.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MessageNetWorking.h"

@implementation MessageNetWorking
+ (void)requestFindList:(NSDictionary *)params success:(void(^)(NSArray *))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more {
    NSString *url = kFindAnon;
    if([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        url = kFindCondition;
    }
    [[NetWorking network] POST:url params:params cache:YES success:^(id result) {
        
        NSMutableArray <XLBFindUserModel *>*dataSource = [NSMutableArray array];
        NSArray <NSDictionary *>*list = [result objectForKey:@"list"];
        NSLog(@"\n\n>>>%li",list.count);
        [list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            XLBFindUserModel *model = [XLBFindUserModel mj_objectWithKeyValues:obj];
            model.ID = [obj objectForKey:@"id"];
            NSMutableArray *tags = [NSMutableArray array];
            [[obj objectForKey:@"tags"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
                [tags addObject:tag];
            }];
            model.tags = tags;
            [dataSource addObject:model];
        }];
        BOOL hasMore = [[result objectForKey:@"next"] boolValue];
        more(hasMore);
        success(dataSource);
        
    } failure:^(NSString *description) {
        failure(description);
    }];
}

+ (void)requestFindScreenCondition:(void(^)(NSArray *result))success failure:(void(^)(NSString *error))failure {
    
    [[NetWorking network] POST:kScreening params:nil cache:YES success:^(id result) {
        NSMutableArray *dataSource = [NSMutableArray array];
        NSLog(@"%@",result);
        NSArray *data = (NSArray *)result;
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            FindScreenModel *model = [FindScreenModel mj_objectWithKeyValues:obj];
            model.descr = [[obj allKeys] containsObject:@"description"] ? [obj objectForKey:@"description"]:@"";
            NSMutableArray *listDict = [NSMutableArray array];
            [[obj objectForKey:@"listDict"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                FindScreenDetailModel *list = [FindScreenDetailModel mj_objectWithKeyValues:obj];
                [listDict addObject:list];
            }];
            model.listDict = listDict;
            [dataSource addObject:model];
        }];
        success(dataSource);
        
    } failure:^(NSString *description) {
        failure(description);
    }];
}
@end
