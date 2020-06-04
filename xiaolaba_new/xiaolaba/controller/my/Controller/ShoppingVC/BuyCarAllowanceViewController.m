//
//  BuyCarAllowanceViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/7/13.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "BuyCarAllowanceViewController.h"
#import "XLBMeRequestModel.h"
#import "XLBInviteModel.h"
#import "XLBChatViewController.h"
#import "BQLShareModel.h"
#import "BQLAuthEngine.h"
@interface BuyCarAllowanceViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIImageView *topImg;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UITextView *contentLabel;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UILabel *inviteLabel;
@property (nonatomic, strong) UIView *inviteLine;
@property (nonatomic, strong) UIView *inviteLine1;


@property (nonatomic, strong) UIView *firstV;
@property (nonatomic, strong) UIView *secondV;
@property (nonatomic, strong) UIView *threeV;
@property (nonatomic, strong) UIButton *getBtn;

@end

@implementation BuyCarAllowanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费领取";
    self.naviBar.slTitleLabel.text = @"免费领取";
    [MobClick event:@"Get_CarTie"];
    // Do any additional setup after loading the view.
    [self setSubViews];
}

- (void)buyCarAllowanceBtnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            [MBProgressHUD showError:@"该活动暂未开启"];
            return;
        }
        BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:nil];
        shareModel.title = @"【小喇叭】快来领取免费挪车贴";
        shareModel.urlString = kDomainUrl;
        shareModel.image = [UIImage imageNamed:@"shareImg"];
        shareModel.describe = @"邀请好友即可免费领，手快有，手慢无～";
        [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_link:shareModel scene:WechatShareSceneSession success:^(id response) {
            
        } failure:^(NSString *error) {
            
        }];
        
    }else if (sender.tag == 200) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            [MBProgressHUD showError:@"该活动暂未开启"];
            return;
        }
        UIImage *image = [UIImage imageNamed:@"weixinShare"];
        WXMediaMessage *message = [WXMediaMessage message];
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = UIImagePNGRepresentation(image);
        message.mediaObject = imageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.bText = NO;
        req.scene = WechatShareSceneTimeline;
        [WXApi sendReq:req];
    }else if (sender.tag == 300) {
        if (self.data.count < 3) {
            [MBProgressHUD showSuccess:@"不满足免费领取条件"];
            return;
        }else {
            [[CSRouter share] push:@"PayCheTieViewController" Params:@{@"type":@"1"} hideBar:YES];
        }
    }
}
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

