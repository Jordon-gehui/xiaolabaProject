//
//  XLBRankingListViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBRankingListViewController.h"
#import "SLCycleScrollView.h"
#import "LoginView.h"
#import "LittleHeadModel.h"
#import "VoiceActorOwnerViewController.h"
#import "XLBAlertController.h"
#import "BaseWebViewController.h"
#import "ReportChatViewController.h"

@interface XLBRankingListViewController ()<SLCycleScrollViewDelegate,SLCycleScrollViewDatasource>
{
    NSDictionary *dataDic;
}
@property (nonatomic,strong) UIScrollView *bgScrollV;
@property (nonatomic,strong) SLCycleScrollView *csView;
@property (nonatomic,strong) NSMutableArray *bannersArr;
@property (nonatomic,strong) UIView *topRankingView;
@property (nonatomic,strong) UIView *midRankingView;


@end
#define BannerHeight (kSCREEN_WIDTH * 2 / 5)

@implementation XLBRankingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    NSString *bannerPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *bannerSubPath=[bannerPath stringByAppendingPathComponent:@"RankBannerData.archiver"];
    NSArray * bannerData = [NSKeyedUnarchiver unarchiveObjectWithFile:bannerSubPath];
    if (bannerData) {
        self.bannersArr = [LittleHeadModel mj_objectArrayWithKeyValuesArray:bannerData];
        [self.csView reloadData];
        if (self.bannersArr.count == 1) {
            [self.csView.pageControl setHidden:YES];
        }else {
            [self.csView.pageControl setHidden:NO];
        }
    }
    // Do any additional setup after loading the view.
    //排行榜
    [self loadHeaderView];
    [self httpLoadData];
}
-(void)loadHeaderView{
    kWeakSelf(self)
    [[NetWorking network] POST:kRankBanners params:nil cache:NO success:^(id result) {
        weakSelf.bannersArr = [LittleHeadModel mj_objectArrayWithKeyValuesArray:result];
        
        [self.csView reloadData];
        if (weakSelf.bannersArr.count == 1) {
            [self.csView.pageControl setHidden:YES];
        }else {
            [self.csView.pageControl setHidden:NO];
        }
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path=[docPath stringByAppendingPathComponent:@"RankBannerData.archiver"];
        BOOL falg = [NSKeyedArchiver archiveRootObject:result toFile:path];
        if (falg == YES) {
            NSLog(@"归档成功");
        }else {
            NSLog(@"归档失败");
        }
    } failure:^(NSString *description) {
        
    }];
    
}
-(void)httpLoadData {
    kWeakSelf(self)
//    [[NetWorking network] POST:kSYRankIn params:nil cache:NO success:^(id result) {
//        NSLog(@"%@",result);
//        dataDic = result;
//        [weakSelf viewSetData];
//    } failure:^(NSString *description) {
//        
//    }];
}
-(void)viewSetData{
    NSArray *syList = [dataDic objectForKey:@"akira"];
    if (syList.count>0) {
        NSDictionary *fristDic = [syList firstObject];
        UIImageView *fristImg = [self.topRankingView viewWithTag:11];
        [fristImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[fristDic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:nil];
    }
    
    if (syList.count>1) {
        NSDictionary *secondDic = [syList objectAtIndex:1];
        UIImageView *secondImg = [self.topRankingView viewWithTag:22];
        [secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[secondDic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:nil];
    }
    if (syList.count>2) {
        NSDictionary *thirdDic = [syList objectAtIndex:2];
        UIImageView *thirdImg = [self.topRankingView viewWithTag:33];
        [thirdImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[thirdDic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:nil];
    }
    
    NSArray *yzList = [dataDic objectForKey:@"face"];
    if (yzList.count>0) {
        NSDictionary *fristDic = [yzList firstObject];
        UIImageView *fristImg = [self.midRankingView viewWithTag:11];
        [fristImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[fristDic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:nil];
    }
    
    if (yzList.count>1) {
        NSDictionary *secondDic = [yzList objectAtIndex:1];
        UIImageView *secondImg = [self.midRankingView viewWithTag:22];
        [secondImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[secondDic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:nil];
    }
    if (yzList.count>2) {
        NSDictionary *thirdDic = [yzList objectAtIndex:2];
        UIImageView *thirdImg = [self.midRankingView viewWithTag:33];
        [thirdImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[thirdDic objectForKey:@"img"] Withtype:IMGAvatar]] placeholderImage:nil];
    }
}
-(UIView *)addTopRankingViewFrame:(CGRect)rect :(NSString*)title WithTag:(NSInteger)tag{
    UIView *tempView = [[UIView alloc]initWithFrame:rect];
    tempView.backgroundColor = [UIColor whiteColor];
    tempView.tag = tag;
    UIImageView *imageV = [UIImageView new];
    if (tag == 1) {
        [imageV setImage:[UIImage imageNamed:@"icon_phb_sy"]];
    }else{
        [imageV setImage:[UIImage imageNamed:@"pic_phb_yz"]];
    }
    [tempView addSubview:imageV];
    UILabel *titleLbl = [UILabel new];
    titleLbl.text = title;
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textColor = [UIColor textBlackColor];
    [tempView addSubview:titleLbl];
    UILabel *rightLbl = [UILabel new];
    rightLbl.text = @"更多 >";
    rightLbl.font = [UIFont systemFontOfSize:13];
    rightLbl.textColor = [UIColor textRightColor];
    [tempView addSubview:rightLbl];
    
    UIImageView *fristHeaderImg = [UIImageView new];
    fristHeaderImg.image = [UIImage imageNamed:@"pic_phb_g"];
    fristHeaderImg.backgroundColor = [UIColor clearColor];
    [tempView addSubview:fristHeaderImg];
    
    UIImageView *fristImg = [UIImageView new];
    fristImg.image = [UIImage imageNamed:@"weitouxiang"];
    [fristImg setUserInteractionEnabled:YES];
    fristImg.layer.cornerRadius = (105*kiphone6_ScreenWidth)/2.0;
    fristImg.tag = 11;
    fristImg.layer.masksToBounds = YES;
    fristImg.backgroundColor = [UIColor clearColor];
    [tempView addSubview:fristImg];
    
    UIImageView *secondHeaderImg = [UIImageView new];
    secondHeaderImg.image = [UIImage imageNamed:@"pic_phb_y"];
    secondHeaderImg.backgroundColor = [UIColor clearColor];
    [tempView addSubview:secondHeaderImg];
    
    UIImageView *secondImg = [UIImageView new];
    secondImg.image = [UIImage imageNamed:@"weitouxiang"];
    [secondImg setUserInteractionEnabled:YES];
    secondImg.layer.cornerRadius = (90*kiphone6_ScreenWidth)/2.0;
    secondImg.tag = 22;
    secondImg.layer.masksToBounds = YES;
    secondImg.backgroundColor = [UIColor clearColor];
    [tempView addSubview:secondImg];
    
    UIImageView *thirdHeaderImg = [UIImageView new];
    thirdHeaderImg.image = [UIImage imageNamed:@"pic_phb_j"];
    thirdHeaderImg.backgroundColor = [UIColor clearColor];
    [tempView addSubview:thirdHeaderImg];
    
    UIImageView *thirdImg = [UIImageView new];
    thirdImg.image = [UIImage imageNamed:@"weitouxiang"];
    [thirdImg setUserInteractionEnabled:YES];
    thirdImg.layer.cornerRadius = (90*kiphone6_ScreenWidth)/2.0;
    thirdImg.tag = 33;
    thirdImg.layer.masksToBounds = YES;
    [tempView addSubview:thirdImg];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewClick:)];
    [tempView addGestureRecognizer:tapView];
    UITapGestureRecognizer *tapFristView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFristViewClick:)];
    UILongPressGestureRecognizer *longPressFristView = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFristViewClick:)];
    [fristImg addGestureRecognizer:longPressFristView];
    [fristImg addGestureRecognizer:tapFristView];
    UITapGestureRecognizer *tapSecondView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSecondViewClick:)];
    UILongPressGestureRecognizer *longPressSecondView = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSecondViewClick:)];
    [secondImg addGestureRecognizer:longPressSecondView];
    [secondImg addGestureRecognizer:tapSecondView];
    UITapGestureRecognizer *tapThirdView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapThirdViewClick:)];
    UILongPressGestureRecognizer *longPressThirdView = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressThirdViewClick:)];
    [thirdImg addGestureRecognizer:longPressThirdView];
    [thirdImg addGestureRecognizer:tapThirdView];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(tempView).with.offset(15);
        make.width.height.mas_offset(20);
    }];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageV.mas_right).with.offset(5);
        make.centerY.mas_equalTo(imageV);
    }];
    [rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tempView.mas_right).with.offset(-15);
        make.centerY.mas_equalTo(imageV);
    }];
    [fristImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLbl.mas_bottom).with.offset(25);
        make.centerX.mas_equalTo(tempView);
        make.width.height.mas_equalTo(105*kiphone6_ScreenWidth);
    }];
    [secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(fristImg.mas_bottom);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(90*kiphone6_ScreenWidth);
    }];
    [thirdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(fristImg.mas_bottom);
        make.right.mas_equalTo(tempView.mas_right).with.offset(-20);
        make.width.height.mas_equalTo(90*kiphone6_ScreenWidth);
    }];
    [fristHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(fristImg.mas_top).with.offset(6);
        make.centerX.mas_equalTo(fristImg);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    [secondHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(secondImg.mas_top).with.offset(6);
        make.centerX.mas_equalTo(secondImg);
        make.width.mas_equalTo(40*3/4.0);
        make.height.mas_equalTo(30*3/4.0);
    }];
    [thirdHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(thirdImg.mas_top).with.offset(6);
        make.centerX.mas_equalTo(thirdImg);
        make.width.mas_equalTo(40*3/4.0);
        make.height.mas_equalTo(30*3/4.0);
    }];
    return tempView;
}
- (void) initViews {
    [self.bgScrollV addSubview:self.csView];
    self.topRankingView = [self addTopRankingViewFrame:CGRectMake(0, self.csView.bottom+15, kSCREEN_WIDTH, 183) :@"声优排行榜" WithTag:1];
    [self.bgScrollV addSubview:self.topRankingView];
    self.midRankingView = [self addTopRankingViewFrame:CGRectMake(0, self.topRankingView.bottom+5, kSCREEN_WIDTH, 183) :@"点赞排行榜" WithTag:2];
    [self.bgScrollV addSubview:self.midRankingView];

}

