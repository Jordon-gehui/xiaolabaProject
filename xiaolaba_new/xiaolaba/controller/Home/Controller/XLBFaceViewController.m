//
//  XLBFaceViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBFaceViewController.h"
#import "OwnerViewController.h"
#import "XLBFaceView.h"
#import "LoginView.h"
@interface XLBFaceViewController ()<XLBFaceViewDelegate>
@property (nonatomic, strong) XLBFaceView *faceBgView;
@end

@implementation XLBFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //颜值墙
    [self faceBgView];
    [self.faceBgView.faceCollection.mj_header beginRefreshing];
}

- (void)showBtnClick {
    [[CSRouter share] push:@"XLBMyInfoSubShowViewController" Params:@{@"editUser":[XLBUser user]} hideBar:YES];
}

- (void)notLogin {
    [LoginView addLoginView];
}

- (void)seletedItemWithFaceModel:(FaceListModel *)faceModel {
    if (kNotNil(faceModel)) {
        OwnerViewController * oner = [OwnerViewController new];
        oner.userID = faceModel.userID;
        oner.delFlag = 0;
        oner.hidesBottomBarWhenPushed =YES;
        oner.returnBlock = ^(id data) {
            NSDictionary *params = (NSDictionary *)data;
            NSString *result = [params objectForKey:@"praise"];
            NSInteger likeSum = [[params objectForKey:@"likeSum"] integerValue];
            if (kNotNil(result)) {
                faceModel.liked = result;
                faceModel.likeSum = [NSString stringWithFormat:@"%li",[faceModel.likeSum integerValue] + likeSum];
                [self.faceBgView.faceCollection reloadData];
            }
        };
        [self.navigationController pushViewController:oner animated:YES];
    }
}

- (XLBFaceView *)faceBgView {
    if (!_faceBgView) {
        if (iPhoneX) {
            _faceBgView = [[XLBFaceView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        }else {
            _faceBgView = [[XLBFaceView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        }
        _faceBgView.delegate = self;
        [self.view addSubview:_faceBgView];
    }

    return _faceBgView;
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
