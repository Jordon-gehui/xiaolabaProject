//
//  XLBChooseLocationViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBChooseLocationViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import "XLBUser.h"

@interface LocationCell : UITableViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@end
@implementation LocationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.userInteractionEnabled = YES;
        _title = [[UILabel alloc] init];
        [self.contentView addSubview:_title];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = UIColorFromRGB(0x575757);
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        _subtitle = [[UILabel alloc] init];
        [self.contentView addSubview:_subtitle];
        _subtitle.font = [UIFont systemFontOfSize:13];
        _subtitle.textColor = RGB(176, 176, 176);
        [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(_title);
            make.top.equalTo(_title.mas_bottom).with.offset(4);
        }];
        UIView *line = [[UIView alloc] init];
        [self.contentView addSubview:line];
        line.backgroundColor = RGB(244, 244, 244);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_title.mas_left);
            make.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.7);
        }];
    }
    return self;
}
@end




@interface XLBChooseLocationViewController () <BMKLocationServiceDelegate,BMKPoiSearchDelegate,UISearchBarDelegate>
{
    NSArray *keyList;
    NSInteger listNumber;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cashData;
@property (nonatomic, copy)NSString *city;
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic,strong) BMKPoiSearch *poiSearch;//搜索服务

@end

@implementation XLBChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"所在位置";
    self.naviBar.slTitleLabel.text = @"所在位置";
    [self setup];
    [self setupHeader];
}
- (void)setupHeader {
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.showsCancelButton = NO;
    _searchBar.tintColor = [UIColor grayColor];
    _searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    
    _searchBar.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 45);
    for (UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                UITextField *textField = [subView.subviews objectAtIndex:0];
                textField.backgroundColor = [UIColor whiteColor];
                
                //设置输入框边框的颜色
                textField.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
                textField.layer.borderWidth = 1;
                textField.layer.cornerRadius = 15;
                
                //设置输入字体颜色
                textField.textColor = [UIColor textBlackColor];
                
                //设置默认文字颜色
                UIColor *color = [UIColor grayColor];
                [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"搜索"
                                                                                    attributes:@{NSForegroundColorAttributeName:color}]];
                //修改默认的放大镜图片
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = [UIImage imageNamed:@"fangdajing"];
                textField.leftView = imageView;
            }
        }
    }
    self.tableView.sectionIndexColor = RGB(102, 102, 102);
    self.tableView.tableHeaderView = _searchBar;
    self.tableView.backgroundColor = [UIColor whiteColor];
}
#pragma mark - UISearchBarDelegate 协议

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
    
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    searchBar.text = nil;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    if (keyList.count !=2) {
        keyList = @[@"小区",@"商场"];
        self.page = 0;
        listNumber = 0;
        self.dataSource = self.cashData;
        [self.tableView reloadData];
    }
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    [self.searchBar resignFirstResponder];// 放弃第一响应者
    if (kNotNil(searchBar.text)) {
        [self filterBySubstring:searchBar.text];
    }
    
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    NSLog(@"textDidChange---%@",searchBar.text);
    if (!kNotNil(searchBar.text)) {
        if (keyList.count !=2) {
            keyList = @[@"小区",@"商场"];
            self.page = 0;
            listNumber = 0;
            self.dataSource = self.cashData;
            [self.tableView reloadData];
        }
        
    }
    //    [self controlAccessoryView:0];// 隐藏遮盖层。
    
}
- (void) filterBySubstring:(NSString*) subStr {
    keyList =@[subStr];
    [self refresh];
}
- (void)setup {
    
    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    //设置代理
    self.service.delegate = self;
    //开启定位
    
    self.tableView.rowHeight = 55.f;
    self.tableView.backgroundColor = RGB(248, 248, 248);
    self.tableView.tableFooterView = [UIView new];
//    self.allowRefresh = YES;
    [self refresh];
    self.allowLoadMore =YES;
//    keyList = @[@"花园$小吃"];
//    keyList = @[@"企业",@"学校",@"餐馆",@"酒店",@"商业区",@"写字楼",@"工业区",@"物流",@"快递",@"小区",@"停车场",@"医院",@"4s店"];
    keyList = @[@"小区",@"商场"];
}
-(void)refresh {
    self.page = 0;
    listNumber = 0;
    [self showHudWithText:nil];
    [self.service startUserLocationService];
}

