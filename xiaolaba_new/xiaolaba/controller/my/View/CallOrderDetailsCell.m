//
//  CallRecordsCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CallOrderDetailsCell.h"
@interface CallOrderDetailsCell()
{
    UIImageView *headerImg;
    UILabel*nameLbl;
    UIImageView *callImg;
    
    UILabel *orderTimeLbl;
    UILabel *timeLbl;
    UILabel *orderContentLbl;
    UILabel *contentLbl;
    UILabel *orderFreeLbl;
    UILabel *freeLbl;
    UILabel *orderPayLbl;
    UILabel *payLbl;
    
    UILabel *orderRefundLbl;
    UILabel *orderMoneyLbl;
    UILabel *moneyLbl;
    UILabel *orderStatusLbl;
    UILabel *statusLbl;
}
@end
@implementation CallOrderDetailsCell

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
    headerImg= [UIImageView new];
    headerImg.layer.masksToBounds = YES;
    headerImg.layer.cornerRadius = 20;
    headerImg.image = [UIImage imageNamed:@"weitouxiang"];
    [self addSubview:headerImg];
    
    nameLbl = [UILabel new];
    nameLbl.font = [UIFont systemFontOfSize:14];
    nameLbl.textColor = [UIColor commonTextColor];
    nameLbl.text = @"1344";
    [self addSubview:nameLbl];
    
    callImg=[UIImageView new];
    [self addSubview:callImg];
    orderTimeLbl = [UILabel new];
    orderTimeLbl.font = [UIFont systemFontOfSize:14];
    orderTimeLbl.textColor = [UIColor commonTextColor];
    orderTimeLbl.text = @"下单时间";
    [self addSubview:orderTimeLbl];
    
    timeLbl = [UILabel new];
    timeLbl.font = [UIFont systemFontOfSize:14];
    timeLbl.textColor = [UIColor commonTextColor];
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.text = @"3月15日 15:33:33";
    [self addSubview:timeLbl];
    orderContentLbl = [UILabel new];
    orderContentLbl.font = [UIFont systemFontOfSize:14];
    orderContentLbl.text = @"订单内容";
    orderContentLbl.textColor = [UIColor commonTextColor];
    [self addSubview:orderContentLbl];
    contentLbl = [UILabel new];
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.textColor = [UIColor commonTextColor];
    contentLbl.textAlignment = NSTextAlignmentRight;
    contentLbl.text = @"唱首歌";
    [self addSubview:contentLbl];
    orderFreeLbl = [UILabel new];
    orderFreeLbl.font = [UIFont systemFontOfSize:14];
    orderFreeLbl.textColor = [UIColor commonTextColor];
    orderFreeLbl.text = @"订单费用";
    [self addSubview:orderFreeLbl];
    freeLbl = [UILabel new];
    freeLbl.font = [UIFont systemFontOfSize:14];
    freeLbl.textColor = [UIColor commonTextColor];
    freeLbl.textAlignment = NSTextAlignmentRight;
    freeLbl.text = @"100车币";
    [self addSubview:freeLbl];
        orderPayLbl = [UILabel new];
    orderPayLbl.font = [UIFont systemFontOfSize:14];
    orderPayLbl.textColor = [UIColor commonTextColor];
    orderPayLbl.text = @"  支付";
    [self addSubview:orderPayLbl];
    payLbl = [UILabel new];
    payLbl.font = [UIFont systemFontOfSize:14];
    payLbl.textColor = [UIColor commonTextColor];
    payLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:payLbl];
    
    orderRefundLbl = [UILabel new];
    orderRefundLbl.font = [UIFont systemFontOfSize:14];
    orderRefundLbl.textColor = [UIColor commonTextColor];
    orderRefundLbl.text = @"退款详情";
    [self addSubview:orderRefundLbl];
    orderMoneyLbl = [UILabel new];
    orderMoneyLbl.font = [UIFont systemFontOfSize:14];
    orderMoneyLbl.textColor = [UIColor commonTextColor];
    orderMoneyLbl.text = @"退款金额";
    [self addSubview:orderMoneyLbl];
    moneyLbl = [UILabel new];
    moneyLbl.font = [UIFont systemFontOfSize:14];
    moneyLbl.textColor = [UIColor commonTextColor];
    moneyLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLbl];
    orderStatusLbl = [UILabel new];
    orderStatusLbl.font = [UIFont systemFontOfSize:14];
    orderStatusLbl.textColor = [UIColor commonTextColor];
    orderStatusLbl.text = @"退款状态";
    [self addSubview:orderStatusLbl];
    statusLbl = [UILabel new];
    statusLbl.font = [UIFont systemFontOfSize:14];
    statusLbl.textColor = [UIColor commonTextColor];
    statusLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:statusLbl];
    
}
- (void)layoutSubviews {
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
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
    [orderFreeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(orderContentLbl.mas_bottom).with.mas_offset(15);
    }];
    [freeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).with.mas_offset(-15);
        make.top.mas_equalTo(orderContentLbl.mas_bottom).with.mas_offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).with.mas_offset(-15);
    }];
}
-(void)setViewData:(id)dic {
    
}

+(NSString *)cellReuseIdentifier {
    return @"CallOrderDeatilsCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

