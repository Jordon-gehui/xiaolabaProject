//
//  DefaultList.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/1.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "DefaultList.h"
#import "XLBUser.h"

@implementation DefaultList

+(NSArray*)initControllers {
    return  @[@{@"controller":@"XLBHomeViewController",
                               @"tab_img_nor":@"homenor",
                               @"tab_img_sel":@"homesel",
                               @"title":@"喇叭"},
                             @{@"controller":@"XLBFindViewController",
                               @"tab_img_nor":@"findnor",
                               @"tab_img_sel":@"findsel",
                               @"title":@"车友"},
                             @{@"controller":@"XLBMessageViewController",
                               @"tab_img_nor":@"msgnor",
                               @"tab_img_sel":@"msgsel",
                               @"title":@"消息"},
                             @{@"controller":@"XLBMeViewController",
                               @"tab_img_nor":@"menor",
                               @"tab_img_sel":@"mesel",
                               @"title":@"我"}];
}
+(NSArray*)initOthersHomeList {
     return @[@"昵称",@"性别",@"年龄",@"个人认证",@"所在地",@"车型",@"个性签名"];
}

+(NSArray*)initMsgList {
    return  @[@{@"img":@"xitong1",
                @"title":@"系统消息",
                @"subtitle":@"暂无新消息",
                @"time":@"",
                @"type":@"0",
                @"content":@"",},
              @{@"img":@"nuoche1",
                @"title":@"挪车通知",
                @"subtitle":@"暂无新消息",
                @"time":@"",
                @"type":@"1",
                @"content":@"",},
              @{@"img":@"xiaoxi1",
                @"title":@"好友通知",
                @"subtitle":@"暂无新消息",
                @"time":@"",
                @"type":@"2",
                @"content":@"",},
              @{@"img":@"guanz_1",
                @"title":@"关注",
                @"subtitle":@"暂无新消息",
                @"time":@"",
                @"type":@"3",
                @"content":@"",},
              @{@"img":@"dianz_1",
                @"title":@"赞",
                @"subtitle":@"暂无新消息",
                @"time":@"",
                @"type":@"4",
                @"content":@"",},
              @{@"img":@"pl_1",
                @"title":@"评论",
                @"subtitle":@"暂无新消息",
                @"time":@"",
                @"type":@"5",
                @"content":@"",},];
}

