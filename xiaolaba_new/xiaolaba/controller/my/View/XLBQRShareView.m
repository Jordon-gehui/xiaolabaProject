//
//  XLBQRShareView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBQRShareView.h"

@interface XLBQRShareView ()

@property (nonatomic, strong) UIImageView *bgImg;

@property (nonatomic, strong) UIView *topV;

@property (nonatomic, strong) UIImageView *lineImg;

@property (nonatomic, strong) UILabel *circle;
@property (nonatomic, strong) UILabel *circleTwo;

@property (nonatomic, strong) UIView *qrBgV;
@property (nonatomic, strong) UIImageView *qrImg;

@property (nonatomic, strong) UILabel *bottomLabel;

@end
@implementation XLBQRShareView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, kSCREEN_HEIGHT + 30, kSCREEN_WIDTH*3, kSCREEN_HEIGHT*3);
        [self setSubViews];
    }
    return self;
}


- (void)setSubViews {
    
    _bgImg = [UIImageView new];
    _bgImg.image = [UIImage imageNamed:@"bg_yqsr"];
    [self addSubview:_bgImg];
    

    
    _qrBgV = [UIView new];
    _qrBgV.backgroundColor = [UIColor whiteColor];
    _qrBgV.layer.masksToBounds = YES;
    _qrBgV.layer.cornerRadius = 60;
    [self addSubview:_qrBgV];
    
    _qrImg = [UIImageView new];
    _qrImg.image = [UIImage imageNamed:@"xlbdl"];
    [_qrBgV addSubview:_qrImg];
    
    _bottomLabel = [UILabel new];
    _bottomLabel.text = @"";
    _bottomLabel.numberOfLines = 0;
    _bottomLabel.textAlignment = NSTextAlignmentLeft;
    _bottomLabel.textColor = [UIColor commonTextColor];
    _bottomLabel.font = [UIFont systemFontOfSize:36];
    [self addSubview:_bottomLabel];
    
    _topV = [UIView new];
    _topV.backgroundColor = [UIColor whiteColor];
    _topV.layer.masksToBounds = YES;
    _topV.layer.cornerRadius = 60;
    [self addSubview:_topV];
    
    _topLabel = [UILabel new];
    _topLabel.text = @"专属邀请码";
    _topLabel.numberOfLines = 0;
    _topLabel.textColor = [UIColor commonTextColor];
    if (iPhone5s) {
        _topLabel.font = [UIFont systemFontOfSize:39];
    }else {
        _topLabel.font = [UIFont systemFontOfSize:45];
    }
    _topLabel.textAlignment = NSTextAlignmentCenter;
    [_topV addSubview:_topLabel];
    
    
    _lineImg = [UIImageView new];
    _lineImg.image = [UIImage imageNamed:@"pic_fgx_l"];
    [_topV addSubview:_lineImg];
    
    _circle = [UILabel new];
    _circle.backgroundColor = [UIColor lightColor];
    _circle.layer.masksToBounds = YES;
    _circle.layer.cornerRadius = 15;
    [_topV addSubview:_circle];
    
    _circleTwo = [UILabel new];
    _circleTwo.backgroundColor = [UIColor lightColor];
    _circleTwo.layer.masksToBounds = YES;
    _circleTwo.layer.cornerRadius = 15;
    [_topV addSubview:_circleTwo];
    
    _inviteLabel = [UILabel new];
    
    _inviteLabel.textColor = [UIColor commonTextColor];
    if (iPhone5s) {
        _inviteLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:84];
    }else {
        _inviteLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:105];
    }
    _inviteLabel.textAlignment = NSTextAlignmentCenter;
    [_topV addSubview:_inviteLabel];
    
    NSString *string = @"邀请规则：\n1.您的专属邀请码只属于您个人；\n2.好友在身边，随手下载小喇叭，完成注册输入邀请码后，您和好友均能获取3车币；\n3.好友不在身边？只需手指点一下，将小喇叭邀请链接或者截图发送到朋友圈，共邀好友前来下载。";
    // Adjust the spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15.f;
    paragraphStyle.alignment = self.bottomLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:45] range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor commonTextColor] range:NSMakeRange(5, string.length - 5)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange(5, string.length - 5)];
    
    self.bottomLabel.attributedText = attributedString;
    
}

- (UIImage*)imageWithUIView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
    
}

- (void)layoutSubviews {
    
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
        
    }];
    

    
    
    [_qrBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-144*kiphone6_ScreenWidth);
        make.left.mas_equalTo(self.mas_left).with.offset(144*kiphone6_ScreenWidth);
        make.height.mas_equalTo(self.qrBgV.mas_width);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_qrImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.qrBgV).with.offset(30);
        make.right.bottom.mas_equalTo(self.qrBgV).with.offset(-30);
        make.centerX.mas_equalTo(self.qrBgV.mas_centerX);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.qrBgV.mas_left).with.offset(0);
        make.right.mas_equalTo(self.qrBgV.mas_right).with.offset(0);
        make.top.mas_equalTo(self.qrBgV.mas_bottom).with.offset(60*kiphone6_ScreenHeight);
    }];
    
    [_topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.qrBgV.mas_top).with.offset(-120);
        make.centerX.mas_equalTo(self.mas_centerX);
        if (iPhoneX) {
            make.height.mas_equalTo(210*kiphone6_ScreenHeight);
        }else {
            make.height.mas_equalTo(240*kiphone6_ScreenHeight);
        }
        make.width.mas_equalTo(540*kiphone6_ScreenWidth);
        
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topV.mas_top).with.offset(15);
        make.left.mas_equalTo(self.topV.mas_left).with.offset(30);
        make.right.mas_equalTo(self.topV.mas_right).with.offset(-30);
        make.height.mas_equalTo(45);
    }];
    
    [_lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhone5s) {
            make.top.mas_equalTo(_topLabel.mas_bottom).with.offset(15);
        }else {
            make.top.mas_equalTo(_topLabel.mas_bottom).with.offset(30);
        }        make.left.mas_equalTo(_circle.mas_right).with.offset(15);
        make.right.mas_equalTo(_circleTwo.mas_left).with.offset(-15);
        make.height.mas_equalTo(3);
        make.centerX.mas_equalTo(_topV.mas_centerX);
    }];
    
    [_circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_topV.mas_left).with.offset(-15);
        make.centerY.mas_equalTo(_lineImg.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];
    
    [_circleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_topV.mas_right).with.offset(15);
        make.width.height.mas_equalTo(_circle);
        make.centerY.mas_equalTo(_lineImg.mas_centerY);
    }];
    
    [_inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineImg.mas_bottom).with.offset(30);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_topV.mas_bottom).with.offset(-15);
    }];
}
@end
