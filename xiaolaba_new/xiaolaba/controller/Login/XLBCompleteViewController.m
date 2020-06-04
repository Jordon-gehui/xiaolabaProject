//
//  XLBCompleteViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/11.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCompleteViewController.h"
#import "RootTabbarController.h"
#import "NetWorking.h"
#import "BQLSheetView.h"
#import "AppDelegate.h"
#import "XLBUser.h"
#import "XLBAlertController.h"
#import "XLBMeRequestModel.h"
#import "XLBSeleDateView.h"

@interface XLBCompleteViewController () <BQLSheetViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,XLBSeleDateViewDelegate>

@property (nonatomic, strong) NSArray *avatar_array;
@property (nonatomic, strong) NSArray *sex_array;
@property (nonatomic, strong) NSArray <NSDictionary *>*age_array;
@property (nonatomic, strong) UIImage *avatar_image;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTop;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabelTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextfield;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (nonatomic, strong) UIDatePicker *datePicker;
@end
#define MAX_STARWORDS_LENGTH 10
@implementation XLBCompleteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.view endEditing:YES];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];
    // 基本配置

    [self setup];

    if ([self.rightItemTag isEqualToString:@"1"]) {
        
        NSString *str = [XLBUser user].userModel.img;
        if (str) {
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.nickNameTextfield];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.avatarImage.layer.masksToBounds = YES;
    if ([UIScreen mainScreen].bounds.size.height <= 568) {
        self.viewHeight.constant = 50;
        self.topLabelTop.constant = 58;
        self.avatarImgHeight.constant = 80;
        self.lineBottom.constant = 35;
        self.avatarImage.layer.cornerRadius = 40;
    }else {
        NSLog(@"%f",75.0f * kiphone6_ScreenHeight);
        self.viewHeight.constant = 65;
        self.lineBottom.constant = 60.0f * kiphone6_ScreenHeight;
        self.avatarImgHeight.constant = 94 * kiphone6_ScreenHeight;
        self.imgTop.constant = 35 * kiphone6_ScreenHeight;
        self.avatarImage.layer.cornerRadius = self.avatarImage.size.height/2.0f;
        self.topLabelTop.constant = 75;
        if (iPhoneX) {
            self.imgTop.constant = 45;
            self.btnBottom.constant = 120;
            self.topLabelTop.constant = 88;
        }
    }
    
}

-(void) pushHomePage {
    [[NetWorking network] POST:kSkip params:nil cache:NO success:^(id result) {
    } failure:^(NSString *description) {
    }];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    RootTabbarController *tab = [RootTabbarController sharedRootBar];
//
//    [RootTabbarController transformRootControllerFrom:self to:tab];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"complete" object:nil];

//    if (self.returnBlock) {
//        self.returnBlock(@"1");
//    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideDatePicker];
}
- (void)setup {
    
    if (![self.rightItemTag isEqualToString:@"1"]) {
        
        self.rightItem = [UIButton new];
        [self.rightItem setTitle:@"跳过" forState:UIControlStateNormal];
        [self.rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightItem.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.rightItem addTarget:self action:@selector(pushHomePage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.rightItem];
        [self.rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.height.mas_equalTo(40);
            make.top.mas_equalTo(30);
        }];
    }
    
    self.nickNameTextfield.tintColor = [UIColor whiteColor];
    [self.nickNameTextfield setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [self.nickNameTextfield setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
//    self.hintLabel.text = @"完善信息\n让大家更好的了解你";
    self.hintLabel.textAlignment = NSTextAlignmentLeft;
    
    UITapGestureRecognizer *sexLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexLabelTapClick:)];
    self.sexLabel.userInteractionEnabled = YES;
    [self.sexLabel addGestureRecognizer:sexLabelTap];
    
    UITapGestureRecognizer *ageLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ageLabelTapClick:)];
    self.ageLabel.userInteractionEnabled = YES;
    [self.ageLabel addGestureRecognizer:ageLabelTap];
    

    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.hintLabel.font = [UIFont systemFontOfSize:25];
    }
    // 选择信息初始化
    self.avatar_array = @[@"拍照",@"从相册选取"];
    self.sex_array = @[@"女",@"男"];
    self.completeButton.layer.masksToBounds = YES;
    self.completeButton.layer.cornerRadius = 5;
    self.nickNameTextfield.tag = 666;
//    [self.nickNameTextfield setDelegate:self];
    [self buttonStatus];
//
    NSString *string = @"完善信息\n让大家更好的了解你";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    // Adjust the spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.f;
    paragraphStyle.alignment = self.hintLabel.textAlignment;
