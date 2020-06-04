//
//  VoiceActorCollectionViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceActorCollectionViewCell.h"
#import "XLBDEvaluateView.h"
@interface VoiceActorCollectionViewCell ()

@property (nonatomic, strong) UIView *statusV;
@property (nonatomic, strong) UIImageView *statusImg;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UIImageView *pickImg;
@property (nonatomic, strong) XLBDEvaluateView *evaluateV;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *signLabel;
//@property (nonatomic, strong) UIImageView *voiceImg;
@property (nonatomic, strong) UIView *videoV;
@property (nonatomic, strong) UILabel *videoLabel;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *callBtn;

@end


@implementation VoiceActorCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(VoiceActorListModel *)model {
    [self.pickImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.pick[0] Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickName.text = model.nickname;
    self.statusLabel.text = [NSString stringWithFormat:@"%@车币/分",model.priceAkira];
    [self.evaluateV insertSign:model.tags];
    if ([model.onlineType isEqualToString:@"2"]) {
        self.statusImg.backgroundColor = [UIColor shadeStartColor];
    }else{
        self.statusImg.backgroundColor = [UIColor whiteColor];
    }
    if (kNotNil(model.signature)) {
        self.signLabel.text = model.signature;
    }else {
        self.signLabel.text = @"还没有个性签名！";
    }
    
    if (([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) || (![XLBUser user].isLogin || !kNotNil([XLBUser user].token))) {
        if ([model.onlineType isEqualToString:@"2"]) {
            self.statusImg.backgroundColor = [UIColor shadeStartColor];
            self.statusLabel.text = @"在线";
        }else{
            self.statusImg.backgroundColor = [UIColor whiteColor];
            self.statusLabel.text = @"不在线";
        }
    }
    
    if (!kNotNil(model.voiceTime) || [model.voiceTime containsString:@"(null)"]) {
        self.videoLabel.text = @"0''";
    }
    self.videoLabel.text = [NSString stringWithFormat:@"%@''",model.voiceTime];
    _model = model;
}

- (void)setSubViews {
    self.pickImg = [UIImageView new];
    self.pickImg.image = [UIImage imageNamed:@""];
    self.pickImg.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.pickImg];
    
    self.statusV = [UIView new];
    self.statusV.backgroundColor = [[UIColor textBlackColor] colorWithAlphaComponent:0.5f];
    self.statusV.layer.masksToBounds = YES;
    self.statusV.layer.cornerRadius = 10;
    [self.contentView addSubview:self.statusV];
    
    self.statusImg = [UIImageView new];
    self.statusImg.layer.masksToBounds = YES;
    self.statusImg.layer.cornerRadius = 3;
    [self.statusV addSubview:self.statusImg];
    
    self.statusLabel = [UILabel new];
    self.statusLabel.text = @"45车币/分";
    self.statusLabel.font = [UIFont systemFontOfSize:11];
    self.statusLabel.textColor = [UIColor whiteColor];
    [self.statusV addSubview:self.statusLabel];
   
    
    self.nickName = [UILabel new];
    self.nickName.text = @"戴葛辉";
    self.nickName.textColor = [UIColor commonTextColor];
    self.nickName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nickName];
    
    self.evaluateV = [XLBDEvaluateView new];
    [self.evaluateV setFont:7];
    [self.evaluateV setlHeight:12];
    [self.evaluateV setLwidth:15];
    [self.evaluateV setRadius:2];
    [self.contentView addSubview:self.evaluateV];

    self.signLabel = [UILabel new];
    self.signLabel.text = @"世界就在我的手中";
    self.signLabel.textColor = [UIColor annotationTextColor];
    self.signLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.signLabel];
    
