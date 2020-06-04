//
//  XLBInformationViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/17.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBInformationViewController.h"
#import "NewsDetailPage.h"
#import "InformationCell.h"
#import "InformationImgCell.h"
#import "LoginView.h"


@interface XLBInformationViewController ()

@end

@implementation XLBInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //资讯
    [self setup];
    
}

- (void)setup {
    self.tableView.estimatedRowHeight = 200.f;
    self.tableView.backgroundColor = RGB(248, 248, 248);
    self.allowRefresh = YES;
    self.allowLoadMore =YES;
    [self.tableView registerClass:[InformationCell class] forCellReuseIdentifier:[InformationCell cellReuseIdentifier]];
    [self.tableView registerClass:[InformationImgCell class] forCellReuseIdentifier:[InformationImgCell cellOneIdentifier]];
    [self.tableView registerClass:[InformationImgCell class] forCellReuseIdentifier:[InformationImgCell cellImgsIdentifier]];
    //解档
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"SY_zixunData.archiver"];
    NSArray *mainData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (mainData) {
        self.data = [NSMutableArray arrayWithArray:mainData];
        [self.tableView reloadData];
    }

}
-(void)refresh {
    self.page =0;
    [self loadHttp];
}
-(void)loadMore {
    [self loadHttp];
}
-(void)loadHttp {
    self.page ++;
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(10)}};
    [[NetWorking network] POST:kZXList params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[result objectForKey:@"list"]];
        if (self.page ==1) {
            self.data = arr;
            NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            NSString *path=[docPath stringByAppendingPathComponent:@"SY_zixunData.archiver"];
            BOOL falg = [NSKeyedArchiver archiveRootObject:arr toFile:path];
            if (falg == YES) {
                NSLog(@"归档成功");
            }else {
                NSLog(@"归档失败");
            }
            [self.tableView reloadData];
        }else{
            if(arr.count>1){
                [self.data addObjectsFromArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
        }
        if (arr.count<10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSString *description) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)newsClick:(NSString*)webId {
    NewsDetailPage *web =[[NewsDetailPage alloc]init];
    web.hidesBottomBarWhenPushed = YES;
    web.webId = webId;
    [self.navigationController pushViewController:web animated:YES];
}


- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //model 1大图 2小图 3 多图
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *modelStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mode"]];
    NSLog(@"modelStr = %@",modelStr);
    id cell;
    if ([modelStr isEqualToString:@"1"]) {
        InformationImgCell *infocell = [tableView dequeueReusableCellWithIdentifier:[InformationImgCell cellOneIdentifier]];
        [infocell setViewData:[self.data objectAtIndex:indexPath.row]];
        cell = infocell;
    }else if ([modelStr isEqualToString:@"3"]) {
        InformationImgCell *infocell = [tableView dequeueReusableCellWithIdentifier:[InformationImgCell cellImgsIdentifier] forIndexPath:indexPath];;
        [infocell setViewData:[self.data objectAtIndex:indexPath.row]];
        cell = infocell;
    }else{
        InformationCell *infocell = [tableView dequeueReusableCellWithIdentifier:[InformationCell cellReuseIdentifier] forIndexPath:indexPath];;
        [infocell setViewData:[self.data objectAtIndex:indexPath.row]];
        cell = infocell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *webid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self newsClick:webid];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