//    //    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
//    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    //    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(34, 180, 153) range:NSMakeRange(0, 5)];
//    //    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(152, 152, 152) range:NSMakeRange(5, string.length - 5)];
    self.hintLabel.attributedText = attributedString;
    
    self.avatarImage.image = [UIImage imageNamed:@"weitouxiang"];
    // 填充数据（如果有的话）
    XLBUser *user = [XLBUser user];
    if(user.isWeChatLogin) {
        [[NetWorking network] asyncUploadImage:self.avatar_image avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[names firstObject] forKey:@"avatar"];
            [params setObject:user.userModel.nickname forKey:@"nickname"];
            
            [[NetWorking network] POST:kComplete params:params cache:NO success:^(id result) {
                
            } failure:^(NSString *description) {
            }];
        }];
        
        
        NSLog(@"%@",user.userModel.headimgurl);
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:user.userModel.headimgurl Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"] ];
        self.nickNameTextfield.text = user.userModel.nickname;
        self.sexLabel.text = user.userModel.sex ? (user.userModel.sex == 0 ? @"女":@"男"):@"性别";
        
    }
    

}

- (IBAction)avatarClick:(UIButton *)sender {
    
//    BQLSheetView *sheetView = [[BQLSheetView alloc] initWith:self.avatar_array message:nil];
//    sheetView.delegate = self;
//    [sheetView show:[UIApplication sharedApplication].keyWindow];
    
    
    
  
    kWeakSelf(self);
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:self.avatar_array title:nil message:nil cancel:YES cancelBlock:^{
        
        NSLog(@"点击了取消");
    } itemBlock:^(NSUInteger index) {
        
        switch (index) {
            case 0: {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSLog(@"点击了拍照");
                    [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypeCamera];
                }
                else {
                    NSLog(@"模拟器打不开相机");
                }
            }
                break;
            case 1: {
                [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
                
            default:
                break;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sexLabelTapClick:(UITapGestureRecognizer *)tap {
    kWeakSelf(self);
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:self.sex_array title:nil message:nil cancel:YES cancelBlock:^{
        
        NSLog(@"点击了取消");
    } itemBlock:^(NSUInteger index) {
        weakSelf.sexLabel.text = weakSelf.sex_array[index];
        weakSelf.sexLabel.font = [UIFont systemFontOfSize:20];
        weakSelf.sexLabel.textColor = [UIColor whiteColor];
        [self buttonStatus];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)ageLabelTapClick:(UITapGestureRecognizer *)tap {
    XLBSeleDateView *dateView = [[XLBSeleDateView alloc] init];
    dateView.delegate = self;
    
    [dateView show:self.view];
    //    BQLSheetView *sheetView = [[BQLSheetView alloc] initWithDatePickView];
    //    sheetView.delegate = self;
    //    [sheetView show:[UIApplication sharedApplication].keyWindow];
}

- (void)dateSelectView:(XLBSeleDateView *)view didSelectbirthday:(NSString *)birthday {
    self.ageLabel.text = birthday;
    self.ageLabel.textColor = [UIColor whiteColor];
    self.ageLabel.font = [UIFont systemFontOfSize:20];
    [self buttonStatus];

}
-(void)showDatePicker {
    [UIView animateWithDuration:0.3 animations:^{
        [_datePicker setHidden:NO];
        _datePicker.frame = CGRectMake(0, kSCREEN_HEIGHT-150, kSCREEN_WIDTH, 150);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideDatePicker {
    [UIView animateWithDuration:0.3 animations:^{
        _datePicker.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 150);
    } completion:^(BOOL finished) {
        [_datePicker setHidden:YES];
    }];
}
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_datePicker];
        if (iPhoneX) {
            _datePicker.frame = CGRectMake(0, kSCREEN_HEIGHT-30, kSCREEN_WIDTH, 150);
        }else {
            _datePicker.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 150);
        }
        [_datePicker setHidden:YES];
        
        [self.datePicker addTarget:self action:@selector(seletedDatePicker:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
-(void)seletedDatePicker:(UIDatePicker*)picker{
    NSString *dateFor = @"yyyy-MM-dd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFor];
    NSString *seletedDate = [formatter stringFromDate:_datePicker.date];
    self.ageLabel.text = seletedDate;
    self.ageLabel.textColor = [UIColor whiteColor];
    self.ageLabel.font = [UIFont systemFontOfSize:20];
}

- (void)buttonStatus {
    if ([XLBUser user].userModel.headimgurl != nil&&self.nickNameTextfield.text.length>0&&self.sexLabel.text.length>0&&self.ageLabel.text.length > 0&&![self.sexLabel.text isEqualToString:@"性别"]&&![self.ageLabel.text isEqualToString:@"年龄"]) {
        _completeButton.enabled = YES;
    }else{
        _completeButton.enabled = NO;
    }
//    UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH - 80, 44)]];
    
    
    self.completeButton.backgroundColor = _completeButton.isEnabled?RGB(46, 48, 51):RGB(194, 194, 194);
}

- (IBAction)completeClick:(UIButton *)sender {
    
    // 先传图
//    [self showHudWithText:nil];
    kWeakSelf(self);
    
    XLBUser *user = [XLBUser user];

        if(self.avatar_image) {
            
            [[NetWorking network] asyncUploadImage:self.avatar_image avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
                
                NSLog(@"names = %@",names);
                // 调用完善信息api
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[names firstObject] forKey:@"avatar"];
                [params setObject:weakSelf.nickNameTextfield.text forKey:@"nickname"];
                [params setObject:[weakSelf.sexLabel.text isEqualToString:@"女"] ? @(0):@(1) forKey:@"sex"];
                [params setObject:self.ageLabel.text forKey:@"birthdate"];

                [weakSelf complete:params];
            }];
        }
        else {
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setObject:self.nickNameTextfield.text forKey:@"nickname"];
//            [params setObject:[self.sexLabel.text isEqualToString:@"女"] ? @(0):@(1) forKey:@"sex"];
//            [params setObject:self.ageLabel.text forKey:@"birthdate"];
//
//            [self complete:params];
            if(user.isWeChatLogin) {
        
                [[NetWorking network] asyncUploadImage:self.avatarImage.image avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
                    
                    NSLog(@"names = %@",names);
                    // 调用完善信息api
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:[names firstObject] forKey:@"avatar"];
                    [params setObject:weakSelf.nickNameTextfield.text forKey:@"nickname"];
                    [params setObject:[weakSelf.sexLabel.text isEqualToString:@"女"] ? @(0):@(1) forKey:@"sex"];
                    [params setObject:self.ageLabel.text forKey:@"birthdate"];
                    
                    [weakSelf complete:params];
                }];
            }else
            [MBProgressHUD showError:@"请选择头像"];
        }
}

- (void)complete:(NSDictionary *)params {
    
    kWeakSelf(self);
    [[NetWorking network] POST:kComplete params:params cache:NO success:^(id result) {
        
        NSLog(@"result = %@",result);
        if ([self.rightItemTag isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [XLBMeRequestModel requestInfo:^(XLBUser *user) {
                [weakSelf hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];

                if ([self.delegate respondsToSelector:@selector(completeBtnClick:)]) {
                    [self.delegate completeBtnClick:user];
                }
            } failure:^(NSString *error) {
                
            }];
            return ;
        }else{
            [XLBMeRequestModel requestInfo:^(XLBUser *user) {
                [weakSelf hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"complete" object:nil];

//                if (self.returnBlock) {
//                    self.returnBlock(@"1");
//                }
            } failure:^(NSString *error) {
                [weakSelf hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"complete" object:nil];
                
            }];
        }
    } failure:^(NSString *description) {
        
        NSLog(@"error");
        [weakSelf hideHud];
    }];
}

- (void)sheetView:(BQLSheetView *)sheetView items:(NSArray *)items didSelectAtIndex:(NSUInteger)index {
    
    if([items isEqualToArray:self.avatar_array]) {
        switch (index) {
            case 0: {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSLog(@"点击了拍照");
                    [self chooseCameraOrAlbum:UIImagePickerControllerSourceTypeCamera];
                }
                else {
                    NSLog(@"模拟器打不开相机");
                }
            }
                break;
            case 1: {
                [self chooseCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
                
            default:
                break;
        }
    }
    else if ([items isEqualToArray:self.sex_array]) {
        self.sexLabel.text = items[index];
    }
}

- (void)sheetView:(BQLSheetView *)sheetView didSelectDate:(NSString *)date {
    
    self.ageLabel.text = date;
}

- (void)chooseCameraOrAlbum:(UIImagePickerControllerSourceType )type {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = type;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.avatar_image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatarImage.image = self.avatar_image;
    [self buttonStatus];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSInteger existedLength = textField.text.length;
//    NSInteger selectedLength = range.length;
//    NSInteger replaceLength = string.length;
//    if (existedLength - selectedLength + replaceLength >10) {
//        return NO;
//    }
//    return YES;
//}
#pragma mark - Notification Method
-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.nickNameTextfield];
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