- (UIScrollView *)bgScrollV {
    if (!_bgScrollV) {
        _bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom  -44)];
        _bgScrollV.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT-44 + 1);
        [self.view addSubview:self.bgScrollV];
    }
    return _bgScrollV;
}

//2 颜值排行榜点击 1声优 3 土豪
-(void)tapViewClick:(UITapGestureRecognizer*)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    if (sender.view.tag ==1) {
        [[CSRouter share]push:@"XLBRankingListDetailViewController" Params:@{@"rankList_sy":@"1"} hideBar:YES];

    }else if (sender.view.tag ==2){
        [[CSRouter share]push:@"XLBRankingListDetailViewController" Params:@{@"rankList_sy":@"0"} hideBar:YES];
    }
}
-(void)tapFristViewClick:(UITapGestureRecognizer*)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    NSInteger tag = sender.view.superview.tag;
    if (tag ==1) {
        NSArray *list = [dataDic objectForKey:@"akira"];
        if (list.count>0) {
            NSDictionary *dic = [list objectAtIndex:0];
            NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            VoiceActorOwnerViewController * oner = [VoiceActorOwnerViewController new];
            oner.userID = userId;
            oner.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:oner animated:YES];
        }
    }else if (tag ==2){
        NSArray *list = [dataDic objectForKey:@"face"];
        if (list.count>0) {
            NSDictionary *dic = [list objectAtIndex:0];
            NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            OwnerViewController * oner = [OwnerViewController new];
            oner.userID = userId;
            oner.delFlag = 0;
            oner.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:oner animated:YES];
        }
    }
}
- (void)longPressFristViewClick:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
            [LoginView addLoginView];
            return;
        }
        NSInteger tag = gesture.view.superview.tag;
        if (tag ==1) {
            NSArray *list = [dataDic objectForKey:@"akira"];
            if (list.count>0) {
                NSDictionary *dic = [list objectAtIndex:0];
                NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self showAlertViewWithUserID:userId];

            }
        }else if (tag ==2){
            NSArray *list = [dataDic objectForKey:@"face"];
            if (list.count>0) {
                NSDictionary *dic = [list objectAtIndex:0];
                NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self showAlertViewWithUserID:userId];
            }
        }
    }
}

