//
//  XLBRecommendViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBRecommendViewController.h"
#import "NewsDetailPage.h"
#import "InformationCell.h"
#import "InformationImgCell.h"
#import "homeSYRecommendCell.h"
#import "SLCycleScrollView.h"
#import "LittleHeadModel.h"
#import "LoginView.h"
#import "BaseWebViewController.h"
#import "XLBAlertController.h"
#import "VoiceActorOwnerViewController.h"
#import "MomentsCell.h"
#import "LittleDetailViewController.h"

@interface XLBRecommendViewController ()<SLCycleScrollViewDelegate,SLCycleScrollViewDatasource,homeSyRecommendCellDelegate,MomentsCellDelegate>
{
     SLCycleScrollView *littleHeadView;
}
@property (strong,nonatomic) NSMutableArray *bannersArr;
@property (strong,nonatomic) NSMutableDictionary *heightDic;

@end

#define BannerHeight (kSCREEN_WIDTH * 2 / 5)

static NSString *const celldef = @"celldef";
static NSString *const cellvalue1 = @"cellvalue1";
static NSString *const cellvalue2 = @"cellvalue2";

@implementation XLBRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //推荐
    self.heightDic = [NSMutableDictionary dictionary];
    self.isGrouped = YES;
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"SYData.archiver"];
    NSArray *mainData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (mainData) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.data = [NSMutableArray arrayWithArray:mainData];
        [self.tableView reloadData];
    }
    [self setup];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginSuccess) name:@"logout" object:nil];
}
- (void)loginSuccess {
    [self.tableView.mj_header beginRefreshing];
}
- (void)setup {
    self.tableView.estimatedRowHeight = 200.f;
    self.tableView.backgroundColor = RGB(248, 248, 248);
    self.allowRefresh = YES;
    self.allowLoadMore =YES;
    [self.tableView registerClass:[InformationCell class] forCellReuseIdentifier:[InformationCell cellReuseIdentifier]];
    [self.tableView registerClass:[InformationImgCell class] forCellReuseIdentifier:[InformationImgCell cellOneIdentifier]];
    [self.tableView registerClass:[InformationImgCell class] forCellReuseIdentifier:[InformationImgCell cellImgsIdentifier]];
    [self.tableView registerClass:[homeSYRecommendCell class] forCellReuseIdentifier:[homeSYRecommendCell cellReuseIdentifier]];
    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:celldef];
    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:cellvalue1];
    [self.tableView registerClass:[MomentsCell class] forCellReuseIdentifier:cellvalue2];

    
    NSString *bannerPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *bannerSubPath=[bannerPath stringByAppendingPathComponent:@"BannerData.archiver"];
    NSArray * bannerData = [NSKeyedUnarchiver unarchiveObjectWithFile:bannerSubPath];
    if (bannerData) {
        self.bannersArr = [LittleHeadModel mj_objectArrayWithKeyValuesArray:bannerData];
        self.tableView.tableHeaderView = [self littleHeadView];
        if (self.bannersArr.count == 1) {
            [littleHeadView.pageControl setHidden:YES];
        }else {
            [littleHeadView.pageControl setHidden:NO];
        }
        [littleHeadView  reloadData];
    }
    //解档

    [self loadHeaderView];
}
-(void)loadHeaderView{
    kWeakSelf(self)
    [[NetWorking network] POST:kBanners params:nil cache:NO success:^(id result) {
        weakSelf.bannersArr = [LittleHeadModel mj_objectArrayWithKeyValuesArray:result];
        
        self.tableView.tableHeaderView = [self littleHeadView];
        if (weakSelf.bannersArr.count == 1) {
            [littleHeadView.pageControl setHidden:YES];
        }else {
            [littleHeadView.pageControl setHidden:NO];
        }
        [littleHeadView reloadData];
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path=[docPath stringByAppendingPathComponent:@"BannerData.archiver"];
        BOOL falg = [NSKeyedArchiver archiveRootObject:result toFile:path];
        if (falg == YES) {
            NSLog(@"归档成功");
        }else {
            NSLog(@"归档失败");
        }
    } failure:^(NSString *description) {

    }];

}
-(void)refresh {
    self.page = 0;
    [self loadHttp];
}
-(void)loadMore {
    [self loadHttp];
}
-(void)loadHttp{
    self.page ++;
    NSDictionary *params = @{@"createUser":@"",@"page":@{@"curr":@(self.page),
                                                         @"size":@(10)}};
    if ([XLBUser user].isLogin &&kNotNil([XLBUser user].token)) {
        NSString *userId = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
        params = @{@"createUser":userId,@"page":@{@"curr":@(self.page),
                                                @"size":@(10)}};
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NetWorking network] POST:kSYtuijian params:params cache:NO success:^(id result) {
            NSLog(@"=====%@",result);
            NSMutableArray *arr = [NSMutableArray arrayWithArray:result];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (self.page ==1) {
                NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
                NSString *path=[docPath stringByAppendingPathComponent:@"SYData.archiver"];
                BOOL falg = [NSKeyedArchiver archiveRootObject:arr toFile:path];
                if (falg == YES) {
                    NSLog(@"归档成功");
                }else {
                    NSLog(@"归档失败");
                }
            }
            if (self.page ==1&&arr.count>1){
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
            });
            if (arr.count<10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSString *description) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }];
    });
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mode"]];
    //model 1大图 2小图 3 多图 -1 声优 -2  -3
    NSLog(@"modelStr = %@",typeStr);
    id cell;
    if ([typeStr isEqualToString:@"1"]) {
        InformationImgCell *infocell = [tableView dequeueReusableCellWithIdentifier:[InformationImgCell cellOneIdentifier]];
        [infocell setViewData:dic];
        cell = infocell;
    }else if ([typeStr isEqualToString:@"3"]) {
        InformationImgCell *infocell = [tableView dequeueReusableCellWithIdentifier:[InformationImgCell cellImgsIdentifier] forIndexPath:indexPath];;
        [infocell setViewData:dic];
        cell = infocell;
    }else if ([typeStr isEqualToString:@"2"]) {
        InformationCell *infocell = [tableView dequeueReusableCellWithIdentifier:[InformationCell cellReuseIdentifier] forIndexPath:indexPath];;
        [infocell setViewData:dic];
        cell = infocell;
    }else if ([typeStr isEqualToString:@"-1"]||[typeStr isEqualToString:@"-2"]) {
        NSArray*tempList;
        NSInteger is_sy = 0; //是否是声优
        if ([typeStr isEqualToString:@"-2"]) { //车友
            tempList = [dic objectForKey:@"listNear"];
        }else{//声优
            tempList = [dic objectForKey:@"list"];
            is_sy = 1;
        }
        homeSYRecommendCell *infocell = [tableView dequeueReusableCellWithIdentifier:[homeSYRecommendCell cellReuseIdentifier]];
        [infocell setViewData:tempList :is_sy];
        [infocell setDelegate:self];
        cell = infocell;
    }else { //-3。动态
        NSDictionary *modelDic = [dic objectForKey:@"moment"];
        LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
        MomentsCell *littleCell;
        if (model.imgs.count ==1) {
            littleCell = [tableView dequeueReusableCellWithIdentifier:cellvalue1];
        }else if(model.imgs.count>1){
            littleCell = [tableView dequeueReusableCellWithIdentifier:cellvalue2];
        }else {
            littleCell = [tableView dequeueReusableCellWithIdentifier:celldef];
        }
        [littleCell setDelegate:self];
        [littleCell setModel:model];
        cell = littleCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *modelStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mode"]];
    if (![modelStr isEqualToString:@"-1"]&&![modelStr isEqualToString:@"-2"]&&![modelStr isEqualToString:@"-3"]) {
        NSString *webid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        [self newsClick:webid];
    }else{
        if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
            [LoginView addLoginView];
            return;
        }
        if ([modelStr isEqualToString:@"-1"]) {
            if ([self.delegate respondsToSelector:@selector(didSeleted:)]) {
                [self.delegate didSeleted:2];
            }
        }
        if ([modelStr isEqualToString:@"-3"]) {
            NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
            NSDictionary *modelDic = [dic objectForKey:@"moment"];
            LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
            
            MomentsCell *littleCell = [self.tableView cellForRowAtIndexPath:indexPath];
            //请求查看接口
            [self lookDataWith:model.ID with:littleCell];
        }
    }
    
}
- (void)lookDataWith:(NSString *)currentID with:(MomentsCell*)littleCell{
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",kLookLish,currentID];
    
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        littleCell.cellModel.views = [NSString stringWithFormat:@"%li",[littleCell.cellModel.views integerValue]+1];
        [self pushDetailVC:littleCell];
    } failure:^(NSString *description) {
        [self pushDetailVC:littleCell];
    }];
    
}
- (void)pushDetailVC:(MomentsCell*)littleCell {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    [MobClick event:@"Recommended_dynamic"];
    LittleDetailViewController *detail = [LittleDetailViewController new];
    detail.hidesBottomBarWhenPushed = YES;
    detail.detailModel = littleCell.cellModel;
    detail.returnBlock = ^(id data) {
        LittleHornTableViewModel *littleModl = data;
        int index = 0;
        for (int i=0; i<self.data.count; i++) {
            NSDictionary *tempDic = self.data[i];
            LittleHornTableViewModel *model =[LittleHornTableViewModel mj_objectWithKeyValues:tempDic];
            if ([littleModl.ID isEqualToString:model.ID]) {
                index = i;
                NSDictionary *dataDic = [littleModl mj_keyValues];
                [self.data replaceObjectAtIndex:i withObject:dataDic];
            }
        }
        [littleCell setModel:littleModl];
    };
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)newsClick:(NSString*)webId {
    [MobClick event:@"Recommended_News"];
    NewsDetailPage *web =[[NewsDetailPage alloc]init];
    web.hidesBottomBarWhenPushed = YES;
    web.webId = webId;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didSeletedWithuserId:(NSString *)userId :(NSInteger)is_sy {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    if (is_sy) {
        [MobClick event:@"Recommended_Voice"];

        VoiceActorOwnerViewController * oner = [VoiceActorOwnerViewController new];
        oner.userID = userId;
        oner.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:oner animated:YES];
    }else{
        [MobClick event:@"Recommended_CarFriend"];
        OwnerViewController *vc = [OwnerViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userID = userId;
        vc.delFlag = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - cell代理
-(void)cellReLoadDelegate:(NSIndexPath *)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    });
}
//删除
- (void)deleteCell:(NSString *)userId {
    
}
//头像
- (void)headImageClick:(MomentsCell*)cell withId:(NSString *)userID {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    OwnerViewController * oner = [OwnerViewController new];
    oner.userID = userID;
    oner.delFlag = 0;
    oner.hidesBottomBarWhenPushed =YES;
    oner.returnBlock = ^(id data) {
        NSDictionary *params = (NSDictionary *)data;
        NSString *string = [params objectForKey:@"follows"];
        BOOL isrefresh = NO;
        if (kNotNil(string)) {
            if ([string isEqualToString:@"1"]) {
                for (NSDictionary *dic in self.data) {
                    NSDictionary *modelDic = [dic objectForKey:@"moment"];
                    LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
                    if ([userID isEqualToString:model.createUser]) {
                        if (![model.follows isEqualToString:string]) {
                            model.follows = @"1";
                            isrefresh = YES;
                        }
                    }
                }
            }else {
                for (NSDictionary *dic in self.data) {
                    NSDictionary *modelDic = [dic objectForKey:@"moment"];
                    LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
                    if ([userID isEqualToString:model.createUser]) {
                        if (![model.follows isEqualToString:string]) {
                            model.follows = @"0";
                            isrefresh = YES;
                        }
                    }
                }
            }
            if (isrefresh) {
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }
    };
    [self.navigationController pushViewController:oner animated:YES];
}
//关注
- (void)followClick:(MomentsCell*)cell withId:(NSString *)userID {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    NSDictionary *dict = @{@"followId": userID ?: @""};
    if ([cell.cellModel.follows isEqualToString:@"1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定不再关注此人？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *creatain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NetWorking network] POST:kCancleFollow params:dict cache:NO success:^(id result) {
                NSLog(@"-----%@",result);
                for (NSDictionary *dic in self.data) {
                    NSDictionary *modelDic = [dic objectForKey:@"moment"];
                    LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
                    if ([userID isEqualToString:model.createUser]) {
                        model.follows = @"0";
                    }
                }
                [self.tableView reloadData];
            } failure:^(NSString *description) {
                [MBProgressHUD showError:@"取消关注失败"];
                
            }];
        }];
        [alert addAction:cancle];
        [alert addAction:creatain];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    }else{
        [[NetWorking network] POST:kAddFollow params:dict cache:NO success:^(id result) {
            for (NSDictionary *dic in self.data) {
                NSDictionary *modelDic = [dic objectForKey:@"moment"];
                LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
                if ([userID isEqualToString:model.createUser]) {
                    model.follows = @"1";
                }
            }
            [self.tableView reloadData];
            
        } failure:^(NSString *description) {
            
            [MBProgressHUD showError:@"关注失败"];
            
        }];
    }
    
}
//点赞
- (void)zanBuAddClick:(MomentsCell*)cell withId:(NSString *)currentID withLike:(NSString *)like {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",kPubZanlish,currentID];
    if ([like isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"不能重复点赞"];
        return;
    }
    [[NetWorking network] POST:str params:nil cache:NO success:^(id result) {
        for (NSDictionary *dic in self.data) {
            NSDictionary *modelDic = [dic objectForKey:@"moment"];
            LittleHornTableViewModel*model = [LittleHornTableViewModel mj_objectWithKeyValues:modelDic];
            if ([currentID isEqualToString:model.ID]) {
                model.liked = @"1";
                NSString *str =[NSString stringWithFormat:@" %ld", [model.likes integerValue] + 1];
                model.likes = str;
                [cell setModel:model];
            }
        }
        //        [self.tableView reloadData];
        //        [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"点赞失败"];
        
    }];
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

    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, littleHeadView.width, littleHeadView.height)];
    v.contentMode = UIViewContentModeScaleAspectFill;
    v.clipsToBounds = YES;
    [v sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:banner.image Withtype:IMGNormal]] placeholderImage:nil options:SDWebImageRetryFailed];
    //Printing description of banner->_image:
  //  http://zhangshangxiaolaba.oss-cn-shanghai.aliyuncs.com/banner/auth.png
    return v;
}

