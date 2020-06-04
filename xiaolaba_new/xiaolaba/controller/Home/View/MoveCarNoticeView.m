//
//  MoveCarNoticeView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#define ImgWidth 100*kiphone6_ScreenWidth


#import "MoveCarNoticeView.h"

@interface MoveCarNoticeView ()

@property (nonatomic, strong)UIView *locationView;
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UILabel *plateLabel;
@property (nonatomic, strong)UILabel *locationSubLabel;
@property (nonatomic, strong)UILabel *plateSubLabel;


@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, strong)UILabel *messageSubLabel;
@property (nonatomic, strong)UIImageView *mesImage1;
@property (nonatomic, strong)UIImageView *mesImage2;
@property (nonatomic, strong)UIImageView *mesImage3;


@property (nonatomic, strong)UILabel *lineLabel;

@property (nonatomic, strong)UILabel *ownerLabel;
@property (nonatomic, strong)UILabel *ownerName;
@property (nonatomic, strong)UIImageView *ownerImage;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic,copy) NSDictionary *tempDic;
@end

@implementation MoveCarNoticeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews {

    self.backgroundColor = [UIColor whiteColor];
    self.locationView = [UIView new];
    [self.locationView.layer setMasksToBounds:YES];
    [self.locationView.layer setCornerRadius:5.0];
    [self.locationView.layer setBorderWidth:1.0];
    self.locationView.layer.borderColor=[UIColor colorWithR:225 g:230 b:240].CGColor;
    self.locationView.backgroundColor = [UIColor whiteColor];
    
    self.locationSubLabel = [UILabel new];
    self.locationSubLabel.textColor = [UIColor grayColor];
    self.locationSubLabel.textAlignment = NSTextAlignmentLeft;
    self.locationSubLabel.text = @"位置:";
    self.locationSubLabel.font = [UIFont systemFontOfSize:15];
    [self.locationView addSubview:self.locationSubLabel];
    
    self.locationLabel = [UILabel new];
    self.locationLabel.textColor = [UIColor textBlackColor];
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.text = @"未知";
    self.locationLabel.font = [UIFont systemFontOfSize:15];
    [self.locationView addSubview:self.locationLabel];

    
    self.plateSubLabel = [UILabel new];
    self.plateSubLabel.textColor = [UIColor grayColor];
    self.plateSubLabel.textAlignment = NSTextAlignmentLeft;
    self.plateSubLabel.text = @"车牌号:";
    self.plateSubLabel.font = [UIFont systemFontOfSize:15];
    [self.locationView addSubview:self.plateSubLabel];

    self.plateLabel = [UILabel new];
    self.plateLabel.textColor = [UIColor textBlackColor];
    self.plateLabel.textAlignment = NSTextAlignmentLeft;
    self.plateLabel.text = @"未知";
    self.plateLabel.font = [UIFont systemFontOfSize:15];
    [self.locationView addSubview:self.plateLabel];

    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.messageSubLabel = [UILabel new];
    self.messageSubLabel.textColor = [UIColor grayColor];
    self.messageSubLabel.font = [UIFont systemFontOfSize:15];
    self.messageSubLabel.text = @"提醒信息(给车主留言):";
    self.messageSubLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.messageSubLabel];
    
    self.messageLabel = [UILabel new];
    self.messageLabel.textColor = [UIColor textBlackColor];
    self.messageLabel.font = [UIFont systemFontOfSize:15];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.messageLabel];
    
    _mesImage1 = [UIImageView new];
    _mesImage1.clipsToBounds = YES;
    _mesImage1.layer.cornerRadius = 5;
    [_mesImage1 setHidden:YES];
    [self.contentView addSubview:_mesImage1];
    _mesImage2 = [UIImageView new];
    _mesImage2.clipsToBounds = YES;
    _mesImage2.layer.cornerRadius = 5;
    [_mesImage2 setHidden:YES];

    [self.contentView addSubview:_mesImage2];
    _mesImage3 = [UIImageView new];
    _mesImage3.clipsToBounds = YES;
    _mesImage3.layer.cornerRadius = 5;
    [_mesImage3 setHidden:YES];

    [self.contentView addSubview:_mesImage3];
    
    self.lineLabel = [UILabel new];
    self.lineLabel.backgroundColor = [UIColor grayColor];
    
    self.ownerLabel = [UILabel new];
    
    self.ownerLabel.font = [UIFont systemFontOfSize:15];
    self.ownerLabel.textColor = [UIColor grayColor];
    self.ownerLabel.textAlignment = NSTextAlignmentLeft;
    self.ownerLabel.text = @"车主信息";
    
    
    self.ownerImage = [UIImageView new];
    self.ownerImage.layer.masksToBounds = YES;
    self.ownerImage.layer.cornerRadius = 25;
    self.ownerBtn = [UIButton new];
    
    self.ownerName = [UILabel new];
    
    self.ownerName.textColor = [UIColor textBlackColor];
    self.ownerName.textAlignment = NSTextAlignmentLeft;
    self.ownerName.font = [UIFont systemFontOfSize:17];
    self.ownerName.text = @"未知";
    
    self.chatBtn = [[UIButton alloc] init];
    self.chatBtn.backgroundColor = [UIColor lightColor];
    self.chatBtn.layer.masksToBounds = YES;
    self.chatBtn.layer.cornerRadius = 5;
    
    [self.chatBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [self.chatBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
    self.chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.locationView];
    [self addSubview:self.contentView];
    [self addSubview:self.lineLabel];
    [self addSubview:self.ownerLabel];
    [self addSubview:self.ownerImage];
    [self addSubview:self.ownerName];
    [self addSubview:self.chatBtn];
    [self addSubview:self.ownerBtn];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
}

