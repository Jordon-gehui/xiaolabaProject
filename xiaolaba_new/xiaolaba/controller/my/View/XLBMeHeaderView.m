//
//  XLBMeHeaderView.m
//  xiaolaba
//
//  Created by lin on 2017/7/19.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMeHeaderView.h"
#import <UIImageView+WebCache.h>
//#import "UIControl+YYAdd.h"

@interface XLBMeHeaderView ()

@property (nonatomic, strong) XLBUser *user;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *focus_label;
@property (nonatomic, strong) UILabel *fans_label;
@property (nonatomic, strong) UILabel *timelin_label;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) UIImageView *cir_two;
@property (nonatomic, strong) UIView *line_one;
@property (nonatomic, strong) UILabel *label_two;
@property (nonatomic, strong) UIView *temp_bottom_line_one;

@end

@implementation XLBMeHeaderView

- (instancetype)initWithUser:(XLBUser *)user complete:(BOOL )complete {
    
    if(self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.user = user;
        [self setupSubViews:complete];
    }
    return self;
}

- (void)setupSubViews:(BOOL )complete {
    
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH/1.59+45);
    self.backgroundColor = RGB(244, 244, 244);


    // 头像
    UIImageView *imageV= [UIImageView new];
    [imageV setImage:[UIImage imageNamed:@"myBack"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kSCREEN_WIDTH/1.59);
    }];
    UIView *whiteBackView = [UIView new];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    whiteBackView.layer.cornerRadius = 5;
    whiteBackView.layer.masksToBounds = YES;
    [self addSubview:whiteBackView];
    
    [whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(70);
        make.top.mas_equalTo(imageV.mas_bottom).with.offset(-40);
    }];
    _avatar_image = [[UIImageView alloc] init];
    _avatar_image.layer.masksToBounds = YES;
    _avatar_image.layer.cornerRadius = 30;
    [imageV addSubview:_avatar_image];
    [_avatar_image mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(88);
        }else{
            make.top.mas_equalTo(66);
        }
        make.left.mas_equalTo(25);
        make.width.height.mas_equalTo(60);
    }];
    [_avatar_image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.user.userModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    // 昵称
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.textColor = [UIColor whiteColor];
    self.nickNameLabel.font = [UIFont systemFontOfSize:17];
    [imageV addSubview:self.nickNameLabel];
    self.nickNameLabel.text = self.user.userModel.nickname;
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_avatar_image.mas_right).with.offset(10);
        make.top.mas_equalTo(_avatar_image.mas_top).with.offset(10);
    }];
    UILabel *hint_label = [[UILabel alloc] init];
    hint_label.textColor = [UIColor whiteColor];
    hint_label.font = [UIFont systemFontOfSize:14];
    hint_label.text = @"查看或者编辑个人资料";
    [imageV addSubview:hint_label];
    [hint_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(8);
    }];
    // 个人资料
    UIButton *update_button = [UIButton buttonWithType:0];
    [self addSubview:update_button];
    [update_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.nickNameLabel);
        make.left.mas_equalTo(_avatar_image.mas_right).offset(10);
        make.right.mas_equalTo(self);
        make.bottom.equalTo(hint_label.mas_bottom);
    }];

    [update_button addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //修改头像
    
    UIButton *update_user_image = [UIButton buttonWithType:0];
    [self addSubview:update_user_image];
    [update_user_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_avatar_image);
        make.width.height.mas_equalTo(_avatar_image);
    }];
