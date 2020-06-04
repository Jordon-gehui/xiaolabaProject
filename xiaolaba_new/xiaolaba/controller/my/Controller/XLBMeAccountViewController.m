//
//  XLBMeAccountViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMeAccountViewController.h"

@interface XLBMeAccountViewController ()
@property (nonatomic, strong) UIView *topBackV;
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UILabel *chepiaoLbl;

@property (nonatomic, strong) UIImageView *tipImg;
@property (nonatomic, strong) UILabel *tipLbl;

@property (nonatomic, strong) UILabel *leftTipLbl;
@property (nonatomic, strong) UILabel *leftMoneyLbl;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UILabel *rightTipLbl;
@property (nonatomic, strong) UILabel *rightMoneyLbl;
@property (nonatomic, strong) UIButton *tixianBtn;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, copy) NSString *aliNickName;
@property (nonatomic, copy) NSString *aliUserId;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation XLBMeAccountViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self request];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}
- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收益";
    self.naviBar.slTitleLabel.text = @"我的收益";
    _aliNickName = @"";
    _aliUserId = @"";
    [self setSubViews];
    [self request];
}

-(void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"icon_sy_mx"];
    [rightItem setImage:image forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}
-(void)rightClick {
    [[CSRouter share]push:@"EarningsListViewController" Params:nil hideBar:YES];
}

- (void)request {
    [[NetWorking network] POST:kMYShouYi params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        float testMoney = [[result objectForKey:@"chargeMoney"] floatValue];
        NSString *testStr = [NSString stringWithFormat:@"%.2f",testMoney];
        _leftMoneyLbl.text= testStr;
        float ticketMoney = [[result objectForKey:@"ticketSum"] floatValue];
        NSString *_moneyStr = [NSString stringWithFormat:@"%.2f",ticketMoney];
        _moneyLbl.text= _moneyStr;
        
        float _rightMoney = [[result objectForKey:@"transferMoney"] floatValue];

        NSString *_rightMoneyStr = [NSString stringWithFormat:@"%.2f",_rightMoney];
        _aliNickName = [NSString stringWithFormat:@"%@",[result objectForKey:@"aliNickname"]];
        _aliUserId = [NSString stringWithFormat:@"%@",[result objectForKey:@"aliId"]];

       _rightMoneyLbl.text =  _rightMoneyStr;
    } failure:^(NSString *description) {
        
    }];
}

