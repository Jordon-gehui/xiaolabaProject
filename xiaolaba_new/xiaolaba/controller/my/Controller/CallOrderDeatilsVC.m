//
//  CallOrderDeatilsVC.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/30.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CallOrderDeatilsVC.h"
#import "CallRecordsCell.h"
#import "XLBErrorView.h"
#import "VoiceActorOwnerViewController.h"
#import "EaseSDKHelper.h"
#import "OwnerRequestManager.h"
#import "VoiceCallView.h"

@interface CallOrderDeatilsVC ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate,CallRecordsCellDelegate,VoiceCallViewDelegate>

@property (nonatomic, strong) XLBErrorView *errorV;

@property (nonatomic, strong) VoiceCallView *voiceCallV;

@property (nonatomic, strong) XLBVoiceActorModel *actorModel;
@end

@implementation CallOrderDeatilsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.naviBar.slTitleLabel.text = @"订单详情";
    self.tableView.backgroundColor = RGB(247, 247, 247);
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[CallRecordsCell class] forCellReuseIdentifier:[CallRecordsCell cellDeatilsIdentifier]];
//    self.allowRefresh = YES;
//    self.allowLoadMore = YES;
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

-(void)titleClick:(UIButton*)sender{
    
}
- (void)refresh {
    [super refresh];
    
    //    self.page = 0;
    [self getData];
    
}

- (void)loadMore {
    [super loadMore];
    [self getData];
    
}
-(void)getData{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CallRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:[CallRecordsCell cellDeatilsIdentifier] forIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setViewData:self.orderModel isPlace:self.isPlace];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)callBtnClickWithModel:(CallOrderModel *)callModel {
    NSLog(@"%@",callModel.userId);
    if (!kNotNil(callModel.calledId)) return;
    NSDictionary *parae = @{@"createUser":callModel.calledId};
    kWeakSelf(self)
    [weakSelf showHudWithText:@""];
    [OwnerRequestManager requestVoiceActorOwnerWithParameter:parae success:^(XLBVoiceActorModel *respones) {
        [weakSelf hideHud];
        self.actorModel = respones;
        if ([respones.akiraModel.onlineType isEqualToString:@"2"]) {
            _voiceCallV = [VoiceCallView new];
            _voiceCallV.delegate = self;
            _voiceCallV.money = respones.akiraModel.priceAkira;
            [self.view.window addSubview:_voiceCallV];
            [_voiceCallV changeStatus];
        }else {
            [MBProgressHUD showError:@"对方不在线!"];
        }
    } error:^(id error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}
- (void)startBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.actorModel.user.ID,@"nickName":self.actorModel.user.nickname,@"userImg":self.actorModel.user.img,@"money":self.actorModel.akiraModel.priceAkira,@"type":[NSNumber numberWithInt:0]}];
}

- (void)callHeaderImgClick:(NSString *)modelid issy:(NSString*)isSY{
    if ([isSY isEqualToString:@"3"]) {
        VoiceActorOwnerViewController * oner = [VoiceActorOwnerViewController new];
        oner.userID = modelid;
        oner.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:oner animated:YES];
    }else{
        OwnerViewController * oner = [OwnerViewController new];
        oner.userID = modelid;
        oner.delFlag = 0;
        oner.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:oner animated:YES];
    }
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.tableView addSubview:_errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
    //    self.page = 0;
    //    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