//    [update_user_image addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//        if ([weakSelf.delegate respondsToSelector:@selector(headerUserImageUpdateClick)]) {
//            [weakSelf.delegate headerUserImageUpdateClick];
//        }
//    }];
    //修改头像
    [update_user_image addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    // 关注、粉丝、动态
    CGFloat width = (kSCREEN_WIDTH-30) / 3.0;
    CGFloat height = width * 0.5;
    self.focus_label = [[UILabel alloc] init];
    self.focus_label.numberOfLines = 0;
    self.focus_label.textAlignment = NSTextAlignmentCenter;
    [whiteBackView addSubview:self.focus_label];
    [self.focus_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(whiteBackView);
        make.centerY.mas_equalTo(whiteBackView);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.f;
    paragraphStyle.alignment = self.focus_label.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    NSString *followString = [NSString stringWithFormat:@"%@\n关注",self.user.userModel.follows];
    NSMutableAttributedString *followattString = [[NSMutableAttributedString alloc] initWithString:followString];
    [followattString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followString length])];
    [followattString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, followString.length - 2)];
    [followattString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(followString.length - 2, 2)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, followString.length - 2)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(followString.length - 2, 2)];
    self.focus_label.attributedText = followattString;

    UIButton *focus_button = [UIButton buttonWithType:0];
    [self addSubview:focus_button];
    [focus_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.focus_label);
    }];

    [focus_button addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.fans_label = [[UILabel alloc] init];
    self.fans_label.numberOfLines = 0;
    self.fans_label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.fans_label];
    [self.fans_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.focus_label.mas_right).with.offset(1);
        make.top.equalTo(self.focus_label.mas_top);
        make.width.height.equalTo(self.focus_label);
    }];
    NSString *followerString = [NSString stringWithFormat:@"%@\n粉丝",self.user.userModel.followers];
    NSMutableAttributedString *followerAttString = [[NSMutableAttributedString alloc] initWithString:followerString];
    [followerAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followerString length])];
    [followerAttString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, followerString.length - 2)];
    [followerAttString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(followerString.length - 2, 2)];
    [followerAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, followerString.length - 2)];
    [followerAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(followerString.length - 2, 2)];
    self.fans_label.attributedText = followerAttString;

    UIButton *fans_button = [UIButton buttonWithType:0];
    [self addSubview:fans_button];
    [fans_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.fans_label);
    }];
    [fans_button addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.timelin_label = [[UILabel alloc] init];
    self.timelin_label.numberOfLines = 0;
    self.timelin_label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timelin_label];
    [self.timelin_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.fans_label.mas_right).with.offset(1);
        make.top.equalTo(self.focus_label.mas_top);
        make.width.height.equalTo(self.focus_label);
    }];
    NSString *friendString = [NSString stringWithFormat:@"%@\n好友",self.user.userModel.friends];
    NSMutableAttributedString *friendAttString = [[NSMutableAttributedString alloc] initWithString:friendString];
    [friendAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [friendString length])];
    [friendAttString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, friendString.length - 2)];
    [friendAttString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(friendString.length - 2, 2)];
    [friendAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, friendString.length - 2)];
    [friendAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(friendString.length - 2, 2)];
    self.timelin_label.attributedText = friendAttString;

    UIButton *timelin_button = [UIButton buttonWithType:0];
    [timelin_button addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timelin_button];
    [timelin_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(self.timelin_label);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor lineColor];
    [whiteBackView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(whiteBackView);
        make.left.mas_equalTo(self.focus_label.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
    }];
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor lineColor];
    [whiteBackView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(whiteBackView);
        make.left.mas_equalTo(self.fans_label.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
    }];
    
    UIView *bottom_line_one = [[UIView alloc] init];
    bottom_line_one.backgroundColor = RGB(244, 244, 244);
    [self addSubview:bottom_line_one];
    [bottom_line_one mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *rightBtn = [UIButton new];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setImage:[UIImage imageNamed:@"icon_wd_sz"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.top.mas_equalTo(40);
        }else {
            make.top.mas_equalTo(24);
        }
        make.right.mas_equalTo(-15);
//        make.width.height.mas_equalTo(40);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(40);
    }];
    
    self.temp_bottom_line_one = bottom_line_one;
    // 未完成认证
    
    //个人资料按钮
    update_button.tag = 10;
    //修改头像
    update_user_image.tag = 20;
    //关注
    focus_button.tag = 30;
    //粉丝
    fans_button.tag = 40;
    //好友
    timelin_button.tag = 50;


    if(complete) {
        self.lastView = bottom_line_one;
    }
    else {
        self.lastView = bottom_line_one;
    }
    
    
    
    [self layoutIfNeeded];
    
    
    
    self.height = self.lastView.bottom;
}

