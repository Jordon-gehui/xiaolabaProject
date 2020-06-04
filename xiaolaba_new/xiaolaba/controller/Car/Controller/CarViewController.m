//
//  CarViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CarViewController.h"
#import "LoginView.h"
#import <AVFoundation/AVFoundation.h>
#import "XLBAlertController.h"
#import "LittleHeadModel.h"
#import "BaseWebViewController.h"
#import "XLBCarRemindView.h"
#import "XLBLoginViewController.h"
#import "XLBAddressTool.h"
#import <AddressBook/AddressBook.h>
typedef NS_ENUM(NSUInteger,ButtonTag) {
    ScanBtnTag = 100,
    BoundBtnTag,
    MyCarBtnTag,
    CarApproveBtnTag,
    QuestionBtnTag,
};

@interface CarViewController ()
{
    UIImageView *headerView;
    UILabel *tipLbl;
    UIButton *scanBtn;
    UIButton *boundBtn;
    UIButton *myCardBtn;
    UIButton *carApproveBtn;
    UILabel *line;
    UILabel *hLine;
    UILabel *yLine;
    UIButton *questionBtn;
    
    NSString *status;
    LittleHeadModel *model;
}
@end

@implementation CarViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddAdressBook" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挪车";
    self.naviBar.slTitleLabel.text = @"挪车";
    // Do any additional setup after loading the view.
    [self setSubViews];
    
    [MobClick event:@"Nav_moveCar"];
    if (iPhone5s || kSCREEN_HEIGHT == 480) {
        self.scrollView.scrollEnabled = YES;
    }else {
        self.scrollView.scrollEnabled = NO;
    }
    [self loadHttpBanner];
    
    NSString *moveCar = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoveCarRemind"];
    if (!kNotNil(moveCar)) {
        XLBCarRemindView *remind = [[XLBCarRemindView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:@"carPage"];
    }
    if ([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        [self addAdressBook];
    }else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAdressBook) name:@"AddAdressBook" object:nil];
    }
}
- (void)addAdressBook {
    if ([XLBUser user].isLogin && kNotNil([XLBUser user].token)) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CallPhoneDict"];
        if (kNotNil(dict) && ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            [[XLBAddressTool addressToolShared] setDict:dict];
            [[XLBAddressTool addressToolShared] creatPhoneNumber];
        }
    }
}
- (void)btnClick:(UIButton *)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    switch (sender.tag) {
        case ScanBtnTag:{
            [MobClick event:@"Scan_CarFriend"];
            [self scanBtnClickWithType:@"2"];
        }
            break;
        case BoundBtnTag:{
            [MobClick event:@"Bind_CarTie"];
            [self scanBtnClickWithType:@"1"];
        }
            break;
        case MyCarBtnTag:{
            [[CSRouter share]push:@"XLBMyMoveCardViewController" Params:nil hideBar:YES];
        }
            break;
        case CarApproveBtnTag:{
            [[CSRouter share]push:@"XLBMoveRecordsViewController" Params:nil hideBar:YES];
        }
            break;
            
        case QuestionBtnTag:{
            [[CSRouter share] push:@"XLBQuestionViewController" Params:nil hideBar:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)boundBtnClick {
    [[CSRouter share]push:@"XLBMyMoveCardViewController" Params:nil hideBar:YES];
}

- (void)scanBtnClickWithType:(NSString *)type {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    [MobClick event:@"Home_Scan"];
    //判断是否已授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
            [MBProgressHUD showError:@"请前往设置->隐私->相机授权应用拍照权限"];
            return ;
        }
    }
    // 判断是否可以打开相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[CSRouter share]push:@"ScanViewController" Params:@{@"type":type} hideBar:YES];
    } else {
        [MBProgressHUD showError:@"相机设备无法访问"];
    }
}
-(void)loadHttpBanner{
    [[NetWorking network] POST:kMoveBanners params:nil cache:NO success:^(id result) {
        NSArray *arr = [LittleHeadModel mj_objectArrayWithKeyValuesArray:result];
        model = [arr firstObject];
        [headerView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.image Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"car_banner"] options:SDWebImageRetryFailed];
    } failure:^(NSString *description) {
        
    }];
}
- (void)setSubViews {
    self.scrollView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom);
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT+1);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300*kiphone6_ScreenWidth)];
    headerView.image = [UIImage imageNamed:@"car_banner"];
    [headerView setUserInteractionEnabled:YES];
    [self.scrollView addSubview:headerView];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerTapClick)];
    [headerView addGestureRecognizer:tap];
    UIView *bgView = [self viewWithRect:CGRectMake(0, headerView.bottom, kSCREEN_WIDTH, 300*kiphone6_ScreenWidth+2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bgView];
    
    [self buttonWithBtn:scanBtn];
    [self buttonWithBtn:boundBtn];
    [self buttonWithBtn:myCardBtn];
    [self buttonWithBtn:carApproveBtn];
}

