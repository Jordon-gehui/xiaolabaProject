//
//  XLBMyInfoHeaderView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/6.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyInfoHeaderView.h"
#import "XLBDEvaluateView.h"
#import "XLBMyInfoCollectionViewCell.h"
#import "NetWorking.h"
#import <UIImageView+WebCache.h>
#define kMargin 5
#define colCount 4
#define kMax 9

@interface XLBMyInfoHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSIndexPath *_originalIndexPath;
    UIView *_snapshotView;

    NSIndexPath *_moveIndexPath;

}

@property (nonatomic, assign) NSInteger currentUserImageIndex;

@property (nonatomic, strong) UILabel *sublabel;
@property (nonatomic, strong) NSMutableArray *pickArray;
@property (nonatomic, strong) NSMutableArray *saveArray;
@property (nonatomic, strong) NSMutableArray *showImageArray;

@property (nonatomic, strong) XLBUser *user;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UIView *temp_bottom_line_one;
@property (nonatomic, strong) XLBDEvaluateView *evaluateView;
@property (nonatomic, strong) UICollectionView *imageCollectionView;

@end

@implementation XLBMyInfoHeaderView

- (id)initWithFrame:(CGRect)frame user:(XLBUser *)user {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.user = user;
        [self setUpSubViews];
    }
    return self;
}


- (void)setUpSubViews{
    
    [self showImageArray];
    [self pickArray];
    //头像默认值
    self.currentUserImageIndex = 0;
    if ([self.user.userModel.img hasPrefix:@"http://zhangshangxiaolaba.oss"]) {
        self.userImageUrl = [self.user.userModel.img componentsSeparatedByString:@"com/"][1];
    }else {
        self.userImageUrl = self.user.userModel.img;
    }
//    if ([self.user.userModel.img hasPrefix:@"http://wx"]||[self.user.userModel.img hasPrefix:@"https://wx"]||[self.user.userModel.img hasPrefix:@"http://tva3"]||[self.user.userModel.img hasPrefix:@"https://tva3"]) {
//        self.userImageUrl = self.user.userModel.img;
//    }else {
//        self.userImageUrl = [self.user.userModel.img componentsSeparatedByString:@"com/"][1];
//    }
    UIView *bottom_line_one = [[UIView alloc] init];
    bottom_line_one.backgroundColor = RGB(244, 244, 244);
    [self addSubview:bottom_line_one];
    [bottom_line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    self.temp_bottom_line_one = bottom_line_one;
    self.imageCollectionView =  [self imageCollectionView];
    UILabel *tem_bottom_line_label = [[UILabel alloc] init];
    tem_bottom_line_label.text = @"拖拽可更改排序，共八张";
    tem_bottom_line_label.font = [UIFont systemFontOfSize:13];
    tem_bottom_line_label.textColor = [UIColor commonTextColor];
    tem_bottom_line_label.textAlignment = NSTextAlignmentLeft;
    [bottom_line_one addSubview:tem_bottom_line_label];
    
    [tem_bottom_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(20);
        
    }];
    
}


- (NSMutableArray *)pickArray {
    if (!_pickArray) {
        _pickArray = [NSMutableArray arrayWithObjects:@{@"id":@"-1",@"add":@"pic_xj",@"isAdd":@"YES",}, nil];
        [self.pickArray insertObjects:self.user.userModel.pick atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.pickArray.count - 1, self.user.userModel.pick.count)]];
    }
    return _pickArray;
}

- (NSMutableArray *)showImageArray {
    if (!_showImageArray) {
        _showImageArray = [NSMutableArray arrayWithArray:self.user.userModel.pick];
    }
    return _showImageArray;
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
        if (_pickArray.count > 4) {
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
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [_imageCollectionView addGestureRecognizer:longPress];
    }
    return _imageCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_pickArray.count > 8) {
        return 8;
    }else if (_pickArray.count == 0 || !kNotNil(_pickArray)) {
        return 1;
    }
    return _pickArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLBMyInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLBMyInfoCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    self.saveArray = self.pickArray;
    cell.addBtn.hidden = YES;
    [cell.checkBtn setTitle:@"" forState:UIControlStateNormal];

    if (indexPath.row == self.pickArray.count - 1) {
        cell.addBtn.hidden = NO;
        cell.userImageView.image = [UIImage imageNamed:@"me_icon_paiz"];
        [cell.addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    }else {
        NSDictionary *dict = [self.pickArray objectAtIndex:indexPath.row];
        cell.checkBtn.tag = indexPath.row;
        NSString *ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        if ([dict[@"picks"] isKindOfClass:[NSString class]]) {
            [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:dict[@"picks"] Withtype:IMGAvatar]] placeholderImage:nil];
        }
//        if (indexPath.row == _currentUserImageIndex) {
//            [cell.checkBtn setTitle:@"头像" forState:UIControlStateNormal];
//        }
        if (ID.length < 5) {
                cell.userImageView.image = dict[@"picks"];
            }
    }
    
    [cell.checkBtn addTarget:self action:@selector(showClick:) forControlEvents:UIControlEventTouchUpInside];
    [self changeCollectionViewHeight];
    return cell;
}
- (void)changeCollectionViewHeight {
    CGFloat itemWidth = (kSCREEN_WIDTH - 20) / 4;
    CGFloat image_bg_view_height = itemWidth * 2 + 15;
    if (self.pickArray.count > 4) {
        _imageCollectionView.height = image_bg_view_height;
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, image_bg_view_height + 30);
    }else {
        _imageCollectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, itemWidth + 10);
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, itemWidth + 40);
    }
}

