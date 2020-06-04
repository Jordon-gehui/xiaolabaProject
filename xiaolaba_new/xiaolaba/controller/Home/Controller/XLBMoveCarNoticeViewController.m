//
//  XLBMoveCarNoticeViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMoveCarNoticeViewController.h"
#import "MoveCarNoticeView.h"
#import "XLBChatViewController.h"
#import "RePlyView.h"
@interface XLBMoveCarNoticeViewController ()

@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UIButton *messageBtn;
@property (nonatomic, strong)UIButton *checkBtn;
@property (nonatomic, strong)UIImageView *carImage;
@property (nonatomic, strong)UILabel *content;
@property (nonatomic, strong)UIImageView *bgImage;
@property (nonatomic, strong)MoveCarNoticeView *carNoticeView;
@property (nonatomic, strong)RePlyView *replyView;

@property (nonatomic, copy)NSDictionary *modelDic;

@end

@implementation XLBMoveCarNoticeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.navigationController.navigationBar.alpha = 1;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    self.view.backgroundColor = RGB(54, 56, 72);
    
    self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [self.bgImage setImage:[UIImage imageNamed:@"pic_banner"]];
    [self.view addSubview:self.bgImage];
    
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //必须给effcetView的frame赋值,因为UIVisualEffectView是一个加到UIIamgeView上的子视图.
    effectView.frame = _bgImage.bounds;
    [self.bgImage addSubview:effectView];
    
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kMoveCarsDetailMessage params:@{@"id":_carId} cache:NO success:^(NSDictionary* result) {
        [weakSelf hideHud];
        NSLog(@"--------------------------- 挪车详情 %@",result);
        _modelDic = result;
        [self setSubViews];
    } failure:^(NSString *description) {
        [weakSelf hideHud];

    }];
}

- (void)setSubViews {
    if (!kNotNil(_modelDic)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.closeBtn = [UIButton new];
    [self.closeBtn setEnlargeEdge:8];
    [self.closeBtn setImage:[UIImage imageNamed:@"icon_gb"] forState:0];
    [self.closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageBtn = [UIButton new];
    self.messageBtn.clipsToBounds = YES;
    self.messageBtn.layer.cornerRadius = 5;
    self.messageBtn.backgroundColor = RGB(255, 255, 255);
    [self.messageBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [self.messageBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.messageBtn.tag = 100;
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.messageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkBtn = [UIButton new];
    self.checkBtn.clipsToBounds = YES;
    self.checkBtn.layer.cornerRadius = 5;
    self.checkBtn.tag = 200;
    self.checkBtn.backgroundColor = RGB(251, 218, 60);
    [self.checkBtn setTitle:@"查看挪车信息" forState:UIControlStateNormal];
    [self.checkBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.checkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (kNotNil([_modelDic objectForKey:@"licensePlate"])) {
        [self.checkBtn setHidden:NO];
    }else {
        [self.checkBtn setHidden:YES];
    }
    
    self.content = [UILabel new];
    self.content.numberOfLines = 2;
    self.content.textColor = [UIColor whiteColor];
    self.content.font = [UIFont systemFontOfSize:25];
    if ([[_modelDic allKeys] containsObject:@"nickname"]&&kNotNil([_modelDic objectForKey:@"nickname"])) {
        self.content.text=[NSString stringWithFormat:@"%@通知您前来挪车\n请尽快联系对方",[_modelDic objectForKey:@"nickname"]];
    }else
    self.content.text = @"对方车主通知您前来挪车\n请尽快联系对方";
    self.content.textAlignment = NSTextAlignmentCenter;
    
    UIImage* image = [UIImage imageNamed:@"pic_car"];
    self.carImage = [[UIImageView alloc] initWithImage:image];
    self.carImage.layer.cornerRadius = 8;
    self.carImage.layer.masksToBounds = YES;
    self.carImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.messageBtn];
    [self.view addSubview:self.checkBtn];
    [self.view addSubview:self.content];
    [self.view addSubview:self.carImage];

    [self.view addSubview:self.closeBtn];

//    _replyView = [[RePlyView alloc]initWithArr:[_modelDic objectForKey:@"replys"]];
//    _replyView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
//    [_replyView setHidden:YES];
//    [_replyView.closeBtn addTarget:self action:@selector(rePlyViewHide) forControlEvents:UIControlEventTouchUpInside];
//    [_replyView.sendBtn addTarget:self action:@selector(rePlyMessage) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:_replyView];

    kWeakSelf(self)
    [_carImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.view);
    }];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_carImage.mas_top).with.offset(-30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-15);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-15);
        make.height.mas_equalTo(44);
    }];
    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_messageBtn.mas_top).with.offset(-30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        //发消息
        if ([[_modelDic objectForKey:@"app"] isEqualToString:@"0"]) {
            if (kNotNil([_modelDic objectForKey:@"uid"])) {
                [self sendMsg];
            }
        }else {
            [[CSRouter share]push:@"NetMsgTablePage" Params:@{@"carId":_carId,@"createUser":[_modelDic objectForKey:@"uid"]} hideBar:YES];
//            [_replyView setHidden:!_replyView.isHidden];
        }

    }else if(sender.tag == 200){
        //查看
        self.carNoticeView = [[MoveCarNoticeView alloc] init];
        [self.view addSubview:self.carNoticeView];
        
        [self.carNoticeView.chatBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
        [self.carNoticeView.ownerBtn addTarget:self action:@selector(ownerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.carNoticeView setDateDic:_modelDic];
        kWeakSelf(self);
        [self.carNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSCREEN_WIDTH);
            make.bottom.mas_equalTo(weakSelf.view.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
            make.height.greaterThanOrEqualTo(@200);
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)ownerBtnClick:(UIButton *)sender {
    if (kNotNil(_modelDic[@"uid"])) {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":_modelDic[@"uid"],@"delFlag":@0,} hideBar:YES];
    }
}
-(void)sendMsg {
    if ([[_modelDic objectForKey:@"app"] isEqualToString:@"0"]) {
        NSString *string =[NSString stringWithFormat:@"%@",[_modelDic objectForKey:@"uid"]];
        XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:string conversationType:EMConversationTypeChat];
        chat.hidesBottomBarWhenPushed = YES;
        if ([[_modelDic allKeys] containsObject:@"nickname"]) {
            chat.nickname = [_modelDic objectForKey:@"nickname"];
        }
        if ([[_modelDic allKeys] containsObject:@"img"]) {
            chat.avatar = [_modelDic objectForKey:@"img"];
        }
        chat.userId = string;
        chat.isMoveCar = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }else{
        [[CSRouter share]push:@"NetMsgTablePage" Params:@{@"carId":_carId,@"createUser":[_modelDic objectForKey:@"uid"]} hideBar:YES];
    }
}
-(void)rePlyViewHide {
    self.replyView.textView.text = @"";
    [self.replyView setHidden:YES];
}
-(void)rePlyMessage {
    if (!kNotNil(_replyView.textView.text)) {
        [MBProgressHUD showError:@"快捷回复不能为空"];
        return;
    }
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] POST:kMoveCarsDetailMessageReply params:@{@"id":_carId,@"message":_replyView.textView.text} cache:NO success:^(NSDictionary* result) {
        NSLog(@"--------------------------- 挪车详情 %@",result);
        [weakSelf hideHud];
        [weakSelf.replyView setHidden:YES];
        [MBProgressHUD showError:@"快捷回复成功"];

    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:@"快捷回复失败"];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.carNoticeView removeFromSuperview];
        self.carNoticeView = nil;
        [self.carNoticeView removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
