//
//  XLBPraseListCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/16.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBPraseListCollectionViewCell.h"
#import "XLBDEvaluateView.h"

@interface XLBPraseListCollectionViewCell()

@property (nonatomic, strong)UIView *bgV;
@property (nonatomic, strong)UIImageView *topImg;
@property (nonatomic, strong)UILabel *nickName;
@property (nonatomic, strong)UIImageView *sex;
@property (nonatomic, strong)XLBDEvaluateView *devaluateV;
//@property (nonatomic, strong)UIButton *followBtn;
@property (nonatomic, strong)UIButton *topBtn;
@property (nonatomic, strong)UILabel *follow;
@end

@implementation XLBPraseListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(PraiseListModel *)model {
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGMoment]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickName.text = model.nickname;
    
    if ([model.sex isEqualToString:@"1"]) {
        self.sex.image = [UIImage imageNamed:@"icon_man"];
    }
    if ([model.sex isEqualToString:@"0"]) {
        self.sex.image = [UIImage imageNamed:@"icon_woman"];
    }
    [self.devaluateV insertSign:model.tags];

    _model = model;
}

- (void)setSubViews {
    self.bgV = [UIView new];
//    _bgV.layer.masksToBounds = YES;
//    _bgV.layer.cornerRadius = 10;
    self.bgV.backgroundColor = [UIColor whiteColor];
//    self.contentView.layer.shadowOpacity = 0.1;// 阴影透明度
//    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
//    self.contentView.layer.shadowRadius = 2;// 阴影扩散的范围控制
//    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    [self.contentView addSubview:self.bgV];
    
    self.topImg = [UIImageView new];
    self.topImg.alpha = 1;
    [self.bgV addSubview:self.topImg];
    
    self.topBtn = [UIButton new];
    [self.topBtn addTarget:self action:@selector(checkUserImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgV addSubview:self.topBtn];
    
    self.nickName = [UILabel new];
    self.nickName.font = [UIFont systemFontOfSize:14];
    self.nickName.textColor = [UIColor commonTextColor];
    [self.bgV addSubview:self.nickName];
    
    self.sex = [UIImageView new];
    [self.bgV addSubview:self.sex];
    
    self.devaluateV = [XLBDEvaluateView new];
    [self.devaluateV setFont:7];
    [self.devaluateV setlHeight:12];
    [self.devaluateV setLwidth:15];
    [self.devaluateV setRadius:2];
    [self.bgV addSubview:self.devaluateV];
    
//    _followBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
//    [_followBtn setTitle:@"看Ta主页" forState:0];
//    _followBtn.layer.masksToBounds = YES;
//    _followBtn.layer.cornerRadius = 5;
//    _followBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [_followBtn setTitleColor:[UIColor textBlackColor] forState:0];
//    [_followBtn setEnlargeEdge:20];
//    [_followBtn addTarget:self action:@selector(checkUserOwner:) forControlEvents:UIControlEventTouchUpInside];
//    [_bgV addSubview:_followBtn];
//    UIColor *btnColor = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:_followBtn.size]];
//    _followBtn.backgroundColor = btnColor;

    self.follow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    self.follow.font = [UIFont systemFontOfSize:12];
    self.follow.layer.masksToBounds = YES;
    self.follow.layer.cornerRadius = 5;
    self.follow.text = @"看Ta主页";
    self.follow.textColor = [UIColor textBlackColor];
    self.follow.textAlignment = NSTextAlignmentCenter;
    [self.bgV addSubview:self.follow];

    UIColor *followColor = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:self.follow.size]];
    self.follow.backgroundColor = followColor;
 }
- (void)checkUserImgBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(checkUserImgWithImg:)]) {
        [_delegate checkUserImgWithImg:_topImg.image];
    }
}

- (void)layoutSubviews {
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.bgV).with.offset(0);
        make.height.mas_equalTo(self.bgV.mas_width).with.offset(0);
    }];
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.topImg);
        make.top.mas_equalTo(self.topImg.mas_top).with.offset(0);
        make.centerX.mas_equalTo(self.topImg.mas_centerX).with.offset(0);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImg.mas_bottom).with.offset(6);
        make.left.mas_equalTo(self.bgV.mas_left).with.offset(0);
    }];
    
    [self.sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.bgV.mas_right).with.offset(-5);
        make.left.mas_equalTo(self.nickName.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.nickName.mas_centerY);
        make.width.height.mas_equalTo(15);
        
    }];

    [self.devaluateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_left).with.offset(0);
        make.top.mas_equalTo(self.nickName.mas_bottom).with.offset(8);
        make.height.mas_equalTo(15);
    }];

    [self.follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.devaluateV.mas_bottom).with.offset(12);
        make.centerX.mas_equalTo(self.bgV.mas_centerX).with.offset(0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(70);
        make.bottom.mas_equalTo(self.bgV.mas_bottom).with.offset(-8);
    }];

    
}

+ (NSString *)praiseCellID {
    return @"praiseCellID";
}

@end
