//
//  XLBPhoneModifyViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBPhoneModifyViewController.h"
#import "XLBUser.h"
//#import "UILabel+BULabel.h"
#import "XLBMeRequestModel.h"
#import "ChangePhoneView.h"

@interface XLBPhoneModifyViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) ChangePhoneView *changeView;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *valid;
@property (nonatomic, copy) NSString *validSub;
@end

@implementation XLBPhoneModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机号修改";
    _changeView = [[ChangePhoneView alloc] init];
    _changeView.phoneTextField.tag = 10;
    _changeView.validTextField.tag = 20;
    _changeView.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    _changeView.validTextField.keyboardType = UIKeyboardTypePhonePad;

    
    _changeView.phoneTextField.delegate = self;
    _changeView.validTextField.delegate = self;

    
    _changeView.hintL.text = [NSString stringWithFormat:@"更换手机后，下次登录可使用新手机号登录。\n当前手机号\n%@",[XLBUser user].userModel.phone];
    [self bql_setRowSpace:5.0f label:self.changeView.hintL];
    [_changeView.sendBtn addTarget:self action:@selector(sendValidAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:_changeView];
    [_changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(74);
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

- (void) sendValidAction:(UIButton *) sender {
    kWeakSelf(self);
    [weakSelf showHudWithText:nil];
    [[NetWorking network] POST:kLoginCode params:@{@"phoneNumber":self.changeView.phoneTextField.text} cache:NO success:^(id result) {
        [weakSelf hideHud];
        if (kNotNil(result)) {
            NSLog(@"%@",result);
            if (![result isEqualToString:@"000000"]) return;
            self.validSub = result;
            
            [MBProgressHUD showSuccess:@"验证码发送成功"];
        }
    } failure:^(NSString *description) {
        [weakSelf hideHud];

        [MBProgressHUD showError:@"验证码发送失败"];
    }];
    //发送成功开启倒计时
    [_changeView startCountDown];
        
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

- (void)rightClick {
    kWeakSelf(self);

    if ([self.valid isEqualToString:self.validSub]) {
        [MBProgressHUD showError:@"验证码错误"];
    }else {
        NSDictionary *dict = @{@"phoneNumber":self.phone,@"verifyCode":self.valid,};
        [weakSelf showHudWithText:@""];
        [XLBMeRequestModel changePhone:dict error:^(NSString *error) {
            if (kNotNil(error)) {
                [weakSelf hideHud];
                [weakSelf showHudWithText:@"出错了，请重试"];
            }else {
                [weakSelf hideHud];
                [weakSelf showHudWithText:@"更改成功"];
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
