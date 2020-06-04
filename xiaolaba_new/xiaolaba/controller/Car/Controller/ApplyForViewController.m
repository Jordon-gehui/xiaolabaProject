//
//  ApplyForViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/7/12.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "ApplyForViewController.h"
#import "XLBMeRequestModel.h"
#import "XLBAlertController.h"
@interface ApplyForViewController ()
{
    UIImageView *backView;
    UIImageView *titleView;
    UILabel *titleLbl;
    UIView *applyforBtn;
    UIView *payforBtn;
}

@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ApplyForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"申请车贴";
    self.naviBar.slTitleLabel.text = @"申请车贴";
    [self initNaviBar];
    [self initSubView];
    
    NSDictionary *params = @{@"page":@{@"curr":@(0),
                                       @"size":@(3)}};
    [XLBMeRequestModel requsetInviteFriendsParams:params success:^(NSArray<XLBInviteModel *> *models) {
        [self.data addObjectsFromArray:models];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    } more:^(BOOL more) {
    }];
    // Do any additional setup after loading the view.
}
- (void)initNaviBar {
    [super initNaviBar];
}

-(void)initSubView{
    backView = [UIImageView new];
//    backView.frame = self.view.frame;
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    backView.image = [UIImage imageNamed:@"Invitefriends_back"];
    titleView = [UIImageView new];
    [self.view addSubview:titleView];
    titleView.image = [UIImage imageNamed:@"method_title"];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(50);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).with.offset(5);
        make.height.mas_equalTo(483/750.0*(kSCREEN_WIDTH-10));
    }];
    titleLbl = [UILabel new];
    titleLbl.text = @"以下方式获取挪车贴";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(15);
    }];
    applyforBtn = [self addBtnWithTitle:@"免费领取" content:@"邀请3位好友成功注册即可" imageName:@"icon_mflq"];
    [self.view addSubview:applyforBtn];
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapApplyFor)];
    [applyforBtn addGestureRecognizer:tapges];
    [applyforBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(20);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(90);
    }];
    payforBtn = [self addBtnWithTitle:@"点击申购" content:@"填写联系人，地址即可 " imageName:@"icon_hc"];
    [self.view addSubview:payforBtn];
    UITapGestureRecognizer *tapges2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPayFor)];
    [payforBtn addGestureRecognizer:tapges2];
    [payforBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(applyforBtn.mas_bottom).with.offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(90);
    }];
}
-(UIView*)addBtnWithTitle:(NSString*)titleStr content:(NSString*)contentStr imageName:(NSString *)imageName{
    UIView *btnView = [UIView new];
    btnView.layer.cornerRadius = 5;
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.masksToBounds = YES;
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = titleStr;
    titleLbl.font = [UIFont systemFontOfSize:18];
    if ([titleStr isEqualToString:@"免费领取"]) {
        titleLbl.textColor = RGB(236,90,120);
    }else{
        titleLbl.textColor = RGB(91,120,239);
    }
    [btnView addSubview:titleLbl];
    UILabel *contentLbl = [UILabel new];
    contentLbl.text = contentStr;
    contentLbl.textColor = [UIColor minorTextColor];
    contentLbl.font = [UIFont systemFontOfSize:14];
    [btnView addSubview:contentLbl];
    UIImageView *imageView = [UIImageView new];
    imageView.image =[UIImage imageNamed:imageName];
    [btnView addSubview:imageView];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
    }];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(10);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnView);
        if ([titleStr isEqualToString:@"免费领取"]) {
            make.right.mas_equalTo(-30);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(51);
        }else{
            make.right.mas_equalTo(-25);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(37);
        }
        
    }];
    return btnView;
}
-(void)tapApplyFor{
    [[NetWorking network] POST:kMeCar params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            if (kNotNil([result objectForKey:@"status"])) {
                NSString *status = [result objectForKey:@"status"];
                if ([status isEqualToString:@"-1"]) {
                    [[CSRouter share]push:@"BuyCarAllowanceViewController" Params:@{@"data":self.data} hideBar:YES];
                }else {
                    [self showAlert];
                }
            }
        }
        
    } failure:^(NSString *description) {
        
    }];
}
-(void)tapPayFor {
    [[CSRouter share]push:@"PayCheTieViewController" Params:@{@"type":@"2"} hideBar:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showAlert {
    NSString *alertString = @"你已申请挪车贴，不能再次申请，关注公众号“小喇叭挪车”，更多精美挪车贴等你来取~";
    
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"确定"] title:nil message:alertString cancel:NO cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        
    }];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, alertString.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertString.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
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
