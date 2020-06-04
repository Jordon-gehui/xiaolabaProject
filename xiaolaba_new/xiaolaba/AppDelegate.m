//
//  AppDelegate.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstLaunchPage.h"
#import "RootTabbarController.h"
#import <Hyphenate/Hyphenate.h>
#import "EaseSDKHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XLBEaseMobManager.h"
#import "XLBLocation.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "XLBLoginViewController.h"
#import <WXApi.h>
#import <IMessageModel.h>
#import "XLBNoticeViewController.h"
#import "XLBMoveCarNoticeViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Hyphenate/EMMessage.h>
#import "XLBMsgNotifitionViewController.h"
#import "XLBPraiseListController.h"
#import "XLBMsgSystemViewController.h"
#import "XLBMessageViewController.h"
#import "NetMsgTablePage.h"
#import "XLBMoveRecordsModel.h"
#import "XLBChatViewController.h"
#import "BaseWebViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LittleHornViewController.h"
#import "WithdrawViewController.h"
#import "XLBAccountDetailViewController.h"
#import "LittleHornTableViewModel.h"
#import "PayCheTieViewController.h"
#import "XLBSuccessQRViewController.h"
#import "CarOrderViewController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "JPUSHService.h"

static NSString *const JPUSHAPPKEY = @""; // 极光appKey
static NSString *const channel = @"Publish channel"; // 固定的
static NSString *const EMCAppkey = @""; //环信appkey
static NSString *const UMAppkey = @""; //友盟appkey

#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
static NSString *const EMCcerName = @""; // 环信
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
static NSString *const EMCcerName = @""; //  环信

#endif
static NSString *const VersionsKey = @"VersionsKey"; //

static const CGFloat kDefaultPlaySoundInterval = 3.0;


@interface AppDelegate () <JPUSHRegisterDelegate,EMChatManagerDelegate,UITabBarControllerDelegate,UIAlertViewDelegate,EMGroupManagerDelegate>
{
    NSMutableArray *messageList;
    NSString *moveCarId;
    NSDictionary *isMoveDic;
    UILabel *tipTitleLbl;
    UILabel *tipContentLbl;
    NSString *versionsStr;
    NSString *remarkStr;
}
@property (nonatomic,strong)NSTimer *_vibrationTimer;
@property (nonatomic,strong)NSDate *lastPlaySoundDate;
@property (nonatomic,retain)FirstLaunchPage *flPage;
@property (nonatomic,strong)RootTabbarController *tbc;
@property (nonatomic,retain)UIButton *closeRemindBtn;
@property (nonatomic,retain)UIView *moveOverView;
//有挪车业务
@property (nonatomic,retain)UIView *moveCarTipView;
//发现新版本
@property (nonatomic,retain)UIView *versionsTipView;
@property (nonatomic,retain)UIButton *versionsCancleBtn;
@property (nonatomic, strong) NSMutableArray *distrubGroupList;
@end

@implementation AppDelegate

- (void)createTabBarController {
    if([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] isEqualToString:[XLBUser getAppVersion]]) {
        _tbc = [RootTabbarController sharedRootBar];
        [_tbc setDelegate:self];
        _tbc.selectedIndex = 0;
        self.window.rootViewController = _tbc;
        if([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
            [self performSelector:@selector(showMoveCarTipView) withObject:nil afterDelay:0.1];
        }
        [self performSelector:@selector(uploadVersions) withObject:nil afterDelay:2];

    }else {
        _flPage = [[FirstLaunchPage alloc] init];
        self.window.rootViewController = _flPage;
    }

    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //创建tabbar
    [self createTabBarController];
    [Fabric with:@[[Crashlytics class]]];

    //检测网络
    [self reachability];
    [WXApi registerApp:@"wxa1b81875f06907c4"];
    // 环信注册
    EMOptions *options = [EMOptions optionsWithAppkey:EMCAppkey];
    options.apnsCertName = EMCcerName;
    options.isAutoAcceptGroupInvitation = YES;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:EMCAppkey
                                         apnsCertName:EMCcerName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    // 登陆环信
    [XLBEaseMobManager xlbLoginEaseMob:^(NSError *error) {
        if (!error) {
            NSLog(@"auto环信登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            [[XLBCache cache] store:[[[EMClient sharedClient] contactManager] getBlackList] key:@"BlackList"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EaseMobIsLogin" object:nil];
        } else {
            NSLog(@"auto环信登录失败");
        }
    }];
    // 注册键盘
//    [IQKeyboardManager sharedManager].enable = YES;
    // 注册极光推送
    [self replyPushNotificationAuthorization:application options:launchOptions];
    // 获取地理信息
    XLBLocation *location = [XLBLocation location];
    [location getCurrentLocationComplete:^(NSDictionary *location) {
    }];
    // 启动百度服务
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    //启动地图引擎
//    UL8HlFe4cQA5CWUouZDaLri7iuUS7Elr
//    wViTGQrMtFVb0jXQTBEIMTGM
    BOOL success =  [manager start:@"UL8HlFe4cQA5CWUouZDaLri7iuUS7Elr" generalDelegate:nil];
    if (!success) {
        NSLog(@"失败");
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    messageList= [@[@"",@"",@""] mutableCopy];
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification != nil) {
        
        if (application.applicationState == UIApplicationStateActive) {
            [JPUSHService setBadge:0];
        }
        //本地通知处理
//        [self _operateLocalNotificationByUserInfo:userInfo];
        
    }
    //友盟统计
    UMConfigInstance.appKey = UMAppkey;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setLogEnabled:NO];
    
    
    return YES;
}

