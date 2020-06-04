//
//  XLBGroupAddManagerTableViewCell.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/2.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupAddManagerTableViewCell.h"
#import "XLBGroupAddManagerSheetView.h"

#import <EaseUI/EaseUI.h>

@interface XLBGroupAddManagerTableViewCell ()<XLBGroupAddManagerSheetViewDelegate>
@property (nonatomic, assign) BOOL isAdmin;

@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIView *line;
@end


@implementation XLBGroupAddManagerTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setGroupModel:(GroupMemberModel *)groupModel {
    _groupModel = groupModel;
    [self.img sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:groupModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    self.nickName.text = groupModel.membersName;
    if ([groupModel.isAdmin isEqualToString:@"1"]) {
        self.isAdmin = YES;
        [self.addBtn setTitle:@"取消管理员" forState:0];
    }else {
        self.isAdmin = NO;
        [self.addBtn setTitle:@"设为管理员" forState:0];
    }
}

- (void)updateAddManagerClick {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XLBGroupAddManagerSheetView *sheetView = [XLBGroupAddManagerSheetView new];
    sheetView.nickName = self.groupModel.membersName;
    sheetView.isAdmin = self.groupModel.isAdmin;
    sheetView.delegate = self;
    [window addSubview:sheetView];
}
- (void)didCertainBtnClick {
    if (self.isAdmin == YES) {
        [[EMClient sharedClient].groupManager removeAdmin:self.groupModel.membersId fromGroup:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                NSLog(@"取消成功");
                self.isAdmin = NO;
                [self.addBtn setTitle:@"设为管理员" forState:0];
                self.groupModel.isAdmin = @"0";
            }else {
                NSLog(@"取消管理员--%@",aError.errorDescription);
                [MBProgressHUD showError:@"取消管理员失败"];
            }
        }];
        
    }else {
        [[EMClient sharedClient].groupManager addAdmin:self.groupModel.membersId toGroup:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                NSLog(@"设置成功");
                self.isAdmin = YES;
                [self.addBtn setTitle:@"取消管理员" forState:0];
                self.groupModel.isAdmin = @"1";
            }else {
                NSLog(@"设置管理员--%@",aError.errorDescription);
                [MBProgressHUD showError:@"添加管理员失败"];
            }
        }];
    }
}
- (void)setSubViews {
    self.nickName = [UILabel new];
    self.nickName.font = [UIFont systemFontOfSize:15];
    self.nickName.textColor = [UIColor colorWithR:66 g:66 b:66];
    [self.contentView addSubview:self.nickName];
    
    self.line = [UILabel new];
    self.line.backgroundColor = [UIColor viewBackColor];
    [self.contentView addSubview:self.line];
    
    self.img = [UIImageView new];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 25;
    [self.contentView addSubview:self.img];
    
    self.addBtn = [UIButton new];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.addBtn setTitle:@"设为管理员" forState:0];
    [self.addBtn setTitleColor:[UIColor colorWithHexString:@"#2e3033"] forState:0];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.layer.borderColor = [UIColor colorWithHexString:@"#e1e6f0"].CGColor;
    self.addBtn.layer.borderWidth = 1;
    [self.addBtn addTarget:self action:@selector(updateAddManagerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addBtn];
    
    
}
- (void)layoutSubviews {
    kWeakSelf(self);
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.7);
    }];
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    
    [weakSelf.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.img.mas_right).with.offset(15);
        make.centerY.mas_equalTo(weakSelf.img.mas_centerY);
    }];
    
    [weakSelf.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(30);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)AddManagerTableViewCellID {
    return @"AddManagerTableViewCellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
