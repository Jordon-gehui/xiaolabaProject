//
//  XLBUserModel.h
//  xiaolaba
//
//  Created by lin on 2017/8/9.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFindUserModel.h"

@interface XLBUserModel : NSObject

@property (nonatomic, copy) NSString *birthdate; // 年龄
@property (nonatomic, copy) NSString *city;// 城市
@property (nonatomic, copy) NSString *domicile;// 住宅
@property (nonatomic, strong) NSNumber *followers; // 粉丝数
@property (nonatomic, strong) NSNumber *follows; // 关注数
@property (nonatomic, strong) NSNumber *friends; // 好友数
@property (nonatomic, strong) NSNumber *ID; // id
@property (nonatomic, copy) NSString *img; // 头像
@property (nonatomic, copy) NSString *messageReminder; // 挪车信息通知模式 0:关闭1:开启
@property (nonatomic, copy) NSString *nickname; // 昵称
@property (nonatomic, copy) NSString *phone; // 手机
@property (nonatomic, strong) NSNumber *sex; // 性别
@property (nonatomic, copy) NSString *signature; // 签名
@property (nonatomic, strong) NSNumber *sound; // 铃声模式 0:关闭1:开启
@property (nonatomic, strong) NSNumber *status; // 户认证状态(0登录注册/10完善信息/20认证申请/30认证通 过/40认证拒绝)
@property (nonatomic, strong) NSNumber *addressbook;// 允许通讯录找到我开关
@property (nonatomic, strong) NSNumber *allowMicroblog;//允许通过微博找到我开关
@property (nonatomic, strong) NSArray *pick; // 背景图
@property (nonatomic, strong) NSNumber *weiboId; // 微博认证状态0：未认证1：已认证
@property (nonatomic, strong) NSNumber *weixinId; // 微信认证状态0：未认证1：已认证
@property (nonatomic, strong) NSArray <UserTagsModel *>*tags; // 标签
@property (nonatomic, copy) NSString *headimgurl;



- (NSArray <NSString *>*)allKeys;

@end


