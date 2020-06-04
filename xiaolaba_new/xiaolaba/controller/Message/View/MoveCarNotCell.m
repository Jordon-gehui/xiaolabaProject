//
//  MoveCarNotCell.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/28.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MoveCarNotCell.h"
@interface MoveCarNotCell()
@property (nonatomic ,strong)UILabel *contentLbl;
@property (nonatomic ,strong)UILabel *timeLbl;
//内容最多三张图片
@property (nonatomic ,strong)UIImageView *content1Img;
@property (nonatomic ,strong)UIImageView *content2Img;
@property (nonatomic ,strong)UIImageView *content3Img;
@property (nonatomic ,strong)UIView *lineV;

@property (nonatomic ,copy)NSArray *imgsArr;

@end
@implementation MoveCarNotCell

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
    _timeLbl = [UILabel new];
    _timeLbl.font = [UIFont systemFontOfSize:12];
    _timeLbl.textColor = [UIColor textBlackColor];
    [self addSubview:_timeLbl];
    
    _contentLbl = [UILabel new];
    _contentLbl.font = [UIFont systemFontOfSize:14];
    _contentLbl.textColor = [UIColor textBlackColor];
    _contentLbl.numberOfLines = 0;
    [self addSubview:_contentLbl];
    
    _content1Img =[UIImageView new];
    _content1Img.layer.cornerRadius = 5;
    _content1Img.layer.masksToBounds = YES;
    [self addSubview:_content1Img];
    _content2Img =[UIImageView new];
    _content2Img.layer.cornerRadius = 5;
    _content2Img.layer.masksToBounds = YES;
    [self addSubview:_content2Img];
    _content3Img =[UIImageView new];
    _content3Img.layer.cornerRadius = 5;
    _content3Img.layer.masksToBounds = YES;
    [self addSubview:_content3Img];
    
    _lineV = [UIView new];
    [_lineV setBackgroundColor:[UIColor lineColor]];
    [self addSubview:_lineV];
}

-(void)setViewData:(XLBMoveRecordsModel*)model {
//    NSLog(@"%@",model.message);
    _contentLbl.text = model.message;
    _timeLbl.text = model.noticeDate;
    if(kNotNil(model.imgs)){
        _imgsArr = [model.imgs componentsSeparatedByString:@","];
        if (_imgsArr.count ==3) {
            [_content3Img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_imgsArr[2] Withtype:IMGMoment]]];
            [_content1Img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_imgsArr[0] Withtype:IMGMoment]]];
            [_content2Img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_imgsArr[1] Withtype:IMGMoment]]];
            _content1Img.hidden = NO;
            _content2Img.hidden = NO;
            _content3Img.hidden = NO;
        }else if (_imgsArr.count ==1) {
            [_content1Img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_imgsArr[0] Withtype:IMGMoment]]];
            _content1Img.hidden = NO;
            _content2Img.hidden = YES;
            _content3Img.hidden = YES;
        }else {
            [_content1Img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_imgsArr[0] Withtype:IMGMoment]]];
            [_content2Img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:_imgsArr[1] Withtype:IMGMoment]]];
            _content1Img.hidden = NO;
            _content2Img.hidden = NO;
            _content3Img.hidden = YES;
        }
        [_lineV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.content1Img.mas_bottom).with.offset(15);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self);
        }];
    }else {
        _content1Img.hidden = YES;
        _content2Img.hidden = YES;
        _content3Img.hidden = YES;

        [_lineV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(_contentLbl.mas_bottom).with.offset(15);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self);
        }];
    }
    [self layoutIfNeeded];
}

-(void)layoutSubviews {
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(15);
        make.right.mas_equalTo(self).with.offset(-15);
    }];
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLbl.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self).with.offset(15);
        make.right.mas_equalTo(self).with.offset(-15);
    }];
    [_content1Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(15);
        make.top.mas_equalTo(self.contentLbl.mas_bottom).with.offset(10);
        make.width.and.height.mas_equalTo(@80);
    }];
    [_content2Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.content1Img.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.content1Img);
        make.width.and.height.mas_equalTo(@80);
    }];
    [_content3Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.content2Img.mas_right).with.offset(15);
        make.centerY.mas_equalTo(self.content1Img);
        make.width.and.height.mas_equalTo(@80);
    }];
}

+(NSString *)cellReuseIdentifier {
    return @"MoveCarNotCell";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
