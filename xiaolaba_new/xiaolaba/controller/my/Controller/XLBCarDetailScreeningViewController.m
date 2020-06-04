//
//  XLBCarDetailScreeningViewController.m
//  xiaolaba
//
//  Created by lin on 2017/8/18.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarDetailScreeningViewController.h"
#import "XLBCarDetailScreeningCell.h"
#import "XLBMeRequestModel.h"

@interface XLBCarDetailScreeningViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSArray <XLBCarDetailModel *>*dataSource;

@end

@implementation XLBCarDetailScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"车型选择";
    self.naviBar.slTitleLabel.text = @"车型选择";
    self.listTableView.rowHeight = 55.f;
    kWeakSelf(self);
    [weakSelf showHudWithText:nil];
    if(kNotNil(self.parentId)) {
        [XLBMeRequestModel requestCarDetail:@{@"parentId":self.parentId} success:^(NSArray<XLBCarDetailModel *> *cars) {
            
            [weakSelf hideHud];
            weakSelf.dataSource = cars;
            [weakSelf.listTableView reloadData];
        } failure:^(NSString *error) {
            
            [weakSelf hideHud];
        }];
    }
    else {
        [MBProgressHUD showError:@"出错了，请重试"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    XLBCarDetailModel *present = self.dataSource[section];
    NSArray <XLBCarDetailChildModel *>*children = present.children;
    return children.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XLBCarDetailModel *present = self.dataSource[section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = RGB(247, 247, 247);
    UILabel *label = [[UILabel alloc] init];
    [headerView addSubview:label];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor textBlackColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    label.text = present.name;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBCarDetailScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBCarDetailScreeningCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBCarDetailScreeningCell class]) owner:self options:nil].lastObject;
    }
    XLBCarDetailModel *present = self.dataSource[indexPath.section];
    NSArray <XLBCarDetailChildModel *>*children = present.children;
    XLBCarDetailChildModel *model = children[indexPath.row];
    cell.car_title.text = model.name;
    cell.car_subtitle.text = model.priceDesc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLBCarDetailModel *present = self.dataSource[indexPath.section];
    NSArray <XLBCarDetailChildModel *>*children = present.children;
    XLBCarDetailChildModel *model = children[indexPath.row];
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"vehicleAreaIdNotifition" object:nil userInfo:@{@"vehicleAreaId":@(model.ID),@"carname":model.name}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<XLBCarDetailModel *> *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
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
