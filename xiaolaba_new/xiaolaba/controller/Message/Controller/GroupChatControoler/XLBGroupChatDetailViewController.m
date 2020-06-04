//
//  XLBGroupChatDetailViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/5/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//
#define btnnumber 5 //每行几个

typedef NS_ENUM(NSInteger, GroupDetailViewTag) {
    PortraitViewTag = 100,
    NameViewTag,
    AnnouncementViewTag,
    ShareViewTag,
    MeNameViewTag,
    StickViewTag,
    NoDisturbingViewTag,
    AddManagerViewTag,
    SearchViewTag,
    HoldingViewTag,
};

#import "XLBGroupChatDetailViewController.h"
#import "XLBGroupChatDetailTableViewCell.h"

@interface XLBGroupChatDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *headerV;

@property (nonatomic, strong) UIView *portraitV;
@property (nonatomic, strong) UIView *nameV;
@property (nonatomic, strong) UIView *announcementV;
@property (nonatomic, strong) UIView *shareV;
@property (nonatomic, strong) UIView *meNameV;
@property (nonatomic, strong) UIView *stickV;
@property (nonatomic, strong) UIView *noDisturbingV;
@property (nonatomic, strong) UIView *addManagerV;
@property (nonatomic, strong) UIView *searchV;
@property (nonatomic, strong) UIView *holdingV;

@property (nonatomic, strong) UISwitch *switch_stick;
@property (nonatomic, strong) UISwitch *switch_noDisturbing;
@property (nonatomic, strong) UISwitch *switch_search;
@property (nonatomic, strong) UISwitch *switch_holding;

@property (nonatomic,assign)NSInteger rowNuber;
@property (nonatomic,assign)NSInteger MaxCount;
@property (nonatomic, strong) NSMutableArray *userArr;
@end