- (void)setSubViews {
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Invitefriends_back"]];
    self.bgImg.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self.scrollView addSubview:self.bgImg];
    
    self.topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invite_title"]];
    self.topImg.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH - 10, 196/740.0*(kSCREEN_WIDTH-10));
    self.topImg.centerX = self.view.centerX;
    [self.scrollView addSubview:self.topImg];

    self.topLabel = [UILabel new];
    self.topLabel.text = @"活动规则";
    self.topLabel.font = [UIFont systemFontOfSize:18];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.frame = CGRectMake(0, self.topImg.bottom + 20, 90, 18);
    self.topLabel.centerX = self.view.centerX;
    [self.scrollView addSubview:self.topLabel];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor whiteColor];
    self.line.frame = CGRectMake(27, 0, (kSCREEN_WIDTH - 90 - 20 - 54)/2, 0.7);
    self.line.centerY = self.topLabel.centerY;
    [self.scrollView addSubview:self.line];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [UIColor whiteColor];
    self.line1.frame = CGRectMake(self.topLabel.right + 10, 0, (kSCREEN_WIDTH - 90 - 20 - 54)/2, 0.7);
    self.line1.centerY = self.topLabel.centerY;
    [self.scrollView addSubview:self.line1];

    NSString *string = @"方式一：将小喇叭邀请链接分享给好友，通过链接成功下载APP并填写邀请码达到3人，即可免费领取挪车贴一张，每个ID限领一张。\n\n方式二：分享图片到朋友圈，集满18个赞可联系小喇叭客服免费领取挪车贴一张，每个ID限领一张。如有疑问请联系在线客服";
    CGFloat height = [string sizeWithMaxWidth:kSCREEN_WIDTH - 54 font:[UIFont systemFontOfSize:14]].height;
    CGFloat contentHeight;
    if (iPhone5s) {
       contentHeight = height + 60;
    }else {
       contentHeight = height + 40;
    }
    self.contentLabel = [UITextView new];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.editable = NO;
    self.contentLabel.delegate = self;
    self.contentLabel.scrollEnabled = NO;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.frame = CGRectMake(27, self.topLabel.bottom + 20, kSCREEN_WIDTH - 54, contentHeight);
    [self.scrollView addSubview:self.contentLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.f;
    paragraphStyle.alignment = self.contentLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [string length] - 4)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"zaixiankefu://"
                             range:[[attributedString string] rangeOfString:@"在线客服"]];
    self.contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightColor]};
    
    self.contentLabel.attributedText = attributedString;
    
    self.btn = [UIButton new];
    [self.btn setTitle:@"邀请好友" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"btn_yq"] forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn.layer.masksToBounds = YES;
    self.btn.tag = 100;
    self.btn.layer.cornerRadius = 5;
    [self.btn addTarget:self action:@selector(buyCarAllowanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.frame = CGRectMake(29, self.contentLabel.bottom + 22, 140 * kiphone6_ScreenWidth, 40);
    [self.scrollView addSubview:self.btn];
    
    self.shareBtn = [UIButton new];
    [self.shareBtn setTitle:@"分享图片" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_yq"] forState:UIControlStateNormal];
    self.shareBtn.tag = 200;
    [self.shareBtn addTarget:self action:@selector(buyCarAllowanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn.layer.masksToBounds = YES;
    self.shareBtn.layer.cornerRadius = 5;
    self.shareBtn.frame = CGRectMake(kSCREEN_WIDTH - 29 - (140 * kiphone6_ScreenWidth), 0, 140 * kiphone6_ScreenWidth, 40);
    self.shareBtn.centerY = self.btn.centerY;
    [self.scrollView addSubview:self.shareBtn];
    
    self.inviteLabel = [UILabel new];
    self.inviteLabel.text = @"邀请的好友";
    self.inviteLabel.textColor = [UIColor whiteColor];
    self.inviteLabel.font = [UIFont systemFontOfSize:18];
    self.inviteLabel.textAlignment = NSTextAlignmentCenter;
    self.inviteLabel.frame =CGRectMake(0, self.btn.bottom + 34, 100, 18);
    self.inviteLabel.centerX = self.view.centerX;
    [self.scrollView addSubview:self.inviteLabel];
    
    self.inviteLine = [UIView new];
    self.inviteLine.backgroundColor = [UIColor whiteColor];
    self.inviteLine.frame = CGRectMake(self.inviteLabel.right + 10, 0, (kSCREEN_WIDTH - 100 - 20 - 54)/2, 0.7);
    self.inviteLine.centerY = self.inviteLabel.centerY;
    [self.scrollView addSubview:self.inviteLine];
    
    self.inviteLine1 = [UIView new];
    self.inviteLine1.backgroundColor = [UIColor whiteColor];
    self.inviteLine1.frame = CGRectMake(27, 0, (kSCREEN_WIDTH - 100 - 20 - 54)/2, 0.7);
    self.inviteLine1.centerY = self.inviteLabel.centerY;
    [self.scrollView addSubview:self.inviteLine1];
    NSLog(@"%@",self.data);
    if (kNotNil(self.data) && self.data.count > 0) {
        if (self.data.count == 1) {
            self.firstV = [self setUserImgWithFrame:CGRectMake(0, self.inviteLabel.bottom + 20, kSCREEN_WIDTH, 40) model:self.data[0]];
            [self.scrollView addSubview:self.firstV];
        }else if (self.data.count == 2) {
            self.firstV = [self setUserImgWithFrame:CGRectMake(0, self.inviteLabel.bottom + 20, kSCREEN_WIDTH, 40) model:self.data[0]];
            [self.scrollView addSubview:self.firstV];
            
            self.secondV = [self setUserImgWithFrame:CGRectMake(0, self.firstV.bottom + 10, kSCREEN_WIDTH, 40) model:self.data[1]];
            [self.scrollView addSubview:self.secondV];
        }else if (self.data.count == 3) {
            self.firstV = [self setUserImgWithFrame:CGRectMake(0, self.inviteLabel.bottom + 20, kSCREEN_WIDTH, 40) model:self.data[0]];
            [self.scrollView addSubview:self.firstV];
            
            self.secondV = [self setUserImgWithFrame:CGRectMake(0, self.firstV.bottom + 10, kSCREEN_WIDTH, 40) model:self.data[1]];
            [self.scrollView addSubview:self.secondV];
            
            self.threeV = [self setUserImgWithFrame:CGRectMake(0, self.secondV.bottom + 10, kSCREEN_WIDTH, 40) model:self.data[2]];
            [self.scrollView addSubview:self.threeV];
        }
    }

    
    self.getBtn = [UIButton new];
    [self.getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getBtn setTitle:@"免费领取" forState:UIControlStateNormal];
    [self.getBtn addTarget:self action:@selector(buyCarAllowanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.getBtn setBackgroundImage:[UIImage imageNamed:@"btn_lq"] forState:UIControlStateNormal];
    self.getBtn.tag = 300;
    self.getBtn.layer.masksToBounds = YES;
    self.getBtn.layer.cornerRadius = 5;
    self.getBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.getBtn.frame = CGRectMake(0, self.inviteLabel.bottom + 40, kSCREEN_WIDTH - 54, 40);
    if (self.data.count == 1) {
        self.getBtn.frame = CGRectMake(0, self.firstV.bottom + 20, kSCREEN_WIDTH - 54, 40);

    }else if (self.data.count == 2) {
        self.getBtn.frame = CGRectMake(0, self.secondV.bottom + 20, kSCREEN_WIDTH - 54, 40);

    }else if (self.data.count == 3) {
        self.getBtn.frame = CGRectMake(0, self.threeV.bottom + 20, kSCREEN_WIDTH - 54, 40);
    }
    self.getBtn.centerX = self.view.centerX;
    [self.scrollView addSubview:self.getBtn];
    
    self.bgImg.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.getBtn.bottom + 200);
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.getBtn.bottom + 30);
}

- (UIView *)setUserImgWithFrame:(CGRect)rect model:(XLBInviteModel *)model{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UIImageView *userImg = [UIImageView new];
    [userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[NSString stringWithFormat:@"%@",model.img] Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    userImg.layer.masksToBounds = YES;
    userImg.layer.cornerRadius = 20;
    [view addSubview:userImg];
    
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(28);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *nickNameLabel = [UILabel new];
    nickNameLabel.textColor = [UIColor lightColor];
    nickNameLabel.text = model.nickname;
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    nickNameLabel.frame = CGRectMake(userImg.right + 10, 0, 200, 18);
    nickNameLabel.centerY = userImg.centerY;
    [view addSubview:nickNameLabel];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(userImg.mas_centerY);
        make.left.mas_equalTo(userImg.mas_right).with.offset(10);
    }];
    UILabel * dateLabel = [UILabel new];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.text = [self dateWithDateString:model.createDate];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-28);
        make.centerY.mas_equalTo(0);
    }];
    
    return view;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"zaixiankefu"]) {
        NSLog(@"在线客服---------------");
        XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:@"42327218134736896" conversationType:EMConversationTypeChat];
        chat.hidesBottomBarWhenPushed = YES;
        chat.nickname = @"小喇叭客服";
        chat.avatar = @"http://zhangshangxiaolaba.oss-cn-shanghai.aliyuncs.com/avatar/02B4334D-92E0-4ADA-BCEE-8BB676BBA7DB.jpg";
        chat.userId = @"42327218134736896";
        [self.navigationController pushViewController:chat animated:YES];
        return NO;
    }
    return YES;
}

- (NSString *)dateWithDateString:(NSString *)dateString {
    
    if(kNotNil(dateString)) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        // 获取当前时间的年、月、日
        NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        // 获取消息发送时间的年、月、日
        NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000.0];
        components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
        // 判断
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"MM.dd HH:ss";
        
        return [dateFmt stringFromDate:msgDate];
    }
    else {
        return @"";
    }
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
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
