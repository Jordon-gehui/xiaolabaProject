//
//  XLBIdentSuccessViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/23.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBIdentSuccessViewController.h"
#import "XLBMeCarTableViewCell.h"
#import "XLBMeRequestModel.h"
@interface XLBIdentSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _curr;            // 请求起始点
    NSInteger _size;            // 一页数据量
    BOOL _hasMore;               // 是否还有更多
}
@property (nonatomic, strong) UIImageView *success;
@property (nonatomic, strong) UILabel *successLabel;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *cardNOLabel;
@property (nonatomic, strong) UILabel *brandNOLabel;
@property (nonatomic, strong) UILabel *TimeLabel;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XLBIdentSuccessViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isCert) return;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_isCert) return;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isCert == YES) {
        self.title = @"认证成功";
        self.naviBar.slTitleLabel.text = @"认证成功";
        [self setUpSuccessUI];
    }else {
        self.title = @"车辆信息";
        self.naviBar.slTitleLabel.text = @"车辆信息";
        self.data = [[DefaultList initMeCarList] mutableCopy];
//        [self creatTableView];
        
        NSDictionary *params = @{@"page":@{@"curr":@(1),
                                           @"size":@(10)}};
        [XLBMeRequestModel requestCarInfo:params success:^(NSArray<XLBMeCarDetailModel *> *models) {
            XLBMeCarDetailModel *model = models[0];
            for (int i = 0; i < self.data.count; i++) {
                NSMutableDictionary *dict = [self.data[i] mutableCopy];
                [dict setValue:model.owner forKey:@"owner"];
                [dict setValue:model.plateNumber forKey:@"plateNumber"];
                [dict setValue:model.vehicleAreaName forKey:@"vehicleAreaName"];
                [dict setValue:model.model forKey:@"model"];
                [self.data replaceObjectAtIndex:i withObject:dict];
            }
            [self setUpVehicleUI:model];
        } failure:^(NSString *error) {
            
        } more:^(BOOL more) {
            
        }];
    }

}
- (void)setUpSuccessUI {
    self.success = [UIImageView new];
    self.success.image = [UIImage imageNamed:@"pic_nck"];
    self.successLabel = [UILabel new];
    
    self.successLabel.text = @"已认证成功";
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.textColor = RGB(204, 204, 204);
    
    [self.view addSubview:self.success];
    [self.success mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100*kiphone6_ScreenWidth);
        make.height.mas_equalTo(115*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).with.offset(-20);
    }];
    
    [self.view addSubview:self.successLabel];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.success.mas_bottom).with.offset(20);
    }];
}
- (void)setUpVehicleUI:(XLBMeCarDetailModel*)model {
    UIImageView *cardbackView = [UIImageView new];
    cardbackView.image = [UIImage imageNamed:@"bg_xszrz"];
    cardbackView.layer.cornerRadius = 10;
    cardbackView.layer.masksToBounds = YES;
    [self.view addSubview:cardbackView];
    UIImageView *iconIView = [UIImageView new];
    iconIView.image = [UIImage imageNamed:@"icon_xsz"];
    [cardbackView addSubview:iconIView];
    UILabel *nameLbl = [UILabel new];
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.font = [UIFont systemFontOfSize:18];
    nameLbl.text = @"行驶证";
    [cardbackView addSubview:nameLbl];
    self.nameLabel = [UILabel new];
    self.nameLabel.text = model.owner;
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:17];
    [cardbackView addSubview:self.nameLabel];
    UILabel *cardLbl = [UILabel new];
    cardLbl.font = [UIFont systemFontOfSize:13];
    cardLbl.textColor = UIColorFromRGB(0x999999);
    cardLbl.text = @"号牌号码";
    [cardbackView addSubview:cardLbl];
    self.cardNOLabel = [UILabel new];
    self.cardNOLabel.font = [UIFont systemFontOfSize:16];
    self.cardNOLabel.textColor = [UIColor whiteColor];
    self.cardNOLabel.text = model.plateNumber;
    [cardbackView addSubview:self.cardNOLabel];
    UILabel *brandLbl = [UILabel new];
    brandLbl.font = [UIFont systemFontOfSize:13];
    brandLbl.textColor = UIColorFromRGB(0x999999);
    brandLbl.text = @"品牌型号";
    [cardbackView addSubview:brandLbl];
    self.brandNOLabel = [UILabel new];
    self.brandNOLabel.font = [UIFont systemFontOfSize:16];
    self.brandNOLabel.textColor = [UIColor whiteColor];
    self.brandNOLabel.text = model.vehicleAreaName;
    [cardbackView addSubview:self.brandNOLabel];
    UILabel *timeLbl = [UILabel new];
    timeLbl.font = [UIFont systemFontOfSize:13];
    timeLbl.textColor = UIColorFromRGB(0x999999);
    timeLbl.text = @"注册日期";
    [cardbackView addSubview:timeLbl];
    self.TimeLabel = [UILabel new];
    self.TimeLabel.font = [UIFont systemFontOfSize:16];
    self.TimeLabel.textColor = [UIColor whiteColor];
    NSString *sting = [NSString stringWithFormat:@"%@",model.createDate];
    
    self.TimeLabel.text = [ZZCHelper dateStringFromNumberTimer:sting type:1];
    [cardbackView addSubview:self.TimeLabel];
    
    [cardbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(345.5*kiphone6_ScreenWidth);
        make.height.mas_equalTo(225*kiphone6_ScreenWidth);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(30);
    }];
    [iconIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cardbackView).with.offset(15);
        make.top.mas_equalTo(cardbackView).with.offset(20);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(16);
    }];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView.mas_right).with.offset(5);
        make.centerY.mas_equalTo(iconIView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cardbackView.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(iconIView);
    }];
    [cardLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView);
        make.top.mas_equalTo(iconIView.mas_bottom).with.offset(20);
    }];
    [self.cardNOLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView);
        make.top.mas_equalTo(cardLbl.mas_bottom).with.offset(5);

    }];
    [brandLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView);
        make.top.mas_equalTo(self.cardNOLabel.mas_bottom).with.offset(10);

    }];
    [self.brandNOLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView);
        make.top.mas_equalTo(brandLbl.mas_bottom).with.offset(5);

    }];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView);
        make.top.mas_equalTo(self.brandNOLabel.mas_bottom).with.offset(10);

    }];
    [self.TimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconIView);
        make.top.mas_equalTo(timeLbl.mas_bottom).with.offset(5);

    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f*kiphone6_ScreenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBMeCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBMeCarTableViewCell cellMeCarID]];
    if (!cell) {
        cell = [[XLBMeCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XLBMeCarTableViewCell cellMeCarID]];
    }
    cell.meCarList = self.data[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 52.f*kiphone6_ScreenHeight;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    [self.view addSubview:self.tableView];
}


- (void)backClick:(id)sender {
    if (self.isCert == YES) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
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