- (void)reachability{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可用");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
            // 登陆环信

            if(![EMClient sharedClient].isLoggedIn) {
                [XLBEaseMobManager xlbLoginEaseMob:^(NSError *error) {
                    if (!error) {
                        NSLog(@"环信登录成功");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"EaseMobIsLogin" object:nil];

                        [[XLBCache cache] store:[[[EMClient sharedClient] contactManager] getBlackList] key:@"BlackList"];
                    } else {
                        NSLog(@"环信登录失败");
                    }
                }];
            }
            
        }else
        {
            NSLog(@"没有网");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络失去连接" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
           
            
        }

    }];
    
    //通知页面及时处理

}

#pragma mark - 本地通知处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive) {
        [JPUSHService setBadge:0];
    }
    //对收到的信息 进行 符合自己业务的 操作
    NSLog(@"前台本地通知%@",userInfo);
//    [self _operateLocalNotificationByUserInfo:userInfo];
    
}

#pragma mark - 注册推送回调获取 DeviceToken
#pragma mark -- 成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 注册成功
    // 极光: Required - 注册 DeviceToken
    NSLog(@"注册deviceToken=%@",deviceToken);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark -- 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // 注册失败
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//应用处于前台时的远程推送接受
        
    } else {//应用处于前台时的本地推送接受
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);//
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // iOS7之后调用这个
    [JPUSHService handleRemoteNotification:userInfo];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0 && application.applicationState != UIApplicationStateActive) {
        // 程序在后台或者关闭状态 通过点击推送进来的会弹走这个方法
        // application.applicationState
        NSLog(@"iOS7、8、9系统，收到通知:%@",userInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"cs" userInfo:userInfo];
    }
    NSLog(@"后台本地通知%@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10程序在前台时收到的推送:%@",userInfo);
        UIViewController *topmostVC = [self topViewController];
        if([XLBUser user].isLogin
           && kNotNil([XLBUser user].token)
           &&![topmostVC isKindOfClass:[XLBMoveCarNoticeViewController class]]
           &&[[userInfo allKeys] containsObject:@"type"]) {

            if ([[userInfo objectForKey:@"type"] isEqualToString:@"6"]){
                moveCarId =[userInfo objectForKey:@"carId"];
                [self showMoveOverViewWithMoveCarID:moveCarId];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"cs" userInfo:userInfo];
            }

            if ([[userInfo objectForKey:@"type"] isEqualToString:@"1"]){
                XLBMoveCarNoticeViewController *moveCar =[[XLBMoveCarNoticeViewController alloc]init];
                moveCar.hidesBottomBarWhenPushed = YES;
                moveCar.carId = [userInfo objectForKey:@"carId"];
                [topmostVC.navigationController pushViewController:moveCar animated:YES];
            }

        }

    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 程序关闭后, 通过点击推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NSLog(@"iOS10程序关闭后通过点击推送进入程序弹出的通知:%@",userInfo);
