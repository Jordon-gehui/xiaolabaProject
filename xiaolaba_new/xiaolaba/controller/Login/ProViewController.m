//
//  ProViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ProViewController.h"

@interface ProViewController ()
@property (nonatomic,retain)UILabel *tipL;
@property (nonatomic,retain)UILabel *contentL;
@end

@implementation ProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    self.naviBar.slTitleLabel.text = @"常见问题";
    self.view.backgroundColor = [UIColor viewBackColor];
    _tipL =[UILabel new];
    _tipL.backgroundColor = [UIColor viewBackColor];
    _tipL.text =@"<用户常见问题小贴士>";
    _tipL.textColor = [UIColor blackColor];
    _tipL.textAlignment = NSTextAlignmentCenter;
    _tipL.font = [UIFont boldSystemFontOfSize:18];
    [self.scrollView addSubview:_tipL];
    _contentL = [UILabel new];
    _contentL.text = @"车币为app虚拟货币，以1:10的比例，现金充值购买，1元=10车币 ；车币:车票=1:1.88；车票:人民币=20:1,车币，车票只作为中间转换货币,不可直接提现。\n\n1、什么是我的账户？\n我的账户是用户在小喇叭使用的金额，支持充值，提现支付等功能。\n充值：将其他账户的余额转入小喇叭账户\n提现：将我的账户余额，转入微信账户\n支付：小喇叭支付时可以使用账户余额和零钱分别支付\n\n2、我的账户充值支持哪些通道？\n目前小喇叭的充值仅限支付宝支付，不支持单独绑定银行卡与微信\n\n3、充值的限额是多少？\n充值最大限额在于您的支付宝每天转出的最大限额\n\n4、提现的限额是多少？\n每天可提现3次，单次提现金额为10-3000元\n\n5、我的账户提现什么时候到？\n当天提现提交后，将在3个工作日到账，您的提现金额将自动转入您的支付宝账户\n\n6、如何查询我的账户收支明细\n在我的->我的收益界面有交易明细，可查看充值和提现以及通话明细\n\n7、为什么我的账户提现超时还未到账？\n建议您先查看支付宝的收支明细，如果已经超过了资金到账时间，而支付宝没有收款记录，建议您拨打电话021-59168603人工咨询\n\n8、为什么支付宝到账的金额和提现申请的金额不一样？\n为了更好的提供服务，小喇叭将收取10%的提现金额，作为服务费用以便更好的改善产品和服务，希望您支持\n\n9、提现为什么绑定支付宝账号?\n提现的时候必须绑定支付宝账号，因为提现成功资金会转入您绑定的支付宝账户";

    _contentL.textColor = [UIColor blackColor];
    _contentL.numberOfLines = 0;
    _contentL.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:_contentL];
    
    kWeakSelf(self)
    [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(weakSelf.scrollView).with.offset(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
    }];
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tipL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(weakSelf.scrollView).with.offset(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
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