UILabel *cer(NSString *text) {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor shadeStartColor];
    label.text = text;
    return label;
}

- (void)updateUser:(XLBUser *)user {
    
    self.user = user;
    BOOL status = [user.userModel.status integerValue] == 30 ? YES:NO;
    if (!status) {
        if ([user.userModel.status integerValue] < 10) {
            _line_one.backgroundColor = RGB(211, 211, 211);
            _label_two.textColor = RGB(211, 211, 211);
            _cir_two.image = [UIImage imageNamed:@"huidian"];
        }
    }
    self.nickNameLabel.text = user.userModel.nickname;
    [self.avatar_image sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:user.userModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.f;
    paragraphStyle.alignment = self.focus_label.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    NSString *followString = [NSString stringWithFormat:@"%@\n关注",user.userModel.follows];
    NSMutableAttributedString *followattString = [[NSMutableAttributedString alloc] initWithString:followString];
    [followattString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followString length])];
    [followattString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, followString.length - 2)];
    [followattString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(followString.length - 2, 2)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, followString.length - 2)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(followString.length - 2, 2)];
    self.focus_label.attributedText = followattString;
    
    
    NSString *followerString = [NSString stringWithFormat:@"%@\n粉丝",user.userModel.followers];
    NSMutableAttributedString *followerAttString = [[NSMutableAttributedString alloc] initWithString:followerString];
    [followerAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followerString length])];
    [followerAttString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, followerString.length - 2)];
    [followerAttString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(followerString.length - 2, 2)];
    [followerAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, followerString.length - 2)];
    [followerAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(followerString.length - 2, 2)];
    self.fans_label.attributedText = followerAttString;
    
    NSString *friendString = [NSString stringWithFormat:@"%@\n好友",user.userModel.friends];
    NSMutableAttributedString *friendAttString = [[NSMutableAttributedString alloc] initWithString:friendString];
    [friendAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [friendString length])];
    [friendAttString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, friendString.length - 2)];
    [friendAttString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(friendString.length - 2, 2)];
    [friendAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, friendString.length - 2)];
    [friendAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(friendString.length - 2, 2)];
    self.timelin_label.attributedText = friendAttString;
    
    self.lastView = self.temp_bottom_line_one;
    
    [self layoutIfNeeded];
    self.height = self.lastView.bottom;
}


- (void)certainBtnClick:(UIButton *)sender {
            kWeakSelf(self);

    if ([weakSelf.delegate respondsToSelector:@selector(headerViewCertiClick)]) {
                        [weakSelf.delegate headerViewCertiClick];
            }
}

- (void)updateBtnClick:(UIButton *)sender {
    kWeakSelf(self);
    switch (sender.tag) {
        case 10:{
            //修改个人资料
            if ([weakSelf.delegate respondsToSelector:@selector(headerViewUpdateInfoClick)]) {
                [weakSelf.delegate headerViewUpdateInfoClick];
            }
        }
            break;
        case 20: {
            //修改头像
            if ([weakSelf.delegate respondsToSelector:@selector(headerUserImageUpdateClick)]) {
                [weakSelf.delegate headerUserImageUpdateClick];
            }
        }
            break;
        case 30: {
            if ([weakSelf.delegate respondsToSelector:@selector(headerViewFollowClick)]) {
                [weakSelf.delegate headerViewFollowClick];
            }
        }
            break;
        case 40: {
            if ([weakSelf.delegate respondsToSelector:@selector(headerViewFollowerClick)]) {
                [weakSelf.delegate headerViewFollowerClick];
            }
        }
            break;
        case 50: {
            if ([weakSelf.delegate respondsToSelector:@selector(headerViewMomentClick)]) {
                [weakSelf.delegate headerViewMomentClick];
            }
        }
            break;
        default:
            break;
    }
}

- (void)rightItemClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(headerViewRightItemClick)]) {
        [self.delegate headerViewRightItemClick];
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
