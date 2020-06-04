//
//  XLBMyInfoShowSubViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//
#import "XLBMeRequestModel.h"
#import "XLBUser.h"
//#import "XLBMyInfoImgView.h"
#import "XLBDMyInfoCell.h"
#import "XLBMyInfoShowHeaderView.h"
#import "XLBMyInfoSubShowViewController.h"
#import "XLBMyInfoShowSubViewController.h"
#import "ImageReviewViewController.h"
#import "OwnerDynamicViewController.h"
@interface XLBMyInfoShowSubViewController ()<UITableViewDelegate,UITableViewDataSource,XLBMyInfoShowHeaderViewDelegate,XLBMyInfoSubShowViewControllerDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meTableTop;

@property (nonatomic, strong) NSMutableArray *settingSource;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, strong) XLBMyInfoShowHeaderView *heardView;

@property (nonatomic, strong) XLBUser *user;

@end

@implementation XLBMyInfoShowSubViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUp) name:@"saveSuccess" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setImage:[UIImage imageNamed:@"compile_icon"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}
- (void)setUp {
    self.title = [XLBUser user].userModel.nickname;
    self.naviBar.slTitleLabel.text = [XLBUser user].userModel.nickname;
    CGFloat itemWidth = (kSCREEN_WIDTH - 20) / 4;
    CGFloat image_bg_view_height = itemWidth * 2 + 15;
    kWeakSelf(self);
    [XLBMeRequestModel requestInfo:^(XLBUser *user) {
        weakSelf.user = user;
        CGFloat height = 0;
        if (user.userModel.pick.count > 4) {
            height = image_bg_view_height + 40;
        }else{
            height =  itemWidth + 10 + 40;
        }
        weakSelf.heardView = [[XLBMyInfoShowHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height) user:user];
        _heardView.delegate = self;
        weakSelf.meTable.tableHeaderView = weakSelf.heardView;
        weakSelf.meTable.tableFooterView = [UIView new];
        self.sign = user.userModel.signature;
        [self.meTable reloadData];

    } failure:^(NSString *error) {
        
    }];
    [self settingSource];
    self.meTableTop.constant = self.naviBar.bottom;
    self.meTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.meTable.separatorColor = [UIColor lineColor];
    [self.meTable reloadData];
}

- (NSMutableArray *)settingSource {
    if(!_settingSource) {
        _settingSource = [[DefaultList initMeInfoList] mutableCopy];
    }
    return _settingSource;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.settingSource[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001f;
    }else{
        return 10.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor viewBackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if ([self.sign sizeWithMaxWidth:184.0f*kiphone6_ScreenHeight font:[UIFont systemFontOfSize:15]].height < 44.0f) {
            return 44.0f*kiphone6_ScreenHeight;
        }
        return [self.sign sizeWithMaxWidth:184.0f*kiphone6_ScreenHeight font:[UIFont systemFontOfSize:15]].height;
    }
    return 44.0f*kiphone6_ScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    XLBDMyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBDMyInfoCell class])];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBDMyInfoCell class]) owner:self options:nil].lastObject;
    }
    cell.user = self.user;
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    if (indexPath.section == 1) {
        cell.XLBSubTitleHeight.constant = [self.sign sizeWithMaxWidth:184.0f*kiphone6_ScreenHeight font:[UIFont systemFontOfSize:15]].height;
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        OwnerDynamicViewController * ower = [OwnerDynamicViewController new];
        ower.ID = [NSString stringWithFormat:@"%@",self.user.userModel.ID] ;
        ower.owerTitle = @"我的动态";
        ower.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ower animated:YES];
    }
}
- (void)rightClick {
    XLBMyInfoSubShowViewController *myInfo = [[XLBMyInfoSubShowViewController alloc] init];
    myInfo.editUser = [XLBUser user];
    myInfo.delegate = self;
    [self.navigationController pushViewController:myInfo animated:YES];
}
- (void)imageShowWithIndex:(NSString *)index images:(NSMutableArray *)images {
    NSLog(@"%@",index);
    ImageReviewViewController *showImage = [[ImageReviewViewController alloc]init];
    showImage.imageArray = images;
    showImage.currentIndex = [NSString stringWithFormat:@"%@",index];
    showImage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:showImage animated:YES completion:nil];
}

- (void)saveSuccessClick {
    [self setUp];
}


@end
