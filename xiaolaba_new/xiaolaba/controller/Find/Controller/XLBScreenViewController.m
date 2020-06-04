//
//  XLBScreenViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBScreenViewController.h"
#import "MessageNetWorking.h"

#import "XLBScreenCell.h"
#import "XLBScreenSubTableViewCell.h"
#import "XLBPriceViewController.h"
#import "XLBAlertController.h"
#import "XLBCarsListViewController.h"
@interface XLBScreenViewController ()<UITableViewDelegate,UITableViewDataSource,XLBPriceViewControllerDelegate,XLBCarsListViewControllerDelegate,XLBScreenSubTableViewCellDelegate>
@property (nonatomic, assign) BOOL isAge;
@property (nonatomic, copy)NSString *isSex;

@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *city;

@property (nonatomic, copy)NSString *age;

@property (nonatomic, copy)NSString *carPrice;
@property (nonatomic, copy)NSString *cpValue;

@property (nonatomic, copy)NSString *carBrand;

@property (nonatomic, strong)NSDictionary *ageDic;
@property (nonatomic, strong)NSDictionary *carPriceDic;

@property (nonatomic, copy)NSString *carBrandValue;

@property (nonatomic, copy)NSString *ageValue;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *ageArray;
@property (nonatomic, strong) NSMutableArray *brandsArray;
@property (nonatomic, strong) NSMutableDictionary *temp_params;

@end