//+(NSArray*)initMeList {
//     return [NSMutableArray arrayWithArray:@[@[@{@"icon":@"icon_wdzh",
//                                                  @"title":@"我的账户",
//                                                  @"subtitle":@"",
//                                                  @"subtitle_color":@""},
//                                               @{@"icon":@"icon_wddt",
//                                                 @"title":@"我的动态",
//                                                 @"subtitle":@"",
//                                                 @"subtitle_color":@""},
//                                               @{@"icon":@"icon_wdsy",
//                                                 @"title":@"我的收益",
//                                                 @"subtitle":@"",
//                                                 @"subtitle_color":@""},
//                                               @{@"icon":@"icon_syrz",
//                                                 @"title":@"声优认证",
//                                                 @"subtitle":@"",
//                                                 @"subtitle_color":@""},
//                                               @{@"icon":@"icon_sfbz",
//                                                 @"title":@"收费标准",
//                                                 @"subtitle":@"",
//                                                 @"subtitle_color":@""},
//                                               @{@"icon":@"icon_thjl",
//                                                 @"title":@"收支记录",
//                                                 @"subtitle":@"",
//                                                 @"subtitle_color":@""}],
//                                             @[ @{@"icon":@"icon_clrz",
//                                                  @"title":@"车辆认证",
//                                                  @"subtitle":@"",
//                                                  @"subtitle_color":@""},
//                                                @{@"icon":@"icpn_wd_dj",
//                                                   @"title":@"我的订单",
//                                                   @"subtitle":@"",
//                                                   @"subtitle_color":@""},
//                                                 @{@"icon":@"icon_yqhy",
//                                                 @"title":@"邀请好友",
//                                                 @"subtitle":@"",
//                                                 @"subtitle_color":@""},
//                                                @{@"icon":@"icon_kf",
//                                                  @"title":@"在线客服",
//                                                  @"subtitle":@"",
//                                                  @"subtitle_color":@""},
//                                                @{@"icon":@"icon_yhfk",
//                                                  @"title":@"用户反馈",
//                                                  @"subtitle":@"",
//                                                  @"subtitle_color":@""}]]];
//}
+(NSArray*)initMeList {
    return [NSMutableArray arrayWithArray:@[
                                            @[@{@"icon":@"icon_wddt",
                                                 @"title":@"我的动态",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                                @{@"icon":@"icon_clrz",
                                                 @"title":@"车辆认证",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icon_yqhy",
                                                 @"title":@"邀请好友",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icon_kf",
                                                 @"title":@"在线客服",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icon_yhfk",
                                                 @"title":@"用户反馈",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                              @{@"icon":@"icon_gywm",
                                                @"title":@"关于我们",
                                                @"subtitle":@"",
                                                @"subtitle_color":@""}]]];
}


+(NSArray*)initMeSubList {
    return [NSMutableArray arrayWithArray:@[@[@{@"icon":@"icon_wddt",
                                                @"title":@"我的动态",
                                                @"subtitle":@"",
                                                @"subtitle_color":@""},
                                              @{@"icon":@"icon_syrz",
                                                @"title":@"声优认证",
                                                @"subtitle":@"",
                                                @"subtitle_color":@""}],
                                            @[ @{@"icon":@"icon_clrz",
                                                 @"title":@"车辆认证",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icpn_wd_dj",
                                                 @"title":@"我的订单",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icon_yqhy",
                                                 @"title":@"邀请好友",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icon_kf",
                                                 @"title":@"在线客服",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""},
                                               @{@"icon":@"icon_yhfk",
                                                 @"title":@"用户反馈",
                                                 @"subtitle":@"",
                                                 @"subtitle_color":@""}]]];
}



+ (NSArray *)initAccountList {
    return @[@{@"price":@"1",@"carMoney":@"10车币",},@{@"price":@"6",@"carMoney":@"60车币",},@{@"price":@"30",@"carMoney":@"300车币",},@{@"price":@"100",@"carMoney":@"1000车币",},@{@"price":@"500",@"carMoney":@"500车币",},@{@"price":@"1000",@"carMoney":@"10000车币",},@{@"price":@"",@"carMoney":@"",}];
}

+(NSArray*)initMyInfoList {
    XLBUser *user =[XLBUser user];
    return @[@[@{@"title":@"昵称",@"value":user.userModel.nickname},@{@"title":@"性别",@"value":[user.userModel.sex boolValue] ? @"男":@"女"},@{@"title":@"年龄",@"value":[ZZCHelper dateStringFromNumberTimer:user.userModel.birthdate type:2]}],
             @[@{@"title":@"个性签名",@"value":user.userModel.signature}]];
}


+(NSArray*)initMeInfoList {
    return [NSMutableArray arrayWithArray:@[@[@{@"icon":@"",
                                                @"title":@"昵称",
                                                @"subtitle":@"",
                                                @"subtitle_color":@"",},
                                              @{@"icon":@"",
                                                @"title":@"性别",
                                                @"subtitle":@"",
                                                @"subtitle_color":@"",},
                                              @{@"icon":@"",
                                                @"title":@"生日",
                                                @"subtitle":@"",
                                                @"subtitle_color":@"",},
                                              @{@"icon":@"",
                                                @"title":@"居住地",
                                                @"subtitle":@"",
                                                @"subtitle_color":@"",},],
                                            @[@{@"icon":@"",
                                                @"title":@"个性签名",
                                                @"subtitle":@"",
                                                @"subtitle_color":@"",},],]];
}



+ (NSArray*)initMoveCarControllerList {
    return [NSMutableArray arrayWithArray:@[@{@"header":@"已有挪车贴",
                                              @"items":@[@{@"image":@"pic_nck1",
                                                           @"title":@"",
                                                           @"subtitle":@"",
                                                           @"color":@(NO),
                                                           @"arrow":@(NO)},
                                                         @{@"image":@"cc",
                                                           @"title":@"已绑定",
                                                           @"subtitle":@"15214383839",
                                                           @"color":@(YES),
                                                           @"arrow":@(NO)}]},
                                            @{@"header":@"",
                                              @"items":@[@{@"image":@"",
                                                           @"title":@"",
                                                           @"subtitle":@"",
                                                           @"color":@(NO),
                                                           @"arrow":@(YES)}]},
                                            @{@"header":@"以下方式获取挪车贴",
                                              @"items":@[@{@"image":@"pic_kd",
                                                           @"title":@"快递送货上门",
                                                           @"subtitle":@"填写联系人，地址即可",
                                                           @"color":@(NO),
                                                           @"arrow":@(YES)}]}
                                            ]];
}

+ (NSArray *)initCarQRCodeList {
    return @[
             @{@"title":@"如何获取挪车贴？",@"subtitle":@"    方法一：进入“小喇叭挪车”微信公众号主界面，点击下方“申请挪车贴”，按照提示操作，即可获取自己的挪车贴；\n    方法二：进入“小喇叭”App主界面，点击挪车—->我的挪车贴—->获取挪车贴，按照提示操作，即可获取自己的挪车贴；",},
             @{@"title":@"如何绑定二维码？",@"subtitle":@"    方法一：您获取到我们的二维码后，安装“小喇叭”App，进入App主界面，点击挪车—->扫描二维码进行绑定，绑定后将挪车贴，贴在车前挡风玻璃右下角；\n    方法二：您获取到我们的二维码后，进入“小喇叭挪车”微信公众号主界面，点击下方“绑定挪车贴”，按照提示操作，即可绑定挪车贴",},
             @{@"title":@"想要解绑怎么办？",@"subtitle":@"    进入“小喇叭”App主界面，点击挪车-—>我的挪车贴—->选择已绑定的挪车贴—->进行解绑；",},
             @{@"title":@"如何通知他人挪车？",@"subtitle":@"    微信扫对方车上的挪车二维码，点击下方我要挪车按钮，根据界面提示，即可通知他人挪车；",},
             @{@"title":@"为什么别人扫了我的二维码我收不到信息？",@"subtitle":@"    首先，您要使用二维码挪车贴，需要先扫描自己的二维码，完成绑定。只有绑定好了，别人扫码后，点击我要挪车，您就可以收到信息了。若您在‘设置’里面的挪车通知状态开启的情况下，您还可以收到图文，位置，图片等信息；",},
             @{@"title":@"换车对我的二维码有没有什么影响？",@"subtitle":@"    没有任何影响，只需要将您的二维码重新黏贴到您的新车上即可；",},];
}

+(NSArray*)initScreenCarInfoList {
    
    return  @[@{@"title":@"",@"subtitle":@"",},
            @{@"title":@"城市",@"subtitle":@"上海",},
            @{@"title":@"年龄",@"subtitle":@"90后",},
            @{@"title":@"车辆价格",@"subtitle":@"10万以下",},
            @{@"title":@"车辆品牌",@"subtitle":@"奥迪",},];
}

+(NSArray*)initMeCarList {
    
    return  @[@{@"title":@"所有人",@"owner":@"",},
              @{@"title":@"车辆号码",@"plateNumber":@"",},
              @{@"title":@"车辆品牌",@"vehicleAreaName":@"",},
              @{@"title":@"车辆型号",@"model":@"",},];
}

+(NSArray *)initGroupChatListWithType:(NSString *)type {
    if ([type isEqualToString:@"1"]) {
        return @[@[@{@"title":@"群头像",@"subTitle":@"",@"content":@"",},@{@"title":@"群名称",@"subTitle":@"",@"content":@"",},@{@"title":@"群公告",@"subTitle":@"",@"content":@"",},@{@"title":@"分享群",@"subTitle":@"",@"content":@"",}],@[@{@"title":@"我的群昵称",@"subTitle":@"",@"content":@"",},],@[@{@"title":@"置顶该消息",@"subTitle":@"",@"content":@"",},@{@"title":@"消息免打扰",@"subTitle":@"",@"content":@"",},],@[@{@"title":@"设置管理员",@"subTitle":@"",@"content":@"",},@{@"title":@"允许群被搜索",@"subTitle":@"",@"content":@"",},]];
    }else {
        return @[@[@{@"title":@"群头像",@"subTitle":@"",@"content":@"",},@{@"title":@"群名称",@"subTitle":@"",@"content":@"",},@{@"title":@"群公告",@"subTitle":@"",@"content":@"",},@{@"title":@"分享群",@"subTitle":@"",@"content":@"",}],@[@{@"title":@"我的群昵称",@"subTitle":@"",@"content":@"",},],@[@{@"title":@"置顶该消息",@"subTitle":@"",@"content":@"",},@{@"title":@"消息免打扰",@"subTitle":@"",@"content":@"",},],];
    }
}

@end