- (void)showAlertViewWithUserID:(NSString *)userId {
    
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"确定"] title:@"您确定举报该用户？" message:@"" cancel:YES cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        ReportChatViewController *chat = [ReportChatViewController new];
        chat.hidesBottomBarWhenPushed = YES;
        chat.reportType = @"4";
        chat.detailID = userId;
        [self.navigationController pushViewController:chat animated:YES];
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)tapSecondViewClick:(UITapGestureRecognizer*)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    NSInteger tag = sender.view.superview.tag;
    if (tag ==1) {
        NSArray *list = [dataDic objectForKey:@"akira"];
        if (list.count>1) {
            NSDictionary *dic = [list objectAtIndex:1];
            NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            VoiceActorOwnerViewController * oner = [VoiceActorOwnerViewController new];
            oner.userID = userId;
            oner.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:oner animated:YES];
        }
    }else if (tag ==2){
        NSArray *list = [dataDic objectForKey:@"face"];
        if (list.count>1) {
            NSDictionary *dic = [list objectAtIndex:1];
            NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            OwnerViewController * oner = [OwnerViewController new];
            oner.userID = userId;
            oner.delFlag = 0;
            oner.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:oner animated:YES];
        }
    }
}

- (void)longPressSecondViewClick:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
            [LoginView addLoginView];
            return;
        }
        NSInteger tag = longPress.view.superview.tag;
        if (tag ==1) {
            NSArray *list = [dataDic objectForKey:@"akira"];
            if (list.count>1) {
                NSDictionary *dic = [list objectAtIndex:1];
                NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self showAlertViewWithUserID:userId];
            }
        }else if (tag ==2){
            NSArray *list = [dataDic objectForKey:@"face"];
            if (list.count>1) {
                NSDictionary *dic = [list objectAtIndex:1];
                NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self showAlertViewWithUserID:userId];
            }
        }
    }
}
-(void)tapThirdViewClick:(UITapGestureRecognizer*)sender {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    NSInteger tag = sender.view.superview.tag;
    if (tag ==1) {
        NSArray *list = [dataDic objectForKey:@"akira"];
        if (list.count>2) {
            NSDictionary *dic = [list objectAtIndex:2];
            NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            VoiceActorOwnerViewController * oner = [VoiceActorOwnerViewController new];
            oner.userID = userId;
            oner.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:oner animated:YES];
        }
    }else if (tag ==2){
        NSArray *list = [dataDic objectForKey:@"face"];
        if (list.count>2) {
            NSDictionary *dic = [list objectAtIndex:2];
            NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            OwnerViewController * oner = [OwnerViewController new];
            oner.userID = userId;
            oner.delFlag = 0;
            oner.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:oner animated:YES];
        }
    }
}