- (void)show{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT*0.5)];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor textBlackColor];
    self.bgView.alpha = 0.4;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.bgView addGestureRecognizer:tap];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self];
    
}

-(void) setDateDic:(NSDictionary *)dic {
    _tempDic = dic;
    if (kNotNil([dic objectForKey:@"nickname"])) {
        [self.ownerName setText:[dic objectForKey:@"nickname"]];
    }else{
        [self.ownerName setText:@"匿名"];
    }
    if (kNotNil([dic objectForKey:@"img"])) {
         [self.ownerImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[dic objectForKey:@"img"] Withtype:IMGAvatar]]];
    }else{
        [self.ownerImage setImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    self.locationLabel.text = [dic objectForKey:@"location"];
    self.plateLabel.text = [dic objectForKey:@"licensePlate"];
    self.messageLabel.text = [dic objectForKey:@"message"];
    if (kNotNil([dic objectForKey:@"imgs"])) {
        NSArray *array = [[dic objectForKey:@"imgs"] componentsSeparatedByString:@","];
        for (int i = 0; i<array.count; i++) {
            if (i == 0) {
                [self.mesImage1 sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[0] Withtype:IMGMoment]]];
                [self.mesImage1 setHidden:NO];
            }else if(i==1){
                [self.mesImage2 sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[1] Withtype:IMGMoment]]];
                [self.mesImage2 setHidden:NO];
            }else  {
                [self.mesImage3 sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[2] Withtype:IMGMoment]]];
                [self.mesImage3 setHidden:NO];
            }
        }
    }else {
        [self.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.messageLabel.mas_bottom).mas_equalTo(10);
        }];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.lineLabel.mas_bottom).mas_equalTo(10);
        }];
    }
}