//    _vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playkSystemSound) userInfo:nil repeats:YES];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        NSLog(@"iOS10程序关闭后通过2:%@",userInfo);

        
        UIViewController *topmostVC = [self topViewController];
        if([XLBUser user].isLogin
           && kNotNil([XLBUser user].token)
           &&![topmostVC isKindOfClass:[XLBMoveCarNoticeViewController class]]
           &&[[userInfo allKeys] containsObject:@"type"]) {

            if ([[userInfo objectForKey:@"type"] isEqualToString:@"6"]){
                moveCarId =[userInfo objectForKey:@"carId"];
                [self showMoveOverViewWithMoveCarID:moveCarId];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"cs" userInfo:userInfo];
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"0"]){
                if([[userInfo allKeys] containsObject:@"url"]&&kNotNil([userInfo objectForKey:@"url"])){
                    BaseWebViewController *webview = [BaseWebViewController new];
                    webview.urlStr = [userInfo objectForKey:@"url"];
                    webview.hidesBottomBarWhenPushed = YES;
                    [topmostVC.navigationController pushViewController:webview animated:YES];
                }else{
                    XLBMsgSystemViewController *moveCar =[[XLBMsgSystemViewController alloc]init];
                    moveCar.hidesBottomBarWhenPushed = YES;
                    [topmostVC.navigationController pushViewController:moveCar animated:YES];
                }
                
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"1"]){
                XLBMoveCarNoticeViewController *moveCar =[[XLBMoveCarNoticeViewController alloc]init];
                moveCar.hidesBottomBarWhenPushed = YES;
                moveCar.carId = [userInfo objectForKey:@"carId"];
                [topmostVC.navigationController pushViewController:moveCar animated:YES];
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"2"]){
                XLBMsgNotifitionViewController *moveCar =[[XLBMsgNotifitionViewController alloc]init];
                moveCar.hidesBottomBarWhenPushed = YES;
                [topmostVC.navigationController pushViewController:moveCar animated:YES];
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"3"]){
                XLBPraiseListController *moveCar =[[XLBPraiseListController alloc]init];
                moveCar.hidesBottomBarWhenPushed = YES;
                moveCar.praiseAndFans = @"粉丝";
                [topmostVC.navigationController pushViewController:moveCar animated:YES];
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"4"]){
                XLBPraiseListController *moveCar =[[XLBPraiseListController alloc]init];
                moveCar.hidesBottomBarWhenPushed = YES;
                moveCar.praiseAndFans = @"赞";
                [topmostVC.navigationController pushViewController:moveCar animated:YES];
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"5"]){
                XLBPraiseListController *moveCar =[[XLBPraiseListController alloc]init];
                moveCar.hidesBottomBarWhenPushed = YES;
                moveCar.praiseAndFans = @"评论";
                [topmostVC.navigationController pushViewController:moveCar animated:YES];
            }
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"7"]&&![topmostVC isKindOfClass:[NetMsgTablePage class]]){
                [[CSRouter share]push:@"NetMsgTablePage" Params:@{@"carId":[userInfo objectForKey:@"carId"],@"createUser":[userInfo objectForKey:@"createUser"]} hideBar:YES];
            }
            
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"news"]){
                if ([[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]>201) {
                    [[CSRouter share]push:@"NewsDetailPage" Params:@{@"webId":[userInfo objectForKey:@"uid"]} hideBar:YES];
                }else{
                    [[CSRouter share]push:@"BaseWebViewController" Params:@{@"urlStr":[userInfo objectForKey:@"uid"],@"titleStr":@"热点资讯"} hideBar:YES];
                }

            }
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"dynamic"]) {
                [[NetWorking network] POST:kDynamic params:@{@"id":[userInfo objectForKey:@"momentId"]} cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                    LittleHornTableViewModel *model = [LittleHornTableViewModel mj_objectWithKeyValues:result];
                    [[CSRouter share] push:@"LittleDetailViewController" Params:@{@"detailModel":model} hideBar:YES];
                } failure:^(NSString *description) {
                    
                }];
            }
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"ranking"]) {
                [[CSRouter share] push:@"XLBRankingListDetailViewController" Params:@{@"rankList_sy":@"0"} hideBar:YES];
            }
        }else{//未登录的跳转
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"news"]){
                if ([[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]>201) {
                    [[CSRouter share]push:@"NewsDetailPage" Params:@{@"webId":[userInfo objectForKey:@"uid"]} hideBar:YES];
                }else{
                    [[CSRouter share]push:@"BaseWebViewController" Params:@{@"urlStr":[userInfo objectForKey:@"uid"],@"titleStr":@"热点资讯"} hideBar:YES];
                }
            }
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"dynamic"]) {
                [[NetWorking network] POST:kHomeGoodFreListDetail params:@{@"id":[userInfo objectForKey:@"momentId"]} cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                    LittleHornTableViewModel *model = [LittleHornTableViewModel mj_objectWithKeyValues:result];
                    [[CSRouter share] push:@"LittleDetailViewController" Params:@{@"detailModel":model} hideBar:YES];
                } failure:^(NSString *description) {
                    
                }];
            }
            if ([[userInfo objectForKey:@"type"] isEqualToString:@"ranking"]) {
                [[CSRouter share] push:@"XLBRankingListDetailViewController" Params:@{@"rankList_sy":@"0"} hideBar:YES];
            }
        }

    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);  // 系统要求执行这个方法
}
#endif


- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"后台")
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[userDefa objectForKey:@"kMsgCount"] integerValue]];
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"前台")
    UIViewController *topmostVC = [self topViewController];
    [(BaseViewController*)topmostVC hideHud];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WECHAT_APPID]]) {
        return  [WXApi handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
    }
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",SINA_APPKEY]]) {
        return [WeiboSDK handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
    }else if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        UIViewController *topmostVC = [self topViewController];

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@" result == %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                
                if ([topmostVC isKindOfClass:[PayCheTieViewController class]] || [topmostVC isKindOfClass:[CarOrderViewController class]]) {
                    NSString *result = [resultDic objectForKey:@"result"];
                    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                    if (kNotNil(resultDic)) {
                        NSDictionary *responeDic = [resultDic objectForKey:@"alipay_trade_app_pay_response"];
                        if (kNotNil(responeDic)) {
                            NSString *OutTradeNo = [NSString stringWithFormat:@"%@",[responeDic objectForKey:@"out_trade_no"]];
                            NSString *total_amount = [NSString stringWithFormat:@"%@",[responeDic objectForKey:@"total_amount"]];
                            NSLog(@"%@",@{@"money":total_amount,@"orderNo":OutTradeNo});
                            [[NetWorking network] POST:kCheTieSuccess params:@{@"orderNo":OutTradeNo} cache:NO success:^(id result) {
                                XLBSuccessQRViewController *successVC = [[XLBSuccessQRViewController alloc] init];
                                successVC.subTitle = @"送货上门";
                                [topmostVC.navigationController pushViewController:successVC animated:YES];
                            } failure:^(NSString *description) {
                                
                            }];
                        }
                    }
                    
                }else if ([topmostVC isKindOfClass:[XLBAccountDetailViewController class]]) {
                    NSUserDefaults *userde = [NSUserDefaults standardUserDefaults];
                    NSString *money = [userde objectForKey:@"rechargeMoney"];
                    [[NetWorking network] POST:kPaySuccess params:@{@"money":money} cache:NO success:^(id result) {
                        NSLog(@"%@",money);
                        [MBProgressHUD showSuccess:@"充值成功"];
                        [topmostVC.navigationController popViewControllerAnimated:YES];
                    } failure:^(NSString *description) {
                        
                    }];
                }
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        }];
    }
    return YES;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WECHAT_APPID]]) {
        return  [WXApi handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
    }
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",SINA_APPKEY]]) {
        return [WeiboSDK handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
    }else if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        UIViewController *topmostVC = [self topViewController];

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@" result == %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                if ([topmostVC isKindOfClass:[PayCheTieViewController class]] || [topmostVC isKindOfClass:[CarOrderViewController class]]) {
                    NSString *result = [resultDic objectForKey:@"result"];
                    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                    if (kNotNil(resultDic)) {
                        NSDictionary *responeDic = [resultDic objectForKey:@"alipay_trade_app_pay_response"];
                        if (kNotNil(responeDic)) {
                            NSString *OutTradeNo = [NSString stringWithFormat:@"%@",[responeDic objectForKey:@"out_trade_no"]];
                            NSString *total_amount = [NSString stringWithFormat:@"%@",[responeDic objectForKey:@"total_amount"]];
                            NSLog(@"%@",@{@"money":total_amount,@"orderNo":OutTradeNo});
                            [[NetWorking network] POST:kCheTieSuccess params:@{@"orderNo":OutTradeNo} cache:NO success:^(id result) {
                                XLBSuccessQRViewController *successVC = [[XLBSuccessQRViewController alloc] init];
                                successVC.subTitle = @"送货上门";
                                [topmostVC.navigationController pushViewController:successVC animated:YES];
                            } failure:^(NSString *description) {
                                
                            }];
                        }
                    }
                }else if ([topmostVC isKindOfClass:[XLBAccountDetailViewController class]]) {
                    NSUserDefaults *userde = [NSUserDefaults standardUserDefaults];
                    NSString *money = [userde objectForKey:@"rechargeMoney"];
                    [[NetWorking network] POST:kPaySuccess params:@{@"money":money} cache:NO success:^(id result) {
                        NSLog(@"%@",money);
                        [MBProgressHUD showSuccess:@"充值成功"];
                        [topmostVC.navigationController popViewControllerAnimated:YES];
                    } failure:^(NSString *description) {
                        
                    }];
                }
            }
        }];
        
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[userDefa objectForKey:@"kMsgCount"] integerValue]];
        NSLog(@"%@",[userDefa objectForKey:@"kMsgCount"]);
        if (!kNotNil([userDefa objectForKey:@"kMsgCount"]) || [[userDefa objectForKey:@"kMsgCount"] integerValue] == 0) {
            [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        }else {
            [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%zd",[[userDefa objectForKey:@"kMsgCount"] integerValue]]];
        }
    }else {
        [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:nil];
    }
    

    // 登陆环信
    [XLBEaseMobManager xlbLoginEaseMob:^(NSError *error) {
        if (!error) {
            NSLog(@"环信登录成功");
        } else {
            NSLog(@"环信登录失败");
        }
    }];
}
#pragma mark -- 程序退出，挂断正在进行的语音通话

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //程序被杀死，挂断正在进行的语音通话
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    if (kNotNil([userD objectForKey:@"callID"])) {
        [[EMClient sharedClient].callManager endCall:[userD objectForKey:@"callID"] reason:EMCallEndReasonHangup];
    }
}


