//
//  XLBUser.h
//  xiaolaba
//
//  Created by lin on 2017/6/29.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XLBUserModel.h"

@interface XLBUser : NSObject

+ (instancetype)user;

#warning 如下
/**
 用户信息模型
 暂时不要使用如下方式修改属性值：
    [XLBUser user].userModel.nickname = @"bilibli";
 而应使用如下方式修改
    XLBUserModel *model = [XLBUser user].userModel;
    model.nickname = @"bilibli";
    [XLBUser user].userModel = model;
 
 */
@property (nonatomic, strong) XLBUserModel *userModel;


@property (nonatomic, strong) NSArray *bannersArray;

/**
 是否为微信登陆
 */
@property (nonatomic, assign) BOOL isWeChatLogin;

/**
 设备唯一标识（极光推送）
 */
@property (nonatomic, copy) NSString *deviceNo;

/**
 登陆标识
 */
@property (nonatomic, copy) NSString *token;

/**
 app标识
 */
@property (nonatomic, copy) NSString *appId;

/**
 key标识
 */
@property (nonatomic, copy) NSString *publicKey;

#pragma mark - 声优相关

@property (nonatomic, copy) NSString *imgAkira;//声优认证照片

@property (nonatomic, copy) NSString *imgStatus;//图片认证状态:0未认证 ,1审核中,2未通过,3已通过

@property (nonatomic, copy) NSString *voiceAkira;//声优认证语音

@property (nonatomic, copy) NSString *voiceStatus;//图片认证状态:0未认证 ,1审核中,2未通过,3已通过

@property (nonatomic, copy) NSString *priceAkira;//声优价格:车币/分钟

@property (nonatomic, copy) NSString *onlineType;//在线类型:0不在线,1忙碌,2在线

@property (nonatomic, copy) NSString *type; //类型备用字段

@property (nonatomic, copy) NSString *status;//0未认证 ,1审核中,2未通过,3已通过

//----------------------------------------

/**
 筛选年龄缓存
 */
@property (nonatomic, copy) NSDictionary *shaiXuanKey;
/**
 筛选车品牌缓存
 */

@property (nonatomic, copy) NSDictionary *carSeable;

/**
 筛选其他条件缓存
 */
@property (nonatomic, copy) NSDictionary *other;

/**
 筛选年龄缓存
 */
@property (nonatomic, copy) NSDictionary *carAge;
/**
 微信登陆唯一标识
 */
@property (nonatomic, copy) NSString *weixinId;

/**
 微信登陆openid
 */
@property (nonatomic, copy) NSString *openId;
/**
 微博登陆唯一标识
 */
@property (nonatomic, copy) NSString *weiboId;
/**
 地理位置
 */
@property (nonatomic, copy) NSString *location;

/**
 经度
 */
@property (nonatomic, copy) NSString *longitude;

/**
 纬度
 */
@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *subLocality;


@property (nonatomic, readonly) CLLocationCoordinate2D location2D;

// 环信登录名及密码
@property (nonatomic, copy, readonly) NSString *em_username;
@property (nonatomic, copy, readonly) NSString *em_password;
- (void)storeEmUser:(NSString *)username passwprd:(NSString *)password;

/**
 是否已登录
 */
@property (nonatomic, assign) BOOL isLogin;

/**
 配置第三方登录获取到的信息

 @param response 回调信息
 @param weChat   是否为微信登陆回调
 */
- (void)setupThirdData:(id )response weChat:(BOOL)weChat;


- (void)logout;
    
+ (NSString *)getAppVersion;
    
+ (void)setAppVersion: (NSString *)version;

@end







