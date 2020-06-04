//
//  XLBJoinGroupViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/9.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBJoinGroupViewController.h"
#import "XLBMsgRequestModel.h"
#import "XLBGroupModel.h"
#import "XLBChatGroupViewController.h"
@interface XLBJoinGroupViewController ()

{
    NSString *ownerName;
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *userImgV;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *ownerLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *ownerV;
@property (nonatomic, strong) UIView *memberV;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) XLBGroupModel *model;

@end

@implementation XLBJoinGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群信息";
    self.naviBar.slTitleLabel.text = @"群信息";
    [XLBMsgRequestModel requestGroupModelWithParameter:@{@"groupHuanxin":self.groupID} success:^(XLBGroupModel * respones) {
        self.model = respones;
        [self.userImgV sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:respones.groupImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    } error:^(id error) {
    }];
    
    [self setSubViews];
}

- (void)setSubViews {
//    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT + 1);
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 185)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.topView];
    
    self.userImgV = [UIImageView new];
    self.userImgV.centerX = self.scrollView.centerX;
    self.userImgV.layer.masksToBounds = YES;
    self.userImgV.layer.cornerRadius = 37;
    self.userImgV.layer.borderWidth = 2;
    self.userImgV.layer.borderColor = [UIColor colorWithR:174 g:181 b:194].CGColor;
    self.userImgV.layer.borderWidth = 2;
    [self.topView addSubview:self.userImgV];

    [self.userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(74);
    }];
    
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.userImgV.bottom + 15, kSCREEN_WIDTH, 20)];
    self.nickNameLabel.font = [UIFont systemFontOfSize:18];
    self.nickNameLabel.textColor = [UIColor commonTextColor];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel.text = self.groupDetail.subject;
    [self.topView addSubview:self.nickNameLabel];

    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImgV.mas_bottom).with.offset(15);
        make.centerX.mas_equalTo(0);
    }];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nickNameLabel.bottom + 15, kSCREEN_WIDTH, 20)];
    self.countLabel.font = [UIFont systemFontOfSize:16];
    self.countLabel.textColor = [UIColor minorTextColor];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.text = [NSString stringWithFormat:@"(%ld人群)",(long)self.groupDetail.setting.maxUsersCount];
    [self.topView addSubview:self.countLabel];

    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).with.offset(15);
        make.centerX.mas_equalTo(0);
    }];
    
    
    self.ownerV = [self addViewWithRect:CGRectMake(0, self.topView.bottom, kSCREEN_WIDTH, 50) title:@"群主" subTitle:self.owner content:nil];
    [self.scrollView addSubview:self.ownerV];
    
    NSString *count = [NSString stringWithFormat:@"%ld人",(long)self.groupDetail.occupantsCount];
    self.memberV = [self addViewWithRect:CGRectMake(0, self.ownerV.bottom, kSCREEN_WIDTH, 50) title:@"群成员" subTitle:count content:nil];
    [self.scrollView addSubview:self.memberV];
    NSString *announcement;
    CGFloat height;
    if (kNotNil(self.model.groupAnnouncement)) {
        announcement = [NSString stringWithFormat:@"%@",self.model.groupAnnouncement];
        height = [announcement sizeWithMaxWidth:kSCREEN_WIDTH - 30 font:[UIFont systemFontOfSize:15]].height + 10;
    }else {
        height = 0;
        announcement = @"";
    }
    
    self.contentV = [self addViewWithRect:CGRectMake(0, self.memberV.bottom, kSCREEN_WIDTH, height + 50) title:@"群公告" subTitle:nil content:announcement];
    [self.scrollView addSubview:self.contentV];
    
    self.joinBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentV.bottom + 25, 275, 46)];
    self.joinBtn.centerX = self.scrollView.centerX;
    self.joinBtn.layer.masksToBounds = YES;
    self.joinBtn.layer.cornerRadius = 5;
    [self.joinBtn setTitle:@"加入该群" forState:0];
    [self.joinBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.joinBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.joinBtn.backgroundColor = [UIColor textBlackColor];
    [self.joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.joinBtn];
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.joinBtn.bottom + 10);
}
- (void)joinBtnClick:(UIButton *)sender {
    if (!kNotNil(self.groupID)) {
        return;
    }
    NSDictionary *dict = @{@"groupHuanxin":self.groupID,@"membersIds":[[XLBUser user].userModel.ID stringValue],@"membersName":@"",};

    [[EMClient sharedClient].groupManager joinPublicGroup:self.groupID completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            [[NetWorking network] POST:kAddGroupMembers params:dict cache:NO success:^(id result) {
                [MBProgressHUD showSuccess:@"加入成功"];
                [self pushGroupChatViewControllerWithGroupID:self.groupID nickName:aGroup.subject];
            } failure:^(NSString *description) {
                [MBProgressHUD showSuccess:@"加入失败"];
            }];
        }else {
            NSLog(@"%@",aError.errorDescription);
            [MBProgressHUD showSuccess:@"加入失败"];
        }
    }];
}

- (void)pushGroupChatViewControllerWithGroupID:(NSString *)groupID nickName:(NSString *)nickName{
    XLBChatGroupViewController *chat = [[XLBChatGroupViewController alloc] initWithConversationChatter:[NSString stringWithFormat:@"%@",groupID] conversationType:EMConversationTypeGroupChat];
    chat.hidesBottomBarWhenPushed = YES;
    chat.nickName = nickName;
    [self.navigationController pushViewController:chat animated:YES];
}

- (UIView *)addViewWithRect:(CGRect)rect title:(NSString *)title subTitle:(NSString *)subtitle content:(NSString *)content {
    UIView *bgV = [[UIView alloc] initWithFrame:rect];
    bgV.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor commonTextColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = title;
    [bgV addSubview:titleLabel];
    
    if (subtitle) {
        UILabel *subTitle = [UILabel new];
        subTitle.textColor = [UIColor minorTextColor];
        subTitle.font = [UIFont systemFontOfSize:15];
        subTitle.textAlignment = NSTextAlignmentRight;
        subTitle.text = subtitle;
        [bgV addSubview:subTitle];
        
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        if ([subtitle isEqualToString:@"群主"]) {
            self.ownerLabel = subTitle;
            subTitle.text = ownerName;
        }
    }
    
    if (kNotNil(content)) {
        UILabel *contentLabel = [UILabel new];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textColor = [UIColor minorTextColor];
        contentLabel.numberOfLines = 0;
        contentLabel.text = content;
        [bgV addSubview:contentLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(bgV.mas_top).with.offset(15);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
            make.right.mas_equalTo(-15);
        }];
    }else {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lineColor];
    [bgV addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.7);
    }];
    
    return bgV;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
