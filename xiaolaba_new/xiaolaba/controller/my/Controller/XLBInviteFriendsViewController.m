//
//  XLBInviteFriendsViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/28.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteFriendsViewController.h"
#import "XLBInviteFriendsView.h"
#import "BQLAuthEngine.h"
#import "XLBInviteModel.h"
#import "XLBInviteSuccViewController.h"
#import "XLBQRShareView.h"
@interface XLBInviteFriendsViewController ()<XLBInviteFriendsViewDelegate>

@property (nonatomic, strong)NSMutableDictionary *data;

@property (nonatomic, strong)XLBInviteFriendsView *inviteFriendsV;

@property (nonatomic, strong)XLBQRShareView *qrShare;

@end

@implementation XLBInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    self.naviBar.slTitleLabel.text = @"邀请好友";
    [MobClick event:@"InviteFriends"];
    [self setSubViews];
    [self reqeust];
    
}

- (void)reqeust {
    [[NetWorking network] POST:kUicode params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            _inviteFriendsV.dataDic = result;
            _data = [NSMutableDictionary dictionaryWithDictionary:result];
            _qrShare.inviteLabel.text = _data[@"ucode"];
            [self initNaviBar];
        }
    } failure:^(NSString *description) {
        
    }];
}
- (void)initNaviBar {
    [super initNaviBar];
    if ([_data[@"status"] isEqualToString:@"0"]) {
        UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [rightItem setTitle:@"填写邀请码" forState:0];
        rightItem.titleLabel.textAlignment = NSTextAlignmentRight;
        rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightItem setTitleColor:[UIColor mainColor] forState:0];
        [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        [self.naviBar setRightItem:rightItem];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    }
}

- (void)rightClick {
    if (![_data[@"status"] isEqualToString:@"0"] || !kNotNil(_data[@"ucode"])) return;
    XLBInviteSuccViewController *succVC = [[XLBInviteSuccViewController alloc] init];
    succVC.ucode = _data[@"ucode"];
    succVC.returnBlock = ^(id data) {
        self.naviBar.rightItem.hidden = YES;
//        self.navigationItem.rightBarButtonItem = nil;
        [self reqeust];
    };
    [self.navigationController pushViewController:succVC animated:YES];
//    [[CSRouter share] push:@"XLBInviteSuccViewController" Params:@{@"ucode":_data[@"ucode"]} hideBar:YES];
}

- (void)setSubViews {
    _inviteFriendsV = [[XLBInviteFriendsView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
    _inviteFriendsV.delegate = self;
    [self.view addSubview:_inviteFriendsV];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        _inviteFriendsV.friendsBtn.hidden = YES;
        _inviteFriendsV.weChatBtn.hidden = YES;
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        _inviteFriendsV.qqBtn.hidden = YES;
    }
    
    _qrShare = [[XLBQRShareView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT + 30, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _qrShare.topLabel.text = [NSString stringWithFormat:@"%@的专属邀请码",[XLBUser user].userModel.nickname];
    [self.view addSubview:_qrShare];
}

- (void)inviteFriendsViewBtnWithTag:(UIButton *)sender {
//    if (!kNotNil(_data[@"ucode"])) return;
    UIImage *img1 = [_qrShare imageWithUIView:_qrShare];
    UIImage *scal = [self scaleFromImage:img1];
    BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:@{@"image":scal,}];
    switch (sender.tag) {
        case FriendsShareTag: {
            if (!kNotNil(_data[@"ucode"])) return;
            [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_image:shareModel scene:WechatShareSceneTimeline success:^(id response) {

            } failure:^(NSString *error) {

            }];
        }
            break;
        case WeChatBtnTag: {
            if (!kNotNil(_data[@"ucode"])) return;

            [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_image:shareModel scene:WechatShareSceneSession success:^(id response) {
                
            } failure:^(NSString *error) {
                
            }];
        }
            break;
        case QQShareTag: {
            if (!kNotNil(_data[@"ucode"])) return;

            [[BQLAuthEngine sharedAuthEngine] auth_sina_share_image:shareModel success:^(id response) {
                
            } failure:^(NSString *error) {
                
            }];
        }
            break;
        case InviteCountBtnTag: {
            if (!kNotNil(_data[@"ucode"])) return;
            [[CSRouter share] push:@"XLBInviteListViewController" Params:@{@"uicode":_data[@"ucode"]} hideBar:YES];
        }
            break;
        case RangkingBtnTag: {
            
        }
            break;
        case QrCodeBtnTag: {
            [[CSRouter share] push:@"XLBInviteQRCodeViewController" Params:nil hideBar:YES];
        }
            break;
            
        default:
            break;
    }
}
- (UIImage *)scaleFromImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size = CGSizeMake(width/3.f, height/3.f);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage) {
        return image;
    }
    return newImage;
}

- (NSMutableDictionary *)data {
    if (!_data) {
        _data = [NSMutableDictionary dictionary];
    }
    return _data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
