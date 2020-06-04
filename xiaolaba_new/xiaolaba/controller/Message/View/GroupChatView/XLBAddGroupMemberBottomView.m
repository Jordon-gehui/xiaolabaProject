//
//  XLBAddGroupMemberBottomView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBAddGroupMemberBottomView.h"
#import "XLBAddGroupMemberCollectionViewCell.h"
@interface XLBAddGroupMemberBottomView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSMutableArray *dataSoure;
@end

@implementation XLBAddGroupMemberBottomView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self addSubview:self.line];
    
    self.certainBtn = [UIButton new];
    self.certainBtn.backgroundColor = [UIColor textBlackColor];
    [self.certainBtn setTitle:@"确认" forState:0];
    self.certainBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.certainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.certainBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self addSubview:self.certainBtn];
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.sectionInset = UIEdgeInsetsMake(3, 4, 3, 4);
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64) collectionViewLayout:layout];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.showsHorizontalScrollIndicator = NO;
    [_collectionV registerClass:[XLBAddGroupMemberCollectionViewCell class] forCellWithReuseIdentifier:[XLBAddGroupMemberCollectionViewCell addGroupCollectionCellID]];
    [self addSubview:_collectionV];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(self.height);
    }];
    
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom).with.offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.certainBtn.mas_left).with.offset(-5);
        make.height.mas_equalTo(64);
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    [self.dataSoure removeAllObjects];
    for (int i = 0; i < self.data.count; i++) {
        NSString *value = [self.dict objectForKey:self.data[i]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:value forKey:self.data[i]];
        [self.dataSoure addObject:dict];
    }
    return self.dataSoure.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBAddGroupMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[XLBAddGroupMemberCollectionViewCell addGroupCollectionCellID] forIndexPath:indexPath];
    
//    NSString *img = self.dict[[self.dict.allKeys objectAtIndex:indexPath.item]];
    NSString *img = [[self.dataSoure objectAtIndex:indexPath.item] objectForKey:self.data[indexPath.item]];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];

    return cell;
}




- (NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray array];
    }
    return _dataSoure;
}



@end
