//
//  XLBCarBrandHandleModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/20.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarBrandModel.h"
#import "XLBFindUserModel.h"

@interface XLBCarBrandHandleModel : NSObject

+ (void)requestCarBrand:(void(^)(NSArray <NSString *>*indexs, NSArray <NSArray <XLBCarBrandModel *>*>*models))success failure:(void(^)(NSError *error))failure;

@end
