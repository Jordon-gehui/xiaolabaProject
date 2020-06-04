//
//  XLBFaceWallTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/12/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBFaceWallTableViewCell.h"
@interface XLBFaceWallTableViewCell ()
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UILabel *ranking;
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UIImageView *userBgImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *attentionCount;
@property (nonatomic, strong) UIButton *attentionBtn;

@property (nonatomic, copy) NSString *cellID;
@end
@implementation XLBFaceWallTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _cellID = reuseIdentifier;
        [self setSubViews];
    }
    return self;
}

- (void)setModel:(FaceWallListModel *)model {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.ranking.text = model.ranking;
    self.nickName.text = model.nickname;
    self.attentionCount.text = model.likeSum;
    if ([model.follows isEqualToString:@"0"]) {
        [self.attentionBtn setTitle:@"+ 关注" forState:0];
    }
    if ([model.follows isEqualToString:@"1"]) {
        [self.attentionBtn setTitle:@"已关注" forState:0];
    }
    _model = model;
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.ranking.text = [NSString stringWithFormat:@"%li",index+2];
    if (index == 0) {
        self.userBgImg.image = [UIImage imageNamed:@"pic_yzb_y"];
        self.userImg.frame = CGRectMake(52, 19, 42, 42);
        self.ranking.backgroundColor = [UIColor colorWithHexString:@"#c6d3e2"];
    }else if (index == 1){
        self.userBgImg.image = [UIImage imageNamed:@"pic_yzb_j"];
        self.userImg.frame = CGRectMake(52, 19, 42, 42);
        self.ranking.backgroundColor = [UIColor colorWithHexString:@"#bdae97"];

    }else {
        self.userBgImg.image = [UIImage imageNamed:@""];
        self.userImg.frame = CGRectMake(50, 12, 42, 42);
        self.ranking.backgroundColor = [UIColor whiteColor];
    }
}
- (void)attentionBtnClick:(UIButton *)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        return;
    }
    if (!kNotNil(_model.userId)) return;
    if (kNotNil(_model.userId)) {
        if ([_model.follows isEqualToString:@"0"]) {
            [self addFollow];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self cancleFollow];
            }];
            [alert addAction:cancle];
            [alert addAction:creatain];
            [self.viewController presentViewController:alert animated:YES completion:nil];
        }
    }
}
- (void)addFollow {
    NSDictionary *parameter = @{@"followId":_model.userId,};
    [[NetWorking network] POST:kAddFollow params:parameter cache:NO success:^(id result) {
        [MBProgressHUD showSuccess:@"关注成功"];
        _model.follows = @"1";
        [self.attentionBtn setTitle:@"已关注" forState:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"关注失败"];
        
    }];
    
}

- (void)cancleFollow {
    NSDictionary *parameter = @{@"followId":_model.userId,};
    NSLog(@"%@",parameter);
    [[NetWorking network] POST:kCancleFollow params:parameter cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [MBProgressHUD showSuccess:@"取消成功"];
        _model.follows = @"0";
        [self.attentionBtn setTitle:@"+ 关注" forState:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"取消失败"];
        
    }];
}
- (void)setSubViews {
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = RGB(246, 246, 246);
    [self.contentView addSubview:self.lineV];
    
    self.ranking = [UILabel new];
    self.ranking.layer.masksToBounds = YES;
    self.ranking.layer.cornerRadius = 12;
    self.ranking.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:17];
    self.ranking.textColor = [UIColor commonTextColor];
    self.ranking.textAlignment = NSTextAlignmentCenter;
    self.ranking.text = @"2";
    [self.contentView addSubview:self.ranking];
    
    self.userBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(50, 3, 46, 61)];
    [self.contentView addSubview:self.userBgImg];
    
    self.userImg = [[UIImageView alloc] initWithFrame:CGRectMake(52, 19, 42, 42)];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].userModel.img Withtype:IMGAvatar]]];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 21;
    [self.contentView addSubview:self.userImg];
    
    self.nickName = [UILabel new];
    self.nickName.text = @"戴葛辉";
    self.nickName.font = [UIFont systemFontOfSize:16];
    self.nickName.textColor = [UIColor commonTextColor];
    [self.contentView addSubview:self.nickName];
    
    self.attentImg = [UIImageView new];
    self.attentImg.image = [UIImage imageNamed:@"icon_gz_m"];
    [self.contentView addSubview:self.attentImg];
    
    self.attentionCount = [UILabel new];
    self.attentionCount.font = [UIFont systemFontOfSize:14];
    self.attentionCount.textColor = [UIColor commonTextColor];
    self.attentionCount.text = @"6666";
    self.attentionCount.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.attentionCount];
    
    self.attentionBtn = [UIButton new];
    [self.attentionBtn setTitle:@"+ 关注" forState:0];
    self.attentionBtn.layer.masksToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 13;
    self.attentionBtn.layer.borderWidth = 0.5;
    self.attentionBtn.layer.borderColor = [UIColor mainColor].CGColor;
    self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.attentionBtn setTitleColor:[UIColor textBlackColor] forState:0];
    [self.attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.attentionBtn];
    
}



- (void)layoutSubviews {
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
    }];

    [self.ranking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ranking.mas_right).with.offset(70);
        if ([_cellID isEqualToString:@"faceWallCellID"]) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(-10);

        }else {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);

        }
    }];
    
    if ([_cellID isEqualToString:@"faceWallCellID"]) {
        [self.attentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nickName.mas_bottom).with.offset(3);
            make.left.mas_equalTo(self.nickName.mas_left).with.offset(0);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.attentionCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.attentImg.mas_right).with.offset(5);
            make.centerY.mas_equalTo(self.attentImg.mas_centerY);
        }];
    }
    if ([_cellID isEqualToString:@"faceWallCellID"]) {
        [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).with.offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(26);
            make.width.offset(60);
        }];
    }
    
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    UIBezierPath *path;
    switch (_roundCornerType) {
        case CellTypeTop: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            break;
        }
        case CellTypeBottom: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
            break;
        }
        case CellTypeAll: {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
            break;
        }
        case CellTypeDefault:
        default: {
            self.layer.mask = nil;
            return;
        }
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

+ (NSString *)faceWallCellID {
    return @"faceWallCellID";
}

+ (NSString *)faceWallCellIDVoice {
    return @"faceWallCellIDVoice";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
