//
//  XLBFaceWallView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBFaceWallView.h"
#import "XLBFaceWallTableViewCell.h"
#import "XLBNotLoginView.h"
#import "OwnerRequestManager.h"
#import "XLBFaceNotDataView.h"
@interface XLBFaceWallView ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isFollow;//日榜关注
    BOOL allIsFollow;//总榜关注
    BOOL isRank;//总榜，日榜 0 日榜。1 总榜
//    BOOL isLogin; // 是否登录
}

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *bgImg;
@property (nonatomic, strong)UIImageView *bgImgV;
@property (nonatomic, strong)UIView *headV;
@property (nonatomic, strong)UISegmentedControl *segmentedCon;
@property (nonatomic, strong)UIImageView *userBgImg;
@property (nonatomic, strong)UIImageView *userImg;
@property (nonatomic, strong)UIButton *userBtn;
@property (nonatomic, strong)UILabel *nickName;
@property (nonatomic, strong)UIImageView *attentionImg;
@property (nonatomic, strong)UILabel *attentionCountLabel;
@property (nonatomic, strong)XLBNotLoginView *notV;
@property (nonatomic, strong)NSMutableArray *dayData;
@property (nonatomic, strong)NSMutableArray *allData;

@property (nonatomic, strong)XLBFaceNotDataView *notDataV;
@property (nonatomic, strong)FaceWallListModel *allFirstModel;
@property (nonatomic, strong)FaceWallListModel *dayFirstModel;


@property (nonatomic, assign)NSInteger isSY;
@end

@implementation XLBFaceWallView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
//        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//            [self notV];
//        }else {
            _isSY = type;
            [self bgView];
            isRank = YES;
//            isLogin = YES;
            [self loadAllData];
//        }
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
//            [self notV];
//        }else {
//            [self bgView];
//            isRank = YES;
//            isLogin = YES;
//            [self loadAllData];
//        }
//    }
//    return self;
//}

- (void)setFaceTableViewWithsource:(NSInteger)is_sy {
//    [self.notV setHidden:YES];
    [self.bgView setHidden:NO];
    self.segmentedCon.selectedSegmentIndex = 1;
    isRank = YES;
//    isLogin = YES;
    _isSY = is_sy;
    [self loadAllData];
}
- (void)loginOut {
//    [self.bgView setHidden:YES];
//    [self.notV setHidden:NO];
//    isLogin = NO;
}

- (void)loadRequestData {
//    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) return;
    if (isRank == NO) {
        [self loadDayData];
    }else {
        [self loadAllData];
    }
}
- (void)loadDayData {
//    isLogin = NO;
    [OwnerRequestManager requestFaceWallDayDataParams:nil isSY:_isSY success:^(NSArray *models) {
        if (!kNotNil(models) || models.count == 0) {
            [self.tableV.mj_header endRefreshing];
            self.notDataV.hidden = NO;
            [self.dayData removeAllObjects];
            _dayFirstModel = nil;
            [self.tableV reloadData];
        }else {
            [self.dayData removeAllObjects];
            [self.tableV.mj_header endRefreshing];
            if (kNotNil(models) && models.count != 0) {
                if (_isSY == 1) {
                    NSMutableArray *modelss = [NSMutableArray arrayWithArray:models];
                    FaceWallListModel *model = [models firstObject];
                    _dayFirstModel = model;
                    [modelss removeObjectAtIndex:0];
                    [self.dayData addObjectsFromArray:modelss];
                }else {
                    [models enumerateObjectsUsingBlock:^(FaceWallListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.ranking isEqualToString:@"1"]) {
                            _dayFirstModel = obj;
                            self.attentionCountLabel.text = _dayFirstModel.likeSum;
                        }else {
                            [self.dayData addObject:obj];
                        }
                    }];
                }
                self.nickName.text = _dayFirstModel.nickname;
                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_dayFirstModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                [self.bgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_dayFirstModel.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                if ([_dayFirstModel.follows isEqualToString:@"0"]) {
                    [self.attentionBtn setTitle:@"+ 关注" forState:0];
                    isFollow = NO;
                }
                if ([_dayFirstModel.follows isEqualToString:@"1"]) {
                    [self.attentionBtn setTitle:@"已关注" forState:0];
                    isFollow = YES;
                }
                self.notDataV.hidden = YES;
                [self.tableV reloadData];
            }
        }
       
    } failure:^(NSString *error) {
        self.notDataV.hidden = NO;
        [self.dayData removeAllObjects];
        _dayFirstModel = nil;
        [self.tableV.mj_header endRefreshing];
        [self.tableV reloadData];

    }];
}

