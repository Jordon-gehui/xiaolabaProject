//
//  FriendCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/12.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "FriendCell.h"
@interface FriendCell()
@property (nonatomic ,strong) UIImageView *avatar;
@property (nonatomic ,strong)UILabel *nickname;
@property (nonatomic ,strong)UILabel *content;
@property (nonatomic ,strong)UIView *lineV;

@property (nonatomic ,strong)FriendModel*celldic;

@end
@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellModel = FriendCellNone;
        [self initializer];
    }
    return self;
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellModel = FriendCellNone;
        [self initializer];
    }
    return self;
}
-(void)initializer {
    self.avatar = [UIImageView new];
    self.avatar.layer.cornerRadius = 20;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:self.avatar];
    
    self.nickname = [UILabel new];
    self.nickname.textColor = [UIColor commonTextColor];
    self.nickname.font = [UIFont systemFontOfSize:14];
    self.nickname.text = @"ceshi";
    [self addSubview:self.nickname];

    self.content = [UILabel new];
    self.content.textColor = [UIColor annotationTextColor];
    self.content.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.content];

    self.rightBtn = [UIButton new];
    [self.rightBtn setTitle:@"邀请" forState:0];
    [self.rightBtn setTitleColor:[UIColor commonTextColor] forState:0];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.rightBtn.layer.cornerRadius = 5;
    self.rightBtn.layer.borderWidth = 1;
    self.rightBtn.layer.borderColor = UIColorFromRGB(0xe1e6f0).CGColor;
    self.rightBtn.layer.masksToBounds = YES;
    [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBtn];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor lineColor];
    [self addSubview:self.lineV];
}
-(void)setFriendDic:(FriendModel*)dic status:(FriendCellModel)model {
    self.cellModel = model;
    _celldic = dic;
    if (kNotNil(dic.img)) {
        if ([dic.img isKindOfClass:[NSString class]]){
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:dic.img Withtype:IMGAvatar]]];
        }else{
            [self.avatar setImage:[UIImage imageNamed:@"weitouxiang"]];
        }
    }else {
        [self.avatar setImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    if (kNotNil(dic.nickname)) {
        self.nickname.text = dic.nickname;
    }else{
        if (kNotNil(dic.name)) {
            self.nickname.text = dic.name;
        }else{
            self.nickname.text = @"匿名用户";
        }
    }
    if (self.cellModel ==FriendCellContent) {
        [self.content setHidden:NO];
        if (kNotNil(dic.createDate)) {
            NSString* string = [NSString stringWithFormat:@"%@ %@加入小喇叭",dic.name,[ZZCHelper dateStringFromString:dic.createDate type:1]];
            self.content.text = string;
        }else{
            self.content.text = @"--";
        }
    }else{
        [self.content setHidden:YES];
    }
    [self.nickname mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.cellModel !=FriendCellContent) {
            make.centerY.mas_equalTo(self);
        }else{
            make.top.mas_equalTo(15);
        }
        make.left.mas_equalTo(self.avatar.mas_right).with.offset(10);
        make.right.mas_equalTo(self.rightBtn.mas_left);
    }];
    if (self.cellModel !=FriendCellNoneGuanZhu) {
        if (kNotNil(dic.friends)) {
            if ([dic.friends isEqualToString:@"0"]) {
                [self.rightBtn setTitle:@"加好友" forState:0];
                [self.rightBtn setEnabled:YES];
            }else if ([dic.friends isEqualToString:@"1"]) {
                [self.rightBtn setTitle:@"等待验证" forState:0];
                [self.rightBtn setEnabled:NO];
            }else{
                [self.rightBtn setTitle:@"发消息" forState:0];
                [self.rightBtn setEnabled:YES];
            }
        }else{
            [self.rightBtn setTitle:@"邀请" forState:0];
            [self.rightBtn setEnabled:YES];
        }
    }
    [self layoutIfNeeded];
}