//    self.voiceImg = [UIImageView new];
//    self.voiceImg.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:self.voiceImg];
    
    self.videoV = [UIView new];
    self.videoV.layer.masksToBounds = YES;
    self.videoV.layer.cornerRadius = 8;
    self.videoV.backgroundColor = [[UIColor textBlackColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:self.videoV];
    
    self.videoImg = [UIImageView new];
    self.videoImg.layer.masksToBounds = YES;
    self.videoImg.layer.cornerRadius = 8;
    self.videoImg.image = [UIImage imageNamed:@"btn_sy_bf"];
    [self.videoV addSubview:self.videoImg];
    
    self.videoLabel = [UILabel new];
    self.videoLabel.text = @"19''";
    self.videoLabel.textColor = [UIColor whiteColor];
    self.videoLabel.font = [UIFont systemFontOfSize:9];
    self.videoLabel.textAlignment = NSTextAlignmentCenter;
    [self.videoV addSubview:self.videoLabel];
    
    self.videoBtn = [UIButton new];
    [self.videoBtn addTarget:self action:@selector(voiceCellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.videoBtn.tag = 10;
    [self.videoV addSubview:self.videoBtn];
    [self.videoBtn setEnlargeEdge:10];
    
    self.callBtn = [UIButton new];
    [self.callBtn setBackgroundImage:[UIImage imageNamed:@"icon_sy_th"] forState:0];
    [self.callBtn addTarget:self action:@selector(voiceCellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.callBtn.tag = 20;
    [self.callBtn setEnlargeEdge:10];
    [self.contentView addSubview:self.callBtn];
}
- (void)voiceCellBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(voiceActorCellDidSetedWith:voiceActorModel:voiceImg:)]) {
        [self.delegate voiceActorCellDidSetedWith:sender voiceActorModel:_model voiceImg:self.videoImg];
    }
//    if (sender.tag == 10) {
//        if (sender.selected) {
//            [self.videoImg setImage:[UIImage imageNamed:@"btn_sy_bf"]];
//        }else {
//            [self.videoImg setImage:[UIImage imageNamed:@"btn_st_zt"]];
//        }
//        sender.selected = ! sender.selected;
//    }
//    
}
- (void)layoutSubviews {
    [self.pickImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_width).with.offset(0);
    }];
    
    [self.statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusV.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.statusV.mas_centerY);
        make.width.height.mas_equalTo(6);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusImg.mas_right).with.offset(5);
        make.right.mas_equalTo(self.statusV.mas_right).with.offset(-5);
        make.centerY.mas_equalTo(self.statusV.mas_centerY).with.offset(0);
    }];
    
    [self.statusV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(5);
        make.left.mas_equalTo(self.statusImg.mas_left).with.offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pickImg.mas_bottom).with.offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(8);
        make.right.mas_lessThanOrEqualTo(self.evaluateV.mas_left).with.offset(-5);
    }];
    
    [self.evaluateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickName.mas_centerY).with.offset(0);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(70);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-5);
    }];
    
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_left).with.offset(0);
        make.top.mas_equalTo(self.nickName.mas_bottom).with.offset(5);
    }];
    
//    [self.voiceImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.signLabel.mas_bottom).with.offset(10);
//        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(20);
//    }];
    
    [self.videoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.nickName.mas_left).with.offset(0);
        make.width.mas_equalTo(47);
        make.height.mas_equalTo(16);
    }];
    
    [self.videoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.videoV.mas_left).with.offset(0);
        make.width.height.mas_equalTo(self.videoV.mas_height);
        make.centerY.mas_equalTo(self.videoV.mas_centerY).with.offset(0);
    }];
    
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.videoImg.mas_right).with.offset(0);
        make.right.mas_equalTo(self.videoV.mas_right).with.offset(0);
        make.centerY.mas_equalTo(self.videoV.mas_centerY).with.offset(0);
    }];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
        make.centerY.mas_equalTo(self.videoV.mas_centerY).with.offset(0);
    }];
}
+ (NSString *)voiceActorID {
    return @"voiceActorCollectionViewCellID";
}
@end
