//
//  XLBRankingListDetailViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/20.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBRankingListDetailViewController.h"
#import "LoginView.h"
#import "XLBFaceWallView.h"
@interface XLBRankingListDetailViewController () <XLBFaceWallViewDelegate>

@property (nonatomic, strong) XLBFaceWallView *faceWallBgV;

@end

@implementation XLBRankingListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    self.naviBar.slTitleLabel.text = @"排行榜";
    // Do any additional setup after loading the view.
    [self.faceWallBgV.tableV.mj_header beginRefreshing];
    [self.faceWallBgV setFaceTableViewWithsource:[_rankList_sy integerValue]];
}

- (void)loginBtnClick {
    [LoginView addLoginView];
}

- (void)seletedRowWithFaceWallModel:(FaceWallListModel *)model rank:(NSInteger)rank{
    if (kNotNil(model)) {
        if ([self.rankList_sy isEqualToString:@"1"]) {
            [[CSRouter share] push:@"VoiceActorOwnerViewController" Params:@{@"userID":model.userId} hideBar:YES];
        }else {
            OwnerViewController * oner = [OwnerViewController new];
            oner.userID = model.userId;
            oner.delFlag = 0;
            oner.hidesBottomBarWhenPushed =YES;
            oner.returnBlock = ^(id data) {
                
                NSDictionary *params = (NSDictionary *)data;
                NSString *result = [params objectForKey:@"follows"];
                NSString *praise = [params objectForKey:@"praise"];
                NSInteger likeSum = [[params objectForKey:@"likeSum"] integerValue];
                if (kNotNil(result)) {
                    model.follows = result;
                    if (rank == 0 || rank == 1) {
                        if ([result isEqualToString:@"1"]) {
                            [self.faceWallBgV.attentionBtn setTitle:@"已关注" forState:0];
                        }else {
                            [self.faceWallBgV.attentionBtn setTitle:@"+ 关注" forState:0];
                        }
                        if (kNotNil(praise)) {
                            model.likeSum = [NSString stringWithFormat:@"%li",[model.likeSum integerValue] + likeSum];
                        }
                        [self.faceWallBgV.tableV reloadData];
                    }
                }
            };
            [self.navigationController pushViewController:oner animated:YES];
        }
    }
}
- (XLBFaceWallView *)faceWallBgV {
    if (!_faceWallBgV) {
        _faceWallBgV = [[XLBFaceWallView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom) withType:[self.rankList_sy integerValue]];
        _faceWallBgV.delegate = self;
        [self.view addSubview:_faceWallBgV];
    }
    return _faceWallBgV;
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
