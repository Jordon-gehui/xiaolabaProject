//
//  OwnerImageTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//
#define btnnumber 5 //每行几个

#import "OwnerImageTableViewCell.h"

@interface OwnerImageTableViewCell ()

@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)NSArray *array;

@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIView *imageBgView;
@property (nonatomic, strong) UIImageView *remindImg;

@end

@implementation OwnerImageTableViewCell

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

- (void)setMomentsCount:(NSString *)momentsCount {
    if (kNotNil(momentsCount)) {
        NSLog(@"%@",momentsCount);
        self.headLabel.text = [NSString stringWithFormat:@"动态 %@",momentsCount];
    }
    _momentsCount = momentsCount;
}

- (void)setMomentImg:(NSString *)momentImg {
    if (!kNotNil(momentImg)) {
        self.remindLabel.text = @"车主还没有发表动态图片哦～";
        self.remindImg.image = [UIImage imageNamed:@"pic_wdt"];
    }else {
        self.remindLabel.text = @"";
        self.remindImg.image = [UIImage imageNamed:@""];
        float kimgWidth = 60/375.0*kSCREEN_WIDTH;//控件大小
        float kspace = (kSCREEN_WIDTH-50-kimgWidth*btnnumber)/(btnnumber+1);
        float kHspace = 10;
        NSArray *items = [momentImg componentsSeparatedByString:@","];
        if (items.count > 4) {
            for (int i=0; i<5; i++) {
                int y = i/btnnumber;
                //            int x = i-y*btnnumber;
                
                [self imageWithFrame:CGRectMake((kspace+kimgWidth)*i+kspace, 0, kimgWidth, kimgWidth) WithImage:[items objectAtIndex:i]];
                _height = kHspace+y*(kHspace+kimgWidth) +kimgWidth +5;
            }
        }else {
            for (int i=0; i<items.count; i++) {
                int y = i/btnnumber;
                int x = i-y*btnnumber;
                NSLog(@"%@",[items objectAtIndex:i]);
                [self imageWithFrame:CGRectMake((kspace+kimgWidth)*x+kspace, 0, kimgWidth, kimgWidth) WithImage:[items objectAtIndex:i]];
                _height = kHspace+y*(kHspace+kimgWidth) +kimgWidth +5;
            }
        }
    }
}

- (void)setSubViews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.headLabel = [UILabel new];
    self.headLabel.text = @"动态";
    self.headLabel.textColor = RGB(102, 102, 102);
    self.headLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.headLabel];

    
    self.allBtn = [UIButton new];
    [self.allBtn setImage:[UIImage imageNamed:@"icon_wd_fh"] forState:UIControlStateNormal];
    [self addSubview:self.allBtn];
    
    
//    self.allBigBtn = [UIButton new];
//    self.allBigBtn.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.allBigBtn];

    
    self.imageBgView = [UIView new];
    [self addSubview:self.imageBgView];
    
    
    
    self.remindImg = [UIImageView new];
    
    [self addSubview:self.remindImg];
    
    self.remindLabel = [UILabel new];

    self.remindLabel.font = [UIFont systemFontOfSize:11];
    self.remindLabel.textColor = RGB(204,204,204);
    [self addSubview:self.remindLabel];
    
}
- (void)setIsVoice:(BOOL)isVoice {
    self.headLabel.textColor = [UIColor commonTextColor];
    self.headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _isVoice = isVoice;
}

- (void)imageWithFrame:(CGRect)frame WithImage:(NSString *)imageUrl{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:imageUrl Withtype:IMGMoment]] placeholderImage:[UIImage imageNamed:@""]];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 5;
    [self.imageBgView addSubview:imageView];
}

- (void)layoutSubviews {
    
    
    kWeakSelf(self);
    
    [weakSelf.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_isVoice) {
            make.top.right.mas_equalTo(10);
            make.left.mas_equalTo(15);
        }else {
            make.top.left.right.mas_equalTo(10);
        }
        make.height.mas_equalTo(18);
    }];
    
//    [weakSelf.allBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.centerY.mas_equalTo(weakSelf.mas_centerY);
//        make.left.mas_equalTo(15);
//        make.height.mas_equalTo(weakSelf.mas_height);
//    }];
    

    
    [weakSelf.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_isVoice) {
            make.left.mas_equalTo(weakSelf.headLabel.mas_left).mas_offset(0);
        }else {
            make.left.mas_equalTo(weakSelf.headLabel.mas_left).mas_offset(-5);
        }
        make.top.mas_equalTo(weakSelf.headLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(60);
    }];
    
    [weakSelf.remindImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70*kiphone6_ScreenWidth);
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf);
    }];
    [weakSelf.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(weakSelf.imageBgView.mas_centerY);
        make.width.height.mas_equalTo(15);
    }];
    
    [weakSelf.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.remindImg.mas_bottom).with.offset(2);
        make.centerX.mas_equalTo(weakSelf.remindImg.mas_centerX);
    }];
}

+ (NSString *)cellIdentifie {
    
    return @"cellIdentifie";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
