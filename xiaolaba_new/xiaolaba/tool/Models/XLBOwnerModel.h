//
//  XLBOwnerModel.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBOwnerModel : NSObject

@property (nonatomic, copy) NSString *age; // 年龄
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSString *brandImg; //
@property (nonatomic, copy) NSString *domicile; // 城市
@property (nonatomic, copy) NSString *follows; // 关注
@property (nonatomic, copy) NSString *friends; // 好友数
@property (nonatomic, copy) NSString *ID; // id
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *phone; // 手机
@property (nonatomic, copy) NSString *serieImg; // 车标
@property (nonatomic, copy) NSString *serieName; // 车标名称
@property (nonatomic, copy) NSString *deviceNo; // 是否显示挪车按钮
@property (nonatomic, copy) NSString *likeSum;
@property (nonatomic, copy) NSString *liked;

@property (nonatomic, copy) NSString *sex; // 性别
@property (nonatomic, copy) NSString *signature; // 签名
@property (nonatomic, strong) NSNumber *sound; // 铃声模式 0:关闭1:开启
@property (nonatomic, strong) NSString *messageReminder; //挪车信息通知模式 0：关闭1：开启需要验证
@property (nonatomic, strong) NSNumber *status; // 户认证状态(0登录注册/10完善信息/20认证申请/30认证通 过/40认证拒绝)
@property (nonatomic, strong) NSArray <NSString *>*pick; // 背景图
@property (nonatomic, copy) NSString *picks; // 精选图

@property (nonatomic, strong) NSArray *moments;//动态图

@property (nonatomic, copy) NSString *momentCount;
@property (nonatomic, copy) NSString *momentsImg;
@property (nonatomic, strong) NSArray <UserTagsModel *>*tags; // 标签


@end



@interface XLBVoiceActorModel : NSObject

@property (nonatomic, strong) NSArray *visitorArr;
@property (nonatomic, strong) XLBOwnerModel *user;
@property (nonatomic, strong) UserAkiraModel *akiraModel;
@property (nonatomic, strong) UserAkiraCountModel *akiraCountModel;


@end


