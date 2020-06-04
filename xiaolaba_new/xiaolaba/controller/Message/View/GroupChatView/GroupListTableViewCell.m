//
//  GroupListTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/6.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "GroupListTableViewCell.h"


@interface GroupListTableViewCell ()


@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *img;

@end
@implementation GroupListTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModel:(XLBGroupListModel *)model {
    _model = model;
    NSString *nick;
    if (model.nickname.length > 15) {
        nick = [NSString stringWithFormat:@"%@...",[model.nickname substringWithRange:NSMakeRange(0, 15)]];
    }else {
        nick = model.nickname;
    }
    self.nickName.text = nick;
    [self.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];

}
- (void)setGroup:(EMGroup *)group {
    _group = group;
    NSString *nick;
    if (group.subject.length > 15) {
        nick = [NSString stringWithFormat:@"%@...",[group.subject substringWithRange:NSMakeRange(0, 15)]];
    }else {
        nick = group.subject;
    }
    self.nickName.text = nick;
    NSLog(@"%@",@{@"groupHuanxin":group.groupId});
    [[NetWorking network] POST:kSearchGroup params:@{@"groupHuanxin":group.groupId} cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if (kNotNil(result)) {
            [self.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[result objectForKey:@"groupImg"] Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        }else {
            self.img.image = [UIImage imageNamed:@"weitouxiang"];
        }
    } failure:^(NSString *description) {
        self.img.image = [UIImage imageNamed:@"weitouxiang"];
    }];
}

- (void)setSubViews {
    self.nickName = [UILabel new];
    self.nickName.font = [UIFont systemFontOfSize:15];
    self.nickName.textColor = [UIColor colorWithR:66 g:66 b:66];
    [self.contentView addSubview:self.nickName];
    
    self.line = [UILabel new];
    self.line.backgroundColor = [UIColor viewBackColor];
    [self.contentView addSubview:self.line];
    
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 25;
    [self.contentView addSubview:self.img];
}
- (void)layoutSubviews {
    kWeakSelf(self);
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    
    [weakSelf.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.img.mas_right).with.offset(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf.img.mas_centerY);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)groupListTableViewCellID {
    return @"groupListTableViewCellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
