//
//  XLBMyInfoShowHeaderView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//
#import "UIImage+Util.h"
#import "XLBMyInfoShowHeaderView.h"
#import "XLBDEvaluateView.h"
#import "XLBMyInfoCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface XLBMyInfoShowHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XLBUser *user;
@property (nonatomic, strong) UIView *temp_bottom_line_one;
@property (nonatomic, strong) XLBDEvaluateView *evaluateView;
@property (nonatomic, strong) NSMutableArray *showImageArr;

@end

@implementation XLBMyInfoShowHeaderView

- (id)initWithFrame:(CGRect)frame user:(XLBUser *)user{
    self = [super initWithFrame:frame];
    if (self) {
        self.user = user;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    kWeakSelf(self);
//    CGFloat evaluate_view_height = 40.0f*kiphone6_ScreenHeight;
    UIView *bottom_line_one = [[UIView alloc] init];
    bottom_line_one.backgroundColor = RGB(244, 244, 244);
    [self addSubview:bottom_line_one];
    [bottom_line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    self.temp_bottom_line_one = bottom_line_one;

    XLBDEvaluateView *evaluate_view = [XLBDEvaluateView new];
    [evaluate_view setFont:11];
    [evaluate_view setlHeight:18];
    [evaluate_view setLwidth:15];
    [evaluate_view setRadius:3];
    [evaluate_view insertSign:self.user.userModel.tags];
    evaluate_view.backgroundColor = [UIColor whiteColor];
    [self addSubview:evaluate_view];
    [evaluate_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.imageCollectionView.mas_bottom).with.offset(2);
        make.height.mas_equalTo(15);
//        make.bottom.mas_equalTo(bottom_line_one.mas_top).mas_offset(-10);
    }];
    
    self.evaluateView = evaluate_view;
    [self showImageArr];
    [self imageCollectionView];
}

- (UICollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        CGFloat itemWidth = (kSCREEN_WIDTH - 20) / 4;
        CGFloat image_bg_view_height = itemWidth * 2 + 15;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.sectionInset = UIEdgeInsetsMake(3, 4, 3, 4);
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        CGFloat height = 0;
        if (self.user.userModel.pick.count > 4) {
            height = image_bg_view_height;
        }else {
            height = itemWidth + 10;
        }
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height) collectionViewLayout:layout];
        
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        
        [self addSubview:_imageCollectionView];
        [_imageCollectionView registerNib:[UINib nibWithNibName:@"XLBMyInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XLBMyInfoCollectionViewCell"];
    }
    return _imageCollectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.user.userModel.pick.count > 8) {
        return 8;
    }
    return self.user.userModel.pick.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBMyInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLBMyInfoCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.addBtn.hidden = YES;
    cell.checkBtn.tag = indexPath.row;
    [cell.checkBtn setTitle:@"" forState:UIControlStateNormal];
    [cell.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    if (indexPath.row == 0) {
//        [cell.checkBtn setTitle:@"头像" forState:UIControlStateNormal];
//        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.user.userModel.img Withtype:IMGAvatar]] placeholderImage:nil];
//    }else {
        NSDictionary *picks = [self.user.userModel.pick objectAtIndex:indexPath.row];
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:picks[@"picks"] Withtype:IMGAvatar]] placeholderImage:nil];
//    }
    return cell;
}

- (void)updateUser:(XLBUser *)user {
    self.user = [XLBUser user];
    [self.imageCollectionView reloadData];
    [self layoutIfNeeded];
}


- (NSMutableArray *)showImageArr {
    if (!_showImageArr) {
        _showImageArr = [NSMutableArray arrayWithObjects:@{@"id":self.user.userModel.ID,@"picks":self.user.userModel.img,@"isUser":@"YES",}, nil];
        [self.showImageArr insertObjects:self.user.userModel.pick atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.user.userModel.pick.count)]];
    }
    return _showImageArr;
}

- (void)checkBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(imageShowWithIndex:images:)]) {
        NSString *current = [NSString stringWithFormat:@"%d",sender.tag];
        [self.delegate imageShowWithIndex:current images:(NSMutableArray *)self.user.userModel.pick];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