- (void)setSubViews {
    self.topBackV = [UIView new];
    self.topBackV.backgroundColor = [UIColor textBlackColor];
    [self.view addSubview:self.topBackV];
    
    _backImg = [UIImageView new];
    _backImg.image = [UIImage imageNamed:@"pic_sy_bg"];
    [_topBackV addSubview:_backImg];
    
    _moneyLbl = [UILabel new];
    _moneyLbl.textColor = [UIColor lightColor];
    _moneyLbl.text = @"0";
    _moneyLbl.font = [UIFont systemFontOfSize:45];
    [_topBackV addSubview:_moneyLbl];
    
    _chepiaoLbl = [UILabel new];
    _chepiaoLbl.text = @"账户余额（车票）";
    _chepiaoLbl.textColor = [UIColor lightColor];
    _chepiaoLbl.font = [UIFont systemFontOfSize:15];
    [_topBackV addSubview:_chepiaoLbl];
    
    _tipLbl =[UILabel new];
    _tipLbl.text = @"每日最多提现3次，每日提现限额3000";
    _tipLbl.textColor = [UIColor whiteColor];
    _tipLbl.font = [UIFont systemFontOfSize:10];
    [_topBackV addSubview:_tipLbl];
    
    _tipImg =[UIImageView new];
    _tipImg.image = [UIImage imageNamed:@"icon_sy_gth"];
    [_topBackV addSubview:_tipImg];
    
    _leftTipLbl = [UILabel new];
    _leftTipLbl.text = @"可提现金额（元）";
    _leftTipLbl.textAlignment =NSTextAlignmentCenter;
    _leftTipLbl.textColor = [UIColor whiteColor];
    _leftTipLbl.font = [UIFont systemFontOfSize:13];
    [_topBackV addSubview:_leftTipLbl];
    
    _leftMoneyLbl = [UILabel new];
    _leftMoneyLbl.text = @"0.00";
    _leftMoneyLbl.textAlignment =NSTextAlignmentCenter;
    _leftMoneyLbl.textColor = [UIColor whiteColor];
    _leftMoneyLbl.font = [UIFont systemFontOfSize:25];
    [_topBackV addSubview:_leftMoneyLbl];
    
    _rightTipLbl = [UILabel new];
    _rightTipLbl.text = @"今日可提现金额（元）";
    _rightTipLbl.textColor = [UIColor whiteColor];
    _rightTipLbl.textAlignment =NSTextAlignmentCenter;
    _rightTipLbl.font = [UIFont systemFontOfSize:13];
    [_topBackV addSubview:_rightTipLbl];
    
    _lineV = [UIView new];
    _lineV.backgroundColor = [UIColor whiteColor];
    [_topBackV addSubview:_lineV];
    
    _rightMoneyLbl = [UILabel new];
    _rightMoneyLbl.text = @"0.00";
    _rightMoneyLbl.textColor = [UIColor whiteColor];
    _rightMoneyLbl.font = [UIFont systemFontOfSize:25];
    _rightMoneyLbl.textAlignment =NSTextAlignmentCenter;
    [_topBackV addSubview:_rightMoneyLbl];
    
    _tixianBtn = [UIButton new];
    [_tixianBtn setTitle:@"支付宝提现" forState:0];
    _tixianBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_tixianBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH-40, 47)]]];
    _tixianBtn.layer.cornerRadius = 23.5;
    _tixianBtn.layer.masksToBounds = YES;
    [_tixianBtn addTarget:self action:@selector(tixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_tixianBtn setTitleColor:[UIColor textBlackColor] forState:0];
    [self.view addSubview:_tixianBtn];
    
    _questionBtn = [UIButton new];
    [_questionBtn setTitle:@"常见问题？" forState:0];
    _questionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_questionBtn addTarget:self action:@selector(questionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_questionBtn setTitleColor:[UIColor annotationTextColor] forState:0];
    [self.view addSubview:_questionBtn];
    [self setLayout];
}

-(void)tixianBtnClick{
    [[CSRouter share] push:@"WithdrawViewController" Params:@{@"residueMoney":_leftMoneyLbl.text,@"aliNickname":_aliNickName,@"aliUserId":_aliUserId} hideBar:YES];
}

-(void)questionBtnClick{
    [[CSRouter share]push:@"ProViewController" Params:nil hideBar:YES];
}
-(void)setLayout{
    [_topBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(-88);
        }else{
            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(-64);
        }
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_rightMoneyLbl.mas_bottom).with.offset(20);
    }];
    [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_topBackV);
        make.height.mas_equalTo(111);
    }];
    [_moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topBackV).with.offset(100);
        make.centerX.mas_equalTo(_topBackV);
    }];
    [_chepiaoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_moneyLbl.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(_topBackV);
    }];
    [_tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_chepiaoLbl.mas_bottom).with.offset(30);
        make.centerX.mas_equalTo(_topBackV);
    }];
    [_tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_tipLbl);
        make.right.mas_equalTo(_tipLbl.mas_left).with.offset(-3);
        make.width.height.mas_equalTo(11);
    }];
    [_leftTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tipLbl.mas_bottom).with.offset(40);
        make.left.mas_equalTo(_topBackV);
        make.right.mas_equalTo(_topBackV.mas_right).with.offset(-kSCREEN_WIDTH/2.0);
    }];
    [_leftMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftTipLbl.mas_bottom).with.offset(12);
        make.left.mas_equalTo(_topBackV);
        make.right.mas_equalTo(_topBackV.mas_right).with.offset(-kSCREEN_WIDTH/2.0);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftTipLbl);
        make.left.mas_equalTo(kSCREEN_WIDTH/2.0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(50);
    }];
    [_rightTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftTipLbl);
        make.right.mas_equalTo(_topBackV);
        make.left.mas_equalTo(_topBackV).with.offset(kSCREEN_WIDTH/2.0);
    }];
    [_rightMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftMoneyLbl);
        make.right.mas_equalTo(_topBackV);
        make.left.mas_equalTo(_topBackV).with.offset(kSCREEN_WIDTH/2.0);
    }];
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-40);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    [_tixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_questionBtn.mas_top).with.offset(-30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(47);
    }];

}
- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
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