-(void)bannerTapClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [[[XLBLoginViewController alloc]init] openWithController:self returnBlock:nil];
        return;
    }
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//        [LoginView addLoginView];
//        return;
//    }
    if ([model.type isEqualToString:@"0"]) { //原生跳转
        if (status ==nil) {
            [[NetWorking network] POST:kMeCar params:nil cache:NO success:^(id result) {
                if (kNotNil(result)) {
                    if (kNotNil([result objectForKey:@"status"])) {
                        status = [result objectForKey:@"status"];
                        if ([status isEqualToString:@"-1"]) {
                            [[CSRouter share]push:@"ApplyForViewController" Params:nil hideBar:YES];
                        }else {
                            [self showAlert];
                        }
                    }
                }
                
            } failure:^(NSString *description) {
                
            }];
        }else{
            if ([status isEqualToString:@"-1"]) {
                [[CSRouter share]push:@"ApplyForViewController" Params:nil hideBar:YES];
            }else {
                [self showAlert];
            }
        }
    }else{
        NSLog(@"url跳转%@",model.url);
        [MobClick event:@"Car_Banner"];
        
        BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
        webVC.urlStr = model.url;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    
}
- (UIView *)viewWithRect:(CGRect)rect {
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    tipLbl = [UILabel new];
    tipLbl.text = @"小喇叭服务";
    tipLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    tipLbl.textColor = [UIColor textBlackColor];
    [view addSubview:tipLbl];
    
    questionBtn = [UIButton new];
    [questionBtn setImage:[UIImage imageNamed:@"nc_icon_cjwt"] forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    questionBtn.tag = QuestionBtnTag;
    [view addSubview:questionBtn];
    
    scanBtn = [UIButton new];
    [scanBtn setTitle:@"扫码找车主" forState:UIControlStateNormal];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [scanBtn setImage:[UIImage imageNamed:@"icon_nc_sm"] forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    scanBtn.tag = ScanBtnTag;
    [scanBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:scanBtn];
    
    boundBtn = [UIButton new];
    [boundBtn setTitle:@"绑定挪车贴" forState:UIControlStateNormal];
    boundBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [boundBtn setImage:[UIImage imageNamed:@"icon_nc_bd"] forState:UIControlStateNormal];
    [boundBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    boundBtn.tag = BoundBtnTag;
    [boundBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:boundBtn];
    
    myCardBtn = [UIButton new];
    [myCardBtn setTitle:@"我的挪车贴" forState:UIControlStateNormal];
    myCardBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myCardBtn setImage:[UIImage imageNamed:@"icon_nc_nck"] forState:UIControlStateNormal];
    [myCardBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    myCardBtn.tag = MyCarBtnTag;
    [myCardBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:myCardBtn];
    
    carApproveBtn = [UIButton new];
    [carApproveBtn setTitle:@"挪车记录   " forState:UIControlStateNormal];
    carApproveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [carApproveBtn setImage:[UIImage imageNamed:@"icon_nc_jl"] forState:UIControlStateNormal];
    [carApproveBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    carApproveBtn.tag = CarApproveBtnTag;
    [carApproveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:carApproveBtn];
    
    line = [UILabel new];
    line.backgroundColor = [UIColor lineColor];
    [view addSubview:line];
    
    hLine = [UILabel new];
    hLine.backgroundColor = [UIColor lineColor];
    [view addSubview:hLine];
    
    yLine = [UILabel new];
    yLine.backgroundColor = [UIColor lineColor];
    [view addSubview:yLine];
    
    [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).with.offset(15);
        make.left.mas_equalTo(view.mas_left).with.offset(25);
    }];
    
    [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLbl.mas_centerY);
        make.right.mas_equalTo(view.mas_right).with.offset(-20);
        make.width.height.mas_equalTo(50);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX).with.offset(0);
        make.top.mas_equalTo(tipLbl.mas_bottom).with.offset(25);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(50);
    }];
    
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line.mas_left).with.offset(0);
        make.left.mas_equalTo(view.mas_left).with.offset(0);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(line.mas_centerY).with.offset(0);
    }];
    
    [boundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right).with.offset(0);
        make.right.mas_equalTo(view.mas_right).with.offset(0);
        make.centerY.mas_equalTo(scanBtn);
        make.height.mas_equalTo(50);
    }];
    
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).with.offset(20);
        make.left.mas_equalTo(view.mas_left).with.offset(20);
        make.right.mas_equalTo(view.mas_right).with.offset(-20);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(view.mas_centerX).with.offset(0);
    }];
    
    [yLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX).with.offset(0);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(hLine.mas_bottom).with.offset(20);
        make.height.mas_equalTo(50);
    }];
    
    [myCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(yLine.mas_centerY).with.offset(0);
        make.right.mas_equalTo(yLine.mas_left).with.offset(0);
        make.left.mas_equalTo(view.mas_left).with.offset(0);
        make.centerX.mas_equalTo(scanBtn);
        make.height.mas_equalTo(50);
    }];
    
    [carApproveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(yLine.mas_centerY).with.offset(0);
        make.left.mas_equalTo(yLine.mas_right).with.offset(0);
        make.right.mas_equalTo(view.mas_right).with.offset(0);
        make.centerX.mas_equalTo(boundBtn);
        make.height.mas_equalTo(50);
    }];
    
    return view;
}
- (void)buttonWithBtn:(UIButton *)sender {
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -sender.imageView.bounds.size.width, 0, sender.imageView.bounds.size.width + 10)];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(0, sender.titleLabel.bounds.size.width + 20, 0, -sender.titleLabel.bounds.size.width)];
}

- (void)showAlert {
    NSString *alertString = @"小喇叭车贴仅限免费申请一次 如需再次申请 拨打 021-59168603";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alertString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"立即拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-59168603"]];
    }];
    [defaultAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor minorTextColor] forKey:@"_titleTextColor"];

    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, alertString.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertString.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [self presentViewController:alertController animated:YES completion:nil];
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
