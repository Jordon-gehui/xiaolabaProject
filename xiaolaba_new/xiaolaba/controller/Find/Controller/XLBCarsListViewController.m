//
//  XLBCarsListViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/5.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBCarsListViewController.h"
#import "BQLChineseString.h"
#import "XLBCarBrandModel.h"
#import "BDChineseStor.h"
#import "CarListTableViewCell.h"
#import "UITableView+CCPIndexView.h"
@interface XLBCarsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carsTableTop;

@property (weak, nonatomic) IBOutlet UITableView *carsTableView;
@property (nonatomic, strong) NSMutableArray *carsIndexArray;
@property (nonatomic, strong) NSMutableArray *carsIndexArrays;
@property (nonatomic, strong) NSMutableArray *carsLetterResultArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableDictionary *seleCar;
@property (nonatomic, strong) NSMutableArray *carData;
@end

@implementation XLBCarsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"车品牌";
    self.naviBar.slTitleLabel.text = @"车品牌";
    self.carsTableTop.constant = self.naviBar.bottom;
//    _seleCarDic = [NSMutableDictionary dictionary];
    self.carsTableView.backgroundView = [[UIView alloc] init];

    self.carsTableView.backgroundColor = [UIColor viewBackColor];
    self.carsTableView.sectionIndexColor = RGB(102, 102, 102);
    [self.carsTableView ccpIndexView];
    [self setupCarsJson];
    
    
}
- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
}

- (void)rightClick {
    if ([self.delegate respondsToSelector:@selector(seletedCarSeableWithDict:)]) {
        [self.delegate seletedCarSeableWithDict:_seleCar];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupCarsJson {
    
    self.carsTableView.rowHeight = 65.f;


    [[NetWorking network] POST:kBrands params:nil cache:NO success:^(NSArray *result) {
        self.carData = [XLBCarBrandModel mj_objectArrayWithKeyValuesArray:result];
        self.carsIndexArray = [BDChineseStor IndexWithArray:self.carData Key:@"name"];
        self.carsLetterResultArray = [BDChineseStor sortObjectArray:self.carData Key:@"name"];
        [self.carsLetterResultArray insertObject:self.items atIndex:0];
        [self.carsTableView reloadData];
    } failure:^(NSString *description) {
        
    }];
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.carsIndexArray objectAtIndex:section];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.carsIndexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return index;
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.carsLetterResultArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.carsLetterResultArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    CarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CarListTableViewCell class])];
    if (cell == nil) {
        cell = [[CarListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CarListTableViewCell class])];
    }
    NSString *value ;
    if (indexPath.section == 0) {
        FindScreenDetailModel *model = self.carsLetterResultArray[indexPath.section][indexPath.row];
        cell.carName.text = model.label;
        value = model.value;
        NSString *imgName = [[model.url componentsSeparatedByString:@"/"] lastObject];
        NSLog(@"%@",model.url);
        cell.carImage.image = [UIImage imageNamed:imgName];
        [cell.carImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.url Withtype:IMGNormal]] placeholderImage:nil];
    }else {
        NSArray *modelsArray = self.carsLetterResultArray[indexPath.section];
        XLBCarBrandModel *model = modelsArray[indexPath.row];
        value = model.numberID;
        
        cell.carName.text = model.name;        
        [cell.carImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGNormal]] placeholderImage:nil];
        NSLog(@"%@",model.img);
    }
    NSLog(@"%@",value);
    if ([_seleCar.allKeys containsObject:value]) {
        [cell.seleImage setImage:[UIImage imageNamed:@"sele_icon"]];
    }else {
        [cell.seleImage setImage:[UIImage imageNamed:@""]];
    }
    NSLog(@"%@",_seleCar);

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *value ;
    NSString *name ;
    if (indexPath.section == 0) {
        NSArray *modelArr = self.carsLetterResultArray[indexPath.section];
        FindScreenDetailModel *model = modelArr[indexPath.row];
        value = model.value;
        name = model.label;
        
    }else {
        NSArray *modelsArray = self.carsLetterResultArray[indexPath.section];
        XLBCarBrandModel *model = modelsArray[indexPath.row];
        value = model.numberID;
        name = model.name;
    }
    if ([_seleCar.allKeys containsObject:value]) {
        
        [_seleCar removeObjectForKey:value];
        cell.seleImage.image = [UIImage imageNamed:@""];
        
    }else {
        if (_seleCar.allKeys.count >2) {
            [MBProgressHUD showSuccess:@"最多选择3个"];
        }else {
            [_seleCar setObject:name forKey:value];
            cell.seleImage.image = [UIImage imageNamed:@"sele_icon"];
        }
    }
    NSLog(@"%@",_seleCar);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *content = [[UIView alloc] init];
    content.backgroundColor = [UIColor viewBackColor];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = [UIColor textBlackColor];
    lab.font = [UIFont systemFontOfSize:15];
    if (section == 0) {
        lab.text = @"热门推荐";
    }else {
        lab.text = [self.carsIndexArray objectAtIndex:section-1];
    }
    [content addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.bottom.right.mas_equalTo(0);

    }];
    return content;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)setSeleDic:(NSDictionary *)seleDic {
    _seleCar = [NSMutableDictionary dictionaryWithDictionary:seleDic];
    _seleDic = seleDic;
}

@end
