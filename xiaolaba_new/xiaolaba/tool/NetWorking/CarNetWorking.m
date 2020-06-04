//
//  CarNetWorking.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "CarNetWorking.h"

@implementation CarNetWorking

+ (void)requestHomeMomentList:(NSDictionary *)params success:(void(^)(NSArray <NSString *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more{
    [[NetWorking network] POST:kHomeList params:params cache:NO success:^(NSDictionary* result) {
        NSLog(@"---------------------------  动态列表  %@",result);
        NSArray *array = [NSString mj_objectWithKeyValues:result[@"list"]];
        BOOL hasMore = [[result objectForKey:@"next"] boolValue];
        more(hasMore);
        success(array);
        
    } failure:^(NSString *description) {
        failure(description);
    }];
    
}


@end
