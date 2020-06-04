//
//  OwnerVoiceActorTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "OwnerVoiceActorTableViewCell.h"

@interface OwnerVoiceActorTableViewCell ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *completingRate;
@property (nonatomic, strong) UILabel *callTime;
@property (nonatomic, strong) UILabel *reputationLabel;
@property (nonatomic, strong) UILabel *status;
//@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *statusV;
@property (nonatomic, strong) UIImageView *statusImg;
@property (nonatomic, strong) UILabel *priceLabel;


@end

@implementation OwnerVoiceActorTableViewCell

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

- (void)setVoiceModel:(XLBVoiceActorModel *)voiceModel {
    if (!kNotNil(voiceModel.akiraCountModel.connectionRate)) {
        self.completingRate.text = @"接通率：0";
    }else {
        self.completingRate.text = [NSString stringWithFormat:@"接通率：%@",voiceModel.akiraCountModel.connectionRate];
    }
    if (!kNotNil(voiceModel.akiraCountModel.conversationTime)) {
        self.callTime.text = @"累计通话时长：0分钟";
    }else {
        NSString *callTimeStr ;
        NSInteger callTime = [voiceModel.akiraCountModel.conversationTime integerValue];
        if (callTime>3600) {
            NSInteger hour = callTime/3600;
            NSInteger mod = callTime%3600;
            NSInteger minute = mod/60;
            mod = mod%60;
            callTimeStr = [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒",hour,minute,mod];
        }else if (callTime>60&&callTime<=3600){
            NSInteger minute = callTime/60;
            NSInteger mod = callTime%60;
            callTimeStr = [NSString stringWithFormat:@"%ld分钟%ld秒",minute,mod];
        }else{
            callTimeStr = [NSString stringWithFormat:@"%ld秒",callTime];
        }
        self.callTime.text = [NSString stringWithFormat:@"累计通话时长:%@",callTimeStr];
    }
    if (!kNotNil(voiceModel.akiraCountModel.praiseRate)) {
        self.reputationLabel.text = @"好评率：0";
    }else {
        self.reputationLabel.text = [NSString stringWithFormat:@"好评率：%@",voiceModel.akiraCountModel.praiseRate];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%@车币/分",voiceModel.akiraModel.priceAkira];
    if ([voiceModel.akiraModel.onlineType isEqualToString:@"2"]) {
        self.statusImg.backgroundColor = [UIColor shadeStartColor];
    }else {
        self.statusImg.backgroundColor = [UIColor whiteColor];
    }
    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
        if ([voiceModel.akiraModel.onlineType isEqualToString:@"2"]) {
            self.statusImg.backgroundColor = [UIColor shadeStartColor];
            self.priceLabel.text = @"在线";
        }else {
            self.statusImg.backgroundColor = [UIColor whiteColor];
            self.priceLabel.text = @"不在线";
        }
    }
    _voiceModel = voiceModel;
}
- (void)setSubViews {
    self.topLabel = [UILabel new];
    self.topLabel.text = @"语音通话信息";
    self.topLabel.textColor = [UIColor commonTextColor];
    self.topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self addSubview:self.topLabel];
    
    self.completingRate = [UILabel new];
    self.completingRate.text = @"接通率：100%";
    self.completingRate.textColor = [UIColor commonTextColor];
    self.completingRate.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.completingRate];
    
    self.callTime = [UILabel new];
    self.callTime.text = @"累计通话时长：99分钟";
    self.callTime.textColor = [UIColor commonTextColor];
    self.callTime.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.callTime];
    
    self.reputationLabel = [UILabel new];
    self.reputationLabel.text = @"好评率：99%";
    self.reputationLabel.textColor = [UIColor commonTextColor];
    self.reputationLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.reputationLabel];
    
//    self.status = [UILabel new];
//    self.status.text = @"在线";
//    self.status.textColor = RGB(138, 143, 153);
//    self.status.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.status];
    
    self.statusV = [UIView new];
    self.statusV.backgroundColor = [[UIColor textBlackColor] colorWithAlphaComponent:0.5];
    self.statusV.layer.masksToBounds = YES;
    self.statusV.layer.cornerRadius = 10;
    [self.contentView addSubview:self.statusV];
    
    self.statusImg = [UIImageView new];
    self.statusImg.layer.masksToBounds = YES;
    self.statusImg.layer.cornerRadius = 3;
    [self.statusV addSubview:self.statusImg];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"45车币/分";
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    self.priceLabel.textColor = [UIColor whiteColor];
    [self.statusV addSubview:self.priceLabel];
    
    
    self.checkBtn = [UIButton new];
    [self.checkBtn setTitle:@"查看评价 >" forState:UIControlStateNormal];
    [self.checkBtn setTitleColor:[UIColor shadeStartColor] forState:UIControlStateNormal];
    self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.checkBtn];
//    self.priceLabel = [UILabel new];
//    self.priceLabel.text = @"30车币/分";
//    self.priceLabel.textColor = RGB(138, 143, 153);
//    self.priceLabel.font = [UIFont systemFontOfSize:14];
//    [self addSubview:self.priceLabel];

}

- (void)layoutSubviews {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.completingRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(30);
    }];
    
    [self.callTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.completingRate.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.completingRate.mas_left).with.offset(0);
    }];
    
    [self.reputationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.callTime.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.completingRate.mas_left).with.offset(0);
    }];
    
    [self.statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusV.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.statusV.mas_centerY);
        make.width.height.mas_equalTo(6);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusImg.mas_right).with.offset(5);
        make.right.mas_equalTo(self.statusV.mas_right).with.offset(-5);
        make.centerY.mas_equalTo(self.statusV.mas_centerY).with.offset(0);
    }];
    
    [self.statusV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(25);
        make.left.mas_equalTo(self.statusImg.mas_left).with.offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-26);
        make.height.mas_equalTo(20);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reputationLabel.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.mas_right).with.offset(-26);
    }];
    
//    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(22);
//        make.right.mas_equalTo(self.mas_right).with.offset(-27);
//    }];
//
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.status.mas_bottom).with.offset(5);
//        make.centerX.mas_equalTo(self.status.mas_centerX).with.offset(0);
//    }];
}
+ (NSString *)voiceAcotrTableViewCellID {
    return @"voiceAcotrTableViewCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