-(void)setFriendweiboDic:(FriendModel*)dic status:(FriendCellModel)model {
    self.cellModel = model;
    _celldic = dic;
    if (kNotNil(dic.img)) {
        if ([dic.img isKindOfClass:[UIImage class]]) {
            self.avatar.image = (UIImage*)dic.img;
        }else if ([dic.img isKindOfClass:[NSString class]]){
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:dic.img Withtype:IMGAvatar]]];
        }else{
            [self.avatar setImage:[UIImage imageNamed:@"weitouxiang"]];
        }
    }else{
        [self.avatar setImage:[UIImage imageNamed:@"weitouxiang"]];
    }

    if (kNotNil(dic.nickname)) {
        self.nickname.text = dic.nickname;
    }else{
        if (kNotNil(dic.name)) {
            self.nickname.text = dic.name;
        }else{
            self.nickname.text = @"匿名用户";
        }
    }
    
    [self.nickname mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.avatar.mas_right).with.offset(10);
        make.right.mas_equalTo(self.rightBtn.mas_left);
    }];
    if (kNotNil(dic.follows)) {
        if ([dic.follows isEqualToString:@"0"]) {
            [self.rightBtn setTitle:@"未关注" forState:0];
            [self.rightBtn setEnabled:YES];
        }else{
            [self.rightBtn setTitle:@"已关注" forState:0];
            [self.rightBtn setEnabled:YES];
        }
    }else{
        [self.rightBtn setTitle:@"邀请" forState:0];
        [self.rightBtn setEnabled:YES];
    }
    [self layoutIfNeeded];
}

-(void)setFriendModel:(XLBFindUserModel*)model  status:(FriendCellModel)cellModel {
    self.cellModel = cellModel;
    _celldic = [FriendModel new];
    _celldic.nickname = model.nickname;
    _celldic.userId = model.ID;
    _celldic.img = model.img;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:nil];
    self.nickname.text = model.nickname;
    if (self.cellModel ==FriendCellContent) {
        [self.content setHidden:NO];
    }else{
        [self.content setHidden:YES];
    }
    [self.nickname mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.cellModel !=FriendCellContent) {
            make.centerY.mas_equalTo(self);
        }else{
            make.top.mas_equalTo(15);
        }
        make.left.mas_equalTo(self.avatar.mas_right).with.offset(10);
        make.right.mas_equalTo(self.rightBtn.mas_left);
    }];
    if (self.cellModel !=FriendCellNoneGuanZhu) {
        if ([model.friends isEqualToString:@"0"]) {
            [self.rightBtn setTitle:@"加好友" forState:0];
            [self.rightBtn setEnabled:YES];
        }else if ([model.friends isEqualToString:@"1"]) {
            [self.rightBtn setTitle:@"等待验证" forState:0];
            [self.rightBtn setEnabled:NO];
        }else{
            [self.rightBtn setTitle:@"发消息" forState:0];
            [self.rightBtn setEnabled:YES];
        }
    }
    [self layoutIfNeeded];
}

-(void)rightBtnClick:(id)sender{
    if (self.delegate) {
        [self.rightBtn setEnabled:NO];
        [self.delegate friendCell:self addFriendDic:_celldic];
    }
}
-(void)layoutSubviews {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(15);
        make.left.mas_equalTo(self).with.offset(15);
        make.width.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self).with.offset(-15);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.cellModel !=FriendCellContent) {
            make.centerY.mas_equalTo(self);
        }else{
            make.top.mas_equalTo(15);
        }
        make.left.mas_equalTo(self.avatar.mas_right).with.offset(10);
        make.right.mas_equalTo(self.rightBtn.mas_left);
    }];
   
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickname);
        make.top.mas_equalTo(self.nickname.mas_bottom).with.offset(10);
        make.right.mas_equalTo(self.rightBtn.mas_left);
    }];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.mas_right).with.offset(-15);;
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(self);
    }];
}
@end
