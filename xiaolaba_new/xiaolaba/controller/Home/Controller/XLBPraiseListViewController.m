//
//  XLBPraiseListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBPraiseListViewController.h"
#import "XLBPraseListCollectionViewCell.h"
#import "XLBMeRequestModel.h"
#import "XLBErrorView.h"
@interface XLBPraiseListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XLBPraseListCollectionViewCellDelegate,XLBErrorViewDelegate>

{
    NSInteger _curr;            // 请求起始点
    NSInteger _size;            // 一页数据量
    BOOL _hasMore;               // 是否还有更多
}
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSoure;
@property (nonatomic, strong) XLBErrorView *errorV;

@end

@implementation XLBPraiseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"点赞用户";
    self.naviBar.slTitleLabel.text = @"点赞用户";
    _curr = 1;
    [self getData];
//    [self collectionView];
}

- (void)loadData {
    _curr = 1;
    [self.dataSoure removeAllObjects];
    [self getData];
}

- (void)loadAllData {
    _curr++;
    [self getData];
}

- (void)getData {
    
    kWeakSelf(self);
    NSDictionary *dict = @{@"id":self.createUser,@"createUser":self.momentId,@"page":@{@"curr":@(_curr),
                                                       @"size":@(30)}};
    [XLBMeRequestModel requestPraiseListParams:dict success:^(NSArray *models) {
        if (_curr == 1 && models.count==0) {
            weakSelf.errorV.hidden = NO;
            [weakSelf.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [weakSelf.dataSoure removeAllObjects];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView reloadData];
        }else {
            weakSelf.errorV.hidden = YES;
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            if (_curr == 1) {
                [weakSelf.dataSoure removeAllObjects];
            }
            [weakSelf.dataSoure addObjectsFromArray:models];
            [weakSelf.collectionView reloadData];
            if (models.count<10) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSString *error) {
        [weakSelf.dataSoure removeAllObjects];
        weakSelf.errorV.hidden = NO;
        [weakSelf.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    } more:^(BOOL more) {
        _hasMore = more;
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSoure.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBPraseListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[XLBPraseListCollectionViewCell praiseCellID] forIndexPath:indexPath];
    if (!cell) {
        cell = [[XLBPraseListCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    cell.delegate = self;
    cell.model = self.dataSoure[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PraiseListModel *model = self.dataSoure[indexPath.item];
    if (kNotNil(model.userID)) {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":model.userID,@"delFlag":@0,} hideBar:YES];
    }
}
- (void)checkUserImgWithImg:(UIImage *)img {
    if (kNotNil(img)) {
        NSArray *array = [NSArray arrayWithObject:img];
        ImageReviewViewController *vc = [[ImageReviewViewController alloc]init];
        vc.imageArray = (NSMutableArray *)array;
        vc.currentIndex = @"0";
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kSCREEN_WIDTH-45)/2;
        folwLayout.itemSize = CGSizeMake(itemWidth, itemWidth+100);
        folwLayout.minimumLineSpacing = 10;
        folwLayout.minimumInteritemSpacing = 10;
        folwLayout.sectionInset = UIEdgeInsetsMake(15, 17, 10, 17);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom) collectionViewLayout:folwLayout];
        
        [_collectionView registerClass:[XLBPraseListCollectionViewCell class] forCellWithReuseIdentifier:[XLBPraseListCollectionViewCell praiseCellID]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor viewBackColor];
        _collectionView.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
        _collectionView.mj_footer = [XLBRefreshFooter footerWithRefreshingBlock:^{
            [self loadAllData];
        }];
        [self.view addSubview:_collectionView];
    }
    return  _collectionView;
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.collectionView addSubview:_errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
    //    [self requestData:YES];
    //    self.page = 0;
    //    [self getData];
}

- (NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
