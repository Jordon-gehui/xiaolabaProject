//
//  MessageNetWorking.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "NetWorking.h"

@interface MessageNetWorking : NetWorking

//寻车友
+ (void)requestFindList:(NSDictionary *)params success:(void(^)(NSArray *))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

//筛选条件
+ (void)requestFindScreenCondition:(void(^)(NSArray *result))success failure:(void(^)(NSString *error))failure;
@end
