//
//  VoiceScreenViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//
typedef NS_ENUM(NSUInteger, VoiceScreenBtnTag) {
    GirlBtnTag = 100,
    BoyBtnTag,
    AllBtnTag,
    AllCityBtnTag,
    CityBtnTag,
};
#import "VoiceScreenViewController.h"
#import "VoiceAgeScreeView.h"
#import "VoiceSreenCollectionViewCell.h"
@interface VoiceScreenViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSString *seletedAge;
    NSString *seletedSex;
    NSString *seletedCity;
    NSString *seletedPrice;
    NSString *highPrice;
    NSString *lowPrice;
}
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *city;
@property (nonatomic, strong) UILabel *age;
@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UIButton *girlBtn;
@property (nonatomic, strong) UIButton *boyBtn;
@property (nonatomic, strong) UIButton *allBtn;

@property (nonatomic, strong) UISlider *ageSlider;
@property (nonatomic, strong) UILabel *ageSliderLabel;

@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIButton *cityAllBtn;

@property (nonatomic, strong) VoiceAgeScreeView *ageScreeV;

@property (nonatomic, strong) UICollectionView *priceCollectionV;

@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation VoiceScreenViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    self.naviBar.slTitleLabel.text = @"筛选";
    seletedAge = @"";
    seletedSex = @"";
    seletedCity = @"";
    seletedPrice = @"";
    lowPrice = @"";
    highPrice = @"";
    [self setSubViews];
    [self setLoyot];
    [self baseDataRequest];
    
}
- (void)initNaviBar {
    [super initNaviBar];
    UIButton *reportItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [reportItem setTitle:@"完成" forState:UIControlStateNormal];
    reportItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [reportItem setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    [reportItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:reportItem];
    [self.naviBar setRightItem:reportItem];
}

- (void)baseDataRequest {
    [[NetWorking network] POST:kPos params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if (kNotNil(result)) {
            NSDictionary *dic = [result objectAtIndex:0];
            NSArray *arr = dic[@"listDict"];
            [self.data addObjectsFromArray:arr];
            [self.priceCollectionV reloadData];
        }
    } failure:^(NSString *description) {
        
    }];
}


