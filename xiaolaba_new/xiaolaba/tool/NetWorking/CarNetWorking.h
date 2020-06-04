//
//  CarNetWorking.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/11.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "NetWorking.h"

@interface CarNetWorking : NetWorking

+ (void)requestHomeMomentList:(NSDictionary *)params success:(void(^)(NSArray <NSString *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

@end
