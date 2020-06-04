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
        _title.font = pingHei_Light(16);
        _title.textColor = UIColorHex(575757);
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        _subtitle = [[UILabel alloc] init];
        [self.contentView addSubview:_subtitle];
        _subtitle.font = pingHei_Light(13);
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




@interface XLBChooseLocationViewController () <BMKLocationServiceDelegate,BMKPoiSearchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *locationTable;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic,strong) BMKPoiSearch *poiSearch;//搜索服务

@end

@implementation XLBChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bql_title = @"所在位置";
    self.bql_leftWord = @"取消";
    [self setup];
}

- (void)setup {
    
    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    //设置代理
    self.service.delegate = self;
    //开启定位
    [self.service startUserLocationService];
    
    self.locationTable.rowHeight = 55.f;
    self.locationTable.backgroundColor = RGB(248, 248, 248);
    self.locationTable.tableFooterView = [UIView new];
    
    [self show];
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
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    //索引 默认为0
    option.pageIndex = 0;
    //页数默认为10
    option.pageCapacity = 10;
    //搜索半径
    option.radius = 200;
    //检索的中心点，经纬度
    option.location = userLocation.location.coordinate;
    //搜索的关键字
    //option.keyword = @"大楼";
    option.keyword = @"饮食";
    
    //根据中心点、半径和检索词发起周边检索
    BOOL flag = [self.poiSearch poiSearchNearBy:option];
    if (flag) {
        NSLog(@"搜索成功");
        //关闭定位
        [self.service stopUserLocationService];
    }
    else {
        NSLog(@"搜索失败");
        [self hide];
    }
}

#pragma mark -------BMKPoiSearchDelegate

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    
    NSLog(@"%@",poiDetailResult.name);
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [poiResultList.poiInfoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BMKPoiInfo *info = (BMKPoiInfo *)obj;
            NSDictionary *list = @{@"title":info.name,
                                   @"subtitle":info.address};
            [self.dataSource addObject:list];
            if(idx > 14) *stop = YES;
        }];
        [self.locationTable reloadData];
        [self hide];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        [self hide];
    }
    else {
        NSLog(@"抱歉，未找到结果");
        [self hide];
        [self showMsg:@"未找到结果" bottom:YES];
    }
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated {
    _poiSearch.delegate = nil;
}

- (void)leftClick {
    
    [self popViewController];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LocationCell class])];
    if (cell == nil) {
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LocationCell class])];
    }
    NSDictionary *data = self.dataSource[indexPath.row];
    cell.title.text = [data objectForKey:@"title"];
    cell.subtitle.text = [data objectForKey:@"subtitle"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = self.dataSource[indexPath.row];
    
    NSNotification *locationNotification = [[NSNotification alloc] initWithName:kLocationChooseNotification object:nil userInfo:@{@"location":[data objectForKey:@"subtitle"]}];
    [kNotificationCenter postNotification:locationNotification];
    
    [self popViewController];
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
