//
//  XLBFaceView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/23.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBFaceView.h"
#import "XLBFaceCollectionCell.h"
#import "OwnerRequestManager.h"
#import "XLBErrorView.h"
typedef NS_ENUM(NSInteger,FaceViewBtnTag) {
    FaceViewManBtnTag,
    FaceViewWomanBtnTag,
    FaceViewChangeBtnTag,
    FaceViewShowBtnTag
};

static int manTotal = 1;
static int womanTotal = 1;

@interface XLBFaceView()<UICollectionViewDelegate,UICollectionViewDataSource,XLBFaceCollectionCellDelegate,XLBErrorViewDelegate>
{
    NSInteger curr;
    NSString *sex;
    BOOL isChange;
}
@property (nonatomic, strong)UIView *topV;
@property (nonatomic, strong)XLBErrorView *errorV;
@end

@implementation XLBFaceView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor viewBackColor];
        [self setSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor viewBackColor];
        sex = @"0";
        [self setSubViews];
    }
    return self;
}


- (void)loadData {
    curr = 1;
    [self getData];
}

- (void)loadAllData {
    curr++;
    [self getData];
}

- (void)getData {
    NSDictionary *params;
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        params = @{@"userId":@"",@"sex":sex,@"page":@{@"curr":@(curr),@"size":@(20)},};

    }else {
        params = @{@"userId":[XLBUser user].userModel.ID,@"sex":sex,@"page":@{@"curr":@(curr),@"size":@(20)},};
    }

    [OwnerRequestManager requestFaceParams:params success:^(NSArray *models) {
        
        if (models.count == 0 && curr == 1) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [self.data removeAllObjects];
            [self.faceCollection.mj_header endRefreshing];
            [self.faceCollection.mj_footer endRefreshing];
            [self.faceCollection reloadData];
        }else {
            self.errorV.hidden = YES;
            [self.faceCollection.mj_header endRefreshing];
            [self.faceCollection.mj_footer endRefreshing];
            if (curr == 1) {
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:models];
            [self.faceCollection reloadData];
            if (models.count<20) {
                [self.faceCollection.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSString *error) {
        self.errorV.hidden = NO;
        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [self.data removeAllObjects];
        [self.faceCollection reloadData];
        [self.faceCollection.mj_header endRefreshing];
        [self.faceCollection.mj_footer endRefreshing];
        
    } more:^(BOOL more) {
        
    } total:^(int total) {
        if ([sex isEqualToString:@"1"]) {
            manTotal = total;
        }else {
            womanTotal = total;
        }
    }];
}
#pragma mark - collectionV 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBFaceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[XLBFaceCollectionCell faceCollectionCellID] forIndexPath:indexPath];
    if (!cell) {
        cell = [[XLBFaceCollectionCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    cell.model = self.data[indexPath.item];
    cell.index = indexPath.item;
    cell.delegate = self;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        if ([self.delegate respondsToSelector:@selector(notLogin)]) {
            [self.delegate notLogin];
        }
        return;
    }
    FaceListModel *model = self.data[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(seletedItemWithFaceModel:)]) {
        [self.delegate seletedItemWithFaceModel:model];
    }
}

- (void)seletedItemWithFaceModel:(FaceListModel *)faceModel index:(NSInteger)index {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        if ([self.delegate respondsToSelector:@selector(notLogin)]) {
            [self.delegate notLogin];
        }
        return;
    }
    FaceListModel *model = self.data[index];
    if ([model.userID isEqualToString:faceModel.userID]) {
        if ([model.liked isEqualToString:@"0"]) {
            [[NetWorking network] POST:kAddLiked params:@{@"likeUser":model.userID,} cache:NO success:^(id result) {
                model.likeSum = [NSString stringWithFormat:@"%li",[model.likeSum integerValue] + 1];
                model.liked = @"1";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"praiseChange" object:nil];
                [self.faceCollection reloadData];
            } failure:^(NSString *description) {
                [MBProgressHUD showError:description];
            }];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.4 animations:^{
        if (iPhoneX) {
            self.showFaceBtn.bottom = kSCREEN_HEIGHT - 175;
        }else {
            self.showFaceBtn.bottom = kSCREEN_HEIGHT - 110;
        }
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
    [UIView animateWithDuration:0.4 animations:^{
        if (iPhoneX) {
            self.showFaceBtn.bottom = kSCREEN_HEIGHT + 175;
        }else {
            self.showFaceBtn.bottom = kSCREEN_HEIGHT + 110;
        }
        
    }];
    
}

- (void)setSubViews {
    
    self.topV = [UIView new];
    self.topV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topV];
    
    self.manBtn = [UIButton new];
    self.manBtn.layer.cornerRadius = 11;
    self.manBtn.layer.masksToBounds = YES;
    self.manBtn.layer.borderWidth = 0.5;
    self.manBtn.tag = FaceViewManBtnTag;
    [self.manBtn setTitle:@"男" forState:0];
    self.manBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.manBtn setTitleColor:[UIColor textBlackColor] forState:0];
    self.manBtn.layer.borderColor = [UIColor textBlackColor].CGColor;
    self.manBtn.backgroundColor = [UIColor clearColor];
    [self.manBtn addTarget:self action:@selector(faceViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.manBtn];
    
    self.womanBtn = [UIButton new];
    self.womanBtn.tag = FaceViewWomanBtnTag;
    self.womanBtn.layer.cornerRadius = 11;
    self.womanBtn.layer.masksToBounds = YES;
    self.womanBtn.layer.borderWidth = 0.5;
    self.womanBtn.layer.borderColor = [UIColor textBlackColor].CGColor;
    [self.womanBtn setTitle:@"女" forState:0];
    self.womanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.womanBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.womanBtn.backgroundColor = [UIColor mainColor];
    [self.womanBtn addTarget:self action:@selector(faceViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.womanBtn];
    
    self.changeBtn = [UIButton new];
    self.changeBtn.tag = FaceViewChangeBtnTag;
    [self.changeBtn setTitle:@" 换一换" forState:0];
    [self.changeBtn setImage:[UIImage imageNamed:@"icon_cx"] forState:0];
    self.changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.changeBtn setTitleColor:RGB(132, 196, 245) forState:0];
    [self.changeBtn addTarget:self action:@selector(faceViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.changeBtn];
    
    UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (kSCREEN_WIDTH-45)/2;
    folwLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 70);
    folwLayout.minimumLineSpacing = 10;
    folwLayout.minimumInteritemSpacing = 10;
    folwLayout.sectionInset = UIEdgeInsetsMake(15, 17, 10, 17);
    self.faceCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) collectionViewLayout:folwLayout];
    [self.faceCollection registerClass:[XLBFaceCollectionCell class] forCellWithReuseIdentifier:[XLBFaceCollectionCell faceCollectionCellID]];
    self.faceCollection.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.faceCollection.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
        [self loadAllData];
    }];
    self.faceCollection.delegate = self;
    self.faceCollection.dataSource = self;
    self.faceCollection.showsVerticalScrollIndicator = NO;
    self.faceCollection.backgroundColor = [UIColor viewBackColor];
    [self addSubview:self.faceCollection];
    
    self.showFaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 175, 38)];
    self.showFaceBtn.tag = FaceViewShowBtnTag;