- (void)loadAllData {
//    isLogin = NO;
    [OwnerRequestManager requestFaceWallAllDataParams:nil isSY:_isSY success:^(NSArray *models) {
        if (!kNotNil(models) || models.count == 0) {
            [self.allData removeAllObjects];
            self.notDataV.hidden = NO;
            [self.tableV.mj_header endRefreshing];
            _allFirstModel = nil;
            [self.tableV reloadData];
        }else {
            [self.allData removeAllObjects];
            [self.tableV.mj_header endRefreshing];
            if (kNotNil(models) && models.count != 0) {
                FaceWallListModel *firstModel;
                if (_isSY == 1) {
                    NSMutableArray *modelss = [NSMutableArray arrayWithArray:models];
                    [modelss removeObjectAtIndex:0];
                    firstModel = [models firstObject];
                    _allFirstModel = firstModel;
                    [self.allData addObjectsFromArray:modelss];
                }else {
                    [models enumerateObjectsUsingBlock:^(FaceWallListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.ranking isEqualToString:@"1"]) {
                            _allFirstModel = obj;
                            self.attentionCountLabel.text = obj.likeSum;
                        }else {
                            [self.allData addObject:obj];
                        }
                    }];
                }
                self.nickName.text = _allFirstModel.nickname;
                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_allFirstModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                [self.bgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_allFirstModel.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                if ([_allFirstModel.follows isEqualToString:@"0"]) {
                    [self.attentionBtn setTitle:@"+ 关注" forState:0];
                    allIsFollow = NO;
                }
                if ([_allFirstModel.follows isEqualToString:@"1"]) {
                    [self.attentionBtn setTitle:@"已关注" forState:0];
                    allIsFollow = YES;
                }
                self.notDataV.hidden = YES;
                [self.tableV reloadData];
            }
        }
    } failure:^(NSString *error) {
        [self.tableV.mj_header endRefreshing];
        self.notDataV.hidden = NO;
        _allFirstModel = nil;
        [self.allData removeAllObjects];
        [self.tableV reloadData];
    }];
//    [self layoutIfNeeded];
}

- (void)attentionBtnClick:(UIButton *)sender {
    //关注
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [self.delegate loginBtnClick];
        return;
    }

    if (isRank == NO) {
        if (isFollow == YES) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self cancleFollowWithUserID:_dayFirstModel.userId rank:NO];
            }];
            [alert addAction:cancle];
            [alert addAction:creatain];
            [self.viewController presentViewController:alert animated:YES completion:nil];
        }else {
            [self addFollowWithUserID:_dayFirstModel.userId rank:NO];
        }
    }else {
        if (allIsFollow == YES) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self cancleFollowWithUserID:_allFirstModel.userId rank:YES];
            }];
            [alert addAction:cancle];
            [alert addAction:creatain];
            [self.viewController presentViewController:alert animated:YES completion:nil];
        }else {
            [self addFollowWithUserID:_allFirstModel.userId rank:YES];
        }
    }
}

