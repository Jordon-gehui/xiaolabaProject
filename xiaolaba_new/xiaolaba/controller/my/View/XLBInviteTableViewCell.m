//
//  XLBInviteTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/11/30.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBInviteTableViewCell.h"

@interface XLBInviteTableViewCell ()

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *dateLabel;
@end


@implementation XLBInviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setModel:(XLBInviteModel *)model {
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickName.text = model.nickname;
    self.dateLabel.text = [self dateWithDateString:model.createDate];
    _model = model;
}

- (NSString *)dateWithDateString:(NSString *)dateString {
    
    if(kNotNil(dateString)) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        // 获取当前时间的年、月、日
        NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        // 获取消息发送时间的年、月、日
        NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000.0];
        components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
        // 判断
        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.dateFormat = @"yyyy/MM/dd";
        
        return [dateFmt stringFromDate:msgDate];
    }
    else {
        return @"";
    }
}

- (void)setSubViews {
    self.ranking = [UILabel new];
    self.ranking.layer.masksToBounds = YES;
    self.ranking.layer.cornerRadius = 9;
    self.ranking.textAlignment = NSTextAlignmentCenter;
    self.ranking.backgroundColor = [UIColor lightColor];
    self.ranking.textColor = [UIColor commonTextColor];
    self.ranking.font = [UIFont systemFontOfSize:10];//32  24
    [self.contentView addSubview:self.ranking];
    
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 18;
    [self.contentView addSubview:self.img];
    
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textColor = [UIColor commonTextColor];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.dateLabel];
    
    self.nickName = [UILabel new];
    self.nickName.textColor = [UIColor commonTextColor];
    self.nickName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nickName];
}



- (void)layoutSubviews {
    
    [self.ranking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(3);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(36);
        make.left.mas_equalTo(self.ranking.mas_right).with.offset(19*kiphone6_ScreenWidth);
        make.centerY.mas_equalTo(self.ranking.mas_centerY);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-3);
        make.centerY.mas_equalTo(self.ranking.mas_centerY);
    }];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_right).with.offset(21*kiphone6_ScreenWidth);
        make.centerY.mas_equalTo(self.ranking.mas_centerY);
        make.right.mas_equalTo(self.dateLabel.mas_left).with.offset(-3);
    }];
    
    
}

+ (NSString *)inviteCellID {
    return @"inviteCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