@implementation XLBGroupChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     群成员，群头像，群名称，群公告，分享群，我的群昵称，置顶该消息，消息免打扰，设置管理员，允许群被搜索，允许群成员拉人进群
     */
    self.title = @"群详情";
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom)];
    self.scrollView.backgroundColor = [UIColor viewBackColor];
    [self.view addSubview:self.scrollView];
    CGFloat headerHeight;
    if (self.groupDetail.memberList.count == 0) {
        headerHeight = (((self.groupDetail.memberList.count + 2)/5) + 1) * 70;
    }else if (self.groupDetail.memberList.count != 0 && self.groupDetail.memberList.count < 5) {
        headerHeight = (((self.groupDetail.memberList.count + 2)/5) + 1) * 70 + 10;
    }else {
        headerHeight = (((self.groupDetail.memberList.count + 2)/5) + 1) * 70 + 20;
    }
    self.headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, headerHeight)];
    self.headerV.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.headerV];
    self.userArr = [NSMutableArray array];
    NSLog(@"群组管理：%@  群主:%@",self.groupDetail.adminList,self.groupDetail.owner);
    if (self.groupDetail.memberList.count != 0) {
        [[NetWorking network] POST:kUsli params:@{@"userIds":[self.groupDetail.memberList componentsJoinedByString:@","],} cache:NO success:^(id result) {
            NSLog(@"%@",result);
            [self.userArr addObjectsFromArray:result];
            [self.userArr addObject:@{@"img":@"weitouxiang",@"nickname":@"",}];
            [self.userArr addObject:@{@"img":@"weitouxiang",@"nickname":@"",}];
            [self addheaderGroupMemberWithmemberlist:self.userArr];
        } failure:^(NSString *description) {
            [self.userArr addObject:@{@"img":@"weitouxiang",@"nickname":@"",}];
            [self.userArr addObject:@{@"img":@"weitouxiang",@"nickname":@"",}];
            [self addheaderGroupMemberWithmemberlist:self.userArr];
        }];
    }else {
        [self.userArr addObject:@{@"img":@"weitouxiang",@"nickname":@"",}];
        [self.userArr addObject:@{@"img":@"weitouxiang",@"nickname":@"",}];
        [self addheaderGroupMemberWithmemberlist:self.userArr];
    }

    
    self.portraitV = [self addSwitchView:CGRectMake(0, self.headerV.bottom + 10, kSCREEN_WIDTH, 50) title:@"群头像" content:nil imgView:@"weitouxiang" subTitle:nil isRowRight:YES];
    self.portraitV.tag = PortraitViewTag;
    [self.scrollView addSubview:self.portraitV];
    
    self.nameV = [self addSwitchView:CGRectMake(0, self.portraitV.bottom, kSCREEN_WIDTH, 50) title:@"群名称" content:nil imgView:nil subTitle:self.groupDetail.subject isRowRight:YES];
    self.nameV.tag = NameViewTag;
    [self.scrollView addSubview:self.nameV];
    
    CGFloat height;
    if (kNotNil(self.groupDetail.announcement)) {
        height = [self.groupDetail.announcement sizeWithMaxWidth:kSCREEN_WIDTH - 45 font:[UIFont systemFontOfSize:14]].height;
    }else {
        height = 5;
    }
    self.announcementV = [self addSwitchView:CGRectMake(0, self.nameV.bottom, kSCREEN_WIDTH, height + 45) title:@"群公告" content:self.groupDetail.announcement imgView:nil subTitle:nil isRowRight:YES];
    self.announcementV.tag = AnnouncementViewTag;
    [self.scrollView addSubview:self.announcementV];
    
    self.shareV = [self addSwitchView:CGRectMake(0, self.announcementV.bottom, kSCREEN_WIDTH, 50) title:@"分享群" content:nil imgView:@"weitouxiang" subTitle:nil isRowRight:YES];
    self.shareV.tag = ShareViewTag;
    [self.scrollView addSubview:self.shareV];

    self.meNameV = [self addSwitchView:CGRectMake(0, self.shareV.bottom + 10, kSCREEN_WIDTH, 50) title:@"我的群昵称" content:nil imgView:nil subTitle:@"李丽丽" isRowRight:YES];
    self.meNameV.tag = MeNameViewTag;
    [self.scrollView addSubview:self.meNameV];

    
    self.stickV = [self addSwitchView:CGRectMake(0, self.meNameV.bottom + 10, kSCREEN_WIDTH, 50) title:@"置顶该消息" content:nil imgView:nil subTitle:nil isRowRight:NO];
    self.stickV.tag = StickViewTag;
    [self.scrollView addSubview:self.stickV];

    self.noDisturbingV = [self addSwitchView:CGRectMake(0, self.stickV.bottom, kSCREEN_WIDTH, 50) title:@"消息免打扰" content:nil imgView:nil subTitle:nil isRowRight:NO];
    self.noDisturbingV.tag = NoDisturbingViewTag;
    [self.scrollView addSubview:self.noDisturbingV];
    
    self.addManagerV = [self addSwitchView:CGRectMake(0, self.noDisturbingV.bottom + 10, kSCREEN_WIDTH, 50) title:@"设置管理员" content:nil imgView:nil subTitle:nil isRowRight:YES];
    self.addManagerV.tag = AddManagerViewTag;
    [self.scrollView addSubview:self.addManagerV];
    
    self.searchV = [self addSwitchView:CGRectMake(0, self.addManagerV.bottom, kSCREEN_WIDTH, 50) title:@"允许群被搜索" content:nil imgView:nil subTitle:nil isRowRight:NO];
    self.searchV.tag = SearchViewTag;
    [self.scrollView addSubview:self.searchV];
    
    self.holdingV = [self addSwitchView:CGRectMake(0, self.searchV.bottom, kSCREEN_WIDTH, 50) title:@"允许群成员拉人进群" content:nil imgView:nil subTitle:nil isRowRight:NO];
    self.holdingV.tag = HoldingViewTag;
    [self.scrollView addSubview:self.holdingV];
    
    [self addSwitch];
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, headerHeight + 450 + 60 + self.announcementV.height);

    UITapGestureRecognizer *portaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];

    UITapGestureRecognizer *annountTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];

    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];

    UITapGestureRecognizer *meNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];

    UITapGestureRecognizer *addManagerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickWithTag:)];
    
    [self.portraitV addGestureRecognizer:portaTap];
    [self.nameV addGestureRecognizer:nameTap];
    [self.announcementV addGestureRecognizer:annountTap];
    [self.shareV addGestureRecognizer:shareTap];
    [self.meNameV addGestureRecognizer:meNameTap];
    [self.addManagerV addGestureRecognizer:addManagerTap];
}

