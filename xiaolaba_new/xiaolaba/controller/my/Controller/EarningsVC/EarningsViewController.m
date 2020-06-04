//
//  EarningsViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "EarningsViewController.h"
#import "XLBEarningsView.h"

@interface EarningsViewController ()<XLBEarningsViewDelegate>
@property (nonatomic, strong) XLBEarningsView *earningsV;
@end

@implementation EarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收益";
    self.naviBar.slTitleLabel.text = @"我的收益";
    self.earningsV.backgroundColor = [UIColor whiteColor];
}
- (void) initNaviBar {
    [super initNaviBar];
    
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"收支明细" forState:0];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightItem setTitleColor:[UIColor textBlackColor] forState:0];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

- (void)rightClick {
    //收支明细
    [[CSRouter share] push:@"EarningsListViewController" Params:nil hideBar:YES];
}
- (void)earningsBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case EarningsWithDrawTag: {
            NSLog(@"提现");
            [[CSRouter share] push:@"WithdrawViewController" Params:nil hideBar:YES];
        }
            break;
        case EarningsConversionTag: {
            NSLog(@"兑换");
            [[CSRouter share] push:@"ConversionViewController" Params:nil hideBar:YES];
        }
            break;
        case EarningsQuestionTag: {
            NSLog(@"常见问题");
            [[CSRouter share] push:@"TaskViewController" Params:nil hideBar:YES];

        }
            break;
            
        default:
            break;
    }
}

- (XLBEarningsView *)earningsV {
    if (!_earningsV) {
        _earningsV = [[XLBEarningsView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom)];
        _earningsV.delegate = self;
        [self.view  addSubview:_earningsV];
    }
    return _earningsV;
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
