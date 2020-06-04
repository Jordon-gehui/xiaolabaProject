//
//  XLBMeRequestModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarDetailModel.h"
#import "MsgNoticeModel.h"
#import "XLBSystemMsgModel.h"
#import "CallOrderModel.h"
#import "EarningsListModel.h"
@class XLBFllowFansModel;
@class XLBUser;
@class XLBMoveRecordsModel;
@class XLBSystemMsgModel;
@class XLBInviteModel;

@interface XLBMeRequestModel : NSObject

+ (void)requestCarDetail:(NSDictionary *)params success:(void(^)(NSArray <XLBCarDetailModel *>*cars))success failure:(void(^)(NSString *error))failure;

/**
 获取系统消息
 */
+ (void)requestSystemList:(NSDictionary *)params success:(void(^)(NSArray <XLBSystemMsgModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

/**
 获取粉丝和关注
 */
+ (void)requestFindFollowOrFocus:(BOOL )fans notice:(BOOL)notice params:(NSDictionary *)params success:(void(^)(NSArray <XLBFllowFansModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
/**
 获取邀请好友列表
 */
+ (void)requsetInviteFriendsParams:(NSDictionary *)params success:(void(^)(NSArray <XLBInviteModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
/**
 获取好友通知
 */

+ (void)requsetFriendsNotice:(BOOL)praise params:(NSDictionary *)params success:(void(^)(NSArray <MsgNoticeModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
/**
 获取评论点赞
 */
+ (void)requsetPraiseOrComment:(BOOL)praise params:(NSDictionary *)params success:(void(^)(NSArray <PraiseModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

/**
 获取点赞列表
 */
+ (void)requestPraiseListParams:(NSDictionary *)params success:(void(^)(NSArray *models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

/**
 获取反馈
 */
+ (void)requsetFeedBackList:(NSDictionary *)params success:(void(^)(NSArray *list))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
/**
 获取个人信息
 */
+ (void)requestInfo:(void(^)(XLBUser *user))success failure:(void(^)(NSString *error))failure;
/**
 修改个人信息
 */
+ (void)reviseInfo:(NSDictionary *)params error:(void(^)(NSString *error))error;
/**
 添加背景图
 */
+ (void)addsPicks:(NSDictionary *)params error:(void(^)(NSString *error))error;

/**
 更换手机号码
 */
+ (void)changePhone:(NSDictionary *)params error:(void(^)(NSString *error))error;

+ (void)requestMyMoveList:(NSDictionary *)params success:(void(^)(NSArray <XLBMoveRecordsModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
/**
 挪车通知列表
 */
+ (void)requestMoveCarNotList:(NSDictionary *)params success:(void(^)(NSArray <XLBMoveRecordsModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

/**
 发布挪车获取默认消息（label - value）
 */
+ (void)requestPublishMove:(void(^)(NSArray <NSDictionary *>*list))success failure:(void(^)(NSString *error))failure;

+ (void)publishMove:(NSDictionary *)params error:(void(^)(NSString *error))error;
/**
 识别行驶证
 */
+ (void)identify:(NSDictionary *)params success:(void(^)(NSDictionary *result))success failure:(void(^)(NSString *error))failure;
/**
 我的挪车贴
 */
+ (void)requestMeCarQRCode:(void(^)(NSArray<XLBMeCarQRCodeModel*>*list))success failure:(void(^)(NSString *error))failure;
/**
 获取车辆信息
 */
+ (void)requestCarInfo:(NSDictionary *)params success:(void(^)(NSArray <XLBMeCarDetailModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

/**
 获取订单记录
 */
+ (void)requestCallOrderInfo:(NSDictionary *)params isSY:(NSInteger)isSY success:(void(^)(NSArray <CallOrderModel *>*models))success failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;

/**
 获取充值明细，提现明细列表
 */

+ (void)requestPayDetail:(NSDictionary *)params isPay:(BOOL)isPay success:(void(^)(NSArray <EarningsListModel *>*models))success  recharge:(void(^)(NSString *recharge))recharge failure:(void(^)(NSString *error))failure more:(void(^)(BOOL more))more;
@end