- (void)btnClickWithTag:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case PortraitViewTag: {
            [[CSRouter share] push:@"XLBAddGroupMemberViewController" Params:nil hideBar:YES];
        }
            break;
        case NameViewTag: {
            EMError *error = nil;
            // 修改群名称
            [[EMClient sharedClient].groupManager changeGroupSubject:@"群聊10" forGroup:self.groupDetail.groupId error:&error];
            if (!error) {
                NSLog(@"修改成功");
            }
        }
            break;
        case AnnouncementViewTag: {
            [[EMClient sharedClient].groupManager updateGroupAnnouncementWithId:self.groupDetail.groupId announcement:@"欢迎加入大家庭，让我们一起嗨翻天！" completion:^(EMGroup *aGroup, EMError *aError) {
                if (!aError) {
                    NSLog(@"修改成功");
                }
            }];
        }
            break;
        case ShareViewTag: {
            [self btnClick];
        }
            break;
        case MeNameViewTag: {
            
        }
            break;
        case AddManagerViewTag: {
            [[CSRouter share] push:@"XLBAddManagerViewController" Params:nil hideBar:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)isStichClick:(UISwitch *)groupSwitch {

}

- (void)noDisturbingClick:(UISwitch *)groupSwitch {
    if (groupSwitch.on) {
        [[EMClient sharedClient].groupManager blockGroup:self.groupDetail.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            if(!aError) {
                NSLog(@"屏蔽成功");
            }
        }];
//        EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:self.groupDetail.groupId ignore:NO];
//        NSLog(@"群聊屏蔽%@",error);

    }else {
        [[EMClient sharedClient].groupManager unblockGroup:self.groupDetail.groupId completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                NSLog(@"取消屏蔽");
            }
        }];
//        EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:self.groupDetail.groupId ignore:NO];
//        NSLog(@"群聊屏蔽%@",error);
    }
    
}

- (void)searchClick:(UISwitch *)groupSwitch {
    
}

- (void)holdingClick:(UISwitch *)groupSwitch {
    
}

- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == self.userArr.count -1) {
        NSLog(@"删除群成员");
    }else if (sender.tag == self.userArr.count -2) {
        NSLog(@"添加群成员");
    }else {
        NSLog(@"群成员头像");
    }
}

- (void)addheaderGroupMemberWithmemberlist:(NSArray *)memberList{
    if (memberList.count > 10) {
        _MaxCount = 10;
    }else {
        _MaxCount = memberList.count;
    }
    _rowNuber =btnnumber;
    float kimgWidth = 50; //控件大小
    float kspace = (kSCREEN_WIDTH-20-50*_rowNuber)/(_rowNuber+1);
    float kHspace = 10;
    for (NSInteger i=0; i<memberList.count; i++) {
        NSInteger y = i/_rowNuber;
        NSInteger x = i-y*_rowNuber;
        NSLog(@"%ld",y);
        [self addBtnWithframe:CGRectMake((kspace+kimgWidth)*x+kspace, 10 + y*kHspace+y*(kHspace+kimgWidth), kimgWidth, kimgWidth) WithImageName:memberList[i][@"img"] WithTag:i withTitle:memberList[i][@"nickname"]];
    }
}

