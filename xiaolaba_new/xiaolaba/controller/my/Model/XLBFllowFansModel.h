//
//  XLBFllowFansModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFindUserModel.h"
@class FllowFansUserModel;

/**
 关注、粉丝模型
 */
@interface XLBFllowFansModel : NSObject

@property (nonatomic, copy) NSString *ID; // id
@property (nonatomic, copy) NSString *type; // 状态0:未关注1:已关注2:互相关注
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, strong) FllowFansUserModel *user;

@end

@interface FllowFansUserModel : NSObject

@property (nonatomic, copy) NSString *ID; // id
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *city; // 工作地
@property (nonatomic, strong) NSArray <UserTagsModel *>*tags; // 标签
@property (nonatomic, strong) NSArray <NSString *>*vehicleAreas; // 车标（要拼接）
@property (nonatomic, strong) NSArray <NSString *>*carimg; // 整车图

@end


@interface PraiseModel : NSObject

@property (nonatomic, copy) NSString *content; //消息内容
@property (nonatomic, copy) NSString *createDate; //时间
@property (nonatomic, copy) NSString *pushStatus; //状态
@property (nonatomic, copy) NSString *readStatus; //
@property (nonatomic, copy) NSString *remark; //
@property (nonatomic, copy) NSString *summary; // 消息摘要
@property (nonatomic, copy) NSString *title; //
@property (nonatomic, copy) NSString *nickname; //用户昵称
@property (nonatomic, copy) NSString *img; //用户头像
@property (nonatomic, copy) NSString *uid;//用户ID
@property (nonatomic, copy) NSString *initiatorId;//动态ID
@end