//    self.showFaceBtn.layer.masksToBounds = YES;
//    self.showFaceBtn.layer.cornerRadius = 19;
    [self.showFaceBtn setTitle:@"我要秀点赞" forState:0];
    [self.showFaceBtn setTitleColor:[UIColor lightColor] forState:0];
    self.showFaceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.showFaceBtn setBackgroundImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
    [self.showFaceBtn setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];

    [self.showFaceBtn addTarget:self action:@selector(faceViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showFaceBtn];
}

- (void)faceViewBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case FaceViewManBtnTag: {
            self.manBtn.backgroundColor = [UIColor mainColor];
            [self.manBtn setTitleColor:[UIColor whiteColor] forState:0];
            self.womanBtn.backgroundColor = [UIColor clearColor];
            [self.womanBtn setTitleColor:[UIColor textBlackColor] forState:0];
            sex = @"1";
            [self.faceCollection.mj_header beginRefreshing];
        }
            break;
        case FaceViewWomanBtnTag: {
            self.manBtn.backgroundColor = [UIColor clearColor];
            [self.manBtn setTitleColor:[UIColor textBlackColor] forState:0];
            self.womanBtn.backgroundColor = [UIColor mainColor];
            [self.womanBtn setTitleColor:[UIColor whiteColor] forState:0];
            sex = @"0";
            [self.faceCollection.mj_header beginRefreshing];
        }
            break;
        case FaceViewChangeBtnTag: {
            isChange = YES;
            NSLog(@"%d %d",manTotal,womanTotal);
            if ([sex isEqualToString:@"1"]) {
                if (manTotal < 2) return;
                curr = 1 + (arc4random() % manTotal);
            }
            if ([sex isEqualToString:@"0"]) {
                if (womanTotal < 2) return;
                curr = 1 + (arc4random() % womanTotal);
            }
            [self.data removeAllObjects];
            [self getData];
        }
            break;
        case FaceViewShowBtnTag: {
            if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
                if ([self.delegate respondsToSelector:@selector(notLogin)]) {
                    [self.delegate notLogin];
                }
                return;
            }
            if ([self.delegate respondsToSelector:@selector(showBtnClick)]) {
                [self.delegate showBtnClick];
            }
        }
            break;
            
        default:
            break;
    }
}
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, -50, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.faceCollection addSubview:_errorV];
    }
    return _errorV;
}
- (void)errorViewTap {
    //    [self requestData:YES];
    //    self.page = 0;
    //    [self getData];
}
- (void)layoutSubviews {
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topV.mas_left).with.offset(25);
        make.centerY.mas_equalTo(self.topV.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(50);
    }];
    
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.manBtn);
        make.left.mas_equalTo(self.manBtn.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.manBtn.mas_centerY);
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topV.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(self.topV.mas_centerY);
    }];
    
    [self.showFaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(53);
        make.centerX.mas_equalTo(self.mas_centerX);
        if (iPhoneX) {
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-95);
        }else {
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(-50);
        }
    }];
    
    [self.faceCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topV.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
}
@end