-(void)addBtnWithframe:(CGRect)frame WithImageName:(NSString *)img WithTag:(NSInteger)tag withTitle:(NSString *)nickName{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];

    [button sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    button.imageView.contentMode =UIViewContentModeScaleAspectFill;
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor redColor];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerV addSubview:button];
    
    UILabel *label = [UILabel new];
    label.text = nickName;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor textBlackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.headerV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).with.offset(3);
        make.centerX.mas_equalTo(button);
        make.width.mas_equalTo(button.width + 10);
    }];
}

- (UIView *)addSwitchView:(CGRect)rect title:(NSString *)title content:(NSString *)content imgView:(NSString *)img subTitle:(NSString *)subTitle  isRowRight:(BOOL)right {
    UIView *bgView = [[UIView alloc] initWithFrame:rect];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor textBlackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = title;
    [bgView addSubview:titleLabel];
    
    if (kNotNil(content)) {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
        }];
        UILabel *contentLabel = [UILabel new];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor textBlackColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.numberOfLines = 2;
        contentLabel.text = content;
        [bgView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(5);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-30);
        }];
    }else {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(bgView);
        }];
    }
    if (right) {
        UIImageView *rightImg = [UIImageView new];
        rightImg.image = [UIImage imageNamed:@"icon_wd_fh"];
        [bgView addSubview:rightImg];

        [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(bgView);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(13.5);
        }];

        if (img) {
            UIImageView *imgV = [UIImageView new];
            [imgV sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
            imgV.layer.masksToBounds = YES;
            imgV.layer.cornerRadius = 20;
            imgV.backgroundColor = [UIColor redColor];
            [bgView addSubview:imgV];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(rightImg.mas_left).with.offset(-5);
                make.centerY.mas_equalTo(bgView);
                make.width.height.mas_equalTo(40);
            }];
        }
        if (subTitle) {
            UILabel *subLabel = [UILabel new];
            subLabel.text = subTitle;
            subLabel.textColor = [UIColor textBlackColor];
            subLabel.font = [UIFont systemFontOfSize:15];
            subLabel.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:subLabel];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(rightImg.mas_left).with.offset(-5);
                make.centerY.mas_equalTo(bgView);
            }];
        }
        
    }
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [bgView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgView.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    return bgView;
}

-(void)addSwitch{
    self.switch_stick = [UISwitch new];
    [self.switch_stick addTarget:self action:@selector(isStichClick:) forControlEvents:UIControlEventValueChanged];
    [self.stickV addSubview:self.switch_stick];
    self.switch_noDisturbing = [UISwitch new];
    [self.switch_noDisturbing addTarget:self action:@selector(noDisturbingClick:) forControlEvents:UIControlEventValueChanged];
    self.switch_noDisturbing.on = NO;
    [self.noDisturbingV addSubview:self.switch_noDisturbing];

    self.switch_search = [UISwitch new];
    [self.switch_search addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventValueChanged];
    [self.searchV addSubview:self.switch_search];
    self.switch_holding = [UISwitch new];
    [self.switch_holding addTarget:self action:@selector(holdingClick:) forControlEvents:UIControlEventValueChanged];
    [self.holdingV addSubview:self.switch_holding];
    

    [self.switch_stick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stickV);
        make.right.mas_equalTo(self.stickV.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.switch_noDisturbing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.noDisturbingV);
        make.right.mas_equalTo(self.noDisturbingV.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.switch_search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchV);
        make.right.mas_equalTo(self.searchV.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.switch_holding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.holdingV);
        make.right.mas_equalTo(self.holdingV.mas_right).with.offset(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
}


- (void)btnClick {
    NSLog(@"群组管理2：%@  %@ %d  %@  %@",self.groupDetail.owner,self.groupDetail.adminList,self.groupDetail.occupantsCount,self.groupDetail.memberList,[XLBUser user].userModel.ID);
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
