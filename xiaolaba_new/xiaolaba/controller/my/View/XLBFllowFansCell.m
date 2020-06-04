//
//  XLBFllowFansCell.m
//  xiaolaba
//
//  Created by lin on 2017/7/25.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBFllowFansCell.h"
#import <UIImageView+WebCache.h>
#import "XLBDEvaluateView.h"

@interface XLBFllowFansCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *car;

@property (weak, nonatomic) IBOutlet XLBDEvaluateView *signView;
@property (nonatomic, assign) BOOL isAttention;
@end

@implementation XLBFllowFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}
- (void)layoutSubviews {
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = (70.0f * 0.7)/2;
    self.handle_button.layer.masksToBounds = YES;
    self.handle_button.layer.cornerRadius = 5;
    self.handle_button.layer.borderWidth = 1;
    self.handle_button.layer.borderColor = [UIColor colorWithHexString:@"#e1e6f0"].CGColor;
    
}

- (void)setModel:(XLBFllowFansModel *)model {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:model.user.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];

    self.nick.text = model.user.nickname;
    [self.car sd_setImageWithURL:[NSURL URLWithString:[model.user.vehicleAreas firstObject]] placeholderImage:nil];
    self.location.text = [NSString stringWithFormat:@"居住地:%@",model.user.city];
    [self.signView setFont:7];
    [self.signView setlHeight:12];
    [self.signView setLwidth:15];
    [self.signView setRadius:2];
    [self.signView insertSign:model.user.tags];
    NSString *image = @"";
    NSString *text = @"";
    UIColor *color = nil;
    if(self.isFllow) {

        if ([model.type isEqualToString:@"0"]) {
            image = @"jiaguanzhu";
            text = @"加关注";
            color = [UIColor colorWithHexString:@"#2e3033"];
            self.isAttention = YES;
        }else {
            image = @"yiguanzhu";
            text = @"已关注";
            color = [UIColor colorWithHexString:@"#aeb5c2"];
            self.isAttention = NO;
        }
    }
    else {
        if ([model.type isEqualToString:@"0"]) {
            image = @"jiaguanzhu";
            text = @"加关注";
            color = [UIColor colorWithHexString:@"#2e3033"];
            self.isAttention = NO;
        }else if ([model.type isEqualToString:@"1"]){
            image = @"jiaguanzhu";
            text = @"加关注";
            color = [UIColor colorWithHexString:@"#2e3033"];
            self.isAttention = NO;
        }else if ([model.type isEqualToString:@"2"]){
            image = @"huxiangguanzhu";
            text = @"互相关注";
            color = [UIColor colorWithHexString:@"#aeb5c2"];
            self.isAttention = YES;
        }
    }
    [self.handle_button setTitle:text forState:0];
    [self.handle_button setTitleColor:color forState:0];
    
    _model = model;
}

- (IBAction)handleClick:(UIButton *)sender {
    
    if (self.isFllow) {
        //关注
        if (_isAttention == NO) {
            //取消关注
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [sender setTitleColor:[UIColor colorWithHexString:@"#2e3033"] forState:0];
                [sender setTitle:@"加关注" forState:0];
                [self cancleFollow];
                _isAttention = YES;
            }];
            [alert addAction:cancle];
            [alert addAction:creatain];
            [self.viewController presentViewController:alert animated:YES completion:nil];
        }
        else {
            //添加关注
            [sender setTitleColor:[UIColor colorWithHexString:@"#aeb5c2"] forState:0];
            [sender setTitle:@"已关注" forState:0];
            [self addFollow];
            _isAttention = NO;
        }
    }
    else {
        //粉丝
        NSLog(@"2222");
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
            [sender setTitle:@"互相关注" forState:0];
            [sender setTitleColor:[UIColor colorWithHexString:@"#aeb5c2"] forState:0];
            [self addFollow];
            self.isAttention = YES;
        }
    }
}

- (void)addFollow {
    NSDictionary *parameter = @{@"followId":self.model.user.ID,};
    [[NetWorking network] POST:kAddFollow params:parameter cache:NO success:^(id result) {
        [MBProgressHUD showSuccess:@"关注成功"];
        if (self.isFllow) {
            _model.type = @"1";
        }else {
            _model.type = @"2";
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"followSuccess" object:nil];
        NSLog(@"%@",result);
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"关注失败"];
        
    }];
    
}

- (void)cancleFollow {
    NSDictionary *parameter = @{@"followId":self.model.user.ID,};
    NSLog(@"%@",parameter);
    [[NetWorking network] POST:kCancleFollow params:parameter cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [MBProgressHUD showSuccess:@"取消成功"];
        if (self.isFllow) {
            _model.type = @"0";
        }else {
            _model.type = @"1";
        }
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
