//
//  XLBSystemSettingViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/20.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBSystemSettingViewController.h"
#import "XLBAlertController.h"
#import "NetWorking.h"
#import "XLBLoginViewController.h"
#import "XLBUser.h"
#import <Hyphenate/Hyphenate.h>
#import "XLBGuidanceViewController.h"
#import "RootTabbarController.h"
#import "XLBPraiseListController.h"
#import "XLBAlterPhoneViewController.h"
@interface XLBSystemSettingViewController ()

@property (nonatomic,strong)UIView *userInfoView;

@property (nonatomic,strong) UILabel *phoneLbl;

//@property (nonatomic,strong)UIView *onlineView;

@property (nonatomic,strong)UIView *hourView;

@property (nonatomic,strong)UIView *muteView;

@property (nonatomic,strong)UIView *addressSetView;

@property (nonatomic,strong)UIView *webSetView;

@property (nonatomic,strong)UIView *wxBoundView;
@property (nonatomic,strong)UIView *wbBoundView;
@property (nonatomic,strong)UIView *aboutMeView;
@property (nonatomic,strong)UIView *fileView;
@property (nonatomic,strong)UILabel *fileLabel;
@property (nonatomic,strong)UIView *clearView;

@property (nonatomic,strong)UIView *guidanceView;

@property (nonatomic,strong)UIView *questionView;

@property (nonatomic,strong)UIView *loginoutView;


@property (strong, nonatomic)  UISwitch *switch_one;
@property (strong, nonatomic)  UISwitch *switch_two;
@property (strong, nonatomic)  UISwitch *switch_addressBook;
@property (strong, nonatomic)  UISwitch *switch_allowMicroblog;
@property (strong, nonatomic)  UISwitch *switch_wxBound;
@property (strong, nonatomic)  UISwitch *switch_wbBound;

@property (strong, nonatomic)  UISwitch *switch_Online;
@end

@implementation XLBSystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"系统设置";
    self.naviBar.slTitleLabel.text = @"系统设置";
    self.scrollView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom);
    self.userInfoView = [self addSwitchView:CGRectMake(0, 15, kSCREEN_WIDTH, 50) Title:@"手机号码" content:nil isShowRight:YES];
    self.userInfoView.tag = 50;
    [self.scrollView addSubview:self.userInfoView];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
    [self.userInfoView addGestureRecognizer:tap5];
    self.phoneLbl = [UILabel new];
    self.phoneLbl.font = [UIFont systemFontOfSize:17];
    self.phoneLbl.textColor = UIColorFromRGB(0xa2a2a2);
    [self.userInfoView addSubview:self.phoneLbl];
    self.phoneLbl.text = [XLBUser user].userModel.phone;

    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userInfoView);
        make.right.mas_equalTo(self.userInfoView.mas_right).with.offset(-30);
    }];