- (void)add {
    if([self.delegate respondsToSelector:@selector(addClick:)]) {
        NSUInteger max = kMax - self.pickArray.count > 0 ? kMax - self.pickArray.count:0;
        [self.delegate addClick:max];
    }
}

- (void)showClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteImgWithIndex:max:)]) {
        
        NSUInteger max = kMax - self.pickArray.count > 0 ? kMax - self.pickArray.count:0;
        [self.delegate deleteImgWithIndex:sender.tag max:max];
    }
}

- (void)insertImages:(NSArray *)images {
    if(self.pickArray.count + images.count > kMax) return;
    [self.pickArray insertObjects:images atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.pickArray.count - 1, images.count)]];
    [self.showImageArray insertObjects:images atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.showImageArray.count, images.count)]];
    [self pictureBgViewHeight];
}

- (void)selectImgWithImgDict:(NSDictionary *)dict index:(NSInteger)index{
    if (!kNotNil(dict)) return;
    [self.pickArray replaceObjectAtIndex:index withObject:dict];
    [self.imageCollectionView reloadData];
}
- (void)saveClick {
    if ([self.delegate respondsToSelector:@selector(saveClick:userPictureUrl:)]) {
        [self.delegate saveClick:self.pickArray userPictureUrl:self.userImageUrl];
    }
}

- (void)deleteImageWithIndex:(NSInteger)idx {
    [self.pickArray removeObjectAtIndex:idx];
    [self.showImageArray removeObjectAtIndex:idx];
    [self pictureBgViewHeight];
}
//计算图片背景view 的高度
- (void)pictureBgViewHeight {
    CGFloat itemWidth = (kSCREEN_WIDTH - 20) / 4;
    CGFloat height = 0;
    CGFloat image_bg_view_height = itemWidth * 2 + 15;
    if (self.pickArray.count > 4) {
        height = image_bg_view_height;
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, image_bg_view_height + 40);
    }else {
        height = itemWidth + 40;
        _imageCollectionView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, itemWidth + 10);
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, itemWidth + 40);
    }
    if ([self.delegate respondsToSelector:@selector(changedViewHeight:)]) {
        [self.delegate changedViewHeight:height];
    }
//    NSString *heightString = [NSString stringWithFormat:@"%f",height];
//    NSNotification *notification = [[NSNotification alloc] initWithName:@"heightNotifition" object:nil userInfo:@{@"height":heightString}];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.imageCollectionView reloadData];
}
#pragma mark - 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.imageCollectionView];
    _moveIndexPath = [self.imageCollectionView indexPathForItemAtPoint:touchPoint];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isEditing == NO) {
                self.isEditing = YES;
                self.user = [XLBUser user];
                [self.imageCollectionView layoutIfNeeded];
            }
            if (_moveIndexPath.section == 0) {
                XLBMyInfoCollectionViewCell *selectedItemCell = (XLBMyInfoCollectionViewCell *)[self.imageCollectionView cellForItemAtIndexPath:_moveIndexPath];
                _originalIndexPath = [self.imageCollectionView indexPathForItemAtPoint:touchPoint];
                if (!_originalIndexPath || _moveIndexPath == [NSIndexPath indexPathForRow:_pickArray.count - 1 inSection:0]) {
                    return;
                }else {
                    _snapshotView = [selectedItemCell.contentView snapshotViewAfterScreenUpdates:YES];
                    _snapshotView.center = [recognizer locationInView:self.imageCollectionView];
                    [self.imageCollectionView addSubview:_snapshotView];
                    selectedItemCell.hidden = YES;
                    [UIView animateWithDuration:0.2 animations:^{
                        _snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
                        _snapshotView.alpha = 0.98;
                    }];
                }
                
            }
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
            _snapshotView.center = [recognizer locationInView:self.imageCollectionView];
            
            if (_moveIndexPath.section == 0) {
                if (_moveIndexPath && ![_moveIndexPath isEqual:_originalIndexPath] && _moveIndexPath.section == _originalIndexPath.section) {
                    NSInteger fromIndex = _originalIndexPath.item;
                    NSInteger toIndex = _moveIndexPath.item;
                    if (fromIndex < toIndex) {
                        for (NSInteger i = fromIndex; i < toIndex; i++) {
                            [_pickArray exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                        }
                    }else{
                        for (NSInteger i = fromIndex; i > toIndex; i--) {
                            [_pickArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                        }
                    }
                    if (_moveIndexPath == [NSIndexPath indexPathForRow:_pickArray.count -1 inSection:0] || fromIndex == self.pickArray.count - 1) {
                        return;
                    }else {
                        [self.imageCollectionView moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
                        if ([self.delegate respondsToSelector:@selector(changedImageIndex)]) {
                            [_delegate changedImageIndex];
                        }
                        _originalIndexPath = _moveIndexPath;
                    }
                    
                }
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            XLBMyInfoCollectionViewCell *cell = (XLBMyInfoCollectionViewCell *)[self.imageCollectionView cellForItemAtIndexPath:_originalIndexPath] ;
            cell.hidden = NO;
            cell.checkBtn.tag = _originalIndexPath.row;
            [_snapshotView removeFromSuperview];
        } break;
            
        default: break;
    }
}


//- (void)saveSuccess {
////    self.user = [XLBUser user];
////    [self setUpSubViews];
//    [self.imageCollectionView reloadData];
//}


@end