- (void)replyPushNotificationAuthorization:(UIApplication *)application options:(NSDictionary *)launchOptions {
    
    if (IOS10Later) {
        
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound |UIUserNotificationTypeAlert;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else {
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    /*
     *  launchingOption 启动参数.
     *  appKey 一个JPush 应用必须的,唯一的标识.
     *  channel 发布渠道. 可选.
     *  isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
     *  advertisingIdentifier 广告标识符（IDFA） 如果不需要使用IDFA，传nil.
     * 此接口必须在 App 启动时调用, 否则 JPush SDK 将无法正常工作.
     */
    
    // 如不需要使用IDFA，advertisingIdentifier 可为nil
    // 注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY channel:channel apsForProduction:isProduction advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0) {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [XLBUser user].deviceNo = registrationID;
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            UIDevice *device = [UIDevice currentDevice];
            NSString *osVersion = device.systemVersion;
            [[NetWorking network] POST:kPostVersion params:@{@"deviceType":[UIDeviceHardware platformString],@"osVersion":osVersion,@"appVersion":version,@"deviceNo":[XLBUser user].deviceNo} cache:NO success:^(id result) {
                NSLog(@"%@",result);
            } failure:^(NSString *description) {
                
            }];
        }
        else {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

#pragma  mark - EMGroupManagerDelegate
- (void)userDidJoinGroup:(EMGroup *)aGroup user:(NSString *)aUsername {
    //有用户加入群组
}

- (void)userDidLeaveGroup:(EMGroup *)aGroup user:(NSString *)aUsername {
    //有用户退出群组
}

#pragma  mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages {
    

#if !TARGET_IPHONE_SIMULATOR
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    NSUserDefaults *userDefa = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[userDefa objectForKey:@"kMsgCount"]);
    NSLog(@"%@",aMessages);
    NSInteger count = 0;
    count++;
    [_distrubGroupList removeAllObjects];
    _distrubGroupList=[[[XLBCache cache] cache:@"distrubGroupList"] mutableCopy];
    if (!isAppActivity) {

        [self _showNotificationWithMessage:aMessages];
        [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%zd",[[userDefa objectForKey:@"kMsgCount"] integerValue] + count]];
        [userDefa setObject:@([[userDefa objectForKey:@"kMsgCount"] integerValue] + count) forKey:@"kMsgCount"];

    }else {
        EMMessage *message = aMessages.firstObject;
        
        if (message.chatType != EMChatTypeGroupChat) {
            [self _playSoundAndVibration];
        }else {
            if (kNotNil(_distrubGroupList) && _distrubGroupList.count > 0) {
                [_distrubGroupList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj isEqualToString:message.conversationId]) {
                        [self _playSoundAndVibration];
                        return ;
                    }
                }];
            }else {
                [self _playSoundAndVibration];
            }
        }
        [userDefa setObject:@([[userDefa objectForKey:@"kMsgCount"] integerValue] + aMessages.count) forKey:@"kMsgCount"];
        if ((!kNotNil([userDefa objectForKey:@"kMsgCount"]) || [[userDefa objectForKey:@"kMsgCount"] integerValue] == 0) && aMessages.count == 0){
            [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        }else if(aMessages.count != 0 && [[userDefa objectForKey:@"kMsgCount"] integerValue] == 0){
            [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%zd",aMessages.count]];
        }else {
            [[[[_tbc tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%zd",[[userDefa objectForKey:@"kMsgCount"] integerValue]]];
        }
        
    }
    
    [userDefa synchronize];
    
#endif
}


#pragma mark - private chat

- (void)_playSoundAndVibration {

    
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    [self playNewMessageSound];
}

- (void )playNewMessageSound
{
    // Path for the audio file
    NSURL *bundlePath = [[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"];
    NSURL *noPath = [[NSBundle mainBundle] URLForResource:@"xlbno" withExtension:@"wav"];
    NSURL *audioPath = [[NSBundle bundleWithURL:bundlePath] URLForResource:@"in" withExtension:@"caf"];
    
    SystemSoundID soundID;
    NSLog(@"%@",[XLBUser user].userModel.sound);
    if ([[XLBUser user].userModel.sound integerValue] == 0) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(noPath), &soundID);
    }else {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(audioPath), &soundID);
    }
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

- (void)pushMessageController{

    _tbc = [RootTabbarController sharedRootBar];
    [_tbc setDelegate:self];
    _tbc.selectedIndex = 3;
    self.window.rootViewController = _tbc;
}

- (void)_showNotificationWithMessage:(NSArray *)messages {
    
    
    if (messages) {
        
        [self pushMessageController];
    }
    //发送本地推送
    EMMessage *callMessModel  = messages.firstObject;
    NSString *callMessage = nil;
    id text = callMessModel.body;
    if([text isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *body = text;
        callMessage = body.text;
        if ([callMessage isEqualToString:@"xiaolaba已取消"]) return;
    }
    if (callMessModel.chatType == EMChatTypeGroupChat) {
        if ([_distrubGroupList containsObject:callMessModel.conversationId]) return;
    }


    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessage *messageModel  = messages.firstObject;
        NSString *messageStr = nil;
        id text = messageModel.body;
        if([text isKindOfClass:[EMTextMessageBody class]]) {
            EMTextMessageBody *body = text;
            messageStr = body.text;

        }else if ([text isKindOfClass:[EMVoiceMessageBody class]]) {
            messageStr = @"[语音]";
        }else if ([text isKindOfClass:[EMVideoMessageBody class]]) {
            messageStr = @"[视频]";
        }else if ([text isKindOfClass:[EMImageMessageBody class]]) {
            messageStr = @"[图片]";
        }else if ([text isKindOfClass:[EMLocationMessageBody class]]) {
            messageStr = @"[位置]";
        }

        NSString *title = messageModel.from;
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }else{
        notification.alertBody = NSLocalizedString(@"您收到一条小喇叭消息", @"您收到一条好友请求");
    }
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    if (kNotNil([XLBUser user].userModel.sound) && [[XLBUser user].userModel.sound integerValue] == 0) {
        notification.soundName = @"xlbno.wav";
    }else {
        notification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    UIUserNotificationSettings *local = [UIUserNotificationSettings settingsForTypes:1 << 2 categories:nil];

    [[UIApplication sharedApplication] registerUserNotificationSettings:local];
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [UIApplication sharedApplication].applicationIconBadgeNumber = ++badge;
}
#pragma mark - tabBarController
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if([[self topViewController]isKindOfClass:[LittleHornViewController class]]&&[[tabBarController tabBar].selectedItem.title isEqualToString:@"小喇叭"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rootShow" object:@"root" userInfo:nil];
    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
        //    TabbarShow
    if (kNotNil([tabBarController tabBar].selectedItem.title)) {
        [MobClick event:@"TabbarShow" attributes:@{@"name":[tabBarController tabBar].selectedItem.title,@"__ct__":@"1"}];
        if ([[tabBarController tabBar].selectedItem.title isEqualToString:@"消息"] && (![XLBUser user].isLogin || !kNotNil([XLBUser user].token))) {
            [[[XLBLoginViewController alloc] init] openWithController:[self topViewController] returnBlock:^(id data) {
                _tbc.selectedIndex = 0;
            }];
        }
    }
}
#pragma mark - 挪车提示弹框
-(UIView*)moveCarTipView {
    if (!_moveCarTipView) {
        _moveCarTipView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        [_moveCarTipView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        UIImageView *imageView = [UIImageView new];
        [imageView setImage:[UIImage imageNamed:@"pic_nctc"]];
        [_moveCarTipView addSubview:imageView];
        
        UILabel *content = [UILabel new];
        content.textColor = UIColorFromRGB(0x2e3033);
        if (kSCREEN_WIDTH <378) {
            content.font = [UIFont systemFontOfSize:16];
        }else
        content.font = [UIFont systemFontOfSize:20];
        if ([[isMoveDic allKeys] containsObject:@"moveCarId"]) {
            //        状态 1 为发起方 2 为收到方
            if ([[isMoveDic objectForKey:@"type"] isEqualToString:@"1"]){
                content.text = @"你有一个未完成的挪车业务";
            }else {
                content.text = @"您当前有一个未处理的挪车请求";
            }
        }else {
            content.text = @"你有一个未完成的挪车业务";
        }
        [_moveCarTipView addSubview:content];
        
        UIButton *closeBtn =[UIButton new];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.layer.cornerRadius = 5;
        closeBtn.layer.masksToBounds = YES;
        [closeBtn addTarget:self action:@selector(hideMoveCarTipView) forControlEvents:UIControlEventTouchUpInside];
        [_moveCarTipView addSubview:closeBtn];
        
        UIButton *sureBtn =[UIButton new];
        sureBtn.backgroundColor = [UIColor clearColor];
        sureBtn.layer.cornerRadius = 5;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn addTarget:self action:@selector(showMoveCarNoticeVC) forControlEvents:UIControlEventTouchUpInside];
        [_moveCarTipView addSubview:sureBtn];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_moveCarTipView);
            make.width.mas_equalTo(kSCREEN_WIDTH-60);
            make.height.mas_equalTo((kSCREEN_WIDTH-60)*2/3.0);
        }];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.top.mas_equalTo(imageView).with.offset(90);
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imageView).with.offset(-10);
            make.top.mas_equalTo(imageView).with.offset(10);
            make.width.height.mas_equalTo(40);
        }];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imageView).with.offset(-16);
            make.left.mas_equalTo(imageView).with.offset(16);
            make.bottom.mas_equalTo(imageView).with.offset(-12);
            make.height.mas_equalTo(50*kiphone6_ScreenWidth);
        }];
    }
    return _moveCarTipView;
}
-(void)showMoveCarTipView {
    [[NetWorking network] POST:KCarIsMove params:nil cache:NO success:^(NSDictionary* result) {
        NSLog(@"------------------挪车提示 %@",result);
        isMoveDic = result;
        UIViewController *topmostVC = [self topViewController];
        if ([[isMoveDic allKeys] containsObject:@"moveCarId"]
            &&![topmostVC isKindOfClass:[XLBNoticeViewController class]]
            &&![topmostVC isKindOfClass:[XLBMoveCarNoticeViewController class]]) {
            [self.window addSubview:self.moveCarTipView];
        }else {
            [self locationOpen];
        }
        
    } failure:^(NSString *description) {
        [self locationOpen];
    }];

}

