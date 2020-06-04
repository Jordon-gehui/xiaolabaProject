//
//  XLBAboutMeViewController.m
//  xiaolaba
//
//  Created by lin on 2017/8/22.
//  Copyright © 2017年 jxcode. All rights reserved.
//
/*
 苹果商城地址
 https://itunes.apple.com/cn/app/%E5%B0%8F%E5%96%87%E5%8F%AD-%E4%B8%80%E9%94%AE%E6%8C%AA%E8%BD%A6%E7%A5%9E%E5%99%A8/id1288954548?l=en&mt=8
 */
#import "XLBAboutMeViewController.h"
#import <AFHTTPSessionManager.h>
@interface XLBAboutMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIView *checkV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

@property (weak, nonatomic) IBOutlet UILabel *versionNew;
    @property (weak, nonatomic) IBOutlet UILabel *officialWebsite;
    

@property (nonatomic, assign) BOOL versions;
@end



@implementation XLBAboutMeViewController



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
    self.naviBar.slTitleLabel.text = @"关于我们";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"小喇叭版本 V%@",app_Version];
    self.officialWebsite.text = [NSString stringWithFormat:@"官网：%@",kDomainUrl];
    [[NetWorking network] POST:@"base-data/dict/iosMajor" params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if (kNotNil(result[@"label"]) && [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue] <= [[result[@"label"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
            self.checkV.hidden = NO;
            self.topDistance.constant = 0;
            if ([[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue] == [[result[@"label"] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
                self.versionNew.text = @"最新版本";
            }else {
                self.versionNew.text = @"发现新版本";
            }
        }
        
    } failure:^(NSString *description) {
        
    }];
}



- (IBAction)getVersion:(id)sender {
    if ([self.versionNew.text isEqualToString:@"最新版本"]) return;
//    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1288954548"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kShowAPPStore]];
}


- (IBAction)getAppGrade:(id)sender {
    //itms-apps://itunes.apple.com/cn/app/id1288954548?mt=8&action=write-review
    //itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1288954548&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8
//    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id1288954548?mt=8&action=write-review"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppComment]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
