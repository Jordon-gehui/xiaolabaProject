//
//  PayCheTieView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/7/13.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "PayCheTieView.h"
#import "XLBAreaSelectView.h"

@interface PayCheTieView ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSInteger count;
    PayCheTieViewType viewType;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topImg;
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *reduceBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIView *nameV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *phoneV;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIView *adressV;
@property (nonatomic, strong) UILabel *adressLeftLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation PayCheTieView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor viewBackColor];
        count = 1;
        [self setSubViewsWithType:PayCheTieBuy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(PayCheTieViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        viewType = type;
        self.backgroundColor = [UIColor viewBackColor];
        count = 1;
        [self setSubViewsWithType:type];
    }
    return self;
}
- (void)setModel:(PayCheTieModel *)model {
    _model = model;
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.productUrl Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"cheTieImg"]];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
}
- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        if (count == 1) return;
        count-=1;
    }else if (sender.tag == 200) {
        count+=1;
    }else {
        if ([self.delegate respondsToSelector:@selector(payCheTieViewBtnClick:count:)]) {
            [self.delegate payCheTieViewBtnClick:sender count:count];
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%ld",count * [self.model.price intValue]];
}
- (void)tapGer {
    if ([self.delegate respondsToSelector:@selector(seletedCity)]) {
        [self.delegate seletedCity];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [self endEditing:YES];
        [self.adressTextView resignFirstResponder];
        
        return NO;
    }
    return YES;
    
}

- (void)setSubViewsWithType:(PayCheTieViewType)type {
    self.topImg = [UIImageView new];
    self.topImg.image = [UIImage imageNamed:@"cheTieImg"];
    [self addSubview:self.topImg];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.bgView.layer.mask = maskLayer;
    
    self.topV = [UIView new];
    self.topV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.topV];
    
    
    self.leftLabel = [UILabel new];
    self.leftLabel.text = @"挪车贴";
    self.leftLabel.textColor = [UIColor commonTextColor];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.topV addSubview:self.leftLabel];
    
    self.reduceBtn = [UIButton new];
    [self.reduceBtn setBackgroundImage:[UIImage imageNamed:@"sub_round_high"] forState:UIControlStateNormal];
    self.reduceBtn.tag = 100;
    [self.reduceBtn setEnlargeEdge:10];
    [self.reduceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.reduceBtn];
    
    self.countLabel = [UILabel new];
    self.countLabel.font = [UIFont systemFontOfSize:15];
    self.countLabel.text = @"1";
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.textColor = [UIColor commonTextColor];
    [self.topV addSubview:self.countLabel];
    
    self.addBtn = [UIButton new];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add_round"] forState:UIControlStateNormal];
    self.addBtn.tag = 200;
    [self.addBtn setEnlargeEdge:10];
    [self.addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topV addSubview:self.addBtn];
    
    self.nameV = [UIView new];
    self.nameV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.nameV];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"收件人";
    self.nameLabel.textColor = [UIColor commonTextColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.nameV addSubview:self.nameLabel];
    
    self.nameTextField = [UITextField new];
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.placeholder = @"请输入收件人姓名";
    self.nameTextField.textColor = [UIColor colorWithR:166 g:166 b:166];
    self.nameTextField.font = [UIFont systemFontOfSize:15];
    [self.nameV addSubview:self.nameTextField];
    
    self.phoneV = [UIView new];
    self.phoneV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.phoneV];
    
    self.phoneLabel = [UILabel new];
    self.phoneLabel.text = @"手机号码";
    self.phoneLabel.textColor = [UIColor commonTextColor];
    self.phoneLabel.font = [UIFont systemFontOfSize:15];
    self.phoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.phoneV addSubview:self.phoneLabel];
    
    self.phoneTextField = [UITextField new];
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.placeholder = @"请输入收件人联系方式";
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.textColor = [UIColor colorWithR:166 g:166 b:166];
    self.phoneTextField.font = [UIFont systemFontOfSize:15];
    [self.phoneV addSubview:self.phoneTextField];
    
    self.adressV = [UIView new];
    self.adressV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.adressV];
    
    self.adressLeftLabel = [UILabel new];
    self.adressLeftLabel.text = @"收件地址";
    self.adressLeftLabel.textColor = [UIColor commonTextColor];
    self.adressLeftLabel.font = [UIFont systemFontOfSize:15];
    self.adressLeftLabel.textAlignment = NSTextAlignmentLeft;
    [self.adressV addSubview:self.adressLeftLabel];
    
    self.adressLabel = [UILabel new];
    self.adressLabel.text = @"请选择收件地址";
    self.adressLabel.textColor = [UIColor colorWithR:166 g:166 b:166];
    self.adressLabel.font = [UIFont systemFontOfSize:15];
    self.adressLabel.textAlignment = NSTextAlignmentLeft;
    [self.adressV addSubview:self.adressLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGer)];
    [self.adressV addGestureRecognizer:tap];
    
    self.adressTextView = [SZTextView new];
    self.adressTextView.placeholder = @"请填写详细地址";
    self.adressTextView.returnKeyType = UIReturnKeyDone;
    self.adressTextView.font = [UIFont systemFontOfSize:16];
    self.adressTextView.delegate = self;
    [self.bgView addSubview:self.adressTextView];
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor lineColor];
    [self.topV addSubview:self.line];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = [UIColor lineColor];
    [self.nameV addSubview:self.line1];
    
    self.line2 = [UIView new];
    self.line2.backgroundColor = [UIColor lineColor];
    [self.phoneV addSubview:self.line2];
    
    self.line3 = [UIView new];
    self.line3.backgroundColor = [UIColor lineColor];
    [self.adressV addSubview:self.line3];
    if (type == PayCheTieBuy) {
        self.bottomV = [UIView new];
        self.bottomV.backgroundColor = [UIColor textBlackColor];
        [self addSubview:self.bottomV];
        
        self.payBtn = [UIButton new];
        [self.payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        [self.payBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [self.payBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.payBtn.backgroundColor = [UIColor lightColor];
        self.payBtn.tag = PayCheTieViewBuyBtn;
        [self.bottomV addSubview:self.payBtn];
        
        self.bottomLabel = [UILabel new];
        self.bottomLabel.text = @"合计:";
        self.bottomLabel.font = [UIFont systemFontOfSize:18];
        self.bottomLabel.textColor = [UIColor whiteColor];
        [self.bottomV addSubview:self.bottomLabel];
        
        self.moneyLabel = [UILabel new];
        self.moneyLabel.text = @"￥10";
        self.moneyLabel.font = [UIFont systemFontOfSize:20];
        self.moneyLabel.textColor = [UIColor lightColor];
        [self.bottomV addSubview:self.moneyLabel];
    }else if (type == PayCheTieChargeType) {
        self.reduceBtn.hidden = YES;
        self.addBtn.hidden = YES;
        self.reduceBtn.enabled = NO;
        self.addBtn.enabled = NO;
        self.commitBtn = [UIButton new];
        [self.commitBtn setTitle:@"免费领取" forState:UIControlStateNormal];
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitBtn.backgroundColor = [UIColor lightColor];
        self.commitBtn.tag = PayCheTieChargeBtn;
        [self.commitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.commitBtn];
    }
}

- (void)layoutSubviews {
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(187);
        make.height.mas_equalTo(100);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImg.mas_bottom).with.offset(33);
        make.height.mas_equalTo(305);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(self);
    }];
    
    [self.nameV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.topV);
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(0);
        make.top.mas_equalTo(self.topV.mas_bottom).with.offset(0);
    }];
    
    [self.phoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(0);
        make.width.height.mas_equalTo(self.topV);
        make.top.mas_equalTo(self.nameV.mas_bottom).with.offset(0);
    }];
    
    [self.adressV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.topV);
        make.left.mas_equalTo(self.bgView.mas_left).with.offset(0);
        make.top.mas_equalTo(self.phoneV.mas_bottom).with.offset(0);
    }];
    
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneV.mas_left).with.offset(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLabel.mas_right).with.offset(25);
        make.centerY.mas_equalTo(self.phoneV.mas_centerY).with.offset(0);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextField.mas_left).with.offset(0);
        make.centerY.mas_equalTo(self.topV.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(16);
        
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reduceBtn.mas_right).with.offset(0);
        make.width.mas_equalTo(90);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.countLabel.mas_right).with.offset(0);
        make.width.height.mas_equalTo(self.reduceBtn);
        make.centerY.mas_equalTo(0);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topV.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.7);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextField.mas_left).with.offset(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.adressLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.adressV.mas_centerY).with.offset(0);
    }];
    
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneTextField.mas_left).with.offset(0);
        make.centerY.mas_equalTo(self.adressV.mas_centerY).with.offset(0);
    }];
    
    [self.adressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.adressV.mas_bottom).with.offset(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
        make.bottom.mas_equalTo(self.nameV.mas_bottom).with.offset(0);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
        make.bottom.mas_equalTo(self.phoneV.mas_bottom).with.offset(0);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
        make.bottom.mas_equalTo(self.adressV.mas_bottom).with.offset(0);
    }];
    
    if (viewType == PayCheTieBuy) {
        [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.bottom.mas_equalTo(-20);
            }else {
                make.bottom.mas_equalTo(0);
            }
            make.width.mas_equalTo(kSCREEN_WIDTH);
            make.height.mas_equalTo(60);
            make.centerX.mas_equalTo(0);
        }];
        
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(125);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(60);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomLabel.mas_right).with.offset(0);
            make.centerY.mas_equalTo(0);
        }];
    }else if (viewType == PayCheTieChargeType) {
        [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.bottom.mas_equalTo(-20);
            }else {
                make.bottom.mas_equalTo(0);
            }
            make.width.mas_equalTo(kSCREEN_WIDTH);
            make.height.mas_equalTo(60);
            make.centerX.mas_equalTo(0);
        }];
    }
}
@end