- (void)locationOpen {
    if ([JXutils isLocationServiceOpen] == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法定位" message:@"为了准确找到附近的用户，您需要在用户\"设置\" -> \"隐私\" -> \"定位服务\"中允许小喇叭进行定位" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"允许", nil];
        alert.delegate = self;
        alert.tag = 100;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100 && buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
-(void)hideMoveCarTipView {
    [self.moveCarTipView removeFromSuperview];
}
-(void)showMoveCarNoticeVC {
    [self hideMoveCarTipView];
    if ([[isMoveDic allKeys] containsObject:@"moveCarId"]) {
//        状态 1 为发起方 2 为收到方
        UIViewController *topmostVC = [self topViewController];
        if ([[isMoveDic objectForKey:@"type"] isEqualToString:@"1"]){
            XLBNoticeViewController *moveCar =[[XLBNoticeViewController alloc]init];
            moveCar.hidesBottomBarWhenPushed = YES;
            moveCar.userId = [isMoveDic objectForKey:@"userId"];
            moveCar.imgUrl =[isMoveDic objectForKey:@"imgUrl"];
            moveCar.moveCarId =[isMoveDic objectForKey:@"moveCarId"];
            moveCar.nickname =[isMoveDic objectForKey:@"nickname"];
            moveCar.timeDown =[[isMoveDic objectForKey:@"timeDown"] integerValue];
            [topmostVC.navigationController pushViewController:moveCar animated:YES];
        }else {
            XLBMoveCarNoticeViewController *moveCar =[[XLBMoveCarNoticeViewController alloc]init];
            moveCar.hidesBottomBarWhenPushed = YES;
            moveCar.carId = [isMoveDic objectForKey:@"moveCarId"];
            [topmostVC.navigationController pushViewController:moveCar animated:YES];
        }
    }
}

#pragma mark - 挪车结束弹框
-(UIView*)moveOverView {
    if (!_moveOverView) {
        _moveOverView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        [_moveOverView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(30, (kSCREEN_HEIGHT-350)/2.0, kSCREEN_WIDTH-60, 350)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5;
        contentView.layer.masksToBounds = YES;
        [_moveOverView addSubview:contentView];
        UIImageView *imgeview = [UIImageView new];
        [imgeview setImage:[UIImage imageNamed:@"pic_shj"]];
        [contentView addSubview:imgeview];
        
        UILabel *titleLbl = [UILabel new];
        titleLbl.font = [UIFont systemFontOfSize:30];
        titleLbl.text = @"车主来了么";
        titleLbl.textColor = RGB(46, 48, 51);
        [contentView addSubview:titleLbl];
        
        UILabel *contentLbl = [UILabel new];
        contentLbl.font = [UIFont systemFontOfSize:18];
        NSString *string = @"15分钟已经过去，车主来了么？";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(255, 2, 68) range:NSMakeRange(0, 4)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(92, 95, 102) range:NSMakeRange(4, string.length - 4)];
        contentLbl.attributedText = attributedString;
        [contentView addSubview:contentLbl];
        
        UIButton *remindBtn = [self addMoveOverBtnWithTitle:@"提醒挪车" backColor:[UIColor textBlackColor] color:[UIColor whiteColor]];
        [remindBtn addTarget:self action:@selector(remindMoveCar) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:remindBtn];
        
        UIButton *overBtn = [self addMoveOverBtnWithTitle:@"已完成挪车" backColor:RGB(255, 222, 2) color:[UIColor textBlackColor]];
        [overBtn addTarget:self action:@selector(finishMoveCar) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:overBtn];
    
        UIButton *cancleBtn =[self addMoveOverBtnWithTitle:@"取消" backColor:[UIColor whiteColor] color:[UIColor textBlackColor]];
        cancleBtn.layer.borderWidth = 2;
        cancleBtn.layer.borderColor = [UIColor lineColor].CGColor;
        [cancleBtn addTarget:self action:@selector(hideMoveOverView) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancleBtn];
        
        [imgeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView.mas_top).with.offset(30);
            make.centerX.mas_equalTo(contentView);
        }];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgeview.mas_bottom).with.offset(15);
            make.centerX.mas_equalTo(contentView);
        }];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(20);
            make.centerX.mas_equalTo(contentView);
        }];
        [remindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_offset((contentView.width-45)/2);
            make.height.mas_offset(44);
            make.bottom.mas_equalTo(cancleBtn.mas_top).with.offset(-15);
        }];
        [overBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(remindBtn.mas_right).with.offset(15);
            make.width.mas_offset((contentView.width-45)/2);
            make.height.mas_offset(44);
            make.bottom.mas_equalTo(cancleBtn.mas_top).with.offset(-15);
        }];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_offset(contentView.width-30);
            make.height.mas_offset(44);
            make.bottom.mas_offset(-15);
        }];
    }
    return _moveOverView;
}
-(UIButton *)addMoveOverBtnWithTitle:(NSString*)title backColor:(UIColor*)backcolor color:(UIColor*)textcolor {
    UIButton *button =[UIButton new];
    button.backgroundColor = backcolor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:textcolor forState:0];
    [button setTitle:title forState:0];
    return button;
}

