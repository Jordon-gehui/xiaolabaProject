//
//  XLBPriceViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBPriceViewController.h"
#import "XLBAgeTableViewCell.h"
@interface XLBPriceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *cpValue;//价格value
}
@property (nonatomic, strong)NSMutableDictionary *seleAge;

@end

@implementation XLBPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isAge == YES) {
        self.title = @"年龄";
        self.naviBar.slTitleLabel.text = @"年龄";

    }else {
        self.title = @"车价格";
        self.naviBar.slTitleLabel.text = @"车价格";

    }
    [self setUp];
}

- (void)setUp {

    self.view.backgroundColor = [UIColor viewBackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
}

- (void)rightClick {
    if ([self.delegate respondsToSelector:@selector(didSelectedWithDictionary:withCarPrice:withCarPriceValue:)]) {
        if (_isAge == YES) {
            [self.delegate didSelectedWithDictionary:_seleAge withCarPrice:nil withCarPriceValue:nil];
        }else {
            [self.delegate didSelectedWithDictionary:nil withCarPrice:self.carPri withCarPriceValue:cpValue];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLBAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBAgeTableViewCell class])];
//    NSString *nubRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    FindScreenDetailModel *model = self.data[indexPath.row];
//    NSString *value = [NSString stringWithFormat:@"%li",model.value];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBAgeTableViewCell class]) owner:nil options:nil].lastObject;
    }
    if (_isAge == YES) {
        if ([_seleAge.allKeys containsObject:model.value]) {
            [cell.seleImage setImage:[UIImage imageNamed:@"sele_icon"]];
        }else {
            [cell.seleImage setImage:[UIImage imageNamed:@""]];
        }
    }else {
        
        if ([_carPri isEqualToString:model.label]) {
            cpValue = model.value;
            cell.seleImage.image = [UIImage imageNamed:@"sele_icon"];
        }else {
            cell.seleImage.image = [UIImage imageNamed:@""];
        }
    }
    cell.titles = model.label;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBAgeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSString *nubRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    FindScreenDetailModel *model = self.data[indexPath.row];
    NSLog(@"%@",model.value);
    if (_isAge == NO) {
        if (![_carPri isEqualToString:@""]) {
            _carPri = @"";
            cpValue = @"";
            [cell.seleImage setImage:[UIImage imageNamed:@"sele_icon"]];

        }else {
            _carPri = model.label;
            cpValue = model.value;
            [cell.seleImage setImage:[UIImage imageNamed:@"sele_icon"]];
        }
        [self.tableView reloadData];
    }else {
        if ([_seleAge.allKeys containsObject:model.value]) {
            [_seleAge removeObjectForKey:model.value];
            cell.seleImage.image = [UIImage imageNamed:@""];
        }else {
            [_seleAge setObject:model.label forKey:model.value];
            cell.seleImage.image = [UIImage imageNamed:@"sele_icon"];
        }
        
    }
}

- (void)setItems:(NSArray *)items {
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:items];
    [array addObjectsFromArray:self.data];
    self.data = array;
    [self.tableView reloadData];
    _items = items;
}
- (void)setSeleedDic:(NSDictionary *)seleedDic {
    _seleAge = [NSMutableDictionary dictionaryWithDictionary:seleedDic];
    _seleedDic = seleedDic;
}

@end