- (void)longPressThirdViewClick:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
            [LoginView addLoginView];
            return;
        }
        NSInteger tag = longPress.view.superview.tag;
        if (tag ==1) {
            NSArray *list = [dataDic objectForKey:@"akira"];
            if (list.count>2) {
                NSDictionary *dic = [list objectAtIndex:2];
                NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self showAlertViewWithUserID:userId];
                
            }
        }else if (tag ==2){
            NSArray *list = [dataDic objectForKey:@"face"];
            if (list.count>2) {
                NSDictionary *dic = [list objectAtIndex:2];
                NSString *userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self showAlertViewWithUserID:userId];
            }
        }
    }
}

#pragma mark -SLCycleScrollViewDatasource
- (NSInteger)numberOfPages {
    return self.bannersArr.count;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    if (index > self.bannersArr.count-1) {
        return [UIView new];
    }
    
    LittleHeadModel *banner = self.bannersArr[index];

    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.csView.width, self.csView.height)];
    v.contentMode = UIViewContentModeScaleAspectFill;
    v.clipsToBounds = YES;
    [v sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:banner.image Withtype:IMGNormal]] placeholderImage:nil options:SDWebImageRetryFailed];    
    return v;
}

#pragma mark -SLCycleScrollViewDelegate
- (void)didClickPage:(SLCycleScrollView *)csView atIndex:(NSInteger)index {
    [[CSRouter share] push:@"RankingExplainViewController" Params:nil hideBar:YES];
}

- (SLCycleScrollView *)csView {
    if (!_csView) {
        _csView = [[SLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, BannerHeight)];
        
        [_csView setDelegate:self];
        [_csView setDataource:self];
    }
    return _csView;
}
- (void)showAlert {
    NSString *alertString = @"你已申请挪车贴，不能再次申请，关注公众号“小喇叭挪车”，更多精美挪车贴等你来取~";
    
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"确定"] title:nil message:alertString cancel:NO cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        
    }];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, alertString.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertString.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSMutableArray *)bannersArr{
    
    if (!_bannersArr) {
        _bannersArr = [NSMutableArray array];
    }
    return _bannersArr;
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
