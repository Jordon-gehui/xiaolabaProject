//
//  XLBUser.m
//  xiaolaba
//
//  Created by lin on 2017/6/29.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBUser.h"
#import "SFHFKeychainUtils.h"

static NSString *kAppVersion = @"appVersion";
static NSString *UseKey = @"userKey";
static NSString *BannersKey = @"bannersKey";
static NSString *IsWeChatLogin = @"isWeChatLogin";
static NSString *LocationKey = @"locationKey";

static NSString *DeviceNoKey = @"deviceNoKey";
static NSString *WeixinIdKey = @"weixinIdKey";
static NSString *openIdKey = @"openIdKey";

static NSString *WeiboIdKey = @"weiboIdKey";
static NSString *TokenKey = @"tokenKey";
static NSString *AppKey = @"appKey";
static NSString *PublicKey = @"publicKey";
static NSString *LongitudeKey = @"longitudeKey";
static NSString *LatitudeKey = @"latitudeKey";
static NSString *CountryKey = @"countryKey";
static NSString *ProvinceKey = @"provinceKey";
static NSString *CityKey = @"cityKey";
static NSString *SubLocalityKey = @"subLocalityKey";

static NSString *IsloginKey = @"isloginKey";

static NSString *ApiCacheKey = @"apiCacheKey";

static NSString *ShaiXuanKey = @"suanXuanKey";

static NSString *CarSeableKey = @"carSeableKey";

static NSString *CarAge = @"carAgeKey";

static NSString *OtherKey = @"otherKey";


@interface XLBUser ()

@end

@implementation XLBUser

+ (instancetype)user {
    
    static XLBUser *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        user = [[self.class alloc] init];
    });
    return user;
}

- (void)setUserModel:(XLBUserModel *)userModel {
    
    NSString *json = [userModel mj_JSONString];
    if(kNotNil(json)) {
        [[XLBCache cache] store:json key:UseKey];
    }
}


- (XLBUserModel *)userModel {
    
    NSString *json = [[XLBCache cache] cache:UseKey];
    if(kNotNil(json)) {
        XLBUserModel *user = [XLBUserModel mj_objectWithKeyValues:json];
        
        NSMutableArray *tags = [NSMutableArray array];
        [user.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UserTagsModel *tag = [UserTagsModel mj_objectWithKeyValues:obj];
            [tags addObject:tag];
        }];
        user.tags = tags;
        return user;
    }
    return [[XLBUserModel alloc] init];
}

- (void)setBannersArray:(NSArray *)bannersArray {
    
    if(kNotNil(bannersArray)) {
        [[XLBCache cache] store:bannersArray key:BannersKey];
    }
}

- (NSArray *)bannersArray {
    
    if(kNotNil([[XLBCache cache] cache:BannersKey])) {
        return [[XLBCache cache] cache:BannersKey];
    }
    return nil;
}

- (void)setIsWeChatLogin:(BOOL)isWeChatLogin {
    
    [[XLBCache cache] store:@(isWeChatLogin) key:IsWeChatLogin];
}

- (BOOL)isWeChatLogin {
    
    return [[[XLBCache cache] cache:IsWeChatLogin] boolValue];
}

- (void)setDeviceNo:(NSString *)deviceNo {
    
    if(kNotNil(deviceNo)) {
        [[XLBCache cache] store:deviceNo key:DeviceNoKey];
    }
}

- (NSString *)deviceNo {
    
    if(kNotNil([[XLBCache cache] cache:DeviceNoKey])) {
        return [[XLBCache cache] cache:DeviceNoKey];
    }
    return @"";
}

- (void)setWeixinId:(NSString *)weixinId {
    
    if(kNotNil(weixinId)) {
        [[XLBCache cache] store:weixinId key:WeixinIdKey];
    }
}

- (NSString *)weixinId {
    
    if(kNotNil([[XLBCache cache] cache:WeixinIdKey])) {
        return [[XLBCache cache] cache:WeixinIdKey];
    }
    return @"";
}

- (void)setOpenId:(NSString *)openId {
    
    if(kNotNil(openId)) {
        [[XLBCache cache] store:openId key:openIdKey];
    }
}

- (NSString *)openId {
    
    if(kNotNil([[XLBCache cache] cache:openIdKey])) {
        return [[XLBCache cache] cache:openIdKey];
    }
    return @"";
}

