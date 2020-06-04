//
//  XLBMoveCarDetailViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMoveCarDetailViewController.h"
#import "MoveCarNoticeView.h"
#import "XLBChatViewController.h"
@interface XLBMoveCarDetailViewController ()
@property (nonatomic, strong)MoveCarNoticeView *carNoticeView;

@end

@implementation XLBMoveCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"挪车详情";
    self.naviBar.slTitleLabel.text = @"挪车详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.carNoticeView = [[MoveCarNoticeView alloc] init];
    self.carNoticeView.isMoveCar = YES;
    self.carNoticeView.model = self.model;

    [self.carNoticeView.chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.carNoticeView.ownerBtn addTarget:self action:@selector(ownerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.carNoticeView];
    kWeakSelf(self);
    [self.carNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.top.mas_equalTo(self.naviBar.bottom);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.greaterThanOrEqualTo(@300);
    }];
}
- (void)ownerBtnClick:(UIButton *)sender {
    if (kNotNil(self.model.uid)) {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":self.model.uid,@"delFlag":@0,} hideBar:YES];
    }
}

- (void)chatBtnClick:(UIButton *)sender {

    if (kNotNil(self.model.app) && [self.model.app isEqualToString:@"0"]) {
        if (kNotNil(self.model.uid)) {
            NSString *string = [NSString stringWithFormat:@"%@",self.model.uid];
            XLBChatViewController *chat = [[XLBChatViewController alloc] initWithConversationChatter:string conversationType:EMConversationTypeChat];
            chat.hidesBottomBarWhenPushed = YES;
            chat.nickname = self.model.nickname;
            chat.avatar = self.model.img;
            chat.userId = string;
            chat.isFinishMove = YES;
            [self.navigationController pushViewController:chat animated:YES];
        }
    }else {
        NSDictionary *dict = [@{@"carId":self.model.createID,@"isFinishMove":@1} mutableCopy];
        if (!kNotNil(self.model.uid)) {
            [dict setValue:@"" forKey:@"createUser"];
        }else {
            [dict setValue:self.model.uid forKey:@"createUser"];
        }
        [[CSRouter share]push:@"NetMsgTablePage" Params:dict hideBar:YES];
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
