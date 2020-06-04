//
//  XLBAccountDetailViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/20.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAccountDetailViewController.h"
#import "VoiceActorCollectionReusableView.h"
#import "XLBAccountDetailCollectionViewCell.h"
#import "APOrderInfo.h"
#import "RechargeView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface XLBAccountDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RechargeViewDelegate>
@property (nonatomic, strong) UIButton *alipayBtn;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) VoiceActorCollectionReusableView *headerView;
@end

@implementation XLBAccountDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    self.translucentNav = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self moneyRequest];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)moneyRequest {
    
    [[NetWorking network] POST:kTicket params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            [self.data addObjectsFromArray:result[0][@"listDict"]];
            [self.data addObject:@{@"label":@"",@"value":@"",}];
            [self.collectionView reloadData];
        }
    } failure:^(NSString *description) {
        
    }];
    
    [[NetWorking network] POST:kMoney params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if (kNotNil([result objectForKey:@"coinSum"])) {
            float coinSumMoney = [[result objectForKey:@"coinSum"] floatValue];
            self.headerView.accountLabel.text = [NSString stringWithFormat:@"%.2f",coinSumMoney];
            [userDefault setObject:[result objectForKey:@"coinSum"] forKey:@"coinSum"];
        }else {
            self.headerView.accountLabel.text = @"0";
            [userDefault setObject:@"0" forKey:@"coinSum"];
        }
        [userDefault synchronize];
    } failure:^(NSString *description) {
        self.headerView.accountLabel.text = @"0";
    }];
    
    
}
- (void)alipayBtnClick:(UIButton *)sender {
    if (!kNotNil(self.money)) {
        [MBProgressHUD showError:@"请至少选择一个充值金额"];
        return;
    }
    [self aliPayWithMoney:self.money];
}

- (void)aliPayWithMoney:(NSString *)money {
    NSDictionary *dict = @{@"money":money};
    [[NetWorking network] POST:kPaySign params:dict cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if (!kNotNil(result)) return ;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:money forKey:@"rechargeMoney"];
        [userDef synchronize];
        [[AlipaySDK defaultService] payOrder:result[@"orderSign"] fromScheme:@"xiaolaba" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                [MBProgressHUD showSuccess:@"充值成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}
- (void)helpBtnClick:(UIButton *)sender {
    NSLog(@"%@",self.money);
    [[CSRouter share] push:@"XLBAccountHelpViewController" Params:nil hideBar:YES];
}
- (void)didConfirmWithMoney:(NSString *)money {
    NSLog(@"%@",money);
    [self aliPayWithMoney:money];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[VoiceActorCollectionReusableView voiceActorHeaderView] forIndexPath:indexPath];
        return self.headerView;
    }else {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
            [footView addSubview:[self addFootView]];
        return footView;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (iPhoneX) {
        CGSize size={kSCREEN_WIDTH,274};
        return size;
    }else {
        CGSize size={kSCREEN_WIDTH,250};
        return size;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size={kSCREEN_WIDTH,150};
    return size;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBAccountDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[XLBAccountDetailCollectionViewCell accountDetailCellId] forIndexPath:indexPath];
    if (!cell) {
        cell = [[XLBAccountDetailCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 165, 80)];
    }
    cell.customPrice.hidden= YES;
    cell.discountsLabel.hidden = YES;
    cell.img.hidden = YES;
    cell.dict = self.data[indexPath.item];
    if (indexPath.item == self.data.count-1) {
        cell.priceLabel.text = @"";
        cell.img.hidden = YES;
        cell.customPrice.hidden=NO;
        cell.discountsLabel.hidden = YES;
    }else if (indexPath.item == 0) {
        cell.discountsLabel.hidden = NO;
        cell.img.hidden = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.data.count -1) {
        RechargeView *rechargeV = [RechargeView new];
        rechargeV.delegate = self;
        rechargeV.style = @"1";
        rechargeV.account = self.headerView.accountLabel.text;
        [self.view.window addSubview:rechargeV];
        
    }else {
        XLBAccountDetailCollectionViewCell *cell = (XLBAccountDetailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.bgView.layer.borderColor = [UIColor shadeEndColor].CGColor;
        self.money = self.data[indexPath.item][@"value"];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBAccountDetailCollectionViewCell *cell = (XLBAccountDetailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgView.layer.borderColor = [UIColor lineColor].CGColor;
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kSCREEN_WIDTH-30)/2;
        folwLayout.itemSize = CGSizeMake(itemWidth, 80);
        folwLayout.minimumLineSpacing = 10;
        folwLayout.minimumInteritemSpacing = 5;
        folwLayout.sectionInset = UIEdgeInsetsMake(5, 12, 5, 12);
        if (iPhoneX) {
            folwLayout.headerReferenceSize=CGSizeMake(kSCREEN_WIDTH, 274); //设置collectionView头视图的大小
        }else {
            folwLayout.headerReferenceSize=CGSizeMake(kSCREEN_WIDTH, 250); //设置collectionView头视图的大小
        }
        folwLayout.footerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 150);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT+64) collectionViewLayout:folwLayout];
        [_collectionView registerClass:[XLBAccountDetailCollectionViewCell class] forCellWithReuseIdentifier:[XLBAccountDetailCollectionViewCell accountDetailCellId]];
        [self.collectionView registerClass:[VoiceActorCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[VoiceActorCollectionReusableView voiceActorHeaderView]];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.collectionView];
        if (iPhoneX) {
            self.collectionView.top = -90;
        }else{
            self.collectionView.top = -64;
        }
    }
    return _collectionView;
}

- (UIView *)addFootView {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
    footV.backgroundColor = [UIColor whiteColor];
    
    self.alipayBtn = [UIButton new];
    [self.alipayBtn setTitle:@"确认支付" forState:0];
    [self.alipayBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.alipayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.alipayBtn setBackgroundImage:[UIImage imageNamed:@"btn_zf"] forState:UIControlStateNormal];
    [self.alipayBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:self.alipayBtn];
    
    [self.alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footV.mas_top).with.offset(10);
        make.height.mas_equalTo(47);
        make.width.mas_equalTo(295);
        make.centerX.mas_equalTo(footV.mas_centerX).with.offset(0);
    }];

    
    self.helpBtn = [UIButton new];
    [self.helpBtn setTitle:@"帮助？" forState:0];
    [self.helpBtn setTitleColor:[UIColor annotationTextColor] forState:0];
    self.helpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.helpBtn addTarget:self action:@selector(helpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:self.helpBtn];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alipayBtn.mas_bottom).with.offset(5);
        make.left.right.mas_equalTo(0);
    }];
    
    return footV;
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
