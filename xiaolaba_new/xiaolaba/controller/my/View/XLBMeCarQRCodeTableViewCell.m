//
//  XLBMeCarQRCodeTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBMeCarQRCodeTableViewCell.h"

@interface XLBMeCarQRCodeTableViewCell ()

@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UIImageView *kongkong;
@property (nonatomic, strong) UIImageView *codeImg;
@property (nonatomic, assign) BOOL isForbid;
@end

@implementation XLBMeCarQRCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self setSubViews];
    }
    return self;
}

- (void)setItem:(XLBMeCarQRCodeModel *)item {
    if (kNotNil(item)) {
        if (item.status == 1) {
            _isForbid = NO;
            [self.cancleBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
            [self.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (kNotNil(item.carId)) {
            self.number.text = [NSString stringWithFormat:@"No.%@",item.carId];
        }
    }
    _item = item;
    
}

- (void)setSubViews {
    self.kongkong = [UIImageView new];
    self.kongkong.image = [UIImage imageNamed:@"bg_jcbd"];
    [self.contentView addSubview:self.kongkong];
    
    self.codeImg = [UIImageView new];
    self.codeImg.image = [UIImage imageNamed:@"icon_jcbd"];
    [self.contentView addSubview:self.codeImg];
    
    self.status = [UILabel new];
    self.status.text = @"挪车贴";
    self.status.font = [UIFont systemFontOfSize:18];
    self.status.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.status];
    
    self.number = [UILabel new];
    self.number.font = [UIFont systemFontOfSize:14];
    self.number.textColor = [UIColor annotationTextColor];
    [self.contentView addSubview:self.number];
    
    self.cancleBtn = [UIButton new];
    [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:self.cancleBtn];
    
}

- (void)cancleBtnClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"解除绑定之后挪车服务将不能使用，请慎重！" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认解除绑定" otherButtonTitles:nil, nil];
    
    [actionSheet showInView:actionSheet];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *parameter = @{@"encrypt":self.item.encrypt,};
        [[NetWorking network] POST:kCarforbid params:parameter cache:NO success:^(id result) {
            if ([self.delegate respondsToSelector:@selector(deleteMoveCarCardWith:index:encrypt:)]) {
                [self.delegate deleteMoveCarCardWith:self index:[NSString stringWithFormat:@"%li",self.cellIndex] encrypt:self.item.encrypt];
            }
        } failure:^(NSString *description) {
            
        }];
    }
}

- (void)layoutSubviews {
    
    kWeakSelf(self);
    [self.kongkong mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
        make.height.mas_equalTo(90);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.center.mas_equalTo(0);
//        make.bottom.mas_equalTo(-5);

    }];
    
    [self.codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.kongkong.mas_top).mas_offset(20);
        make.left.mas_equalTo(weakSelf.kongkong.mas_left).mas_offset(15);
        make.width.height.mas_equalTo(17);

    }];

    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.codeImg.mas_centerY).mas_offset(0);
        make.left.mas_equalTo(weakSelf.codeImg.mas_right).mas_offset(11);
        make.height.mas_equalTo(20);

    }];
    
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.codeImg.mas_left);
        make.top.mas_equalTo(weakSelf.status.mas_bottom).with.offset(8);
        make.height.mas_equalTo(18);
        
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.kongkong.mas_right).mas_offset(-15);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(weakSelf.codeImg.mas_top).with.offset(3);
    }];
    
}



+ (NSString *)cellMeCarQrCodeID {
    return @"cellMeCarQrCodeID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
