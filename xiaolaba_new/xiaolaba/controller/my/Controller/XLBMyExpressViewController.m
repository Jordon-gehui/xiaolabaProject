//
//  XLBMyExpressViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyExpressViewController.h"
#import "SZTextView.h"
#import <UIImageView+WebCache.h>
#import "XLBAreaSelectView.h"
#import "NetWorking.h"
#import "NSString+Category.h"
#import "XLBSuccessQRViewController.h"
@interface XLBMyExpressViewController ()<XLBAreaSelectViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) SZTextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *peopleTextfield;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIView *addressContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLead;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *ID;

@end

@implementation XLBMyExpressViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (iPhoneX) {
        self.bgVTop.constant = 98;
        self.btnLead.constant = 15;
        self.btnTrail.constant = 15;
        self.btnBottom.constant = 30;
        self.completeButton.layer.masksToBounds = YES;
        self.completeButton.layer.cornerRadius = 8;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"快递上门";
    self.naviBar.slTitleLabel.text = @"快递上门";
    [self setup];
}

- (void)setup {
    kWeakSelf(self);
    [[NetWorking network] POST:kExeFind params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if(kNotNil(result)) {
            weakSelf.numberTextfield.text = [result objectForKey:@"licensePlate"];
            weakSelf.peopleTextfield.text = [result objectForKey:@"userName"];
            NSString *area = [NSString stringWithFormat:@"%@%@%@",[result objectForKey:@"province"],[result objectForKey:@"city"],[result objectForKey:@"district"]];
            [weakSelf.areaButton setTitle:area forState:0];
            weakSelf.addressTextView.text = [result objectForKey:@"address"];
        }
    } failure:^(NSString *description) {
    }];
    
    self.addressTextView =[[SZTextView alloc] init];
    self.addressTextView.delegate = self;
    self.addressTextView.returnKeyType = UIReturnKeyDone;
    [self.addressContentView addSubview:self.addressTextView];
    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.addressTextView.placeholder = @"请填写详细地址";
    self.addressTextView.font = [UIFont systemFontOfSize:16];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:self.completeButton.size]];
    self.completeButton.backgroundColor = color;
}

#pragma XLBAreaSelectViewDelegate
- (void)areaSelectView:(XLBAreaSelectView *)view
         didSelectArea:(NSString *)area
              province:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district {
    
    if(kNotNil(area)) {
        [self.areaButton setTitle:area forState:0];
    }
    self.province = province;
    self.city = city;
    self.district = district;
}

- (IBAction)areaClick:(id)sender {
    [self.view endEditing:YES];
    XLBAreaSelectView *areaView = [[XLBAreaSelectView alloc] init];
    areaView.delegate = self;
    [areaView show:self.view];
}

- (IBAction)completeClick:(id)sender {
    if ([self.phoneTextfield.text isValidMobileNumber] == NO) {
        [MBProgressHUD showError:@"请输入正确手机号"];
    }else {
        if(kNotNil(self.phoneTextfield.text) &&
           kNotNil(self.numberTextfield.text) &&
           kNotNil(self.peopleTextfield.text) &&
           kNotNil(self.province) &&
           kNotNil(self.city) &&
           kNotNil(self.district) &&
           kNotNil(self.addressTextView.text)) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if(kNotNil(self.ID)) {
                [params setObject:self.ID forKey:@"id"];
            }
            [params setObject:self.phoneTextfield.text forKey:@"mobile"];
            [params setObject:self.province forKey:@"province"];
            [params setObject:self.city forKey:@"city"];
            [params setObject:self.district forKey:@"district"];
            [params setObject:self.addressTextView.text forKey:@"address"];
            [params setObject:self.numberTextfield.text forKey:@"licensePlate"];
            [params setObject:self.peopleTextfield.text forKey:@"userName"];
            //        [self show];
            kWeakSelf(self);
            [weakSelf showHudWithText:nil];
            [[NetWorking network] POST:kExeAdd params:params cache:NO success:^(id result) {
                [weakSelf hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"statusClick" object:nil];
                XLBSuccessQRViewController *successVC = [[XLBSuccessQRViewController alloc] init];
                successVC.subTitle = @"送货上门";
                [self.navigationController pushViewController:successVC animated:YES];
                
            } failure:^(NSString *description) {
                [weakSelf hideHud];
                [MBProgressHUD showError:@"出错了，请重试"];
            }];
        }
        else {
            [MBProgressHUD showError:@"请将信息填写完整"];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [self.view endEditing:YES];
        [self.addressTextView resignFirstResponder];
        
        return NO;
    }
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