- (void)addFollowWithUserID:(NSString *)userID rank:(BOOL)rank{
    NSDictionary *parameter = @{@"followId":userID,};
    [[NetWorking network] POST:kAddFollow params:parameter cache:NO success:^(id result) {
        [MBProgressHUD showSuccess:@"关注成功"];
        if (rank == NO) {
            isFollow = YES;
            _dayFirstModel.follows = @"1";
        }else {
            allIsFollow = YES;
            _allFirstModel.follows = @"1";
        }
        [self.attentionBtn setTitle:@"已关注" forState:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"关注失败"];
    }];
    
}

- (void)cancleFollowWithUserID:(NSString *)userID rank:(BOOL)rank{
    NSDictionary *parameter = @{@"followId":userID,};
    NSLog(@"%@",parameter);
    [[NetWorking network] POST:kCancleFollow params:parameter cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [MBProgressHUD showSuccess:@"取消成功"];
        if (rank == NO) {
            isFollow = NO;
            _dayFirstModel.follows = @"0";
        }else {
            allIsFollow = NO;
            _allFirstModel.follows = @"0";
        }
        [self.attentionBtn setTitle:@"+ 关注" forState:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"取消失败"];
        
    }];
}


- (void)segmentedConClick:(UISegmentedControl *)segment {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [self.delegate loginBtnClick];
        return;
    }
    if (segment.selectedSegmentIndex == 0) {
        NSLog(@"日榜");
        isRank = NO;
//        if (isLogin == YES) {
            [self loadDayData];
//        }else {
//            if (self.dayData.count == 0 && !kNotNil(_dayFirstModel.userId)) {
//                self.notDataV.hidden = NO;
//                [self.tableV reloadData];
//            }else {
//                self.nickName.text = _dayFirstModel.nickname;
//                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_dayFirstModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
//                [self.bgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_dayFirstModel.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
//                self.attentionCountLabel.text = _dayFirstModel.likeSum;
//                if ([_dayFirstModel.follows isEqualToString:@"0"]) {
//                    [self.attentionBtn setTitle:@"+ 关注" forState:0];
//                }
//                if ([_dayFirstModel.follows isEqualToString:@"1"]) {
//                    [self.attentionBtn setTitle:@"已关注" forState:0];
//                }
//                self.notDataV.hidden = YES;
//                [self.tableV reloadData];
//            }
//        }
        

    }else {
        isRank = YES;
//        if (isLogin == YES) {
//            [self loadAllData];
//        }else {
            if (self.allData.count == 0 && !kNotNil(_allFirstModel.userId)) {
                self.notDataV.hidden = NO;
                [self.tableV reloadData];
            }else {
                self.nickName.text = _allFirstModel.nickname;
                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_allFirstModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                [self.bgImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_allFirstModel.img Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
                self.attentionCountLabel.text = _allFirstModel.likeSum;
                if ([_allFirstModel.follows isEqualToString:@"0"]) {
                    [self.attentionBtn setTitle:@"+ 关注" forState:0];
                    allIsFollow = NO;
                }
                if ([_allFirstModel.follows isEqualToString:@"1"]) {
                    [self.attentionBtn setTitle:@"已关注" forState:0];
                    allIsFollow = YES;
                }
                self.notDataV.hidden = YES;
                [self.tableV reloadData];
            }
            NSLog(@"总榜");
//        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isRank == NO) {
        return self.dayData.count;
    }if (isRank == YES) {
        return self.allData.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLBFaceWallTableViewCell *cell;
    if (_isSY == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:[XLBFaceWallTableViewCell faceWallCellIDVoice]];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:[XLBFaceWallTableViewCell faceWallCellID]];
    }
    if (!cell) {
        if (_isSY == 1) {
            cell = [[XLBFaceWallTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[XLBFaceWallTableViewCell faceWallCellIDVoice]];
        }else {
            cell = [[XLBFaceWallTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[XLBFaceWallTableViewCell faceWallCellID]];
        }
    }
    cell.roundCornerType = CellTypeDefault;

    if (indexPath.row == 0) {
        cell.roundCornerType = CellTypeTop;
    }
    if (isRank == NO) {
        cell.model = self.dayData[indexPath.row];
        if (indexPath.row == self.dayData.count-1) {
            cell.roundCornerType = CellTypeBottom;
        }
        if (indexPath.row == 0 && self.dayData.count == 1) {
            cell.roundCornerType = CellTypeAll;
        }
    }
    if (isRank == YES) {
        cell.model = self.allData[indexPath.row];
        if (indexPath.row == self.allData.count-1) {
            cell.roundCornerType = CellTypeBottom;
        }
        if (indexPath.row == 0 && self.allData.count == 1) {
            cell.roundCornerType = CellTypeAll;
        }
    }
    cell.index = indexPath.row;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [self.delegate loginBtnClick];
        return;
    }
    FaceWallListModel *model;
    if (isRank == NO) {
        model = self.dayData[indexPath.row];
    }
    if (isRank == YES) {
        model = self.allData[indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(seletedRowWithFaceWallModel:rank:)]) {
        if (isRank == NO) {
            [self.delegate seletedRowWithFaceWallModel:model rank:1];
        }else {
            [self.delegate seletedRowWithFaceWallModel:model rank:0];
        }
    }
}

