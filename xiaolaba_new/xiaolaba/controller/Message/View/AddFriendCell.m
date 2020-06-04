//
//  AddFriendCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/11.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "AddFriendCell.h"
#import "XLBDEvaluateView.h"

@interface AddFriendCell()
@property (nonatomic ,strong)UIImageView *avatar;
@property (nonatomic ,strong)UILabel *nickname;
@property (nonatomic ,strong)UILabel *content;
@property (nonatomic ,strong)UIImageView *plateImg;
@property (nonatomic ,strong)UIImageView *carImg;
@property (nonatomic ,strong)UIView *lineView;

@end
@implementation AddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializer];
    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializer];
    }
    return self;
}
-(void)initializer {
    self.avatar = [UIImageView new];
    self.avatar.layer.cornerRadius = 35;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:self.avatar];
    
    // 昵称
    self.nickname = [UILabel new];
    self.nickname.textColor = RGB(34, 49, 49);
    self.nickname.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nickname];
    
    self.content = [UILabel new];
    self.content.textColor = [UIColor commonTextColor];
    self.content.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.content];
    
    self.carImg = [UIImageView new];
    [self addSubview:self.carImg];
    
    self.plateImg = [UIImageView new];
    [self.carImg addSubview:self.plateImg];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor lineColor];
    [self addSubview:_lineView];
    
}
-(void)setFriendModel:(XLBFindUserModel*)model {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickname.text = model.nickname;
    
    self.content.text = [NSString stringWithFormat:@"%@ • %@",model.distance,[ZZCHelper dateStringFromNow:model.updateDate]];
    [self.carImg sd_setImageWithURL:[NSURL URLWithString:model.serieImg] placeholderImage:nil];
    [self.plateImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.brandImg Withtype:IMGNormal]]];
}
-(void)layoutSubviews {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(15);
        make.left.mas_equalTo(self).with.offset(15);
        make.width.height.mas_equalTo(70);
        make.bottom.mas_equalTo(self).with.offset(-15);
    }];
    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(self.avatar.mas_right).with.offset(10);
        make.right.mas_equalTo(self.carImg.mas_left);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickname.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.avatar.mas_right).with.offset(10);
        make.right.mas_equalTo(self.carImg.mas_left);
    }];
    [self.carImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.offset(-15);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60/2*3);
        make.top.mas_equalTo(self).with.offset(20);
    }];
    [self.plateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.carImg);
        make.height.width.mas_equalTo(20);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.mas_right).with.offset(-15);;
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(self);
    }];
}

@end