@implementation XLBScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"寻车友";
    self.naviBar.slTitleLabel.text = @"寻车友";

    _dataArray = [NSMutableArray array];
    _ageArray = [NSMutableArray array];
    _brandsArray = [NSMutableArray array];
    [self setUp];
}
- (void)setUp {
    _isSex = @"";
    _city = @"";
    _carPrice = @"";
    _cpValue = @"";
    _ageValue = @"";
    _carBrandValue = @"";
    
    kWeakSelf(self);
    [weakSelf showHudWithText:nil];
    [MessageNetWorking requestFindScreenCondition:^(NSArray*result) {
        [self hideHud];
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObjectsFromArray:self.dataArray];
        [dataArr addObjectsFromArray:result];
        self.dataArray = dataArr;
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [self hideHud];
        
    }];
    
    _ageDic = [NSMutableDictionary dictionary];
    _carPriceDic = [NSMutableDictionary dictionary];
    if ([XLBUser user].other) {
        NSDictionary *dict = [[XLBUser user].other mutableCopy];
        if (kNotNil(dict[@"ageDic"])) {
            _ageDic = [dict[@"ageDic"] mutableCopy];
            _ageValue = [_ageDic.allKeys componentsJoinedByString:@","];
            for (int i = 0; i < _ageDic.allKeys.count; i++) {
                NSString *key = [_ageDic.allKeys objectAtIndex:i];
                NSString *value = [_ageDic objectForKey:key];
                [self.ageArray addObject:value];
            }
        }
        if (kNotNil(dict[@"carPriceDic"])) {
            _carPriceDic = [dict[@"carPriceDic"] mutableCopy];
            _carBrandValue = [_carPriceDic.allKeys componentsJoinedByString:@","];
            for (int i = 0; i < _carPriceDic.allKeys.count; i++) {
                NSString *key = [_carPriceDic.allKeys objectAtIndex:i];
                NSString *value = [_carPriceDic objectForKey:key];
                [self.brandsArray addObject:value];
            }
        }
        _city = dict[@"city"];
        _carPrice = dict[@"carPrice"];
        _isSex = dict[@"sex"];
        _cpValue = dict[@"cpValue"];
        if ([_isSex isEqualToString:@"1"]) {
            _sex = @"男";
        }
        if ([_isSex isEqualToString:@"0"]) {
            _sex = @"女";
        }
        if ([_isSex isEqualToString:@""]) {
            _sex = @"不限";
        }
        NSLog(@"%@",dict);
    }
    
    self.view.backgroundColor = [UIColor viewBackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.data = (NSMutableArray *)[DefaultList initScreenCarInfoList];
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *leftItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftItem setTitle:@"清空" forState:UIControlStateNormal];
    [leftItem setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    leftItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftItem addTarget:self action:@selector(letfClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setLeftItem:leftItem];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"搜索" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
    
}
-(void)letfClick{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"sex"];
    [dict setObject:@"" forKey:@"city"];
    [dict setObject:@"" forKey:@"carPrice"];
    [dict setObject:@"" forKey:@"cpValue"];
    [dict setObject:@"" forKey:@"ageDic"];
    [dict setObject:@"" forKey:@"carPriceDic"];
    [[XLBUser user] setOther:dict];
    NSString *cityName = @"";
    NSDictionary *parameter = @{@"city":cityName,
                                @"sex":@"",
                                @"age":@"",
                                @"price":@"",
                                @"brands":@""};
    NSLog(@"%@",parameter);
    if (self.block) {
        self.block(parameter,1);
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)rightClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_isSex forKey:@"sex"];
    [dict setObject:_city forKey:@"city"];
    [dict setObject:_carPrice forKey:@"carPrice"];
    [dict setObject:_cpValue forKey:@"cpValue"];
    [dict setObject:_ageDic forKey:@"ageDic"];
    [dict setObject:_carPriceDic forKey:@"carPriceDic"];
    [[XLBUser user] setOther:dict];
    NSString *cityName;
    if (kNotNil(_city)) {
        if ([_city isEqualToString:@"同城"]) {
            cityName = @"1";
        }else {
            cityName = @"";
        }
    }
    if (!kNotNil(_city)) {
        cityName = @"";
    }
    
    NSDictionary *parameter = @{@"city":cityName,
                                @"sex":_isSex,
                                @"age":_ageValue,
                                @"price":_cpValue,
                                @"brands":_carBrandValue,};
    NSLog(@"%@",parameter);
    if (self.block) {
        self.block(parameter,0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backClick:(id)sender {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_isSex forKey:@"sex"];
    [dict setObject:_city forKey:@"city"];
    [dict setObject:_carPrice forKey:@"carPrice"];
    [dict setObject:_cpValue forKey:@"cpValue"];
    [dict setObject:_ageDic forKey:@"ageDic"];
    [dict setObject:_carPriceDic forKey:@"carPriceDic"];
    [[XLBUser user] setOther:dict];
    NSString *cityName;
    if (kNotNil(_city)) {
        if ([_city isEqualToString:@"同城"]) {
            cityName = @"1";
        }else {
            cityName = @"";
        }
    }
    if (!kNotNil(_city)) {
        cityName = @"";
    }
    
    NSDictionary *parameter = @{@"city":cityName,
                                @"sex":_isSex,
                                @"age":_ageValue,
                                @"price":_cpValue,
                                @"brands":_carBrandValue,};
    NSLog(@"%@",parameter);
    if (self.block) {
        self.block(parameter,0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindScreenModel *model = self.dataArray[indexPath.row];

    if (indexPath.row == 0) {
        XLBScreenSubTableViewCell *subCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBScreenSubTableViewCell class])];
        if (!subCell) {
            subCell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBScreenSubTableViewCell class]) owner:self options:nil].lastObject;
        }
        subCell.delegate = self;
        
        subCell.sexLbael.text = model.descr;
        subCell.sex = _sex;
        return subCell;
    }else {
        XLBScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBScreenCell class])];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBScreenCell class]) owner:nil options:nil].lastObject;
        }
        cell.titleLabel.text = model.descr;
        if (indexPath.row == 1) {
            cell.subtitle.text = _city;
        }
        if (indexPath.row == 2) {
            cell.items = self.ageArray;
        }
        if (indexPath.row == 3) {
            cell.subtitle.text = _carPrice;
        }
        if (indexPath.row == 4) {
            cell.items = self.brandsArray;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FindScreenModel *screenModel = self.dataArray[indexPath.row];
    switch (indexPath.row) {
        case 1: {
            
            [self citySeleWithArray:screenModel.listDict];
        }
            break;
        case 2: {
            XLBPriceViewController *priceVC = [[XLBPriceViewController alloc] init];
            priceVC.isAge = YES;
            _isAge = YES;
            priceVC.delegate = self;
            priceVC.items = screenModel.listDict;
            priceVC.seleedDic = _ageDic;
            NSLog(@"%@",_ageDic);
            [self.navigationController pushViewController:priceVC animated:YES];
        }
            break;
        case 3: {
            XLBPriceViewController *priceVC = [[XLBPriceViewController alloc] init];
            priceVC.isAge = NO;
            _isAge = NO;
            priceVC.delegate = self;
            priceVC.carPri = _carPrice;
            priceVC.items = screenModel.listDict;
            [self.navigationController pushViewController:priceVC animated:YES];
        }
            break;
        case 4: {
            XLBCarsListViewController *carListVC = [[XLBCarsListViewController alloc] init];
            carListVC.delegate = self;
            carListVC.seleDic = _carPriceDic;
            carListVC.items = screenModel.listDict;
            [self.navigationController pushViewController:carListVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)didSeletedSexWith:(NSString *)sex {
    _isSex = sex;
}

- (void)didSelectedWithDictionary:(NSDictionary *)dict withCarPrice:(NSString *)carPrice withCarPriceValue:(NSString *)value{
    if (_isAge == YES) {
        _ageDic = dict;
        _ageValue = [dict.allKeys componentsJoinedByString:@","];
        [self.ageArray removeAllObjects];
        for (int i = 0; i < dict.allKeys.count; i++) {
            NSString *key = [dict.allKeys objectAtIndex:i];
            NSString *value = [dict objectForKey:key];
            [self.ageArray addObject:value];
        }
        NSIndexPath *indexPate = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPate] withRowAnimation:UITableViewRowAnimationNone];

    }else {
        _carPrice = carPrice;
        _cpValue = value;
        NSIndexPath *indexPate = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPate] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)seletedCarSeableWithDict:(NSMutableDictionary *)seableDic {
    NSLog(@"%@",seableDic);
    
    _carPriceDic = seableDic;
    _carBrandValue = [seableDic.allKeys componentsJoinedByString:@","];
    [self.brandsArray removeAllObjects];
    for (int i = 0; i < seableDic.allKeys.count; i++) {
        NSString *key = [seableDic.allKeys objectAtIndex:i];
        NSString *value = [seableDic objectForKey:key];
        [self.brandsArray addObject:value];
    }
    NSIndexPath *indexPate = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPate] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)citySeleWithArray:(NSArray<FindScreenDetailModel *>*)items {
    NSMutableArray *array = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(FindScreenDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.label];
    }];
    UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:array title:nil message:nil cancel:YES cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        if (index == 0) {
            self.city = array[0];
        }else {
            self.city = array[1];
        }
        
        NSIndexPath *indexPate = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPate] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
//
//#pragma XLBAreaSelectViewDelegate
//- (void)areaSelectView:(XLBAreaSelectView *)view
//         didSelectArea:(NSString *)area
//              province:(NSString *)province
//                  city:(NSString *)city
//              district:(NSString *)district {
//    self.city = city;
//}

//- (NSDictionary *)ageDic {
//    if (!_ageDic) {
//        _ageDic = [NSDictionary dictionary];
//    }
//    return _ageDic;
//}

- (NSDictionary *)carPriceDic {
    if (!_carPriceDic) {
        _carPriceDic = [NSDictionary dictionary];
    }
    return _carPriceDic;
}

- (NSString *)isSex {
    if (kNotNil(_isSex)) {
        return _isSex;
    }
    return @"";
}

- (NSString *)city {
    if (kNotNil(_city)) {
        return _city;
    }
    return @"";
}

- (NSString *)carPrice {
    if (kNotNil(_carPrice)) {
        return _carPrice;
    }
    return @"";
}

- (NSString *)cpValue {
    if (kNotNil(_cpValue)) {
        return _cpValue;
    }
    return @"";
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
