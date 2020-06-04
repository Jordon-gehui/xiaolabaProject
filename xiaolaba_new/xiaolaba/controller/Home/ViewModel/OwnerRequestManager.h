//
//  OwnerRequestManager.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorking.h"
#import "XLBOwnerModel.h"
#import "VoiceImpressModel.h"
@interface OwnerRequestManager : NSObject
/**
 获取车主主页
 */

+ (void)requestOwnerWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;

/**
 获取颜值墙
 */
+ (void)requestFaceParams:(NSDictionary *)params success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more total:(void(^)(int total))total;

/**
 获取总榜
 */
+ (void)requestFaceWallAllDataParams:(NSDictionary *)params isSY:(NSInteger)is_sy success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 获取日榜
 */
+ (void)requestFaceWallDayDataParams:(NSDictionary *)params isSY:(NSInteger)is_sy success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure;

/**
 获取声优
 */
+ (void)requestVoiceActorDataParams:(NSDictionary *)params success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more total:(void(^)(int total))total;

/**
 获取声优主页
 */

+ (void)requestVoiceActorOwnerWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;
/**
 拨打电话订单生成
 */

+ (void)requestCallPayWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;
/**
 心跳请求
 */

+ (void)requestCallPulseWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;

/**
 结束请求
 */
+ (void)requestCallEndWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;

/**
 结束请求
 */
+ (void)requestImprassWithParameter:(NSDictionary *)para success:(void(^)(VoiceImpressModel *model))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
@end