- (void)rightClick {
    
    if (kNotNil(seletedPrice)) {
        if ([seletedPrice containsString:@"-"]) {
            NSArray *arr = [seletedPrice componentsSeparatedByString:@"-"];
            lowPrice = arr[0];
            highPrice = arr[1];
        }
        if ([seletedPrice containsString:@"以下"]) {
            NSArray *arr = [seletedPrice componentsSeparatedByString:@"以"];
            lowPrice = arr[0];
            highPrice = @"";
        }
        if ([seletedPrice containsString:@"以上"]) {
            NSArray *arr = [seletedPrice componentsSeparatedByString:@"以"];
            lowPrice = @"";
            highPrice = arr[0];
        }
    }
    NSDictionary *dict = @{@"city":seletedCity,@"sex":seletedSex,@"age":seletedAge,@"lowPrice":lowPrice,@"highPrice":highPrice,};
    NSLog(@"%@  %@  %@  lowPrice = %@   highPrice = %@",seletedSex,seletedCity,seletedAge,lowPrice,highPrice);
    if ([self.delegate respondsToSelector:@selector(didSeletedWithParame:)]) {
        [self.delegate didSeletedWithParame:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)voiceScreenBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case GirlBtnTag:{
            [self.girlBtn setBackgroundImage:[UIImage imageNamed:@"btn_xz_h"] forState:UIControlStateNormal];
            [self.boyBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.allBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            seletedSex = @"0";
        }
            break;
        case BoyBtnTag:{
            [self.boyBtn setBackgroundImage:[UIImage imageNamed:@"btn_xz_h"] forState:UIControlStateNormal];
            [self.girlBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.allBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            seletedSex = @"1";
        }
            break;
        case AllBtnTag:{
            [self.allBtn setBackgroundImage:[UIImage imageNamed:@"btn_xz_h"] forState:UIControlStateNormal];
            [self.girlBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.boyBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            seletedSex = @"";

        }
            break;
        case AllCityBtnTag:{
            [self.cityAllBtn setBackgroundImage:[UIImage imageNamed:@"btn_xz_h"] forState:UIControlStateNormal];
            [self.cityBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            seletedCity = @"";
        }
            break;
        case CityBtnTag:{
            [self.cityBtn setBackgroundImage:[UIImage imageNamed:@"btn_xz_h"] forState:UIControlStateNormal];
            [self.cityAllBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            seletedCity = [XLBUser user].city;
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VoiceSreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VoiceSreenCollectionViewCell voiceScreenCellID] forIndexPath:indexPath];
    cell.img.hidden = YES;
    cell.priceDict = self.data[indexPath.item];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--选中");
    VoiceSreenCollectionViewCell *cell = (VoiceSreenCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.img.hidden = NO;
    seletedPrice = self.data[indexPath.item][@"label"];
//    if (indexPath.item == 0) {
//        NSArray *arr = [self.data[indexPath.item][@"label"] componentsSeparatedByString:@"以"];
//
//        lowPrice = @"50";
//        highPrice = @"";
//        seletedPrice = @"";
//    }else if (indexPath.item == self.data.count - 1) {
//        highPrice = @"500";
//        lowPrice = @"";
//        seletedPrice = @"";
//    }else {
//        seletedPrice = self.data[indexPath.item][@"label"];
//    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    VoiceSreenCollectionViewCell *cell = (VoiceSreenCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.img.hidden = YES;
}

- (void)setSubViews {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.lineLabel = [UILabel new];
    self.lineLabel.backgroundColor = [UIColor viewBackColor];
    [self.bgView addSubview:self.lineLabel];

    self.sexLabel = [UILabel new];
    self.sexLabel.text = @"性别";
    self.sexLabel.font = [UIFont systemFontOfSize:15];
    self.sexLabel.textColor = [UIColor minorTextColor];
    [self.bgView addSubview:self.sexLabel];

    self.girlBtn = [UIButton new];
    self.girlBtn.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.girlBtn setTitle:@"女生" forState:0];
    [self.girlBtn setTitleColor:[UIColor minorTextColor] forState:UIControlStateNormal];
    self.girlBtn.layer.masksToBounds = YES;
    self.girlBtn.layer.cornerRadius = 5;
    self.girlBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.girlBtn addTarget:self action:@selector(voiceScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.girlBtn.tag = GirlBtnTag;
    [self.bgView addSubview:self.girlBtn];

    self.boyBtn = [UIButton new];
    self.boyBtn.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    self.boyBtn.layer.masksToBounds = YES;
    self.boyBtn.layer.cornerRadius = 5;
    [self.boyBtn setTitle:@"男生" forState:0];
    [self.boyBtn setTitleColor:[UIColor minorTextColor] forState:UIControlStateNormal];
    self.boyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.boyBtn.tag = BoyBtnTag;
    [self.boyBtn addTarget:self action:@selector(voiceScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.bgView addSubview:self.boyBtn];

    self.allBtn = [UIButton new];
    self.allBtn.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.allBtn setTitle:@"全部" forState:0];
    self.allBtn.layer.masksToBounds = YES;
    self.allBtn.layer.cornerRadius = 5;
    [self.allBtn setTitleColor:[UIColor minorTextColor] forState:UIControlStateNormal];
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.allBtn.tag = AllBtnTag;
    [self.allBtn addTarget:self action:@selector(voiceScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.bgView addSubview:self.allBtn];

    self.city = [UILabel new];
    self.city.text = @"城市";
    self.city.font = [UIFont systemFontOfSize:15];
    self.city.textColor = [UIColor minorTextColor];
    [self.view addSubview:self.city];

    self.cityAllBtn = [UIButton new];
    self.cityAllBtn.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.cityAllBtn setTitle:@"全部" forState:0];
    self.cityAllBtn.layer.masksToBounds = YES;
    self.cityAllBtn.layer.cornerRadius = 5;
    [self.cityAllBtn setTitleColor:[UIColor minorTextColor] forState:UIControlStateNormal];
    self.cityAllBtn.tag = AllCityBtnTag;
    self.cityAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cityAllBtn addTarget:self action:@selector(voiceScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.bgView addSubview:self.cityAllBtn];

    self.cityBtn = [UIButton new];
    self.cityBtn.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    [self.cityBtn setTitle:@"同城" forState:0];
    self.cityBtn.layer.masksToBounds = YES;
    self.cityBtn.layer.cornerRadius = 5;
    self.cityBtn.tag = CityBtnTag;
    [self.cityBtn setTitleColor:[UIColor minorTextColor] forState:UIControlStateNormal];
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cityBtn addTarget:self action:@selector(voiceScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.bgView addSubview:self.cityBtn];


    self.age = [UILabel new];
    self.age.text = @"年龄";
    self.age.font = [UIFont systemFontOfSize:15];
    self.age.textColor = [UIColor minorTextColor];
    [self.bgView addSubview:self.age];
    NSArray *arr = @[@"60后",@"70后",@"80后",@"90后",@"00后",@"10后",];
    self.ageScreeV = [[VoiceAgeScreeView alloc] initWithFrame:CGRectMake(0, 0, 280, 50) titles:arr firstAndLastTitles:@[@"60后",@"10后",] defaultIndex:0 sliderImage:[UIImage imageNamed:@"btn_sx_nll"]];
    self.ageScreeV.block = ^(int index) {
        NSLog(@"%d",index);
        seletedAge = arr[index];
    };
    [self.bgView addSubview:self.ageScreeV];

    if (([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) || (![XLBUser user].isLogin || !kNotNil([XLBUser user].token))) {
        
    }else {
        self.price = [UILabel new];
        self.price.text = @"语音资费（车币）";
        self.price.font = [UIFont systemFontOfSize:15];
        self.price.textColor = [UIColor minorTextColor];
        [self.bgView addSubview:self.price];
        
        UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
        folwLayout.itemSize = CGSizeMake(80, 30);
        folwLayout.minimumLineSpacing = 10;
        folwLayout.minimumInteritemSpacing = 10;
        folwLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10,10);
        self.priceCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) collectionViewLayout:folwLayout];
        [self.priceCollectionV registerClass:[VoiceSreenCollectionViewCell class] forCellWithReuseIdentifier:[VoiceSreenCollectionViewCell voiceScreenCellID]];
        self.priceCollectionV.delegate = self;
        self.priceCollectionV.dataSource = self;
        self.priceCollectionV.showsVerticalScrollIndicator = NO;
        self.priceCollectionV.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.priceCollectionV];
    }
    
}

- (void)setLoyot {
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineLabel.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.view.mas_left).with.offset(15);
    }];
    
    [self.girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sexLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.view.mas_left).with.offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.girlBtn);
        make.centerY.mas_equalTo(self.girlBtn.mas_centerY);
        make.left.mas_equalTo(self.girlBtn.mas_right).with.offset(15);
    }];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.boyBtn);
        make.centerY.mas_equalTo(self.boyBtn.mas_centerY);
        make.left.mas_equalTo(self.boyBtn.mas_right).with.offset(15);
    }];
    
    [self.city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.girlBtn.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.view.mas_left).with.offset(15);
    }];
    
    [self.cityAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.girlBtn);
        make.top.mas_equalTo(self.city.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.girlBtn.mas_centerX).with.offset(0);
    }];
    
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.cityAllBtn);
        make.centerY.mas_equalTo(self.cityAllBtn.mas_centerY);
        make.left.mas_equalTo(self.cityAllBtn.mas_right).with.offset(15);
    }];
    
    [self.age mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cityAllBtn.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.view.mas_left).with.offset(15);
    }];

    [self.ageScreeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.age.mas_bottom).with.offset(-10);
        make.left.mas_equalTo(self.age.mas_left).with.offset(0);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(50);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ageScreeV.mas_bottom).with.offset(35);
        make.left.mas_equalTo(self.view.mas_left).with.offset(15);
    }];
    
    [self.priceCollectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.price.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.price.mas_left).with.offset(-10);
        make.right.mas_equalTo(self.allBtn.mas_right).with.offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-30);
    }];
}
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
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
