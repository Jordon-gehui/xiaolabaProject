//
//  CallRecordsCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CallRecordsCell.h"
@interface CallRecordsCell()
{
    UIView *topbackView;
    UIImageView *headerImg;
    UILabel*nameLbl;
    UILabel *statusLbl;
    UIButton *callImg;
    UIView *lineV;
    UILabel *orderTimeLbl;
    UILabel *timeLbl;
    UILabel *orderContentLbl;
    UILabel *contentLbl;
    UILabel *callTimeLbl;
    UILabel *callLbl;
    UILabel *orderFreeLbl;
    UILabel *freeLbl;
    CallOrderModel *callmodel;
}
@end
@implementation CallRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    topbackView =[UIView new];
    topbackView.backgroundColor = [UIColor lineColor];
    [self addSubview:topbackView];
    
    headerImg= [UIImageView new];
    headerImg.layer.masksToBounds = YES;
    headerImg.layer.cornerRadius = 20;
    headerImg.image = [UIImage imageNamed:@"weitouxiang"];
    [headerImg setUserInteractionEnabled:YES];
    [self addSubview:headerImg];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImgClick)];
    [headerImg addGestureRecognizer:tap];
    
    nameLbl = [UILabel new];
    nameLbl.font = [UIFont systemFontOfSize:14];
    nameLbl.textColor = [UIColor commonTextColor];
    nameLbl.text = @"1344";
    [self addSubview:nameLbl];
    
    statusLbl = [UILabel new];
    statusLbl.font = [UIFont systemFontOfSize:14];
    statusLbl.textColor = [UIColor commonTextColor];
    statusLbl.textAlignment = NSTextAlignmentRight;
    statusLbl.text = @"待确认";
    [self addSubview:statusLbl];
    
    callImg= [UIButton new];
    [callImg setBackgroundImage:[UIImage imageNamed:@"icon_dd_dh"] forState:UIControlStateNormal];
    [callImg addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    callImg.hidden = YES;
    [self addSubview:callImg];
    [callImg setEnlargeEdge:10];
    if ([self.reuseIdentifier isEqualToString:@"cellDeatils"]) {
        callImg.hidden = NO;
        statusLbl.hidden = YES;
    }
    lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [self addSubview:lineV];
    orderTimeLbl = [UILabel new];
    orderTimeLbl.font = [UIFont systemFontOfSize:14];
    orderTimeLbl.textColor = [UIColor minorTextColor];
    orderTimeLbl.text = @"下单时间";
    [self addSubview:orderTimeLbl];
    
    timeLbl = [UILabel new];
    timeLbl.font = [UIFont systemFontOfSize:14];
    timeLbl.textColor = [UIColor minorTextColor];
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.text = @"3月15日 15:33:33";
    [self addSubview:timeLbl];
    callTimeLbl = [UILabel new];
    callTimeLbl.font = [UIFont systemFontOfSize:14];
    callTimeLbl.text = @"通话时长";
    callTimeLbl.textColor = [UIColor minorTextColor];
    [self addSubview:callTimeLbl];
    callLbl = [UILabel new];
    callLbl.font = [UIFont systemFontOfSize:14];
    callLbl.textColor = [UIColor minorTextColor];
    callLbl.textAlignment = NSTextAlignmentRight;
    callLbl.text = @"123s";
    [self addSubview:callLbl];
    orderContentLbl = [UILabel new];
    orderContentLbl.font = [UIFont systemFontOfSize:14];
    orderContentLbl.text = @"订单内容";
    orderContentLbl.textColor = [UIColor minorTextColor];
    [self addSubview:orderContentLbl];
    contentLbl = [UILabel new];
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.textColor = [UIColor minorTextColor];
    contentLbl.textAlignment = NSTextAlignmentRight;
    contentLbl.text = @"唱首歌";
    [self addSubview:contentLbl];
    orderFreeLbl = [UILabel new];
    orderFreeLbl.font = [UIFont systemFontOfSize:14];
    orderFreeLbl.textColor = [UIColor minorTextColor];
    orderFreeLbl.text = @"订单费用";
    [self addSubview:orderFreeLbl];
    freeLbl = [UILabel new];
    freeLbl.font = [UIFont systemFontOfSize:14];
    freeLbl.textColor = [UIColor minorTextColor];
    freeLbl.textAlignment = NSTextAlignmentRight;
    freeLbl.text = @"100车币";
    [self addSubview:freeLbl];
    
}
- (void)layoutSubviews {
    [topbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(10);
    }];
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(topbackView.mas_bottom).with.offset(15);
        make.width.height.mas_equalTo(40);
    }];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerImg);
        make.left.mas_equalTo(headerImg.mas_right).with.mas_offset(10);
    }];
    [statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerImg);
        make.right.mas_equalTo(self).mas_offset(-15);
    }];
    [callImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerImg);
        make.right.mas_equalTo(self).mas_offset(-15);
        make.width.height.mas_equalTo(20);
    }];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImg.mas_bottom).with.mas_offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [orderTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(headerImg.mas_bottom).with.mas_offset(15);
    }];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.mas_offset(-15);
        make.top.mas_equalTo(headerImg.mas_bottom).with.mas_offset(15);
    }];
    [orderContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(orderTimeLbl.mas_bottom).with.mas_offset(15);
    }];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.mas_offset(-15);
        make.top.mas_equalTo(orderTimeLbl.mas_bottom).with.mas_offset(15);
    }];
    [callTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(orderContentLbl.mas_bottom).with.mas_offset(15);
    }];
    [callLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.mas_offset(-15);
        make.top.mas_equalTo(orderContentLbl.mas_bottom).with.mas_offset(15);
    }];
    [orderFreeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(callTimeLbl.mas_bottom).with.mas_offset(15);
    }];
    [freeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.mas_offset(-15);
        make.top.mas_equalTo(callTimeLbl.mas_bottom).with.mas_offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).with.mas_offset(-15);
    }];
}
-(void)setViewData:(id)dic isPlace:(NSInteger)place{
    callmodel = dic;
    if (place == 1) {
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callmodel.calledImg Withtype:IMGPick]] placeholderImage:nil];
    }else {
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callmodel.callingImg Withtype:IMGPick]] placeholderImage:nil];
    }
    nameLbl.text = callmodel.nickname;
    timeLbl.text = [ZZCHelper dateStringFromNumberTimer:callmodel.createDate type:2];
    contentLbl.text = @"语音通话";
    
    NSString *callTimeStr ;
    NSInteger callTime = [callmodel.huanxinTime integerValue];
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
    
    callLbl.text = callTimeStr;
    if (place == 1) {
        freeLbl.text = [NSString stringWithFormat:@"%@车币",callmodel.money];
    }else {
        freeLbl.text = [NSString stringWithFormat:@"%@车票",callmodel.money];
    }
    if ([callmodel.status isEqualToString:@"0"]) {
        statusLbl.text = @"待确认";
    }else if([callmodel.status isEqualToString:@"1"]){
        statusLbl.text = @"已通话";
    }else{
        statusLbl.text = @"无人接听";
    }
    if ([callmodel.remarks isEqualToString:@"3"]) {
        callImg.hidden = NO;
    }else {
        callImg.hidden = YES;
    }
