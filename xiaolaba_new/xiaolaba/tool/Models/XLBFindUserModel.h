//
//  XLBFindUserModel.h
//  xiaolaba
//
//  Created by lin on 2017/7/15.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTagsModel.h"
@interface XLBFindUserModel : NSObject

@property (nonatomic, copy) NSString *city;             // 城市
@property (nonatomic, copy) NSString *district;         //  区
@property (nonatomic, copy) NSString *distance;         // 距离
@property (nonatomic, copy) NSString *ID;               // id
@property (nonatomic, copy) NSString *img;              // 用户头像（要拼接）
@property (nonatomic, copy) NSString *sex;              // 性别 1男 0女
@property (nonatomic, copy) NSString *latitude;         // 纬度
@property (nonatomic, copy) NSString *longitude;        // 经度
@property (nonatomic, copy) NSString *nickname;         // 用户昵称
@property (nonatomic, copy) NSString *raidus;           // 无用参数
@property (nonatomic, copy) NSString *signature;        // 签名
@property (nonatomic, copy) NSString *follows;          //是否 已关注1 未关注0
@property (nonatomic, copy) NSString *friends;          //是否 已是好友1 不是好友0
@property (nonatomic, strong) NSArray <UserTagsModel *>*tags; // 标签
@property (nonatomic, strong) NSArray <NSString *>*vehicleAreas; // 车标（要拼接）
@property (nonatomic, strong) NSArray <NSString *>*carimg;           // 整车图

@property (nonatomic, copy) NSString *serieImg; // 车系图
@property (nonatomic, copy) NSString *brandImg; // 车品牌图
@property (nonatomic, copy) NSString *picks; // 精选图

@property (nonatomic, copy) NSString *updateDate; //在线时间
@property (nonatomic, copy) NSString *liked; //是否点赞


@end


@class FindScreenDetailModel;
@interface FindScreenModel : NSObject
@property (nonatomic, copy) NSString *descr;
@property (nonatomic, strong) NSArray <FindScreenDetailModel *>*listDict;
@property (nonatomic, copy) NSString *type;
@end

@interface FindScreenDetailModel : NSObject
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *url;

@end

