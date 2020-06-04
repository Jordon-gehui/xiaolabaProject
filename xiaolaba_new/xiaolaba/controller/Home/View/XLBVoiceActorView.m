//
//  XLBVoiceActorView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//


#import "VoiceActorCollectionViewCell.h"
#import "OwnerRequestManager.h"
#import "XLBVoiceActorView.h"
#import "VoiceCallView.h"
#import "XLBErrorView.h"

@interface XLBVoiceActorView ()<UICollectionViewDelegate,UICollectionViewDataSource,XLBErrorViewDelegate>
{
    NSInteger curr;
    NSString *sex;
    BOOL isChange;
}

@property (nonatomic, strong) VoiceCallView *callView;
@property (nonatomic, strong)XLBErrorView *errorV;

@end

@implementation XLBVoiceActorView

- (id)init {
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    NSDictionary *parar = @{@"page":@{@"curr":@(curr),@"size":@(20)}};
    [OwnerRequestManager requestVoiceActorDataParams:parar success:^(NSArray *models) {
        if (models.count == 0 && curr == 1) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [self.data removeAllObjects];
            [self.collectionV.mj_header endRefreshing];
            [self.collectionV.mj_footer endRefreshing];
            [self.collectionV reloadData];
        }else {
            self.errorV.hidden = YES;
            [self.collectionV.mj_header endRefreshing];
            [self.collectionV.mj_footer endRefreshing];
            if (curr == 1) {
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:models];
            [self.collectionV reloadData];
            if (models.count<20) {
                [self.collectionV.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSString *error) {
        self.errorV.hidden = NO;
        [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
        [self.data removeAllObjects];
        [self.collectionV reloadData];
        [self.collectionV.mj_header endRefreshing];
        [self.collectionV.mj_footer endRefreshing];
    } more:^(BOOL more) {
        
    } total:^(int total) {
        
    }];
}

#pragma mark - collectionV 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VoiceActorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VoiceActorCollectionViewCell voiceActorID] forIndexPath:indexPath];
    if (!cell) {
        cell = [[VoiceActorCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    cell.model = self.data[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        if ([self.delegate respondsToSelector:@selector(voiceActorNotLogin)]) {
            [self.delegate voiceActorNotLogin];
        }
        return;
    }
    VoiceActorListModel *model = self.data[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(voiceActorSeletedItemWithVoiceActorModel:)]) {
        [self.delegate voiceActorSeletedItemWithVoiceActorModel:model];
    }
}
- (VoiceCallView *)callView {
    if (!_callView) {
        _callView = [[VoiceCallView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    }
    return _callView;
}
- (void)setSubViews {
    UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (kSCREEN_WIDTH-45)/2;
    folwLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 100);
    folwLayout.minimumLineSpacing = 10;
    folwLayout.minimumInteritemSpacing = 10;
    folwLayout.sectionInset = UIEdgeInsetsMake(15, 17, 10, 17);
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) collectionViewLayout:folwLayout];
    [self.collectionV registerClass:[VoiceActorCollectionViewCell class] forCellWithReuseIdentifier:[VoiceActorCollectionViewCell voiceActorID]];
    self.collectionV.mj_header = [XLBRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.collectionV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadAllData];
    }];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor viewBackColor];
    [self addSubview:self.collectionV];
}


- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, -50, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.collectionV addSubview:_errorV];
    }
    return _errorV;
}
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (void)errorViewTap {
    //    [self requestData:YES];
    //    self.page = 0;
    //    [self getData];
}
- (void)layoutSubviews {
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
    }];
}
@end