//    self.onlineView = [self addSwitchView:CGRectMake(0, self.userInfoView.bottom, kSCREEN_WIDTH, 50) Title:@"在线" content:nil isShowRight:NO];
//    [self.scrollView addSubview:self.onlineView];
    self.hourView = [self addSwitchView:CGRectMake(0, self.userInfoView.bottom, kSCREEN_WIDTH, 50) Title:@"铃声模式" content:@"自动切换成震动模式" isShowRight:NO];
    [self.scrollView addSubview:self.hourView];
    
    self.muteView = [self addSwitchView:CGRectMake(0, self.hourView.bottom, kSCREEN_WIDTH, 50) Title:@"免打扰模式" content:@"开启后，扫描人将可以编辑留言与车辆信息发送给您" isShowRight:NO];
    [self.scrollView addSubview:self.muteView];
    
    self.addressSetView = [self addSwitchView:CGRectMake(0, self.muteView.bottom, kSCREEN_WIDTH, 50) Title:@"允许通过通讯录找到我" content:nil isShowRight:NO];
    [self.scrollView addSubview:self.addressSetView];
    self.webSetView = [self addSwitchView:CGRectMake(0, self.addressSetView.bottom, kSCREEN_WIDTH, 50) Title:@"允许通过微博找到我" content:nil isShowRight:NO];
    [self.scrollView addSubview:self.webSetView];
    
    self.wxBoundView = [self addSwitchView:CGRectMake(0, self.webSetView.bottom + 15, kSCREEN_WIDTH, 50) Title:@"微信绑定" content:nil isShowRight:NO];
    [self.scrollView addSubview:self.wxBoundView];
    
    self.wbBoundView = [self addSwitchView:CGRectMake(0, self.wxBoundView.bottom, kSCREEN_WIDTH, 50) Title:@"微博绑定" content:nil isShowRight:NO];
    [self.scrollView addSubview:self.wbBoundView];
    
    self.fileView = [self addSwitchView:CGRectMake(0, self.wbBoundView.bottom, kSCREEN_WIDTH, 50) Title:@"清除缓存" content:nil isShowRight:YES];
    [self.scrollView addSubview:self.fileView];
    self.fileLabel = [UILabel new];
    self.fileLabel.font = [UIFont systemFontOfSize:17];
    self.fileLabel.textColor = UIColorFromRGB(0xa2a2a2);
    [self.fileView addSubview:self.fileLabel];
    self.fileLabel.text = [NSString stringWithFormat:@"%.2fM",[self getCachSize]];
    
    [self.fileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fileView);
        make.right.mas_equalTo(self.fileView.mas_right).with.offset(-30);
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fileView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fileView.mas_left).with.offset(0);
        make.right.mas_equalTo(self.fileView.mas_right).with.offset(0);
        make.top.mas_equalTo(self.fileView.top).with.offset(0);
        make.bottom.mas_equalTo(self.fileView.bottom).with.offset(0);
        
    }];
    

    
    
//    self.aboutMeView = [self addSwitchView:CGRectMake(0, self.wbBoundView.bottom+15, kSCREEN_WIDTH, 50) Title:@"关于我们" content:nil isShowRight:YES];
//    self.aboutMeView.tag = 10;
//    [self.scrollView addSubview:self.aboutMeView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
//    [self.aboutMeView addGestureRecognizer:tap];
    
//    self.guidanceView = [self addSwitchView:CGRectMake(0, self.aboutMeView.bottom, kSCREEN_WIDTH, 50) Title:@"新手引导" content:nil isShowRight:YES];
//    self.guidanceView.tag = 20;
//    [self.scrollView addSubview:self.guidanceView];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
//    [self.guidanceView addGestureRecognizer:tap2];
    
