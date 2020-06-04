//
//  RankingExplainViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/26.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "RankingExplainViewController.h"

@interface RankingExplainViewController ()

@end

@implementation RankingExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜规则";
    self.naviBar.slTitleLabel.text = @"排行榜规则";
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [UIImageView new];
    img.image = [UIImage imageNamed:@"rangingList"];
    [self.scrollView addSubview:img];
    kWeakSelf(self)
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(weakSelf.scrollView).with.offset(35);
        }else {
            make.top.mas_equalTo(weakSelf.scrollView).with.offset(15);
        }
        make.centerX.mas_equalTo(weakSelf.scrollView);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo((kSCREEN_WIDTH-30)*431/330);
        make.bottom.lessThanOrEqualTo(weakSelf.scrollView.mas_bottom).with.offset(-15);
    }];
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