//    statusLbl
    [self layoutIfNeeded];
}
-(void)setViewData:(id)dic issecectCalling:(NSInteger)calling {
    callmodel = dic;
    if (calling ==1) {
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callmodel.calledImg Withtype:IMGPick]] placeholderImage:nil];
        orderFreeLbl.text = @"通话支出";
        freeLbl.text = [NSString stringWithFormat:@"%@车币",callmodel.money];
    }else{
        orderFreeLbl.text = @"通话收益";
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:callmodel.callingImg Withtype:IMGPick]] placeholderImage:nil];
        freeLbl.text = [NSString stringWithFormat:@"%@车票",callmodel.money];

    }
    nameLbl.text = callmodel.nickname;
    timeLbl.text = [ZZCHelper dateStringFromNow:callmodel.createDate];
    NSString *callTimeStr ;
    NSInteger callTime = [callmodel.huanxinTime integerValue];
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
    
    callLbl.text = callTimeStr;
    contentLbl.text = @"语音通话";
    if ([callmodel.status isEqualToString:@"0"]) {
        statusLbl.text = @"待确认";
    }else if([callmodel.status isEqualToString:@"1"]){
        statusLbl.text = @"已通话";
    }else{
        statusLbl.text = @"无人接听";
    }
    //    statusLbl
    [self layoutIfNeeded];
}

-(void) headerImgClick {
    if (self.delegate) {
        [self.delegate callHeaderImgClick:callmodel.calledId issy:callmodel.remarks];
    }
}
- (void)callBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(callBtnClickWithModel:)]) {
        [self.delegate callBtnClickWithModel:callmodel];
    }
}
+(NSString *)cellReuseIdentifier {
    return @"CellRecordsCell";
}

+(NSString *)cellDeatilsIdentifier {
    return @"cellDeatils";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