//    self.questionView = [self addSwitchView:CGRectMake(0, self.guidanceView.bottom, kSCREEN_WIDTH, 50) Title:@"常见问题" content:nil isShowRight:YES];
//    self.questionView.tag = 30;
//    [self.scrollView addSubview:self.questionView];
//    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
//    [self.questionView addGestureRecognizer:tap3];
    
    self.loginoutView = [self addSwitchView:CGRectMake(0, self.fileView.bottom + 15, kSCREEN_WIDTH, 50) Title:@"退出登录" content:nil isShowRight:YES];
    self.loginoutView.tag = 40;
    [self.scrollView addSubview:self.loginoutView];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
    [self.loginoutView addGestureRecognizer:tap4];
    
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.loginoutView.bottom + 10);
    
    [self addSwitch];
    UILabel *lbl = [self.muteView viewWithTag:1];
    if ([[XLBUser user].userModel.messageReminder boolValue] == NO) {
        lbl.text = @"关闭后，扫描人将不能编辑留言与车辆信息发送给您";
    }else {
        lbl.text = @"开启后，扫描人将可以编辑留言与车辆信息发送给您";
    }
    NSLog(@"%d",[[XLBUser user].userModel.messageReminder boolValue]);
}
-(UIView*)addSwitchView:(CGRect)rect Title:(NSString*)title content:(NSString*)content isShowRight:(BOOL)isShow{
    UIView *view =[[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [UILabel new];
    titleLbl.font =[UIFont systemFontOfSize:17];
    titleLbl.textColor = [UIColor textBlackColor];
    titleLbl.text = title;
    [view addSubview:titleLbl];
    
    if (content) {
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(view).with.offset(-5);
        }];
        UILabel *cotentLbl = [UILabel new];
        cotentLbl.font =[UIFont systemFontOfSize:12];
        cotentLbl.textColor = [UIColor titleTextColor];
        cotentLbl.text = content;
        cotentLbl.tag = 1;
        [view addSubview:cotentLbl];
        [cotentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(1);
        }];
    }else{
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(view);
        }];
    }
    
    if (isShow) {
        UIImageView *rightImg = [UIImageView new];
        rightImg.image = [UIImage imageNamed:@"icon_wd_fh"];
        [view addSubview:rightImg];
        [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.right.mas_equalTo(view.mas_right).with.offset(-15);
            make.height.mas_equalTo(12.5);
            make.width.mas_equalTo(7.5);
        }];
    }
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [view addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(view);
        make.height.mas_equalTo(1);
    }];
    return view;
}
-(void)addSwitch{
//    self.switch_Online = [UISwitch new];
//    [self.switch_Online addTarget:self action:@selector(isOnlineSwitch:) forControlEvents:UIControlEventValueChanged];
//    [self.onlineView addSubview:self.switch_Online];
    self.switch_one = [UISwitch new];
    [self.switch_one addTarget:self action:@selector(ringSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.hourView addSubview:self.switch_one];
    
    self.switch_two = [UISwitch new];
    [self.switch_two addTarget:self action:@selector(moveSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.muteView addSubview:self.switch_two];
    self.switch_addressBook = [UISwitch new];
    [self.switch_addressBook addTarget:self action:@selector(addressBookSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.addressSetView addSubview:self.switch_addressBook];
    self.switch_allowMicroblog = [UISwitch new];
    [self.switch_allowMicroblog addTarget:self action:@selector(allowMicroblogSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.webSetView addSubview:self.switch_allowMicroblog];
    
    self.switch_wxBound = [UISwitch new];
    [self.switch_wxBound addTarget:self action:@selector(wxBoundSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.wxBoundView addSubview:self.switch_wxBound];
    
    self.switch_wbBound = [UISwitch new];
    [self.switch_wbBound addTarget:self action:@selector(wbBoundSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.wbBoundView addSubview:self.switch_wbBound];
    NSLog(@"%@",[XLBUser user].onlineType);
    self.switch_Online.on = [[XLBUser user].onlineType isEqualToString:@"2"];
    self.switch_one.on = [[XLBUser user].userModel.sound boolValue];
    self.switch_two.on = [[XLBUser user].userModel.messageReminder boolValue];
    self.switch_addressBook.on = [[XLBUser user].userModel.addressbook boolValue];
    self.switch_allowMicroblog.on = [[XLBUser user].userModel.allowMicroblog boolValue];
    self.switch_wxBound.on = [[XLBUser user].userModel.weixinId boolValue];
    self.switch_wbBound.on = [[XLBUser user].userModel.weiboId boolValue];
    
//    [self.switch_Online mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.onlineView);
//        make.right.mas_equalTo(self.onlineView.mas_right).with.offset(-15);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(30);
//    }];
    [self.switch_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hourView);
        make.right.mas_equalTo(self.hourView.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.switch_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.muteView);
        make.right.mas_equalTo(self.muteView.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.switch_addressBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.addressSetView);
        make.right.mas_equalTo(self.addressSetView.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.switch_allowMicroblog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.webSetView);
        make.right.mas_equalTo(self.webSetView.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.switch_wxBound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.wxBoundView);
        make.right.mas_equalTo(self.wxBoundView.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    [self.switch_wbBound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.wbBoundView);
        make.right.mas_equalTo(self.wbBoundView.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];

}
- (void)btnClickWithTag:(UITapGestureRecognizer*)sender {
    
    switch (sender.view.tag) {
        case 10: {
            //关于我们
            [[CSRouter share] push:@"XLBAboutMeViewController" Params:nil hideBar:YES];
        }
            break;
        case 20: {
            //新手引导
            XLBGuidanceViewController *vc = [[XLBGuidanceViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 30: {
            //常见问题
            [[CSRouter share] push:@"XLBQuestionViewController" Params:nil hideBar:YES];

        }
            break;
        case 40: {
            //退出
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self logout];
            }];
            [defaultAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

            [alertController addAction:defaultAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];

        }
            break;
        case 50: {
            //用户信息
            XLBAlterPhoneViewController *alterPhoneVC = [XLBAlterPhoneViewController new];
            alterPhoneVC.telePhone = [XLBUser user].userModel.phone;
            alterPhoneVC.block = ^(id telePhone) {
                NSLog(@"%@",telePhone);
                self.phoneLbl.text = [telePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            };
            [self.navigationController pushViewController:alterPhoneVC animated:YES];
//            [[CSRouter share]push:@"XLBAccountViewController" Params:nil hideBar:YES];

        }
            break;
        default:
            break;
    }
}

- (void)ringSwitch:(UISwitch *)sender {
    
    [self updateNotifitionModel:@"sound" value:sender.on];
}

- (void)moveSwitch:(UISwitch *)sender {
    NSLog(@"%d",sender.on);
    [self updateNotifitionModel:@"messageReminder" value:sender.on];
}
- (void)addressBookSwitch:(UISwitch *)sender {
    [self updateNotifitionModel:@"addressbook" value:sender.on];
}

- (void)allowMicroblogSwitch:(UISwitch *)sender {
    [self updateNotifitionModel:@"allowMicroblog" value:sender.on];
}

- (void)wxBoundSwitch:(UISwitch *)sender {
    
    kWeakSelf(self);
    if (sender.on == YES) {
        NSLog(@"开始绑定");
        [weakSelf showHudWithText:@"正在绑定"];
        [[BQLAuthEngine sharedAuthEngine] auth_wechat_login:^(id response) {
            NSLog(@"%@",response);
            if (kNotNil(response) && kNotNil([response objectForKey:@"weixinId"])) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[response objectForKey:@"unionid"] forKey:@"weixinId"];
                [[NetWorking network] POST:kWxForbid params:params cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                    [weakSelf hideHud];
                    [MBProgressHUD showSuccess:@"绑定成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                    
                } failure:^(NSString *description) {
                    [self.switch_wxBound setOn:NO animated:YES];
                    [weakSelf hideHud];
                    [MBProgressHUD showError:description];
                }];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.switch_wxBound setOn:NO animated:YES];
                    [weakSelf hideHud];
                });
            }
            
        } failure:^(NSString *error) {
            [self.switch_wbBound setOn:NO animated:YES];
            [weakSelf hideHud];
            [MBProgressHUD showError:error];
        }];
    }else {
        NSLog(@"解除绑定");
        [self cancleWithSwitchType:NO];
    }
}

- (void)wbBoundSwitch:(UISwitch *)sender {
    kWeakSelf(self);
    if (sender.on == YES) {
        [weakSelf showHudWithText:@"正在绑定"];
        [[BQLAuthEngine sharedAuthEngine] auth_sina_login:^(id response) {
            NSLog(@"%@",response);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (kNotNil(response) && kNotNil(response[@"id"])) {
                [params setObject:response[@"id"] forKey:@"weiboId"];
                [[NetWorking network] POST:kWbForbid params:params cache:NO success:^(id result) {
                    [weakSelf hideHud];
                    [MBProgressHUD showSuccess:@"绑定成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                    
                } failure:^(NSString *description) {
                    [self.switch_wbBound setOn:NO animated:YES];
                    [weakSelf hideHud];
                    [MBProgressHUD showError:description];
                }];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideHud];
                    [self.switch_wbBound setOn:NO animated:YES];
                });
            }
            
        } failure:^(NSString *error) {
            [weakSelf hideHud];
            [self.switch_wbBound setOn:NO animated:YES];
            [MBProgressHUD showError:error];
        }];
    }else {
        [self cancleWithSwitchType:YES];
    }
}

- (void)cancleWithSwitchType:(BOOL)type {
    UIAlertController *aler1 = [UIAlertController alertControllerWithTitle:@"是否解除绑定？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *certain = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"0" forKey:@"type"];
        [[NetWorking network] POST: type ? kWbCancle : kWxCancle params:params cache:NO success:^(id result) {
            NSLog(@"%@",result);
            [MBProgressHUD showSuccess:@"解除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
            
        } failure:^(NSString *description) {
            type ? [self.switch_wbBound setOn:YES animated:YES] : [self.switch_wxBound setOn:YES animated:YES];
            [MBProgressHUD showError:description];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        type ? [self.switch_wbBound setOn:YES animated:YES] : [self.switch_wxBound setOn:YES animated:YES];
    }];
    [aler1 addAction:certain];
    [aler1 addAction:cancel];
    [self presentViewController:aler1 animated:YES completion:nil];
}
//设置是否在线
- (void)isOnlineSwitch:(id)sender {
    UISwitch *switch1 = sender;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:switch1.on ? @(2):@(0) forKey:@"onlineType"];
    [[NetWorking network] POST:kSYOnline params:params cache:NO success:^(id result) {
        NSLog(@"修改成功");
        [XLBUser user].onlineType = [NSString stringWithFormat:@"%@",[params objectForKey:@"onlineType"]];
    } failure:^(NSString *description) {
        NSLog(@"修改失败");
    }];
}

- (void)updateNotifitionModel:(NSString *)key value:(BOOL )on {
    NSLog(@"%d",on);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:on ? @(1):@(0) forKey:key];
    [[NetWorking network] POST:kSystem params:params cache:NO success:^(id result) {
        NSLog(@"修改成功");
        if ([key isEqualToString:@"messageReminder"]) {
            UILabel *lbl = [self.muteView viewWithTag:1];
            if (on == YES) {
                lbl.text = @"关闭后，扫描人将不能编辑留言与车辆信息发送给您";
            }else {
                lbl.text = @"开启后，扫描人将可以编辑留言与车辆信息发送给您";
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneSuccess" object:nil];
    } failure:^(NSString *description) {
        NSLog(@"修改失败");
    }];
}
- (void)clearTmpPics {
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}
- (void)logout {
    
    // 环信登出
    kWeakSelf(self);
    [weakSelf showHudWithText:@"正在退出..."];
    [self clearTmpPics];
    [[NetWorking network] POST:kLogout params:nil cache:NO success:^(id result) {
        [weakSelf hideHud];
        [[EMClient sharedClient] logout:YES completion:nil];
        [[XLBUser user] logout];
        // 切换主控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *description) {
        
        [weakSelf hideHud];
        [[EMClient sharedClient] logout:YES completion:nil];
        [[XLBUser user] logout];
        // 切换主控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (CGFloat)getCachSize {
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    __block NSUInteger count = 0;
    for (NSString *file in enumerator) {
        NSString *path = [myCachePath stringByAppendingPathComponent:file];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        count += fileDict.fileSize;
    }
    CGFloat cacheSize = ((CGFloat)imageCacheSize+count)/1024/1024;
    return cacheSize;
}

- (void)clearBtnClick:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] cleanDisk];
        NSString *myCachePaht = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        [[NSFileManager defaultManager] removeItemAtPath:myCachePaht error:nil];
        self.fileLabel.text = @"0.00M";
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:action];
    [alertController addAction:cancle];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