- (void)setModel:(XLBMoveRecordsModel *)model {
    
    self.messageSubLabel.text = @"提醒信息:";
    if (kNotNil(model.nickname)) {
        [self.ownerName setText: model.nickname];
    }else{
        [self.ownerName setText:@"匿名"];
    }
    if (kNotNil(model.img)) {
        [self.ownerImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"kongzhaopiao"]];
    }else{
        [self.ownerImage setImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    self.messageLabel.text = model.message;
    self.locationLabel.text = model.location;
    self.plateLabel.text = model.licensePlate;
    if (kNotNil(model.imgs)) {
        NSArray *array = [model.imgs componentsSeparatedByString:@","];
        for (int i = 0; i<array.count; i++) {
            if (i == 0) {
                [self.mesImage1 sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[0] Withtype:IMGMoment]]];
                [self.mesImage1 setHidden:NO];
            }else if(i==1){
                [self.mesImage2 sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[1] Withtype:IMGMoment]]];
                [self.mesImage2 setHidden:NO];
            }else  {
                [self.mesImage3 sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:array[2] Withtype:IMGMoment]]];
                [self.mesImage3 setHidden:NO];
            }
        }
    }else {
        [self.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.messageLabel.mas_bottom).mas_equalTo(10);
        }];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.lineLabel.mas_bottom).mas_equalTo(10);
        }];
    }
    if (!kNotNil(model.location)) {
        self.locationLabel.text = @"未填写";
    }
    if (!kNotNil(model.licensePlate)) {
        self.plateLabel.text = @"未填写";
    }
    _model = model;
}

- (void)tap:(UIGestureRecognizer *)gesture {
    if (_isMoveCar) {
        
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.bgView removeFromSuperview];
            self.bgView = nil;
            [self removeFromSuperview];
        }];
    }
}

- (void)layoutSubviews {
//    CGFloat contentHeight = [_mes sizeWithMaxWidth:kSCREEN_WIDTH - 20 font:[UIFont systemFontOfSize:15]].height;
    
    kWeakSelf(self);
    [weakSelf.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(60);
    }];
    
    [weakSelf.locationSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.locationView.mas_top).mas_offset(10);
        make.left.mas_equalTo(weakSelf.locationView.mas_left).mas_offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.locationSubLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(weakSelf.locationSubLabel.mas_centerY).mas_offset(0);
        make.right.mas_equalTo(weakSelf.locationView.mas_right).mas_offset(-10);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.plateSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.locationSubLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(weakSelf.locationSubLabel.mas_left).mas_offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(18);
    }];
    
    
    [weakSelf.plateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.plateSubLabel.mas_right).mas_offset(5);
        make.right.mas_equalTo(weakSelf.locationView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(weakSelf.plateSubLabel.mas_centerY).mas_offset(0);
        make.height.mas_equalTo(weakSelf.plateSubLabel.mas_height);
    }];
    
    
    [weakSelf.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.locationView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(weakSelf.locationView.mas_left);
        make.right.mas_equalTo(weakSelf.locationView.mas_right);
        make.bottom.mas_equalTo(weakSelf.mesImage1.mas_bottom).mas_equalTo(10);
    }];
    
    
    [weakSelf.messageSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).mas_offset(0);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).mas_offset(0);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).mas_offset(0);
        make.height.mas_equalTo(18);
    }];
    
    [weakSelf.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.messageSubLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(weakSelf.messageSubLabel.mas_left).mas_offset(0);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).mas_offset(0);
    }];
    
    [weakSelf.mesImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.messageLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(weakSelf.messageLabel.mas_left);
        make.width.height.mas_equalTo(ImgWidth);
    }];
    [weakSelf.mesImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.messageLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(weakSelf.mesImage1.mas_right).with.offset(10);
        make.width.height.mas_equalTo(ImgWidth);
    }];
    [weakSelf.mesImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.messageLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(weakSelf.mesImage2.mas_right).with.offset(10);
        make.width.height.mas_equalTo(ImgWidth);
    }];
    
    [weakSelf.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(weakSelf.mas_left).mas_offset(0);
        make.right.mas_equalTo(weakSelf.mas_right).mas_offset(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [weakSelf.ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.lineLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).mas_offset(0);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).mas_offset(0);
        make.height.mas_equalTo(18);
    }];
    
    [weakSelf.ownerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.ownerLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).mas_offset(-20);
        make.left.mas_equalTo(weakSelf.mas_left).mas_offset(10);
        make.width.height.mas_equalTo(50);
    }];
    
    [weakSelf.ownerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(weakSelf.ownerImage);
        make.centerX.centerY.mas_equalTo(weakSelf.ownerImage);
    }];
    
    [weakSelf.ownerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.ownerImage.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(weakSelf.ownerImage.mas_centerY);
        make.height.mas_equalTo(18);
    }];
    
    [weakSelf.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(weakSelf.ownerImage.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
}

@end
