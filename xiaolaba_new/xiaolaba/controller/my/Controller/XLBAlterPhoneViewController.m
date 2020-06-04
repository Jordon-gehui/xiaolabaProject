//
//  XLBPhoneModifyViewController.m
//  xiaolaba
//
//
//  Created by 戴葛辉 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBAlterPhoneViewController.h"
#import "XLBUser.h"
#import "XLBMeRequestModel.h"
#import "AlterPhone.h"
#import "NSString+Category.h"
@interface XLBAlterPhoneViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) AlterPhone *alterPhoneView;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *valid;
@property (nonatomic, copy) NSString *validSub;
@end

@implementation XLBAlterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机号修改";
    self.naviBar.slTitleLabel.text = @"手机号修改";
    _alterPhoneView = [[AlterPhone alloc] init];
    _alterPhoneView.phoneTextField.tag = 10;
    _alterPhoneView.validTextField.tag = 20;
    _alterPhoneView.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    _alterPhoneView.validTextField.keyboardType = UIKeyboardTypePhonePad;
    _alterPhoneView.phoneTextField.delegate = self;
    _alterPhoneView.validTextField.delegate = self;
    
    
//    _alterPhoneView.hintL.text = [NSString stringWithFormat:@"更换手机后，下次登录可使用新手机号登录。\n当前手机号\n%@",self.telePhone];
//    [self bql_setRowSpace:5.0f label:self.alterPhoneView.hintL];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    paragraphStyle.alignment = _alterPhoneView.hintL.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    NSString *followString = [NSString stringWithFormat:@"更换手机后，下次登录可使用新手机号登录。\n当前手机号\n%@",self.telePhone];
    NSMutableAttributedString *followattString = [[NSMutableAttributedString alloc] initWithString:followString];
    [followattString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followString length])];
    [followattString addAttribute:NSForegroundColorAttributeName value:[UIColor normalTextColor] range:NSMakeRange(0, followString.length - self.telePhone.length)];
    [followattString addAttribute:NSForegroundColorAttributeName value:RGB(23, 23, 23) range:NSMakeRange(followString.length - self.telePhone.length, self.telePhone.length)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, followString.length - self.telePhone.length)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(followString.length - self.telePhone.length, self.telePhone.length)];
    _alterPhoneView.hintL.attributedText = followattString;
    
    [_alterPhoneView.sendBtn addTarget:self action:@selector(sendValidAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_alterPhoneView];
    [_alterPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(10);
        make.height.mas_equalTo(kSCREEN_HEIGHT);
    }];
}

- (void)bql_setRowSpace:(CGFloat)rowSpace label:(UILabel *)hintLabel{
    
    hintLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:hintLabel.attributedText];
    // Adjust the spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.alignment = hintLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [hintLabel.text length])];
    hintLabel.attributedText = attributedString;
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

- (void) sendValidAction:(UIButton *) sender {
    
    if (!kNotNil(self.alterPhoneView.phoneTextField.text)) {
        [MBProgressHUD showError:@"请输入手机号"];
    }else {
        if ([self.alterPhoneView.phoneTextField.text isValidMobileNumber] == NO) {
            [MBProgressHUD showError:@"手机号码不正确"];
        }else {
            kWeakSelf(self);
            [weakSelf showHudWithText:nil];
            [[NetWorking network] POST:kLoginCode params:@{@"phoneNumber":self.alterPhoneView.phoneTextField.text} cache:NO success:^(id result) {
                [weakSelf hideHud];
                if (kNotNil(result)) {
                    NSLog(@"%@",result);
                    if ([result isEqualToString:@"000000"]) return;
                    self.validSub = result;
                    [MBProgressHUD showSuccess:@"验证码发送成功"];
                }
            } failure:^(NSString *description) {
                [weakSelf hideHud];
                [MBProgressHUD showError:@"验证码发送失败"];
            }];
            //发送成功开启倒计时
            [_alterPhoneView startCountDown];
        }
    }
    
    return;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        if (kNotNil(textField.text)) {
            self.phone = textField.text;
        }
    }else {
        if (kNotNil(textField.text)) {
            self.valid = textField.text;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 10) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)rightClick {
    kWeakSelf(self);
    
    if (![self.alterPhoneView.validTextField.text isEqualToString:self.validSub]) {
        [MBProgressHUD showError:@"验证码错误"];
    }else {
        NSDictionary *dict = @{@"phoneNumber":self.alterPhoneView.phoneTextField.text,@"verifyCode":self.alterPhoneView.validTextField.text,};
        [weakSelf showHudWithText:@""];
        [XLBMeRequestModel changePhone:dict error:^(NSString *error) {
            if (kNotNil(error)) {
                [weakSelf hideHud];
                [MBProgressHUD showError:@"出错了，请重试"];
            }else {
                [weakSelf hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneSuccess" object:nil];
                self.block(self.alterPhoneView.phoneTextField.text);
                [MBProgressHUD showSuccess:@"更改成功"];
            }
        }];
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
