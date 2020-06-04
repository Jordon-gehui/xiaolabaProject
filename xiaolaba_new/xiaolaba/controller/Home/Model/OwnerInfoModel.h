//
//  OwnerInfoModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface OwnerInfoModel : NSObject

@property (nonatomic, copy) NSString *age; // 年龄
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSString *brandImg; //

@property (nonatomic, strong) NSNumber *followers; // 粉丝数
@property (nonatomic, strong) NSNumber *follows; // 关注数
@property (nonatomic, strong) NSNumber *friends; // 好友数
@property (nonatomic, strong) NSNumber *ID; // id
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *phone; // 手机
@property (nonatomic, copy) NSString *serieImg; // 车标
@property (nonatomic, copy) NSString *serieName; // 车标名称

@property (nonatomic, strong) NSNumber *sex; // 性别
@property (nonatomic, copy) NSString *signature; // 签名
@property (nonatomic, strong) NSNumber *sound; // 铃声模式 0:关闭1:开启
@property (nonatomic, strong) NSNumber *status; // 户认证状态(0登录注册/10完善信息/20认证申请/30认证通 过/40认证拒绝)
@property (nonatomic, strong) NSArray <NSString *>*pick; // 背景图
@property (nonatomic, copy) NSString *picks; // 精选图

@property (nonatomic, strong) NSArray <UserTagsModel *>*tags; // 标签



@end