#pragma mark -SLCycleScrollViewDelegate
- (void)didClickPage:(SLCycleScrollView *)csView atIndex:(NSInteger)index {
    if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
        [LoginView addLoginView];
        return;
    }
    LittleHeadModel *banner = self.bannersArr[index];
    if ([banner.type isEqualToString:@"0"]) { //原生跳转
        NSLog(@"原生跳转%@",banner.url);
        [MobClick event:@"MainBanner_Native"];
        if (kNotNil(banner.url)) {
            // 创建对象
            if ([banner.url isEqualToString:@"XLBIdentityViewController"]) {
                if ([[XLBUser user].userModel.status integerValue] ==30) {
                    [MBProgressHUD showSuccess:@"已认证成功"];
                }else{
                    [[CSRouter share] push:banner.url Params:nil hideBar:YES];
                }
            }else if([banner.url isEqualToString:@"ApplyForViewController"]) {
                [[CSRouter share] push:banner.url Params:nil hideBar:YES];
            }else if([banner.url hasPrefix:@"vc"]) {
                NSString *str2 = [banner.url substringWithRange:NSMakeRange(2,banner.url.length-2)];
                
                if ([self.delegate respondsToSelector:@selector(didSeleted:)]) {
                    [self.delegate didSeleted:[str2 integerValue]];
                }
            }else{
                [[CSRouter share] push:banner.url Params:nil hideBar:YES];
            }

        }else {
            if ([[XLBUser user].userModel.status integerValue] ==30) {
                [MBProgressHUD showSuccess:@"已认证成功"];
            }else{
                [[CSRouter share] push:@"XLBIdentityViewController" Params:nil hideBar:YES];
            }
        }

    }else { //Url 跳转
        NSLog(@"url跳转%@",banner.url);
        [MobClick event:@"MainBanner_Url"];
        BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
        webVC.urlStr = banner.url;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }

}
- (void)showAlert {
    NSString *alertString = @"小喇叭车贴仅限免费申请一次 如需再次申请 拨打 021-59168603";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:alertString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"立即拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:021-59168603"]];
    }];
    [defaultAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor minorTextColor] forKey:@"_titleTextColor"];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, alertString.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertString.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(SLCycleScrollView*)littleHeadView{
    if (!littleHeadView) {
        littleHeadView = [[SLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, BannerHeight)];
        [littleHeadView setDelegate:self];
        [littleHeadView setDataource:self];
    }
    return littleHeadView;
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