-(void)loadMore {
    self.page++;
    listNumber = 0;
    [self.service startUserLocationService];
}
- (BMKPoiSearch *)poiSearch {
    
    if(!_poiSearch) {
        _poiSearch =[[BMKPoiSearch alloc] init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    //初始化一个周边云检索对象
    BMKPOINearbySearchOption *option = [[BMKPOINearbySearchOption alloc] init];
    //索引 默认为0
    option.pageIndex = (int)self.page;
    //页数默认为10
    option.pageSize = 10;
    //搜索半径
    option.radius = 2000;
    //检索的中心点，经纬度
    option.location = userLocation.location.coordinate;
    //搜索的关键字
    option.keywords = keyList;

        //根据中心点、半径和检索词发起周边检索
    BOOL flag = [self.poiSearch poiSearchNearBy:option];
    if (flag) {
        NSLog(@"搜索成功");
        //关闭定位
        [self.service stopUserLocationService];
    }
    else {
        NSLog(@"搜索失败");
    }
}

#pragma mark -------BMKPoiSearchDelegate

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPOIDetailSearchResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    NSLog(@"%@",poiDetailResult);
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"%@",poiResult.poiInfoList);
        if (self.page ==0 &&listNumber ==0) {
            [self.dataSource removeAllObjects];
        }
        [poiResult.poiInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BMKPoiInfo *info = (BMKPoiInfo *)obj;
            _city = info.city;
            NSDictionary *list = @{@"title":info.name,
                                   @"subtitle":info.address};
            [self.dataSource addObject:list];
//            if(idx > 14) *stop = YES;
        }];
//        if (poiResultList.poiInfoList.count<10) {
//            [self.tableView.mj_footer resetNoMoreData];
//        }
        
//        listNumber ++;
//        if (listNumber != keyList.count) {
//            [self.service startUserLocationService];
//        }else {
            [self hideHud];
            if (self.page ==0 &&keyList.count==2) {
                self.cashData = [self.dataSource mutableCopy];
            }
            [self.tableView reloadData];
//        }
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
//        listNumber ++;
//        if (listNumber != keyList.count) {
//            [self.service startUserLocationService];
//        }else{
            [self hideHud];
            [self.tableView reloadData];
//        }
        NSLog(@"起始点有歧义");
    }else {
        NSLog(@"抱歉，未找到结果");
//        listNumber ++;
//        if (listNumber == keyList.count) {
            [self hideHud];
//            if (self.dataSource.count ==0) {
                [MBProgressHUD showError:@"未找到结果"];
//            }else{
                [self.tableView reloadData];
//            }
//        }else{
//            [self.service startUserLocationService];
//        }
    }
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    _poiSearch.delegate = nil;
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count +2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LocationCell class])];
    if (cell == nil) {
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([LocationCell class])];
    }
    if (indexPath.row ==0) {
        cell.title.text = @"不显示位置";
        cell.subtitle.text = @"隐藏您的地理位置";
    }else if (indexPath.row ==1){
        cell.title.text = _city;
        cell.subtitle.text = @"搜索到的所属城市";
    }else {
        NSDictionary *data = self.dataSource[indexPath.row-2];
        cell.title.text = [data objectForKey:@"title"];
        cell.subtitle.text = [data objectForKey:@"subtitle"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if (self.returnBlock) {
            self.returnBlock(@"");
        }
        
    }else if(indexPath.row == 1) {
        if (self.returnBlock) {
            self.returnBlock(_city);
        }
    }else {
        NSDictionary *data = self.dataSource[indexPath.row-2];
        if (self.returnBlock) {
            self.returnBlock([data objectForKey:@"title"]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
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
