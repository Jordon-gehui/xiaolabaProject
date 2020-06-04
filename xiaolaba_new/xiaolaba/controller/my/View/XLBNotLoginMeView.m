//
//  XLBNotLoginMeView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/1/11.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBNotLoginMeView.h"

@interface XLBNotLoginMeView ()

@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *followCount;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *likeCount;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UILabel *friendsCount;
@property (nonatomic, strong) UIView *bottomV;

@end

@implementation XLBNotLoginMeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {
    self.nickName = [UILabel new];
    self.nickName.text = @"登录/注册";
    self.nickName.textColor = RGB(15, 15, 15);
    self.nickName.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.nickName];
    
    self.remindLabel = [UILabel new];
    self.remindLabel.textColor = [UIColor annotationTextColor];
    self.remindLabel.font = [UIFont systemFontOfSize:14];
    self.remindLabel.text = @"查看或者编辑个人资料";
    [self addSubview:self.remindLabel];
    
    self.userImg = [UIImageView new];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 30;
    self.userImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:self.userImg];
    
    self.lineLabel = [UILabel new];
    self.lineLabel.backgroundColor = [UIColor lineColor];
    [self addSubview:self.lineLabel];
    
    self.followLabel = [UILabel new];
    self.followLabel.numberOfLines = 0;
    self.followLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.followLabel];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.f;
    paragraphStyle.alignment = self.followLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    NSString *followString = @"0\n关注";
    NSMutableAttributedString *followattString = [[NSMutableAttributedString alloc] initWithString:followString];
    [followattString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followString length])];
    [followattString addAttribute:NSForegroundColorAttributeName value:RGB(10, 10, 10) range:NSMakeRange(0, followString.length - 2)];
    [followattString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(followString.length - 2, 2)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, followString.length - 2)];
    [followattString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(followString.length - 2, 2)];
    self.followLabel.attributedText = followattString;
    
    self.likeLabel = [UILabel new];
    self.likeLabel.numberOfLines = 0;
    self.likeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.likeLabel];
    NSString *followerString = @"0\n粉丝";
    NSMutableAttributedString *followerAttString = [[NSMutableAttributedString alloc] initWithString:followerString];
    [followerAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [followerString length])];
    [followerAttString addAttribute:NSForegroundColorAttributeName value:RGB(10, 10, 10) range:NSMakeRange(0, followerString.length - 2)];
    [followerAttString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(followerString.length - 2, 2)];
    [followerAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, followerString.length - 2)];
    [followerAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(followerString.length - 2, 2)];
    self.likeLabel.attributedText = followerAttString;
    
    
    self.friendLabel = [UILabel new];
    self.friendLabel.numberOfLines = 0;
    self.friendLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.friendLabel];
    NSString *friendString = @"0\n好友";
    NSMutableAttributedString *friendAttString = [[NSMutableAttributedString alloc] initWithString:friendString];
    [friendAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [friendString length])];
    [friendAttString addAttribute:NSForegroundColorAttributeName value:RGB(10, 10, 10) range:NSMakeRange(0, friendString.length - 2)];
    [friendAttString addAttribute:NSForegroundColorAttributeName value:RGB(174, 174, 174) range:NSMakeRange(friendString.length - 2, 2)];
    [friendAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, friendString.length - 2)];
    [friendAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(friendString.length - 2, 2)];
    self.friendLabel.attributedText = friendAttString;
    
    
    self.bottomV = [UIView new];
    self.bottomV.backgroundColor = RGB(244, 244, 244);
    [self addSubview:self.bottomV];
    
    self.loginBtn = [UIButton new];
    [self addSubview:self.loginBtn];
}

- (void)layoutSubviews {
    
    CGFloat width = kSCREEN_WIDTH / 3.0;
    CGFloat height = width * 0.5;
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(self.userImg.mas_left).with.offset(-10);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nickName);
        make.top.equalTo(self.nickName.mas_bottom).with.offset(8);
    }];
    

    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.userImg.mas_bottom).with.offset(12);
        make.height.mas_equalTo(0.7);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.lineLabel.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.followLabel.mas_right);
        make.top.mas_equalTo(self.followLabel.mas_top);
        make.width.height.mas_equalTo(self.followLabel);
    }];
    
    [self.friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likeLabel.mas_right);
        make.top.mas_equalTo(self.likeLabel.mas_top);
        make.width.height.mas_equalTo(self.likeLabel);
    }];
    
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.followLabel.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
@end
