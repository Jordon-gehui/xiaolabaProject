//
//  PayCheTieViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/7/13.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "PayCheTieViewController.h"
#import "PayCheTieView.h"
#import "XLBAreaSelectView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayCheTieModel.h"

@interface PayCheTieViewController ()<PayCheTieViewDelegate,XLBAreaSelectViewDelegate>

@property (nonatomic, strong) PayCheTieView *cheTieView;
@property (nonatomic, strong) PayCheTieModel *model;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;

@end

@implementation PayCheTieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.type isEqualToString:@"1"]) {
        self.title = @"快递上门";
        self.naviBar.slTitleLabel.text = @"快递上门";
    }else{
        self.title = @"立即申购";
        self.naviBar.slTitleLabel.text = @"立即申购";
    }
    
    [[NetWorking network] POST:kCarCommodity params:nil cache:NO success:^(id result) {
        PayCheTieModel *model = [PayCheTieModel mj_objectWithKeyValues:result];
        NSLog(@"%@",result);
        self.cheTieView.model = model;
        self.model = model;
    } failure:^(NSString *description) {
        
    }];
    
    [self setSubViews];
    
    [[NetWorking network] POST:kExeFind params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if(kNotNil(result)) {
            self.cheTieView.nameTextField.text = [result objectForKey:@"userName"];
            self.cheTieView.phoneTextField.text = [result objectForKey:@"mobile"];
            NSString *area = [NSString stringWithFormat:@"%@%@%@",[result objectForKey:@"province"],[result objectForKey:@"city"],[result objectForKey:@"district"]];
            self.cheTieView.adressLabel.text = area;
            self.cheTieView.adressTextView.text = [result objectForKey:@"address"];
            self.province = [result objectForKey:@"province"];
            self.city = [result objectForKey:@"city"];
            self.district = [result objectForKey:@"district"];
        }
    } failure:^(NSString *description) {
    }];
}

- (void)setSubViews {
    
    if ([self.type isEqualToString:@"1"]) {
        self.cheTieView = [[PayCheTieView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom) type:PayCheTieChargeType];
        self.cheTieView.delegate = self;
        [self.view addSubview:self.cheTieView];
    }else {
        self.cheTieView = [[PayCheTieView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom) type:PayCheTieBuy];
        self.cheTieView.delegate = self;
        [self.view addSubview:self.cheTieView];
    }
}

- (void)seletedCity {
    [self.view endEditing:YES];
    XLBAreaSelectView *areaView = [[XLBAreaSelectView alloc] init];
    areaView.delegate = self;
    [areaView show:self.view];
}

- (void)areaSelectView:(XLBAreaSelectView *)view
         didSelectArea:(NSString *)area
              province:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district {
    
    if(kNotNil(area)) {
        self.cheTieView.adressLabel.text = [NSString stringWithFormat:@"%@",area];
    }
    self.province = province;
    self.city = city;
    self.district = district;
}

- (void)payCheTieViewBtnClick:(UIButton *)sender count:(NSInteger)count {
    if ([self.cheTieView.phoneTextField.text isValidMobileNumber] == NO) {
        [MBProgressHUD showError:@"请输入正确手机号"];
    }else {
        NSLog(@"%@  %@  %@  %@  %@",self.cheTieView.phoneTextField.text,self.cheTieView.nameTextField.text,self.province,self.city,self.district);
        if(kNotNil(self.cheTieView.phoneTextField.text) &&
           kNotNil(self.cheTieView.nameTextField.text) &&
           kNotNil(self.city) &&
           kNotNil(self.province) &&
           kNotNil(self.district) &&
           kNotNil(self.cheTieView.adressTextView.text)) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if ([self.type isEqualToString:@"2"]) {
                [params setObject:@"2" forKey:@"type"];
            }
            [params setObject:self.cheTieView.phoneTextField.text forKey:@"mobile"];
            [params setObject:self.province forKey:@"province"];
            [params setObject:self.city forKey:@"city"];
            [params setObject:self.district forKey:@"district"];
            [params setObject:self.cheTieView.adressTextView.text forKey:@"address"];
            [params setObject:self.cheTieView.nameTextField.text forKey:@"userName"];
            kWeakSelf(self);
            [weakSelf showHudWithText:nil];
            [[NetWorking network] POST:kExeAdd params:params cache:NO success:^(id result) {
                [weakSelf hideHud];
                NSLog(@"地址：%@",result);
                if ([self.type isEqualToString:@"1"]) {
                    //免费领取
                    [[CSRouter share] push:@"XLBSuccessQRViewController" Params:@{@"subTitle":@"送货上门"} hideBar:YES];
                }else {
                    if (!kNotNil(self.model.commodityID) && !kNotNil(result)) return;
                    
                    NSString *money = [NSString stringWithFormat:@"%ld",count * [self.model.price integerValue]];
                    NSDictionary *dict = @{@"money":money,@"productId":self.model.commodityID,@"addressId":result,};
                    NSLog(@"%@",dict);
                    [[NetWorking network] POST:kCheTieSign params:dict cache:NO success:^(id result) {
                        NSLog(@"%@",result);
                        if (!kNotNil(result)) return ;
                        [[AlipaySDK defaultService] payOrder:result[@"orderSign"] fromScheme:@"xiaolaba" callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                        }];
                    } failure:^(NSString *description) {
                        [MBProgressHUD showError:@"网络错误"];
                    }];
                }
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
