//
//  XLBInviteQRCodeViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/29.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteQRCodeViewController.h"
#import "XLBInviteView.h"
#import "BQLAuthEngine.h"
@interface XLBInviteQRCodeViewController ()<XLBInviteViewDelegate>

@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIView *qrBgV;
@property (nonatomic, strong) UIImageView *qrImg;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) XLBInviteView *inviteV;
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) UIImage *shareImg;
@end

@implementation XLBInviteQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    self.naviBar.slTitleLabel.text = @"邀请好友";
    [self setSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];

}

- (void)userDidTakeScreenshot:(NSNotification *)notification {
    if ((![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        return;
    }
    
    _inviteV = [XLBInviteView new];
    _inviteV.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [_inviteV addGestureRecognizer:tap];
    _shareImg = [XLBInviteQRCodeViewController imageWithScreenshot];
    _inviteV.screenShotImg.image = _shareImg;
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:_inviteV];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        _inviteV.weChatBtn.hidden = YES;
        _inviteV.friendsBtn.hidden = YES;
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        _inviteV.qqBtn.hidden = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        _inviteV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }];
}
- (void)inviteViewBtnClickWithTag:(UIButton *)sender {
    UIImage *image = [self scaleFromImage:_shareImg];
    NSDictionary *dict = @{@"image":image};
    BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:dict];
    switch (sender.tag) {
        case WeChatBtnTag:{
            [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_image:shareModel scene:WechatShareSceneSession success:^(id response) {
                NSLog(@"%@",response);
                
            } failure:^(NSString *error) {
                NSLog(@"%@",error);
                
            }];
            
        }
            break;
        case FriendsBtnTag:{
            [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_image:shareModel scene:WechatShareSceneTimeline success:^(id response) {
                NSLog(@"%@",response);

            } failure:^(NSString *error) {
                NSLog(@"%@",error);

            }];
        }
            break;
        case QQBtnTag:{
            [[BQLAuthEngine sharedAuthEngine] auth_sina_share_image:shareModel success:^(id response) {
                
            } failure:^(NSString *error) {
                
            }];
        }
            break;
        case CancleBtnTag:{
            [UIView animateWithDuration:0.5 animations:^{
                _inviteV.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                [_inviteV removeFromSuperview];
                _inviteV = nil;
            }];
        }
            break;
            
        default:
            break;
    }
}
- (void)tapGes:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.5 animations:^{
        _inviteV.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_inviteV removeFromSuperview];
        _inviteV = nil;
    }];
}

//截取当前屏幕
+ (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}
//返回截取到的图片
+ (UIImage *)imageWithScreenshot {
    NSData *imageData = [XLBInviteQRCodeViewController dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}


- (UIImage *)scaleFromImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    NSData *data =UIImagePNGRepresentation(image);
    CGFloat dataSize = data.length/1024;
    NSLog(@"%f",dataSize);
    CGFloat width  = image.size.width;
    CGFloat height = image.size.height;
    CGSize size;
    if (iPhone6Plus) {
        size = CGSizeMake(width/3.f, height/3.f);
    }else {
        size = CGSizeMake(width/2.f, height/2.f);
    }
    NSLog(@"%f,%f",size.width,size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (!newImage) {
        return image;
    }
    return newImage;
}
- (void)setSubViews {
    UIImageView *bgImg = [UIImageView new];
    bgImg.image = [UIImage imageNamed:@"bg_yq"];
    [self.view addSubview:bgImg];
    
    _userImg = [UIImageView new];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    _userImg.layer.masksToBounds = YES;
    _userImg.layer.cornerRadius = 24;
    [self.view addSubview:_userImg];
    
    _nickName = [UILabel new];
    _nickName.text = [XLBUser user].userModel.nickname;
    _nickName.textColor = [UIColor commonTextColor];
    _nickName.font = [UIFont systemFontOfSize:18];
    _nickName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_nickName];
    
    _qrBgV = [UIView new];
    
    _qrBgV.backgroundColor = [UIColor whiteColor];
    
    _qrBgV.layer.masksToBounds = YES;
    _qrBgV.layer.cornerRadius = 15;
    [self.view addSubview:_qrBgV];
    
    
    _qrImg = [UIImageView new];
    _qrImg.image = [UIImage imageNamed:@"xlbdl"];
    [_qrBgV addSubview:_qrImg];
    
    _remindLabel = [UILabel new];
    _remindLabel.text = @"扫描图上二维码\n加入小喇叭";
    _remindLabel.numberOfLines = 0;
    _remindLabel.textColor = [UIColor commonTextColor];
    _remindLabel.font = [UIFont systemFontOfSize:18];
    _remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_remindLabel];
    
//    _inviteV = [XLBInviteView new];
//    _inviteV.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_inviteV];
    
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);

        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(52*kiphone6_ScreenHeight);
        make.left.mas_equalTo(self.view.mas_left).with.offset(53*kiphone6_ScreenWidth);
        make.width.height.mas_equalTo(48);
    }];
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userImg.mas_centerY);
        make.left.mas_equalTo(self.userImg.mas_right).with.offset(20);
    }];
    
    [_qrBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_bottom).with.offset(26*kiphone6_ScreenHeight);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-48*kiphone6_ScreenWidth);
        make.left.mas_equalTo(self.view.mas_left).with.offset(48*kiphone6_ScreenWidth);
        make.height.mas_equalTo(self.qrBgV.mas_width);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_qrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.qrBgV).with.offset(10);
        make.right.bottom.mas_equalTo(self.qrBgV).with.offset(-10);
        make.centerX.mas_equalTo(self.qrBgV.mas_centerX);

    }];
    
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrBgV.mas_bottom).with.offset(34*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(self.qrBgV.mas_centerX);
    }];
    
    [_inviteV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.height.mas_equalTo(kSCREEN_HEIGHT);
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
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