- (void)remindMoveCar {
    
    [[NetWorking network] POST:KRemindMoveCar params:@{@"id":moveCarId} cache:NO success:^(NSDictionary* result) {
        NSLog(@"------------------再次挪车 %@",result);
        [MBProgressHUD showError:@"已经再次提醒车主前来挪车"];
        moveCarId = [NSString stringWithFormat:@"%@",result];
        if (![[self topViewController] isKindOfClass:[XLBNoticeViewController class]]) {
            [self moveCarWithfindBy];
            if ([[self topViewController] isKindOfClass:[XLBChatViewController class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"MoveCarOver" userInfo:@{@"type":@"1"}];
            }
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"MoveCarOver" userInfo:@{@"type":@"1"}];
        }
        [self hideMoveOverView];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:description];
    }];
}
- (void)moveCarWithfindBy {
    NSDictionary *dict = @{@"id":moveCarId};
    [[NetWorking network] POST:KFindByDetail params:dict cache:NO success:^(id result) {
        NSLog(@"----------- 挪车记录详情 %@   %@",result,dict);
        XLBMoveRecordsModel *model = [XLBMoveRecordsModel mj_objectWithKeyValues:result];
        
        if ([model.status isEqualToString:@"0"] && [model.countdown integerValue] > 0) {
                //挪车通知未过时
                XLBNoticeViewController *noticeVC = [XLBNoticeViewController new];
                noticeVC.userId = model.uid;
                noticeVC.imgUrl = model.img;
                noticeVC.nickname = model.nickname;
                noticeVC.timeDown = [model.countdown integerValue];
                noticeVC.moveCarId = model.createID;
                noticeVC.hidesBottomBarWhenPushed = YES;
                [[self topViewController].navigationController pushViewController:noticeVC animated:YES];
        }
        
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"网络错误，请点击重试"];
    }];
}
-(void)finishMoveCar{
    [[NetWorking network] POST:KFinishMoveCar params:@{@"id":moveCarId} cache:NO success:^(NSDictionary* result) {
        NSLog(@"------------------挪车完成 %@",result);
    } failure:^(NSString *description) {
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"MoveCarOver" userInfo:@{@"type":@"2"}];
    [self hideMoveOverView];
}

-(void)showMoveOverViewWithMoveCarID:(NSString*)carId {
    moveCarId = carId;
    UIViewController*showVC = [self topViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenter" object:@"MoveCarOver" userInfo:@{@"carId":carId,@"type":@"0"}];
    [showVC.view addSubview:self.moveOverView];
}
-(UIView*)versionsTipView {
    if (!_versionsTipView) {
        _versionsTipView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        [_versionsTipView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        UIView *contentView = [UIView new];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.layer.cornerRadius = 5;
        contentView.layer.masksToBounds = YES;
        [_versionsTipView addSubview:contentView];
        
        UIView *backView = [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:backView];
        
        UIImageView *imgeview = [UIImageView new];
        [imgeview setImage:[UIImage imageNamed:@"pic_tb"]];
        [contentView addSubview:imgeview];
        
        UILabel *titleLbl = [UILabel new];
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.text = @"最新版本：v1.0.2";
        titleLbl.textColor = RGB(51, 51, 51);
        [backView addSubview:titleLbl];
        tipTitleLbl = titleLbl;
        
        UILabel *tipLbl = [UILabel new];
        tipLbl.font = [UIFont systemFontOfSize:14];
        tipLbl.text = @"更新内容：";
        tipLbl.textColor = RGB(51, 51, 51);
        [backView addSubview:tipLbl];
        
        UILabel *contentLbl = [UILabel new];
        contentLbl.font = [UIFont systemFontOfSize:12];
        contentLbl.numberOfLines = 0;
        NSString *string =@"1.车主来了么\n2.车主来了么\n3.车主来了么\n4.车主来了么";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        contentLbl.attributedText = attributedString;
        contentLbl.textColor = RGB(102, 102, 102);
        [backView addSubview:contentLbl];
        tipContentLbl = contentLbl;
        
        self.closeRemindBtn = [UIButton new];
        [self.closeRemindBtn setImage:[UIImage imageNamed:@"icon_q"] forState:0];
        [self.closeRemindBtn setTitle:@" 不再提醒" forState:0];
        //标示，用于判断是否不再提醒
        self.closeRemindBtn.tag = 1;
        [self.closeRemindBtn setTitleColor:[UIColor textBlackColor] forState:0];
        self.closeRemindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.closeRemindBtn addTarget:self action:@selector(remindVersions:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:self.closeRemindBtn];
        UIButton *newBtn = [self addMoveOverBtnWithTitle:@"立即更新" backColor:[UIColor lightColor] color:[UIColor textBlackColor]];
        [newBtn addTarget:self action:@selector(updateVersionsPush) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:newBtn];
        
        self.versionsCancleBtn =[UIButton new];
        [self.versionsCancleBtn setImage:[UIImage imageNamed:@"icon_tip_gb"] forState:0];
        [self.versionsCancleBtn addTarget:self action:@selector(hideVersionsView) forControlEvents:UIControlEventTouchUpInside];
        [_versionsTipView addSubview:self.versionsCancleBtn];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_versionsTipView);
            make.top.mas_equalTo(imgeview);
            make.width.mas_equalTo(imgeview);
            make.bottom.mas_equalTo(backView);
        }];
        [imgeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView.mas_top);
            make.centerX.mas_equalTo(contentView);
            make.width.mas_equalTo(kiphone6_ScreenWidth*255);
            make.height.mas_equalTo(kiphone6_ScreenWidth*255*3/5.0);
        }];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgeview.mas_bottom).with.offset(-60);
            make.left.right.mas_equalTo(imgeview);
            make.bottom.mas_equalTo(contentView);
        }];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backView).with.offset(50);
            make.left.mas_equalTo(backView).with.offset(15);
            make.right.mas_equalTo(backView).with.offset(-15);
        }];
        [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(5);
            make.left.mas_equalTo(backView).with.offset(15);
            make.right.mas_equalTo(backView).with.offset(-15);
        }];
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tipLbl.mas_bottom).with.offset(5);
            make.left.mas_equalTo(backView).with.offset(15);
            make.right.mas_equalTo(backView).with.offset(-15);
        }];
        [self.closeRemindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLbl.mas_bottom).with.offset(10);
            make.left.mas_equalTo(backView).with.offset(15);
        }];
        [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.closeRemindBtn.mas_bottom).with.offset(5);
            make.left.mas_equalTo(backView).with.offset(15);
            make.right.mas_equalTo(backView).with.offset(-15);
            make.height.mas_offset(35);
            make.bottom.mas_equalTo(backView.mas_bottom).with.offset(-15);
        }];
        [self.versionsCancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_versionsTipView);
            make.top.mas_equalTo(contentView.mas_bottom).with.offset(20);
        }];
    }
    return _versionsTipView;
}
-(void)remindVersions:(UIButton*)button{
    if (button.tag !=1) {
        button.tag = 1;
        [button setImage:[UIImage imageNamed:@"icon_q"] forState:0];
        [[XLBCache cache] removeCacheForKey:VersionsKey];
    }else{
        button.tag = 2;
        [button setImage:[UIImage imageNamed:@"icon_g"] forState:0];
        [[XLBCache cache] store:versionsStr key:VersionsKey];
    }
    
}
-(void)updateVersionsPush {
    [self.versionsTipView removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kShowAPPStore]];
}
-(void)hideVersionsView {
    if ([remarkStr isEqualToString:@"1"]) {
        exit(1);
    }else{
        [self.versionsTipView removeFromSuperview];
    }
    
}
-(void)uploadVersions {
    kWeakSelf(self)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[NetWorking network] POST:KiosMajor params:nil cache:NO success:^(NSDictionary* result) {
            NSLog(@"------------------更新版本 %@",result);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (kNotNil(result[@"label"]) && [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue] < [[result[@"label"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
                    remarkStr =  [result objectForKey:@"remarks"];
                    if ([[result objectForKey:@"remarks"] isEqualToString:@"1"]){
                        versionsStr = result[@"label"];
                        [self.window addSubview:self.versionsTipView];
                        [weakSelf.closeRemindBtn setHidden:YES];
                        [weakSelf.versionsCancleBtn setHidden:YES];
                        [tipTitleLbl setText:[NSString stringWithFormat:@"最新版本：v %@",[result objectForKey:@"label"]]];
                        NSString *string = [[result objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setLineSpacing:5];//调整行间距
                        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
                        tipContentLbl.attributedText = attributedString;
                    }else {
                        if (![[[XLBCache cache]cache:VersionsKey] isEqualToString:result[@"label"]]) {
                            versionsStr = result[@"label"];
                            [self.window addSubview:self.versionsTipView];
                            [weakSelf.closeRemindBtn setHidden:NO];
                            [weakSelf.versionsCancleBtn setHidden:NO];
                            [tipTitleLbl setText:[NSString stringWithFormat:@"最新版本：v %@",[result objectForKey:@"label"]]];
                            NSString *string = [[result objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
                            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                            [paragraphStyle setLineSpacing:5];//调整行间距
                            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
                            tipContentLbl.attributedText = attributedString;
                        }
                    }
                }
            });
        } failure:^(NSString *description) {
        }];
    });
    
}
-(void)hideMoveOverView {
    [self.moveOverView removeFromSuperview];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//振动
- (void)playkSystemSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    AudioServicesPlaySystemSound(sound);
}

//NSString *osVersion() {
//
//    UIDevice *device = [UIDevice currentDevice];
//    return device.systemVersion;
//}
@end
