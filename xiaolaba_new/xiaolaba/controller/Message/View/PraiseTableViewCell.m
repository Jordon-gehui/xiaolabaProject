//
//  PraiseTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "PraiseTableViewCell.h"


@interface PraiseTableViewCell ()

@property (nonatomic, assign) BOOL isAttention;

@end

@implementation PraiseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (void)layoutSubviews {
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 5;
    self.followBtn.layer.borderColor = [UIColor colorWithHexString:@"#e1e6f0"].CGColor;
    self.followBtn.layer.borderWidth = 1;
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = self.userImg.frame.size.height/2;
    self.contentImg.layer.masksToBounds = YES;
    self.contentImg.layer.cornerRadius = 5;
}

- (void)setPraiseModel:(PraiseModel *)praiseModel {
    NSLog(@"%@",praiseModel.nickname);
    self.nickName.text = praiseModel.nickname;
    self.dateLabel.text = praiseModel.createDate;
    self.content.text = praiseModel.content;
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:praiseModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    if (kNotNil(praiseModel.remark)) {
        [self.contentImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:praiseModel.remark Withtype:IMGMoment]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    }
    self.followBtn.hidden = YES;
//    self.followLabel.hidden = YES;
    _praiseModel = praiseModel;
}

#pragma mark -- 关注cell
- (void)setFansModel:(XLBFllowFansModel *)fansModel {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:fansModel.user.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickName.text = [NSString stringWithFormat:@"%@",fansModel.user.nickname];
    self.nickSubLabel.text = @"关注了您";
    if ([fansModel.type isEqualToString:@"2"]) {
        [self.followBtn setTitle:@"互相关注" forState:0];
        [self.followBtn setTitleColor:[UIColor colorWithHexString:@"#aeb5c2"] forState:0];
        self.isAttention = YES;
    }else {
        [self.followBtn setTitle:@"加关注" forState:0];
        [self.followBtn setTitleColor:[UIColor colorWithHexString:@"#2e3033"] forState:0];
        self.isAttention = NO;
    }
    self.dateLabel.text = fansModel.createDate;
    _fansModel = fansModel;
}


- (IBAction)followBtnClick:(UIButton *)sender {
    
    if (self.isAttention == YES) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setTitleColor:[UIColor colorWithHexString:@"#2e3033"] forState:0];
            [sender setTitle:@"加关注" forState:0];
            [self cancleFollow];
            self.isAttention = NO;
        }];
        [alert addAction:cancle];
        [alert addAction:creatain];
        [self.viewController presentViewController:alert animated:YES completion:nil];
        
    }else {
        [sender setTitleColor:[UIColor colorWithHexString:@"#aeb5c2"] forState:0];
        [sender setTitle:@"互相关注" forState:0];
        [self addFollow];
        self.isAttention = YES;
    }
}


- (void)addFollow {
    NSDictionary *parameter = @{@"followId":self.fansModel.user.ID,};
    [[NetWorking network] POST:kAddFollow params:parameter cache:NO success:^(id result) {
        [MBProgressHUD showSuccess:@"关注成功"];
        _fansModel.type = @"2";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"关注失败"];
        
    }];
    
}

- (void)cancleFollow {
    NSDictionary *parameter = @{@"followId":self.fansModel.user.ID,};
    NSLog(@"%@",parameter);
    [[NetWorking network] POST:kCancleFollow params:parameter cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [MBProgressHUD showSuccess:@"取消成功"];
        _fansModel.type = @"1";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"取消失败"];
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
