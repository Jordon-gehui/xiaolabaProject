//
//  VoiceAppraiseViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceAppraiseViewController.h"
#import "VoiceAppraiseHeaderView.h"
#import "VoiceAppraiseCell.h"
#import "OwnerRequestManager.h"
@interface VoiceAppraiseViewController ()<UITableViewDelegate,UITableViewDataSource,VoiceAppraiseCellDelegate>

{
    NSString *allCount;
    NSString *contentCount;
}
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) VoiceAppraiseHeaderView *header;
@property (nonatomic, strong) VoiceImpressModel *impModel;
@property (nonatomic, strong) UILabel *headerLabel;

@end

@implementation VoiceAppraiseViewController

- (void)viewDidLoad {
    self.isGrouped = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //评价
    self.title = @"评价详情";
    self.naviBar.slTitleLabel.text = @"评价详情";
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.allowRefresh = YES;
    self.allowLoadMore =YES;
    [self.tableView registerClass:[VoiceAppraiseCell class] forCellReuseIdentifier:[VoiceAppraiseCell voiceAppraiseCellID]];
    _header = [[VoiceAppraiseHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    _header.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _header;

}

- (void)refresh {
    [super refresh];
    self.page = 0;
    [self request];
}

- (void)loadMore {
    [super loadMore];
    [self request];
}

- (void)request {
    self.page++;
    NSDictionary *dict = @{@"page":@{@"curr":@(self.page),
                                     @"size":@(20)},@"calledId":self.userId,};
    [OwnerRequestManager requestImprassWithParameter:dict success:^(VoiceImpressModel *model) {
        [model.imprss enumerateObjectsUsingBlock:^(VoiceImpressTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.type isEqualToString:@"0"]) {
                allCount = [NSString stringWithFormat:@"%@",obj.impressionCount];
            }
            if ([obj.type isEqualToString:@"7"]) {
                if (kNotNil(obj.impressionCount) && ![obj.impressionCount isEqualToString:@"0"]) {
                    contentCount = [NSString stringWithFormat:@"%@",obj.impressionCount];
                }
            }
        }];
        
        self.header.allCount = allCount;
        self.header.model = model;
        if (model.contentModel.count == 0 && self.page == 1) {
            [self.data removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page == 1) {
                [self.data removeAllObjects];
            }
            [self.data addObjectsFromArray:model.contentModel];
            [self.tableView reloadData];
            if (model.contentModel.count<20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }

    } failure:^(NSString *error) {
        [self.data removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } more:^(BOOL more) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kSCREEN_WIDTH, 49)];
        view.backgroundColor = [UIColor clearColor];
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH, 48)];
        if (kNotNil(contentCount) && ![contentCount isEqualToString:@"0"]) {
            self.headerLabel.text = [NSString stringWithFormat:@"更多评价(%@)",contentCount];
        }
        self.headerLabel.textColor = [UIColor assistColor];
        self.headerLabel.font = [UIFont systemFontOfSize:16];
        [view addSubview:self.headerLabel];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.headerLabel.bottom, 1)];
        line.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
        [view addSubview:line];
        return view;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceAppraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:[VoiceAppraiseCell voiceAppraiseCellID] forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)didSeletedUserImgWithModel:(VoiceImpressContentModel *)model {
    if ([model.remarks isEqualToString:@"3"]) {
        //声优
        [[CSRouter share] push:@"VoiceActorOwnerViewController" Params:@{@"userID":model.callingId,} hideBar:YES];
    }else {
        [[CSRouter share] push:@"OwnerViewController" Params:@{@"userID":model.callingId,@"delFlag":@0,} hideBar:YES];
    }
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
