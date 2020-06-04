//
//  OwnerVisitorTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "OwnerVisitorTableViewCell.h"

@interface OwnerVisitorTableViewCell ()

@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)NSMutableArray *array;

@property (nonatomic,assign)NSInteger rowNuber;
@property (nonatomic,assign)NSInteger MaxCount;

#define btnnumber 6 //每行几个

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *bgV;
@end

@implementation OwnerVisitorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setVoiceModel:(XLBVoiceActorModel *)voiceModel {
    
    if (kNotNil(voiceModel.visitorArr)) {
        if (_MaxCount==0) {
            if (voiceModel.visitorArr.count > 6) {
                _MaxCount = 6;
            }else {
                _MaxCount = voiceModel.visitorArr.count;
            }
        }
        if (_rowNuber ==0) {
            _rowNuber =btnnumber;
        }
        
        float kimgWidth = 50; //控件大小
        float kspace = (kSCREEN_WIDTH-20-50*_rowNuber)/(_rowNuber+1);
        float kHspace = 10;
        for (NSInteger i=0; i<_MaxCount; i++) {
            NSInteger y = i/_rowNuber;
            NSInteger x = i-y*_rowNuber;
            NSLog(@"%@",voiceModel.visitorArr[i]);
            UserAkiraVisitorModel *visitorModel = voiceModel.visitorArr[i];
            [self addBtnWithframe:CGRectMake((kspace+kimgWidth)*x+kspace, kHspace+y*(kHspace+kimgWidth), kimgWidth, kimgWidth) WithImageName:visitorModel.img WithTag:i];
            _height = kHspace+y*(kHspace+kimgWidth) +kimgWidth +10;
        }
        _voiceModel = voiceModel;
        [self layoutIfNeeded];
    }
}
- (void)setSubViews {
    self.topLabel = [UILabel new];
    self.topLabel.text = @"最近访客";
    self.topLabel.textColor = [UIColor commonTextColor];
    self.topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.contentView addSubview:self.topLabel];
    
//    UIButton *bn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 30)];
//    bn.backgroundColor = [UIColor redColor];
//    [bn addTarget:self action:@selector(bnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:bn];
    
    
    self.bgV = [UIView new];
    [self.contentView addSubview:self.bgV];
}

- (void)bnClick:(UIButton *)sender {
    NSLog(@"222");
}

-(void)addBtnWithframe:(CGRect)frame WithImageName:(NSString *)img WithTag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
//    [button setImage:[UIImage imageNamed:@"weitouxiang"] forState:UIControlStateNormal];
    
    [button sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    button.imageView.contentMode =UIViewContentModeScaleAspectFill;
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor redColor];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgV addSubview:button];
}

- (void)buttonClick:(UIButton *)sender {
    NSLog(@"11");
    if ([self.delegate respondsToSelector:@selector(didSelectButtonWithModel:)]) {
        [self.delegate didSelectButtonWithModel:_voiceModel.visitorArr[sender.tag]];
    }
}
- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)layoutSubviews {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(0);
        make.height.mas_equalTo(70);
    }];
}

+ (NSString *)visitorTableViewCellID {
    return @"visitorTableViewCellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
