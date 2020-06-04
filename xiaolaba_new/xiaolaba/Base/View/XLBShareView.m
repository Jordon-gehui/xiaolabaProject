//
//  XLBShareView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBShareView.h"
@interface XLBShareView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *weChatPyqBtn;
@property (nonatomic, strong) UIButton *weiboBtn;
@property (nonatomic, strong) UILabel *weiboLabel;
@property (nonatomic, strong) UILabel *weChatLabel;
@property (nonatomic, strong) UILabel *weChatPyqLabel;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *cancleBtn;
@end

@implementation XLBShareView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type isHidden:(NSInteger)hidden{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self setSubViewsWithType:type isHidden:hidden];
    }
    return self;
}
- (void)shareBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(shareViewBtnClickWithTag:)]) {
        [self.delegate shareViewBtnClickWithTag:sender];
    }
}
- (void)removeFromView {
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
}
- (void)setSubViewsWithType:(NSInteger)type isHidden:(NSInteger)hidden {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 15;
    [self addSubview:self.bgView];
    

    self.weChatBtn = [UIButton new];
    [self.weChatBtn setBackgroundImage:[UIImage imageNamed:@"icon_wx_yq"] forState:UIControlStateNormal];
    self.weChatBtn.tag = ShareViewWeChatBtnTag;
    [self.weChatBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.weChatBtn];
    
    self.weChatPyqBtn = [UIButton new];
    self.weChatPyqBtn.tag = ShareViewWeChatPyqBtnTag;
    [self.weChatPyqBtn setBackgroundImage:[UIImage imageNamed:@"icon_pyq"] forState:UIControlStateNormal];
    [self.weChatPyqBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.weChatPyqBtn];
    
    self.weiboBtn = [UIButton new];
    self.weiboBtn.tag = ShareViewWeiBoBtnTag;
    if (type == ShareViewDefault) {
        [self.weiboBtn setBackgroundImage:[UIImage imageNamed:@"icon_wb_yq"] forState:UIControlStateNormal];
    }else if(type == ShareViewSaveImg) {
        [self.weiboBtn setBackgroundImage:[UIImage imageNamed:@"icon_bctp"] forState:UIControlStateNormal];
    }
    [self.weiboBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.weiboBtn];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.bgView addSubview:self.line];
    
    self.cancleBtn = [UIButton new];
    [self.cancleBtn addTarget:self action:@selector(removeFromView) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancleBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
    [self.bgView addSubview:self.cancleBtn];
    
    self.weChatLabel = [UILabel new];
    self.weChatLabel.text = @"微信好友";
    self.weChatLabel.textColor = [UIColor minorTextColor];
    self.weChatLabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.weChatLabel];
    
    self.weChatPyqLabel = [UILabel new];
    self.weChatPyqLabel.text = @"朋友圈";
    self.weChatPyqLabel.textColor = [UIColor minorTextColor];
    self.weChatPyqLabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.weChatPyqLabel];
    
    self.weiboLabel = [UILabel new];
    if (type == ShareViewDefault) {
        self.weiboLabel.text = @"新浪微博";
    }else if (type == ShareViewSaveImg) {
        self.weiboLabel.text = @"保存图片";
    }
    self.weiboLabel.textColor = [UIColor minorTextColor];
    self.weiboLabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:self.weiboLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(160);
    }];
    
    
    if (hidden == ShareBtnWeChatHidden) {//没有微信
        [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.width.height.mas_equalTo(50*kiphone6_ScreenHeight);
        }];
        
        [self.weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.centerX.mas_equalTo(self.weiboBtn.mas_centerX).with.offset(0);
        }];
    }else if(hidden == ShareBtnWeiBoHidden){
        //没有微博
        if (type == ShareViewSaveImg) {
            [self.weChatPyqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
                make.top.mas_equalTo(20);
                make.width.height.mas_equalTo(50*kiphone6_ScreenHeight);
            }];
            
            [self.weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.weChatPyqBtn.mas_left).with.offset(-55);
                make.centerY.mas_equalTo(self.weChatPyqBtn);
                make.width.height.mas_equalTo(self.weChatPyqBtn);
            }];
            
            [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.weChatPyqBtn.mas_right).with.offset(55);
                make.centerY.mas_equalTo(self.weChatPyqBtn);
                make.width.height.mas_equalTo(self.weChatPyqBtn);
            }];
            
            [self.weChatPyqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.bgView.mas_centerY);
                make.centerX.mas_equalTo(self.weChatPyqBtn);
            }];
            
            [self.weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.weChatBtn);
                make.centerY.mas_equalTo(self.weChatPyqLabel);
            }];
            
            [self.weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.weiboBtn);
                make.centerY.mas_equalTo(self.weChatPyqLabel);
            }];
        }else {
            [self.weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.bgView.mas_centerX).with.offset(-30);
                make.top.mas_equalTo(20);
                make.width.height.mas_equalTo(50*kiphone6_ScreenHeight);
            }];
            
            [self.weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.weChatBtn.mas_centerX).with.offset(0);
                make.centerY.mas_equalTo(self.bgView.mas_centerY);
            }];
            
            [self.weChatPyqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgView.mas_centerX).with.offset(30);
                make.centerY.mas_equalTo(self.weChatBtn.mas_centerY).with.offset(0);
                make.width.height.mas_equalTo(self.weChatBtn);
            }];
            
            [self.weChatPyqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.weChatLabel);
                make.centerX.mas_equalTo(self.weChatPyqBtn);
            }];
        }
        
    }else {
        
        [self.weChatPyqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX).with.offset(0);
            make.top.mas_equalTo(20);
            make.width.height.mas_equalTo(50*kiphone6_ScreenHeight);
        }];
        
        [self.weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.weChatPyqBtn.mas_left).with.offset(-55);
            make.centerY.mas_equalTo(self.weChatPyqBtn);
            make.width.height.mas_equalTo(self.weChatPyqBtn);
        }];
        
        [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.weChatPyqBtn.mas_right).with.offset(55);
            make.centerY.mas_equalTo(self.weChatPyqBtn);
            make.width.height.mas_equalTo(self.weChatPyqBtn);
        }];
        
        [self.weChatPyqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.centerX.mas_equalTo(self.weChatPyqBtn);
        }];
        
        [self.weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.weChatBtn);
            make.centerY.mas_equalTo(self.weChatPyqLabel);
        }];
        
        [self.weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.weiboBtn);
            make.centerY.mas_equalTo(self.weChatPyqLabel);
        }];
    }
    

    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cancleBtn.mas_top).with.offset(0);
        make.height.mas_equalTo(0.7);
        make.left.right.mas_equalTo(0);
    }];
}

@end
