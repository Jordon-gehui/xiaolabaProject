//
//  XLBGroupAddManagerSheetView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupAddManagerSheetView.h"

@interface XLBGroupAddManagerSheetView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *certainBtn;

@end

@implementation XLBGroupAddManagerSheetView

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self setSubViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self setSubViews];
    }
    return self;
}
- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    self.contentLabel.text = [NSString stringWithFormat:@"您将要设置'%@'成为管理员，设置为管理员后，他将拥有踢人,加人,修改群公告等管理权,请知悉",nickName];
}

- (void)setIsAdmin:(NSString *)isAdmin {
    _isAdmin = isAdmin;
    if ([isAdmin isEqualToString:@"1"]) {
        [self.certainBtn setTitle:@"取消管理员" forState:0];
    }else {
        [self.certainBtn setTitle:@"设为管理员" forState:0];
    }
}
- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    [self addSubview:self.bgView];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor minorTextColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = @"您将要设置xxx成为管理员，设置为管理员后，他将拥有踢人，修改群公告，审核加群申请等管理权，请知悉";
    [self.bgView addSubview:self.contentLabel];
    
    self.cancleBtn = [UIButton new];
    [self.cancleBtn setTitle:@"取消" forState:0];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.cancleBtn.layer.masksToBounds = YES;
    self.cancleBtn.layer.cornerRadius = 5;
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setBackgroundColor:[UIColor colorWithR:161 g:161 b:161]];
    [self.bgView addSubview:self.cancleBtn];
    
    self.certainBtn = [UIButton new];
    self.certainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.certainBtn setTitleColor:[UIColor assistColor] forState:0];
    [self.certainBtn setTitle:@"设为管理员" forState:0];
    self.certainBtn.backgroundColor = [UIColor lightColor];
    self.certainBtn.layer.masksToBounds = YES;
    self.certainBtn.layer.cornerRadius = 5;
    [self.certainBtn addTarget:self action:@selector(certainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.certainBtn];
}
- (void)certainBtnClick {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(didCertainBtnClick)]) {
        [self.delegate didCertainBtnClick];
    }
}
- (void)cancleBtnClick {
    [self removeFromSuperview];
}
- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(170);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(self.bgView.mas_centerX).with.offset(-10);
    }];
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.cancleBtn);
        make.left.mas_equalTo(self.bgView.mas_centerX).with.offset(10);
    }];
}
@end
