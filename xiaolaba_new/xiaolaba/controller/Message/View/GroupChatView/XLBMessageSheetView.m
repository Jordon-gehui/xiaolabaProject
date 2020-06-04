//
//  XLBMessageSheetView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBMessageSheetView.h"


@interface XLBMessageSheetView()

@property (nonatomic, strong) UIImageView *topImg;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *addFriendImg;
@property (nonatomic, strong) UIImageView *addGroupImg;
@property (nonatomic, strong) UIImageView *groupListImg;
@property (nonatomic, strong) UIImageView *scanImg;
@property (nonatomic, strong) UILabel *addFriendLabel;
@property (nonatomic, strong) UILabel *addGroupLabel;
@property (nonatomic, strong) UILabel *groupListLabel;
@property (nonatomic, strong) UILabel *scanLabel;



@property (nonatomic, strong) UIButton *addFriendBtn;
@property (nonatomic, strong) UIButton *addGroupBtn;
@property (nonatomic, strong) UIButton *groupListBtn;
@property (nonatomic, strong) UIButton *scanBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;

@end

@implementation XLBMessageSheetView

- (id)initWithFrame:(CGRect)frame type:(AlertSheetType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self setSubViewsWithType:type];
    }
    return self;
}

- (void)updateTopImgFrame:(CGFloat)top {
    [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
    }];
    [self layoutIfNeeded];
}
- (void)setSubViewsWithType:(AlertSheetType)type {
    
    self.topImg = [UIImageView new];
    self.topImg.image = [UIImage imageNamed:@"m_sanjiao"];
    [self addSubview:self.topImg];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.clipsToBounds = NO;
    [self addSubview:self.bgView];
    
    
    self.addFriendImg = [UIImageView new];
    [self.addFriendImg setImage:type == AlertSheetTypeDefault ? [UIImage imageNamed:@"icon_tjhy"] : [UIImage imageNamed:@"icon_fx_fdt"]];
    [self.bgView addSubview:self.addFriendImg];
    
    self.addFriendLabel = [UILabel new];
    self.addFriendLabel.font = [UIFont systemFontOfSize:16];
    self.addFriendLabel.textColor = [UIColor commonTextColor];
    [self.addFriendLabel setText:type == AlertSheetTypeDefault ? @"添加好友" : @"发动态"];
    self.addFriendLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:self.addFriendLabel];
    
    self.addFriendBtn = [UIButton new];
    self.addFriendBtn.tag = type == AlertSheetTypeDefault ? MessageSheetAddFriendBtnTag : AlertSheetPublishDynamicBtnTag;
    [self.addFriendBtn addTarget:self action:@selector(messageSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.addFriendBtn];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [UIColor lineColor];
    [self.bgView addSubview:self.line1];
    
    self.addGroupImg = [UIImageView new];
    [self.addGroupImg setImage:type == AlertSheetTypeDefault ? [UIImage imageNamed:@"icon_cjql"] : [UIImage imageNamed:@"icon_sm"]];
    [self.bgView addSubview:self.addGroupImg];
    self.addGroupLabel = [UILabel new];
    self.addGroupLabel.font = [UIFont systemFontOfSize:16];
    self.addGroupLabel.textColor = [UIColor commonTextColor];
    [self.addGroupLabel setText:type == AlertSheetTypeDefault ? @"创建群聊" : @"扫一扫"];
    self.addGroupLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:self.addGroupLabel];
    
    self.addGroupBtn = [UIButton new];
    self.addGroupBtn.tag = type == AlertSheetTypeDefault ? MessageSheetAddGroupBtnTag : MessageSheetScanBtnTag;
    [self.addGroupBtn addTarget:self action:@selector(messageSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.addGroupBtn];
    
    
    
    if (type == AlertSheetTypeDefault) {
        
        self.line2 = [UIView new];
        self.line2.backgroundColor = [UIColor lineColor];
        [self.bgView addSubview:self.line2];
        
        self.groupListImg = [UIImageView new];
        self.groupListImg.image = [UIImage imageNamed:@"icon_wdql"];
        [self.bgView addSubview:self.groupListImg];
        
        self.groupListLabel = [UILabel new];
        self.groupListLabel.font = [UIFont systemFontOfSize:16];
        self.groupListLabel.textColor = [UIColor commonTextColor];
        self.groupListLabel.textAlignment = NSTextAlignmentLeft;
        self.groupListLabel.text = @"我的群聊";
        [self.bgView addSubview:self.groupListLabel];

        
        self.line3 = [UIView new];
        self.line3.backgroundColor = [UIColor lineColor];
        [self.bgView addSubview:self.line3];
        
        self.scanImg = [UIImageView new];
        self.scanImg.image = [UIImage imageNamed:@"icon_sm"];
        [self.bgView addSubview:self.scanImg];
        
        self.scanLabel = [UILabel new];
        self.scanLabel.font = [UIFont systemFontOfSize:16];
        self.scanLabel.textColor = [UIColor commonTextColor];
        self.scanLabel.textAlignment = NSTextAlignmentLeft;
        self.scanLabel.text = @"扫一扫";
        [self.bgView addSubview:self.scanLabel];
        
        self.groupListBtn = [UIButton new];
        self.groupListBtn.tag = MessageSheetGroupListBtnTag;
        [self.groupListBtn addTarget:self action:@selector(messageSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.groupListBtn];
        
        self.scanBtn = [UIButton new];
        self.scanBtn.tag = MessageSheetScanBtnTag;
        [self.scanBtn addTarget:self action:@selector(messageSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.scanBtn];
    }
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (type == AlertSheetTypeDefault) {
            make.right.mas_equalTo(-25);
            if (iPhoneX) {
                make.top.mas_equalTo(84);
            }else {
                make.top.mas_equalTo(64);
            }
        }else {
            make.right.mas_equalTo(-25);
            if (iPhoneX) {
                make.top.mas_equalTo(84);
            }else {
                make.top.mas_equalTo(100);
            }
        }
        make.width.mas_equalTo(13.5);
        make.height.mas_equalTo(11.5);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImg.mas_bottom).with.offset(-5);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(203);
        if (type == AlertSheetTypeMain) {
            make.height.mas_equalTo(102);
            make.width.mas_equalTo(130);
        }
    }];
    
    [self.addFriendImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).with.offset(15);
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(15);
    }];
    
    [self.addFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addFriendImg.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.addFriendImg.mas_centerY).with.offset(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(-4);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addFriendLabel.mas_bottom).with.offset(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    [self.addGroupImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(15);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.addGroupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addGroupImg.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.addGroupImg.mas_centerY).with.offset(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.addGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    if (type == AlertSheetTypeDefault) {
        
        
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addGroupLabel.mas_bottom).with.offset(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
        }];
        
        [self.groupListImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line2.mas_bottom).with.offset(12);
            make.centerX.mas_equalTo(self.addFriendImg.mas_centerX).with.offset(0);
            make.width.height.mas_equalTo(25);
        }];
        
        [self.groupListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addFriendLabel.mas_left).with.offset(0);
            make.centerY.mas_equalTo(self.groupListImg.mas_centerY).with.offset(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.groupListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line2.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.groupListLabel.mas_bottom).with.offset(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(1);
        }];
        
        [self.scanImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line3.mas_bottom).with.offset(15);
            make.left.mas_equalTo(self.bgView.mas_left).with.offset(15);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scanImg.mas_right).with.offset(15);
            make.centerY.mas_equalTo(self.scanImg.mas_centerY).with.offset(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line3.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}
- (void)messageSheetBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSeletedMessageSheetViewBtnClick:)]) {
        [self.delegate didSeletedMessageSheetViewBtnClick:sender];
    }
}
@end
