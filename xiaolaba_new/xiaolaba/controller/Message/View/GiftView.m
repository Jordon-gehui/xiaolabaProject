//
//  GiftView.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/24.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "GiftView.h"

@interface GiftView()<UIScrollViewDelegate>
@property (nonatomic,retain)UIButton *vipBtn;
@property (nonatomic,retain)UIScrollView*giftScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic,retain)UIView *balanceView;
@property (nonatomic,retain)UIImageView *moneyImg;
@property (nonatomic,retain)UILabel *moneyLbl;
@property (nonatomic,retain)UIImageView *addImg;

@property (nonatomic,retain)UIButton *sendBtn;
@end
@implementation GiftView
#define kBtnheight 30
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView:frame];
    }
    return self;
}
-(void)initView:(CGRect)frame{
    [self setBackgroundColor:[UIColor whiteColor]];
    _vipBtn = [UIButton new];
    [_vipBtn setTitle:@"开通VIP" forState:0];
    [_vipBtn setTitleColor:[UIColor commonTextColor] forState:0];
    _vipBtn.layer.cornerRadius = kBtnheight/2.0;
    _vipBtn.layer.borderColor = [UIColor lineColor].CGColor;
    _vipBtn.layer.borderWidth = 1.0;
    _vipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _vipBtn.layer.masksToBounds = YES;
    [self addSubview:_vipBtn];
    
    _giftScrollView = [UIScrollView new];
    _giftScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH*3, 0);
    _giftScrollView.backgroundColor = [UIColor clearColor];
    _giftScrollView.showsHorizontalScrollIndicator = NO;
    _giftScrollView.showsVerticalScrollIndicator = NO;
    _giftScrollView.delegate = self;
    _giftScrollView.pagingEnabled= YES;
    [self addSubview:_giftScrollView];
    [self initScrollView];

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH - 100)/2, 50+105, 100, 10)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor viewBackColor];
    [self addSubview:self.pageControl];
    
    
    _balanceView = [UIView new];
    _balanceView.layer.cornerRadius = kBtnheight/2.0;
    _balanceView.layer.borderColor = [UIColor lineColor].CGColor;
    _balanceView.layer.borderWidth = 1.0;
    _balanceView.layer.masksToBounds = YES;
    [self addSubview:_balanceView];
    
    _moneyImg = [UIImageView new];
    _moneyImg.image = [UIImage imageNamed:@"icon_wd_fh"];
    [_balanceView addSubview:_moneyImg];
    _moneyLbl = [UILabel new];
    _moneyLbl.text = @"23455";
    _moneyLbl.textColor = [UIColor commonTextColor];
    _moneyLbl.font = [UIFont boldSystemFontOfSize:14];
    [_balanceView addSubview:_moneyLbl];
    _addImg = [UIImageView new];
    _addImg.image = [UIImage imageNamed:@"icon_wd_fh"];
    [_balanceView addSubview:_addImg];
    
    _sendBtn = [UIButton new];
    [_sendBtn setTitle:@"赠送" forState:0];
    [_sendBtn setTitleColor:[UIColor commonTextColor] forState:0];
    _sendBtn.layer.cornerRadius = kBtnheight/2.0;
    _sendBtn.layer.borderColor = [UIColor lineColor].CGColor;
    _sendBtn.layer.borderWidth = 1.0;
    _sendBtn.layer.masksToBounds = YES;
    [self addSubview:_sendBtn];
    [self layoutIfNeeded];
}
-(void)initScrollView {
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 120)];
    view1.backgroundColor = [UIColor redColor];
    [self.giftScrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, 120)];
    view2.backgroundColor = [UIColor blueColor];
    [self.giftScrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(2*kSCREEN_WIDTH, 0, kSCREEN_WIDTH, 120)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.giftScrollView addSubview:view3];
}
#pragma mark - UIScrollViewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_x = scrollView.contentOffset.x;
    
    NSInteger pageIndex = offset_x/kSCREEN_WIDTH;
    self.pageControl.currentPage = pageIndex;
}
-(void)layoutSubviews {
    [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(10);
        make.right.mas_equalTo(self).with.offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(kBtnheight);
    }];
    [_giftScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_vipBtn.mas_bottom).with.offset(10);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(120);
    }];
    
    [_moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_balanceView);
        make.left.mas_equalTo(_balanceView).with.offset(10);
        make.width.height.mas_equalTo(20);
    }];
    [_moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_moneyImg.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_balanceView);
    }];
    [_addImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_moneyLbl.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_balanceView);
        make.width.height.mas_equalTo(20);
    }];
    [_balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_giftScrollView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self).with.offset(15);
        make.right.mas_equalTo(_addImg).with.offset(10);
        make.height.mas_equalTo(kBtnheight);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