- (void)userBtnClick {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [self.delegate loginBtnClick];
        return;
    }
    if (isRank == NO) {
        if ([self.delegate respondsToSelector:@selector(seletedRowWithFaceWallModel:rank:)]) {
            [self.delegate seletedRowWithFaceWallModel:_dayFirstModel rank:1];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(seletedRowWithFaceWallModel:rank:)]) {
            [self.delegate seletedRowWithFaceWallModel:_allFirstModel rank:0];
        }
    }
}

- (void)setSubViews {
    
    self.bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.bgImg.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImg.layer.masksToBounds = YES;
    [_bgView addSubview:self.bgImg];
    
    self.bgImgV = [UIImageView new];
    self.bgImgV.backgroundColor = [UIColor blackColor];
    self.bgImgV.alpha = 0.5;
    [_bgView addSubview:self.bgImgV];

    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStylePlain];
    if (_isSY == 1) {
        [self.tableV registerClass:[XLBFaceWallTableViewCell class] forCellReuseIdentifier:[XLBFaceWallTableViewCell faceWallCellIDVoice]];
    }else {
        [self.tableV registerClass:[XLBFaceWallTableViewCell class] forCellReuseIdentifier:[XLBFaceWallTableViewCell faceWallCellID]];
    }
    self.tableV.estimatedRowHeight = 100;
    self.tableV.rowHeight = UITableViewAutomaticDimension;
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    self.tableV.backgroundColor = [UIColor clearColor];
    self.tableV.layer.masksToBounds = YES;
    self.tableV.layer.cornerRadius = 10;
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadRequestData];
    }];
    self.tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:self.tableV];
    CGFloat height;
    if (_isSY == 0) {
        height = 230;
    }else {
        height = 180;
    }
    self.headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height)];

    self.headV.backgroundColor = [UIColor clearColor];
    self.tableV.tableHeaderView = self.headV;
    
    self.segmentedCon = [[UISegmentedControl alloc] initWithItems:@[@"日榜",@"总榜",]];
    self.segmentedCon.layer.masksToBounds = YES;
    self.segmentedCon.layer.cornerRadius = 15;
    [self.segmentedCon setSelectedSegmentIndex:1];
    self.segmentedCon.backgroundColor = [UIColor clearColor];
    self.segmentedCon.tintColor= RGBA(255, 255, 255, 0.7);
    self.segmentedCon.layer.borderWidth = 1;
    self.segmentedCon.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.segmentedCon setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    [self.segmentedCon setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.segmentedCon addTarget:self action:@selector(segmentedConClick:) forControlEvents:UIControlEventValueChanged];
    [self.headV addSubview:self.segmentedCon];
    
    self.userBgImg = [UIImageView new];
    self.userBgImg.image = [UIImage imageNamed:@"pic_yzb_g"];
    [self.headV addSubview:self.userBgImg];
    
    self.userImg = [UIImageView new];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 33;
    [self.headV addSubview:self.userImg];
    
    self.userBtn = [UIButton new];
    [self.userBtn addTarget:self action:@selector(userBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headV addSubview:self.userBtn];
    
    self.nickName = [UILabel new];
    self.nickName.font = [UIFont systemFontOfSize:16];
    self.nickName.textColor = [UIColor whiteColor];
    [self.headV addSubview:self.nickName];
    
    if (_isSY == 0) {
        self.attentionImg = [UIImageView new];
        self.attentionImg.image = [UIImage imageNamed:@"icon_gz_m"];
        [self.headV addSubview:self.attentionImg];
        
        self.attentionCountLabel = [UILabel new];
        self.attentionCountLabel.font = [UIFont systemFontOfSize:14];
        self.attentionCountLabel.textColor = [UIColor whiteColor];
        [self.headV addSubview:self.attentionCountLabel];
        
        self.attentionBtn = [UIButton new];
        self.attentionBtn.layer.masksToBounds = YES;
        self.attentionBtn.layer.cornerRadius = 15;
        self.attentionBtn.layer.borderWidth = 0.5;
        self.attentionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.attentionBtn setTitle:@"+ 关注" forState:0];
        [self.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.headV addSubview:self.attentionBtn];
    }
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        [self setSubViews];
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (XLBFaceNotDataView *)notDataV {
    if (!_notDataV) {
        _notDataV = [[XLBFaceNotDataView alloc] initWithFrame:CGRectMake(0, 35, self.tableV.width, self.tableV.height-35)];
        _notDataV.backgroundColor = [UIColor whiteColor];
        _notDataV.layer.masksToBounds = YES;
        _notDataV.layer.cornerRadius = 10;
        _notDataV.hidden = YES;
        [self.tableV addSubview:_notDataV];
    }
    return _notDataV;
}
- (XLBNotLoginView *)notV {
    if (!_notV) {
        _notV = [[XLBNotLoginView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:@"2"];
        [_notV.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_notV];
    }
    return _notV;
}

//- (void)loginBtnClick {
//    if ([self.delegate respondsToSelector:@selector(loginBtnClick)]) {
//        [self.delegate loginBtnClick];
//    }
//}

- (NSMutableArray *)dayData {
    if (!_dayData) {
        _dayData = [NSMutableArray array];
    }
    return _dayData;
}

- (NSMutableArray *)allData {
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        if (iPhoneX) {
            make.bottom.mas_equalTo(-45);
        }else {
            make.bottom.mas_equalTo(-15);
        }
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.segmentedCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headV.mas_centerX);
        make.top.mas_equalTo(self.headV.mas_top).with.offset(0);
        make.width.mas_equalTo(225);
    }];
    
    [self.userBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentedCon.mas_bottom).with.offset(5);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(100);
        make.centerX.mas_equalTo(self.segmentedCon.mas_centerX);
    }];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.userBgImg.mas_centerX);
        make.bottom.mas_equalTo(self.userBgImg.mas_bottom).with.offset(-6);
        make.width.height.mas_equalTo(66);
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.userBgImg);
        make.centerX.mas_equalTo(self.userBgImg.mas_centerX);
        make.centerY.mas_equalTo(self.userBgImg.mas_centerY);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userBgImg.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.userBgImg.mas_centerX);
    }];
    
    if (_isSY == 0) {
        [self.attentionImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_lessThanOrEqualTo(self.nickName.mas_centerX).with.offset(-5);
            make.top.mas_equalTo(self.nickName.mas_bottom).with.offset(5);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.attentionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.attentionImg.mas_centerY);
            make.left.mas_equalTo(self.attentionImg.mas_right).with.offset(5);
            make.height.mas_equalTo(18);
        }];
        [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.attentionImg.mas_bottom).with.offset(5);
            make.centerX.mas_equalTo(self.nickName.mas_centerX);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
        }];
    }
}

@end
