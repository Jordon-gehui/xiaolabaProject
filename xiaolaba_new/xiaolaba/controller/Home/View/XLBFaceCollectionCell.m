//
//  XLBFaceCollectionCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/23.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBFaceCollectionCell.h"
@interface XLBFaceCollectionCell ()

@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UIImageView *userImg;
@property (nonatomic, strong)UILabel *nickName;
@property (nonatomic, strong)UIButton *praiseBtn;
@property (nonatomic, strong)UILabel *praiseCountLabel;

@end
@implementation XLBFaceCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        [self setSubViews];
    }
    return self;
}
- (void)setModel:(FaceListModel *)model {
    if (kNotNil(model.pick)) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.pick[0] Withtype:IMGMoment]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickName.text = model.nickname;
    [self.evaluateV insertSign:model.tags];
    self.praiseCountLabel.text = model.likeSum;
    if ([model.liked isEqualToString:@"0"] || !kNotNil(model.liked)) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_gz"] forState:0];
    }else {
        [self.praiseBtn setImage:[UIImage imageNamed:@"icon_gz_m"] forState:0];
    }
//    if ([model.liked isEqualToString:@"1"]) {
//    }
    _model = model;
}
- (void)setIndex:(NSInteger)index {
    
    self.praiseBtn.tag = index;
    _index = index;
}

- (void)setSubViews {

    self.img = [UIImageView new];
    self.img.image = [UIImage imageNamed:@"1"];
    [self.contentView addSubview:self.img];
    
    self.userImg = [UIImageView new];
    self.userImg.image = [UIImage imageNamed:@"weitouxiang"];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 22;
    [self.contentView addSubview:self.userImg];
    
    self.nickName = [UILabel new];
    self.nickName.font = [UIFont systemFontOfSize:14];
    self.nickName.textColor = [UIColor textBlackColor];
    [self.contentView addSubview:self.nickName];
    
    self.evaluateV = [XLBDEvaluateView new];
    [self.evaluateV setFont:7];
    [self.evaluateV setlHeight:12];
    [self.evaluateV setLwidth:15];
    [self.evaluateV setRadius:2];
    [self.contentView addSubview:self.evaluateV];
    
    self.praiseBtn = [UIButton new];
    [self.praiseBtn setEnlargeEdge:10];
    [self.praiseBtn setImage:[UIImage imageNamed:@"icon_gz"] forState:0];
    [self.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.praiseBtn];
    
    self.praiseCountLabel = [UILabel new];
    self.praiseCountLabel.font = [UIFont systemFontOfSize:11];
    self.praiseCountLabel.textColor = [UIColor textBlackColor];
    self.praiseCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.praiseCountLabel];
    
}

 - (void)praiseBtnClick:(UIButton *)sender {
     if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
         if ([self.delegate respondsToSelector:@selector(seletedItemWithFaceModel:index:)]) {
             [self.delegate seletedItemWithFaceModel:_model index:sender.tag];
         }
         return;
     }
     if ([_model.liked isEqualToString:@"1"] || !kNotNil(_model.liked)) {
         [UIView animateWithDuration:0.5 animations:^{
             sender.transform = CGAffineTransformMakeScale(0.5, 0.5);
         } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.5 animations:^{
                 sender.transform = CGAffineTransformMakeScale(1.4, 1.4);
             } completion:^(BOOL finished) {
                 [UIView animateWithDuration:0.3 animations:^{
                     sender.transform = CGAffineTransformMakeScale(1, 1);
                 } completion:^(BOOL finished) {
                     
                 }];
             }];
         }];
         return;
     };
     if ([self.delegate respondsToSelector:@selector(seletedItemWithFaceModel:index:)]) {
         [self.delegate seletedItemWithFaceModel:_model index:sender.tag];
     }
 }
     
- (void)layoutSubviews {
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.width);
    }];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_bottom).with.offset(-15);
        make.left.mas_equalTo(self.img.mas_left).with.offset(5);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.userImg.mas_bottom).with.offset(0);
        make.right.mas_lessThanOrEqualTo(self.praiseBtn.mas_right).with.offset(-15);
        make.left.mas_equalTo(self.userImg.mas_right).with.offset(5);
    }];
    
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickName.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.img.mas_right).with.offset(-15);
        
    }];
    
    [self.evaluateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_bottom).with.offset(10);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.userImg.mas_left).with.offset(10);
    }];
    
    [self.praiseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.praiseBtn.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.praiseBtn.mas_centerX);
    }];
}

+ (NSString *)faceCollectionCellID {
    return @"faceCollectionCellID";
}

@end
