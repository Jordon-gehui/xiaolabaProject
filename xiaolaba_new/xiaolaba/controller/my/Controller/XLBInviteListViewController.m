//
//  XLBInviteListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/28.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteListViewController.h"
#import "XLBInviteTableViewCell.h"
#import "XLBErrorView.h"
#import "XLBMeRequestModel.h"
@interface XLBInviteListViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UILabel *invitationCode;
@property (nonatomic, strong) UIImageView *imgLine;
@property (nonatomic, strong) UITableView *meTable;
@property (nonatomic, strong) UIView *tableBgV;
@property (nonatomic, strong) UIImageView *topImg;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIScrollView *scrollV;

@property (nonatomic, strong) XLBErrorView *errorV;

@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation XLBInviteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    self.naviBar.slTitleLabel.text = @"邀请好友";
    [self setSubViews];
    [self loadData];
}

- (void)loadData {
    NSDictionary *params = @{@"page":@{@"curr":@(0),
                                       @"size":@(50)}};
    [XLBMeRequestModel requsetInviteFriendsParams:params success:^(NSArray<XLBInviteModel *> *models) {
        if (models.count == 0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [self.data removeAllObjects];
            [self.meTable.mj_header endRefreshing];
            [self.meTable reloadData];
        }else {
            self.errorV.hidden = YES;
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:models];
            [self.meTable.mj_header endRefreshing];
            [self.meTable reloadData];
        }
    } failure:^(NSString *error) {
        self.errorV.hidden = NO;
        [self.data removeAllObjects];
        [self.meTable reloadData];
        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [self.meTable.mj_header endRefreshing];
    } more:^(BOOL more) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[XLBInviteTableViewCell inviteCellID]];

    if (!cell) {
        cell = [[XLBInviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XLBInviteTableViewCell inviteCellID]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ranking.text = [NSString stringWithFormat:@"%li",indexPath.row+1];
    cell.model = [self dateWithDateArr:self.data][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBInviteModel *model = [self dateWithDateArr:self.data][indexPath.row];
    NSLog(@"%@",model.userId);
    [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":model.inviId,@"delFlag":@0,} hideBar:YES];
}

- (void)nextBtnClick:(UIButton *)sender {
    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:10 inSection:0];
//    [_meTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)setSubViews {
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIImageView *bgImg = [UIImageView new];
    bgImg.image = [UIImage imageNamed:@"bg_yq"];
    [self.view addSubview:bgImg];
    
    _scrollV = [[UIScrollView alloc] init];
    _scrollV.pagingEnabled = NO;
    _scrollV.showsHorizontalScrollIndicator = YES;
    if (iPhone5s) {
        _scrollV.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }else {
        _scrollV.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
    }
    [self.view addSubview:_scrollV];
    
    _topV = [UIView new];
    _topV.backgroundColor = [UIColor whiteColor];
    _topV.layer.masksToBounds = YES;
    _topV.layer.cornerRadius = 20;
    [_scrollV addSubview:_topV];
    
    UILabel *label = [UILabel new];
    label.text = @"专属邀请码";
    label.textColor = [UIColor commonTextColor];
    if (iPhone5s) {
        label.font = [UIFont systemFontOfSize:13];
    }else {
        label.font = [UIFont systemFontOfSize:15];
    }
    label.textAlignment = NSTextAlignmentCenter;
    [_topV addSubview:label];
    
    
    _imgLine = [UIImageView new];
    _imgLine.image = [UIImage imageNamed:@"pic_fgx_l"];
    [_topV addSubview:_imgLine];
    
    UILabel *circle = [UILabel new];
    circle.backgroundColor = [UIColor lightColor];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 5;
    [_topV addSubview:circle];
    
    UILabel *circleTwo = [UILabel new];
    circleTwo.backgroundColor = [UIColor lightColor];
    circleTwo.layer.masksToBounds = YES;
    circleTwo.layer.cornerRadius = 5;
    [_topV addSubview:circleTwo];
    
    _invitationCode = [UILabel new];
    
    _invitationCode.textColor = [UIColor commonTextColor];
    _invitationCode.text = _uicode;
    if (iPhone5s) {
        _invitationCode.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
    }else {
        _invitationCode.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    }
    _invitationCode.textAlignment = NSTextAlignmentCenter;
    [_topV addSubview:_invitationCode];
    
    _tableBgV = [UIView new];
    _tableBgV.layer.masksToBounds = YES;
    _tableBgV.layer.cornerRadius = 20;
    _tableBgV.backgroundColor = [UIColor whiteColor];
    [_scrollV addSubview:_tableBgV];
    
    _topImg = [UIImageView new];
//    if (_isRanking == YES) {
//    _topImg.image = [UIImage imageNamed:@"pic_wz_pm"];
//    }else {

//    }
    _topImg.image = [UIImage imageNamed:@"pic_wz_yq"];
    [_tableBgV addSubview:_topImg];
    
    _nextBtn = [UIButton new];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"icon_xl"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tableBgV addSubview:_nextBtn];
    
    _meTable = [[UITableView alloc] initWithFrame:CGRectMake(18, 10, 100, 100) style:UITableViewStyleGrouped];
    _meTable.dataSource = self;
    _meTable.delegate = self;
    _meTable.showsVerticalScrollIndicator = NO;
    _meTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (IOS11Later == YES) {
        _meTable.estimatedSectionHeaderHeight = 0.0001;
    }
    _meTable.backgroundColor = [UIColor whiteColor];
    _meTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _meTable.estimatedRowHeight = 60;
    _meTable.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [_tableBgV addSubview:_meTable];
    
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [_scrollV addSubview:contentLabel];
    
    
    NSString *string = @"邀请规则：\n1.您的专属邀请码只属于您个人；\n2.好友在身边，随手下载小喇叭，完成注册输入邀请码后，您和好友均能获取3车币；\n3.好友不在身边？只需手指点一下，将小喇叭邀请链接或者截图发送到朋友圈，共邀好友前来下载。";
    // Adjust the spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.f;
    paragraphStyle.alignment = contentLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(5, string.length - 5)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(5, string.length - 5)];
    
    contentLabel.attributedText = attributedString;
    
    
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);

        make.left.right.bottom.mas_equalTo(self.view).with.offset(0);
    }];
    
    [_scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSCREEN_WIDTH);
        make.height.mas_equalTo(kSCREEN_HEIGHT - 64);
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(0);

        
    }];
    
    [_topV mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (iPhoneX) {
//            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(32);
//        }else {
//            make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(10);
//        }
        make.top.mas_equalTo(_scrollV.mas_top).with.offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        if (iPhoneX) {
            make.height.mas_equalTo(70*kiphone6_ScreenHeight);
        }else {
            make.height.mas_equalTo(80*kiphone6_ScreenHeight);
        }
        make.width.mas_equalTo(180*kiphone6_ScreenWidth);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone5s) {
            make.top.mas_equalTo(self.topV.mas_top).with.offset(5);
        }else {
            make.top.mas_equalTo(self.topV.mas_top).with.offset(10);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
    [_imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone5s) {
            make.top.mas_equalTo(label.mas_bottom).with.offset(5);
        }else {
            make.top.mas_equalTo(label.mas_bottom).with.offset(10);
        }
        make.left.mas_equalTo(circle.mas_right).with.offset(5);
        make.right.mas_equalTo(circleTwo.mas_left).with.offset(-5);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(_topV.mas_centerX);
    }];
    
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topV.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(_imgLine.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
    
    [circleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_topV.mas_right).with.offset(5);
        make.width.height.mas_equalTo(circle);
        make.centerY.mas_equalTo(_imgLine.mas_centerY);

    }];
    
    [_invitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_imgLine.mas_bottom).with.offset(5);
        make.left.right.mas_equalTo(0);
    }];
    
    [_tableBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topV.mas_bottom).with.offset(12*kiphone6_ScreenHeight);
        make.width.mas_equalTo(300*kiphone6_ScreenWidth);
        make.height.mas_equalTo(335*kiphone6_ScreenHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableBgV.mas_top).with.offset(10);
        make.centerX.mas_equalTo(_tableBgV.mas_centerX);
        make.height.mas_equalTo(16);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_tableBgV.mas_centerX);
        make.height.mas_equalTo(10*kiphone6_ScreenHeight);
        make.bottom.mas_equalTo(_tableBgV.mas_bottom).with.offset(-10);
    }];
    [_meTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topImg.mas_bottom).with.offset(10);
        make.left.mas_equalTo(_tableBgV).with.offset(18);
        make.right.mas_equalTo(_tableBgV).with.offset(-18);
        make.bottom.mas_equalTo(_nextBtn.mas_top).with.offset(-10);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableBgV.mas_bottom).with.offset(20*kiphone6_ScreenHeight);
        make.left.mas_equalTo(_meTable.mas_left);
        make.right.mas_equalTo(_meTable.mas_right);
//        if (iPhone5s) {
//            make.height.mas_equalTo(200);
//        }
    }];
    
}

- (NSArray *)dateWithDateArr:(NSArray *)dateArr{
    
    NSArray *sortArray = (NSMutableArray *)[dateArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        XLBInviteModel *model1 = obj1;
        XLBInviteModel *model2 = obj2;
        
        if ([model1.createDate integerValue] > [model2.createDate integerValue]) {
            return NSOrderedDescending;
        }else {
            return NSOrderedAscending;
        }
    }];
    return sortArray;
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, _meTable.size.width, _meTable.size.height)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.meTable addSubview:_errorV];
    }
    return _errorV;
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
