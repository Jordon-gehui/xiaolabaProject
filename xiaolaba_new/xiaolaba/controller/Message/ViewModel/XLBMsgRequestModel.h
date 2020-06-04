//
//  XLBMsgRequestModel.h
//  xiaolaba
//
//  Created by lin on 2017/8/10.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFriendModel.h"
#import "XLBSessionModel.h"
#import "GroupMemberModel.h"
#import "XLBGroupModel.h"
@interface XLBMsgRequestModel : NSObject

+ (void)requestMyFriendWithfriendLike:(NSString*)likeStr type:(NSString *)type menberList:(NSArray *)menberList :(void(^)(NSArray <NSString *>*indexs,NSArray <NSArray <XLBFriendModel *>*>*models))success failure:(void(^)(NSString *error))failure;

+ (void)requestSessionUserId:(NSString *)userIds groupIds:(NSString *)groupIds
                     session:(NSArray <XLBSessionModel *>*)sessions
                     success:(void(^)(NSMutableArray <XLBSessionModel *>*modes))success
                     failure:(void(^)(NSString *error))failure;

+ (void)requestSessionUserId:(NSString *)userIds
                      admins:(NSArray *)admins type:(NSString *)type
                     success:(void(^)(NSMutableArray <GroupMemberModel *>*modes))success groupMenberList:(void(^)(NSArray <NSString *>*indexs,NSArray <NSArray <GroupMemberModel *>*>*models))groupMenberList
                     failure:(void(^)(NSString *error))failure;

+ (void)requestGroupModelWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;

+ (void)requestGroupListWithParameter:(NSDictionary *)para success:(void(^)(id respones))success error:(void(^)(id error))error;

@end