- (void)setWeiboId:(NSString *)weiboId {
    if (kNotNil(weiboId)) {
        [[XLBCache cache] store:weiboId key:WeiboIdKey];
    }
}

- (NSString *)weiboId {
    
    if(kNotNil([[XLBCache cache] cache:WeiboIdKey])) {
        return [[XLBCache cache] cache:WeiboIdKey];
    }
    return @"";
}

- (void)setToken:(NSString *)token {
    
    if(kNotNil(token)) {
        [[XLBCache cache] store:token key:TokenKey];
    }
}

- (NSString *)token {
    
    if(kNotNil([[XLBCache cache] cache:TokenKey])) {
        return [[XLBCache cache] cache:TokenKey];
    }
    return @"";
}

- (void)setAppId:(NSString *)appId {
    
    if(kNotNil(appId)) {
        [[XLBCache cache] store:appId key:AppKey];
    }
}

- (NSString *)appId {
    
    if(kNotNil([[XLBCache cache] cache:AppKey])) {
        return [[XLBCache cache] cache:AppKey];
    }
    return @"";
}

- (void)setPublicKey:(NSString *)publicKey {
    if(kNotNil(publicKey)) {
        [[XLBCache cache] store:publicKey key:PublicKey];
    }
}

- (NSString *)publicKey {
    if (kNotNil([[XLBCache cache] cache:PublicKey])) {
        return [[XLBCache cache] cache:PublicKey];
    }
    return @"";
}

- (void)setShaiXuanKey:(NSDictionary *)shaiXuanKey{
    
    if(kNotNil(shaiXuanKey)) {
        [[XLBCache cache] store:shaiXuanKey key:ShaiXuanKey];
    }
}

- (NSDictionary *)shaiXuanKey {
    
    if(kNotNil([[XLBCache cache] cache:ShaiXuanKey])) {
        return [[XLBCache cache] cache:ShaiXuanKey];
    }
    return nil;
}

- (void)setCarSeable:(NSDictionary *)carSeable {
    if(kNotNil(carSeable)) {
        [[XLBCache cache] store:carSeable key:CarSeableKey];
    }
}
- (NSDictionary *)carSeable {
    if(kNotNil([[XLBCache cache] cache:CarSeableKey])) {
        return [[XLBCache cache] cache:CarSeableKey];
    }
    return nil;
}

- (void)setOther:(NSDictionary *)other {
    if(kNotNil(other)) {
        [[XLBCache cache] store:other key:OtherKey];
    }
}

- (NSDictionary *)other {
    if(kNotNil([[XLBCache cache] cache:OtherKey])) {
        return [[XLBCache cache] cache:OtherKey];
    }
    return nil;
}


- (void)setCarAge:(NSDictionary *)carAge {
    
    if(kNotNil(carAge)) {
        [[XLBCache cache] store:carAge key:CarAge];
    }
}

- (NSDictionary *)carAge {
    
    if(kNotNil([[XLBCache cache] cache:CarAge])) {
        return [[XLBCache cache] cache:CarAge];
    }
    return nil;
}

- (void)setLocation:(NSString *)location {
    
    if(kNotNil(location)) {
        [[XLBCache cache] store:location key:LocationKey];
    }
}

- (NSString *)location {
    
    if([[XLBCache cache] cache:LocationKey]) {
        return [[XLBCache cache] cache:LocationKey];
    }
    return @"";
}

- (void)setLongitude:(NSString *)Longitude {
    
    if(kNotNil(Longitude)) {
        [[XLBCache cache] store:Longitude key:LongitudeKey];
    }
}

- (NSString *)longitude {
    
    if([[XLBCache cache] cache:LongitudeKey]) {
        return [[XLBCache cache] cache:LongitudeKey];
    }
    return @"";
}

- (void)setLatitude:(NSString *)Latitude {
    
    if(kNotNil(Latitude)) {
        [[XLBCache cache] store:Latitude key:LatitudeKey];
    }
}

- (NSString *)latitude {
    
    if([[XLBCache cache] cache:LatitudeKey]) {
        return [[XLBCache cache] cache:LatitudeKey];
    }
    return @"";
}

- (void)setCountry:(NSString *)Country {
    
    if(kNotNil(Country)) {
        [[XLBCache cache] store:Country key:CountryKey];
    }
}

