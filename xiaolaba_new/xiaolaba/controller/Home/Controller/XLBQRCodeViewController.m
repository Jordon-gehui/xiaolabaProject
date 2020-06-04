//
//  XLBQRCodeViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBQRCodeViewController.h"
#import "XLBQRBgView.h"
#import "XLBSuccessQRViewController.h"
@interface XLBQRCodeViewController ()

@property (nonatomic, strong) XLBQRBgView *qrBgView;

@property (nonatomic, strong) UIButton *forbidBtn;

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) NSString *carID;
@end

@implementation XLBQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定车主卡";
    self.naviBar.slTitleLabel.text = @"绑定车主卡";
    self.view.backgroundColor = [UIColor viewBackColor];

    if (self.url) {
        self.carID = [NSString stringWithFormat:@"%@",[self.url componentsSeparatedByString:@"/"].lastObject];
        NSLog(@"%@ %@",self.carID,self.number);
    }
    [self setSubViews];
}


- (void)setSubViews {
    
    self.qrBgView = [XLBQRBgView new];
    self.qrBgView.backgroundColor = [UIColor whiteColor];
    self.qrBgView.url = self.url;
    self.qrBgView.nubmer = self.number;
    [self.view addSubview:self.qrBgView];
    
    
    self.forbidBtn = [UIButton new];
    self.forbidBtn.clipsToBounds = YES;
    self.forbidBtn.layer.cornerRadius = 5;
//    UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH - 80, 44)]];
    self.forbidBtn.backgroundColor = RGB(61, 66, 67);
    [self.forbidBtn setTitleColor:[UIColor whiteColor] forState:0];
    
    [self.forbidBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    [self.forbidBtn addTarget:self action:@selector(forbidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forbidBtn];
    
    
    self.remindLabel = [UILabel new];
    self.remindLabel.numberOfLines = 0;
    self.remindLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.remindLabel];
    
//    NSString *string = @"如需更改，请在修改手机信息修改";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    // Adjust the spacing
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 8.f;
//    paragraphStyle.alignment = self.remindLabel.textAlignment;
//    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(34, 180, 153) range:NSMakeRange(0, 5)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(152, 152, 152) range:NSMakeRange(5, string.length - 5)];
//    self.remindLabel.attributedText = attributedString;
    self.remindLabel.text = @"";

}


- (void)forbidBtnClick:(UIButton *)sender {
    
    if (!kNotNil(self.carID)) return;
    NSDictionary *parameter = @{@"encrypt":self.carID,};
    kWeakSelf(self);
    [weakSelf showHudWithText:nil];
    [[NetWorking network] POST:KScanCarImg params:parameter cache:NO success:^(id result) {
        
        [weakSelf hideHud];
        
        [MBProgressHUD showSuccess:@"绑定成功"];
        XLBSuccessQRViewController *successVC = [[XLBSuccessQRViewController alloc] init];
        successVC.subTitle = @"挪车贴";
        [self.navigationController pushViewController:successVC animated:YES];

    } failure:^(NSString *description) {
        
        [MBProgressHUD showError:@"绑定成功"];

        
    }];
}

- (void)viewWillLayoutSubviews {
    kWeakSelf(self);
    
    [weakSelf.qrBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.height.width.mas_equalTo(250);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    
    [weakSelf.forbidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.qrBgView.mas_bottom).mas_offset(50);
        
        make.width.mas_equalTo(kSCREEN_WIDTH - 80);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    
    [weakSelf.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.forbidBtn.mas_bottom).mas_offset(10);
        
        make.left.mas_equalTo(weakSelf.qrBgView.mas_left).mas_offset(0);
        make.right.mas_equalTo(weakSelf.qrBgView.mas_right).mas_offset(0);
        make.height.mas_equalTo(100);
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
