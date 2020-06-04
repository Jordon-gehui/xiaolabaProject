//
//  CheTieCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/7/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CheTieCell.h"
@interface CheTieCell()
{
    UIView *backView;
    UILabel *orderNoL;
    UILabel *orderNameL;
    UILabel *dataLabel;
    UILabel *orderPriceL;
    UILabel *orderNumL;
    UILabel *orderTotal;
    UIView *lineView;
    UILabel *recipientsL;
    UILabel *phoneNoL;
    UILabel *addressL;
    UILabel *payMethodL;
    UILabel *payL;
}
@end
@implementation CheTieCell

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
    self.backgroundColor = [UIColor clearColor];
    backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    orderNoL = [UILabel new];
    orderNoL.font = [UIFont systemFontOfSize:14];
    orderNoL.textColor = [UIColor minorTextColor];
    orderNoL.text = @"订单号： 12381948204";
    [backView addSubview:orderNoL];
    
    orderNameL = [UILabel new];
    orderNameL.font = [UIFont systemFontOfSize:14];
    orderNameL.textColor = [UIColor minorTextColor];
    orderNameL.text = @"小喇叭挪车贴";
    [backView addSubview:orderNameL];
    
    dataLabel = [UILabel new];
    dataLabel.font = [UIFont systemFontOfSize:14];
    dataLabel.textColor = [UIColor minorTextColor];
    dataLabel.text = @"时间： 2017-07-17";
    [backView addSubview:dataLabel];
    
    orderPriceL = [UILabel new];
    orderPriceL.font = [UIFont systemFontOfSize:14];
    orderPriceL.textColor = [UIColor minorTextColor];
    orderPriceL.text = @"单价： 10元";
    [backView addSubview:orderPriceL];
    
    orderNumL = [UILabel new];
    orderNumL.font = [UIFont systemFontOfSize:14];
    orderNumL.textColor = [UIColor minorTextColor];
    orderNumL.text = @"数量： 4";
    [backView addSubview:orderNumL];
    
    orderTotal = [UILabel new];
    orderTotal.font = [UIFont systemFontOfSize:14];
    orderTotal.textColor = [UIColor minorTextColor];
    orderTotal.text = @"总价： 40元";
    [backView addSubview:orderTotal];
    
    lineView = [UIView new];
    lineView.backgroundColor = [UIColor lineColor];
    [backView addSubview:lineView];
    
    recipientsL = [UILabel new];
    recipientsL.font = [UIFont systemFontOfSize:14];
    recipientsL.textColor = [UIColor minorTextColor];
    recipientsL.text = @"收件人： 彭于晏";
    [backView addSubview:recipientsL];
    
    phoneNoL = [UILabel new];
    phoneNoL.font = [UIFont systemFontOfSize:14];
    phoneNoL.textColor = [UIColor minorTextColor];
    phoneNoL.text = @"电话号码： 13747372828";
    [backView addSubview:phoneNoL];
    
    addressL = [UILabel new];
    addressL.font = [UIFont systemFontOfSize:14];
    addressL.textColor = [UIColor minorTextColor];
    addressL.numberOfLines = 0;
    addressL.text = @"收货地址： 上海市普陀区万达广场8号楼902";
    [backView addSubview:addressL];
    
    payMethodL = [UILabel new];
    payMethodL.font = [UIFont systemFontOfSize:14];
    payMethodL.textColor = [UIColor minorTextColor];
    payMethodL.text = @"支付方式： 支付宝支付";
    [backView addSubview:payMethodL];
    
    payL = [UILabel new];
    payL.font = [UIFont systemFontOfSize:14];
    payL.textColor = [UIColor redColor];
    payL.text = @"未支付";
    [backView addSubview:payL];
}

- (void)layoutSubviews {
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(5);
        make.left.mas_equalTo(self).with.offset(15);
        make.right.mas_equalTo(self).with.offset(-15);
        make.bottom.mas_equalTo(self).with.offset(-5);
        make.bottom.mas_equalTo(payMethodL.mas_bottom).with.offset(10);
    }];
    [orderNoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(backView).with.offset(15);
    }];
    [orderNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderNoL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView).with.offset(15);
    }];
    [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderNoL.mas_bottom).with.offset(10);
        make.right.mas_equalTo(backView.mas_right).with.offset(-15);
    }];
    
    [orderPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderNameL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView.mas_left).with.offset(15);
    }];
    [orderNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderPriceL);
        make.centerX.mas_equalTo(backView);
    }];
    [orderTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderPriceL);
        make.right.mas_equalTo(backView).with.offset(-15);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderTotal.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView).with.offset(15);
        make.right.mas_equalTo(backView).with.offset(-15);
        make.height.mas_equalTo(1);
    }];
    [recipientsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView).with.offset(15);
    }];
    [phoneNoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(recipientsL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView).with.offset(15);
    }];
    [addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneNoL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView).with.offset(15);
        make.right.mas_equalTo(backView).with.offset(-15);
    }];
    [payMethodL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(backView).with.offset(15);
    }];
    [payL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressL.mas_bottom).with.offset(10);
        make.left.mas_equalTo(payMethodL.mas_right).with.offset(15);
    }];
    [self layoutIfNeeded];
}

-(void)setData:(NSDictionary*)dic{
    NSLog(@"%@",dic);
    orderNoL.text = [NSString stringWithFormat:@"订单号： %@",[dic objectForKey:@"orderNo"]];
    orderNameL.text = @"小喇叭挪车贴";
    orderPriceL.text = [NSString stringWithFormat:@"单价： 10元"];
    orderTotal.text = [NSString stringWithFormat:@"总共： %@元",[dic objectForKey:@"money"]];
    
    orderNumL.text = [NSString stringWithFormat:@"数量： %ld",[[dic objectForKey:@"money"] integerValue]/[[dic objectForKey:@"price"] integerValue]];
    dataLabel.text = [NSString stringWithFormat:@"时间： %@",[ZZCHelper dateStringFromNumberTimer:[dic objectForKey:@"createDate"] type:2]];
    if (kNotNil([dic objectForKey:@"userName"])) {
        recipientsL.text =[NSString stringWithFormat:@"收件人： %@",[dic objectForKey:@"userName"]];
    }else{
        recipientsL.text =[NSString stringWithFormat:@"收件人： 匿名用户"];
    }
    phoneNoL.text = [NSString stringWithFormat:@"电话号码： %@",[dic objectForKey:@"mobile"]];
    NSString *address = [NSString stringWithFormat:@"收货地址： %@%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"],[dic objectForKey:@"district"],[dic objectForKey:@"address"]];
    addressL.text = address;
    NSInteger intert = [[dic objectForKey:@"status"] integerValue];
    if (intert==0) {
        [payL setHidden:NO];
    }else{
        [payL setHidden:YES];
    }
    [self layoutIfNeeded];
}
+(NSString *)cellReuseIdentifier {
    return @"CheTieCell";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