- (NSString *)country {
    
    if([[XLBCache cache] cache:CountryKey]) {
        return [[XLBCache cache] cache:CountryKey];
    }
    return @"";
}
- (void)setProvince:(NSString *)province {
    
    if(kNotNil(province)) {
        [[XLBCache cache] store:province key:ProvinceKey];
    }
}

- (NSString *)province {
    
    if([[XLBCache cache] cache:ProvinceKey]) {
        return [[XLBCache cache] cache:ProvinceKey];
    }
    return @"";
}
- (void)setCity:(NSString *)city {
    
    if(kNotNil(city)) {
        [[XLBCache cache] store:city key:CityKey];
    }
}

- (NSString *)city {
    
    if([[XLBCache cache] cache:CityKey]) {
        return [[XLBCache cache] cache:CityKey];
    }
    return @"";
}
- (void)setSubLocality:(NSString *)subLocality{
    
    if(kNotNil(subLocality)) {
        [[XLBCache cache] store:subLocality key:SubLocalityKey];
    }
}

- (NSString *)subLocality {
    
    if([[XLBCache cache] cache:SubLocalityKey]) {
        return [[XLBCache cache] cache:SubLocalityKey];
    }
    return @"";
}
- (CLLocationCoordinate2D)location2D {
    
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (void)setIsLogin:(BOOL)isLogin {
    
    [[XLBCache cache] store:@(isLogin) key:IsloginKey];
}

- (BOOL)isLogin {
    
    return [[[XLBCache cache] cache:IsloginKey] boolValue];
}

- (void)setupThirdData:(id )response weChat:(BOOL)weChat {
    
    if(weChat) {
        /*
         city = "";
         country = CN;
         headimgurl = "http://wx.qlogo.cn/mmopen/BuAtQhyDJ3LDwFQia0IsjctOTxhIz0LJDrZvGo4WvoXfGbN916fceOF8ica9jhG3eicPxPQzeKNGzIW41U00T0WiaU05aeBagFfO/0";
         language = "zh_CN";
         nickname = "\U5496\U55b1luya";
         openid = "oGkkpwGl8Oz8B5IVmxkg039_3FlY";
         privilege =     (
         );
         province = "";
         sex = 1;
         unionid = ojw3P1dJTTQMpifCj0t72w35Tc8U;
         */
        
        self.isWeChatLogin = YES;
        XLBUserModel *model = [XLBUserModel mj_objectWithKeyValues:response];
        if([[response allKeys] containsObject:@"unionid"]) {
            self.weixinId = [response objectForKey:@"unionid"];
        }
        if([[response allKeys] containsObject:@"openid"]) {
            self.openId = [response objectForKey:@"openid"];
        }
        if([[response allKeys] containsObject:@"headimgurl"]) {
            //_third_headimgurl = [response objectForKey:@"headimgurl"];
        }
        if([[response allKeys] containsObject:@"nickname"]) {
            //_third_nickname = [response objectForKey:@"nickname"];
        }
        if([[response allKeys] containsObject:@"sex"]) {
            //_third_sex = [[response objectForKey:@"sex"] integerValue] == 0 ? @"女":@"男";
        }
        [self setUserModel:model];
        NSLog(@"%@",[XLBUser user].userModel);
    }
    else {
        /*
         "allow_all_act_msg" = 0;
         "allow_all_comment" = 1;
         "avatar_hd" = "http://tvax3.sinaimg.cn/default/images/default_avatar_male_180.gif";
         "avatar_large" = "http://tvax3.sinaimg.cn/default/images/default_avatar_male_180.gif";
         "bi_followers_count" = 0;
         "block_app" = 0;
         "block_word" = 0;
         city = 1000;
         class = 1;
         "created_at" = "Wed Feb 17 12:39:36 +0800 2016";
         "credit_score" = 80;
         description = "";
         domain = "";
         "favourites_count" = 0;
         "follow_me" = 0;
         "followers_count" = 1;
         following = 0;
         "friends_count" = 43;
         gender = m;
         "geo_enabled" = 1;
         id = 5861704214;
         idstr = 5861704214;
         insecurity =     {
         "sexual_content" = 0;
         };
         lang = "zh-cn";
         like = 0;
         "like_me" = 0;
         location = "\U5176\U4ed6";
         mbrank = 0;
         mbtype = 0;
         name = "\U7528\U62375861704214";
         "online_status" = 0;
         "pagefriends_count" = 0;
         "profile_image_url" = "http://tvax3.sinaimg.cn/default/images/default_avatar_male_50.gif";
         "profile_url" = "u/5861704214";
         province = 100;
         ptype = 0;
         remark = "";
         "screen_name" = "\U7528\U62375861704214";
         star = 0;
         status =     {
         annotations =         (
         {
         "client_mblogid" = "iPhone-C2926C8C-9573-4D25-8EC7-4906BBEE9576";
         shooting = 1;
         },
         {
         "mapi_request" = 1;
         }
         );
         "attitudes_count" = 0;
         "biz_feature" = 0;
         "comment_manage_info" =         {
         "approval_comment_type" = 0;
         "comment_permission_type" = "-1";
         };
         "comments_count" = 0;
         "created_at" = "Wed Oct 25 10:56:58 +0800 2017";
         "darwin_tags" =         (
         );
         favorited = 0;
         geo = "<null>";
         "gif_ids" = "";
         hasActionTypeCard = 0;
         "hot_weibo_tags" =         (
         );
         id = 4166691871736540;
         idstr = 4166691871736540;
         "in_reply_to_screen_name" = "";
         "in_reply_to_status_id" = "";
         "in_reply_to_user_id" = "";
         isLongText = 0;
         "is_paid" = 0;
         "is_show_bulletin" = 2;
         "mblog_vip_type" = 0;
         mid = 4166691871736540;
         mlevel = 0;
         "more_info_type" = 0;
         "pending_approval_count" = 0;
         "pic_urls" =         (
         );
         "positive_recom_flag" = 0;
         "reposts_count" = 0;
         source = "<a href=\"http://app.weibo.com/t/feed/6q7EPL\" rel=\"nofollow\">\U672a\U901a\U8fc7\U5ba1\U6838\U5e94\U7528</a>";
         "source_allowclick" = 0;
         "source_type" = 1;
         text = "\U9707\U60ca\Uff01\Uff01\Uff01\U5434\U5f66\U7956\U90fd\U5728\U7528\U7684App\Uff01\Uff01\Uff01";
         textLength = 33;
         "text_tag_tips" =         (
         );
         truncated = 0;
         userType = 0;
         visible =         {
         "list_id" = 0;
         type = 0;
         };
         };
         "statuses_count" = 9;
         "story_read_state" = "-1";
         urank = 1;
         url = "";
         "user_ability" = 0;
         "vclub_member" = 0;
         verified = 0;
         "verified_reason" = "";
         "verified_reason_url" = "";
         "verified_source" = "";
         "verified_source_url" = "";
         "verified_trade" = "";
         "verified_type" = "-1";
         weihao = "";
         */
        NSLog(@"%@",response);
        self.isWeChatLogin = YES;
        XLBUserModel *model = [XLBUserModel mj_objectWithKeyValues:response];
        if([[response allKeys] containsObject:@"weiboUid"]) {
            self.weiboId = [response objectForKey:@"weiboUid"];
        }
        if([[response allKeys] containsObject:@"headimgurl"]) {
            //_third_headimgurl = [response objectForKey:@"headimgurl"];
        }
        if([[response allKeys] containsObject:@"nickname"]) {
            //_third_nickname = [response objectForKey:@"nickname"];
        }
        if([[response allKeys] containsObject:@"sex"]) {
            //_third_sex = [[response objectForKey:@"sex"] integerValue] == 0 ? @"女":@"男";
        }
        [self setUserModel:model];
    }
}

- (NSString *)em_username {
    return [[XLBCache cache] cache:@"em_username"];
}

- (NSString *)em_password {
    return [SFHFKeychainUtils getPasswordForUsername:self.em_username andServiceName:@"xiaolaba" error:nil];
}

- (void)storeEmUser:(NSString *)username passwprd:(NSString *)password {
    
    if(kNotNil(username) && kNotNil(password)) {
        [[XLBCache cache] store:username key:@"em_username"];
        [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"xiaolaba" updateExisting:NO error:nil];
    }
}

- (void)logout {
    [SFHFKeychainUtils deleteItemForUsername:self.em_username andServiceName:@"xiaolaba" error:nil];
    [[XLBCache cache] removeAllCache];
    NSLog(@"token=status = %@--%@",[XLBUser user].token,[XLBUser user].userModel.status);
}
+ (NSString *)getAppVersion {
    return [[XLBCache cache] cache:kAppVersion];
}
    
+ (void)setAppVersion: (NSString *)version {
    [[XLBCache cache] store:version key:kAppVersion];
}

@end







