//
//  MakingTheCertificationViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "MakingTheCertificationViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MakingTheCertificationViewController ()
{
    AVAudioPlayer *_avPlayer;
    AVAudioRecorder *_recorder;
    AVAudioSession *_session;
    
    UIView *photoView;
    UIView *theRecordingView;
    UIImageView *photoImg;
    UIButton *statusBtn;
    UIButton *theRecordBtn;
    UIButton *theRecordStatusBtn;
}
@end

@implementation MakingTheCertificationViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([XLBUser user].imgAkira !=nil&&photoImg!=nil) {
        [photoImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].imgAkira Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"btn_sczp_h"]];
    }
    if (statusBtn !=nil) {
        if ([[XLBUser user].imgStatus isEqualToString:@"2"]) {
            [statusBtn setTitle:@"未通过" forState:0];
        }else if ([[XLBUser user].imgStatus isEqualToString:@"1"]) {
            [statusBtn setTitle:@"审核中" forState:0];
        }else if ([[XLBUser user].imgStatus isEqualToString:@"3"]) {
            [statusBtn setTitle:@"已通过" forState:0];
        }
    }
    if (theRecordStatusBtn !=nil) {
        if ([[XLBUser user].voiceStatus isEqualToString:@"2"]) {
            [theRecordStatusBtn setTitle:@"未通过" forState:0];
        }else if ([[XLBUser user].voiceStatus isEqualToString:@"1"]) {
            [theRecordStatusBtn setTitle:@"审核中" forState:0];
        }else if ([[XLBUser user].voiceStatus isEqualToString:@"3"]) {
            [theRecordStatusBtn setTitle:@"已通过" forState:0];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"声优认证";
    self.naviBar.slTitleLabel.text = @"声优认证";
    [self addsubView];
    // Do any additional setup after loading the view.
}
-(void)addsubView {
    UIImageView *backImage = [UIImageView new];
    backImage.image = [UIImage imageNamed:@"bg_syrz"];
    backImage.alpha = 0.6;
    [self.view addSubview:backImage];
    
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(-88);
        }else{
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(-64);
        }
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    UIImageView *titleImg = [UIImageView new];
    titleImg.image = [UIImage imageNamed:@"pic_syrz"];
    [self.view addSubview:titleImg];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(30);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(169);
        make.height.mas_equalTo(117);
    }];
    photoView= [UIView new];
    [self.view addSubview:photoView];
    UITapGestureRecognizer *photoTap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushPhotoVC)];
    [photoView addGestureRecognizer:photoTap];
    UIView *vLineView = [UIView new];
    vLineView.layer.cornerRadius = 2.5;
    vLineView.layer.backgroundColor = [[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] CGColor];
    [photoView addSubview:vLineView];
    UILabel *photoLbl =[UILabel new];
    photoLbl.font = [UIFont systemFontOfSize:16];
    photoLbl.textColor = [UIColor textBlackColor];
    photoLbl.text = @"照片审核:";
    [photoView addSubview:photoLbl];

    photoImg = [UIImageView new];
    photoImg.layer.cornerRadius = 5;
    photoImg.layer.borderWidth = 1;
    photoImg.layer.masksToBounds = YES;
    photoImg.image = [UIImage imageNamed:@"btn_sczp_h"];
    if ([XLBUser user].imgAkira !=nil) {
        [photoImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].imgAkira Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"btn_sczp_h"]];
    }
    [photoView addSubview:photoImg];

    statusBtn = [UIButton new];
    statusBtn.enabled = NO;
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [statusBtn setTitleColor:[UIColor whiteColor] forState:0];
    [statusBtn setTitle:@"未认证" forState:0];
    statusBtn.layer.cornerRadius = 15;
    [statusBtn setBackgroundColor:[UIColor textRightColor]];
    //图片认证状态:0未认证 ,1审核中,2未通过,3已通过
    [statusBtn setHidden:NO];
    if ([[XLBUser user].imgStatus isEqualToString:@"2"]) {
        [statusBtn setTitle:@"未通过" forState:0];
        [statusBtn setBackgroundColor:[UIColor blackColor]];
    }else if ([[XLBUser user].imgStatus isEqualToString:@"1"]) {
        [statusBtn setTitle:@"审核中" forState:0];
        [statusBtn setBackgroundColor:[UIColor textRightColor]];
    }else if ([[XLBUser user].imgStatus isEqualToString:@"3"]) {
        [statusBtn setTitle:@"已通过" forState:0];
        [statusBtn setHidden:YES];
    }
    [photoView addSubview:statusBtn];
    
    theRecordingView= [UIView new];
    [self.view addSubview:theRecordingView];
    
    UITapGestureRecognizer *theRecordingtap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushTheRecordingVC)];
    [theRecordingView addGestureRecognizer:theRecordingtap];
    UIView *vLineView2 = [UIView new];
    vLineView2.layer.cornerRadius = 2.5;
    vLineView2.layer.backgroundColor = [[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] CGColor];
    [theRecordingView addSubview:vLineView2];
    UILabel *theRecordLbl =[UILabel new];
    theRecordLbl.font = [UIFont systemFontOfSize:16];
    theRecordLbl.textColor = [UIColor textBlackColor];
    theRecordLbl.text = @"声音审核:";
    [theRecordingView addSubview:theRecordLbl];
    
    theRecordBtn = [UIButton new];
    [theRecordBtn setImage:[UIImage imageNamed:@"btn_sts_h"] forState:0];
    theRecordBtn.enabled = NO;
    [theRecordBtn addTarget:self action:@selector(playvideo) forControlEvents:UIControlEventTouchUpInside];
    [theRecordingView addSubview:theRecordBtn];
    
    theRecordStatusBtn = [UIButton new];
    theRecordStatusBtn.enabled = NO;
    theRecordStatusBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [theRecordStatusBtn setTitle:@"未认证" forState:0];
    theRecordStatusBtn.layer.cornerRadius = 15;
    [theRecordStatusBtn setTitleColor:[UIColor whiteColor] forState:0];
    [theRecordStatusBtn setBackgroundColor:[UIColor textRightColor]];
    //图片认证状态:0未认证 ,1审核中,2未通过,3已通过
    [theRecordStatusBtn setHidden:NO];
    if ([[XLBUser user].voiceStatus isEqualToString:@"2"]) {
        [theRecordStatusBtn setTitle:@"未通过" forState:0];
        [theRecordStatusBtn setBackgroundColor:[UIColor blackColor]];

    }else if ([[XLBUser user].voiceStatus isEqualToString:@"1"]) {
        [theRecordStatusBtn setTitle:@"审核中" forState:0];
        [theRecordStatusBtn setBackgroundColor:[UIColor textRightColor]];
    }else if ([[XLBUser user].voiceStatus isEqualToString:@"3"]) {
        [theRecordStatusBtn setTitle:@"已通过" forState:0];
        [theRecordStatusBtn setHidden:YES];
    }
    [theRecordingView addSubview:theRecordStatusBtn];
    
    UILabel *tipLbl =[UILabel new];
    tipLbl.font = [UIFont systemFontOfSize:14];
    tipLbl.textColor = [UIColor minorTextColor];
    tipLbl.textAlignment = NSTextAlignmentCenter;
    tipLbl.numberOfLines = 2;
    tipLbl.text = @"已完成申请资料\n我们会在1-2工作日内审核";
    [self.view addSubview:tipLbl];
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleImg.mas_bottom).with.offset(45);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoView.mas_left).with.offset(30);
        make.centerY.mas_equalTo(photoView);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(16);
    }];
    [photoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vLineView.mas_left).with.offset(12);
        make.centerY.mas_equalTo(photoView);
    }];
    [photoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(photoView);
        make.height.width.mas_equalTo(90);
    }];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(photoView.mas_right).with.offset(-30);
        make.centerY.mas_equalTo(photoView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];

    [theRecordingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    [vLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(theRecordingView.mas_left).with.offset(30);
        make.centerY.mas_equalTo(theRecordingView);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(16);
    }];
    [theRecordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vLineView2.mas_left).with.offset(12);
        make.centerY.mas_equalTo(theRecordingView);
    }];
    [theRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(theRecordingView);
        make.height.width.mas_equalTo(90);
    }];
    [theRecordStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(theRecordingView.mas_right).with.offset(-30);
        make.centerY.mas_equalTo(theRecordingView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-50);
        make.centerX.mas_equalTo(self.view);
    }];
}
-(void)pushPhotoVC{
    //认证照片
    [[CSRouter share]push:@"CertificationPhotoViewController" Params:nil hideBar:YES];
}
-(void)pushTheRecordingVC {
    //认证声音
    [[CSRouter share]push:@"TheRecordingViewController" Params:@{@"isPushTo":@"3"} hideBar:YES];

}

-(void)playvideo{
    NSString *string = [NSString stringWithFormat:@"%@%@",kImagePrefix,[XLBUser user].voiceAkira];
    NSURL *url = [NSURL URLWithString:string];
    _avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    NSLog(@"%li",_avPlayer.data.length/1024);
    
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_avPlayer play];
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
