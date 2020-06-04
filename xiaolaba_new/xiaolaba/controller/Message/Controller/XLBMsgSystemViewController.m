//
//  XLBMsgSystemViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMsgSystemViewController.h"
#import "NetWorking.h"
#import "XLBErrorView.h"
#import "XLBMeRequestModel.h"
#import "XLBSystemMsgModel.h"
#import "XLBMsgSystemSubViewController.h"
#import "BaseWebViewController.h"
#import "MsgSystemImgCell.h"
#import "MsgSytemNormalCell.h"
@interface XLBMsgSystemViewController ()<UITableViewDelegate,UITableViewDataSource,XLBErrorViewDelegate>

@property (nonatomic, assign) BOOL praise;

@property (nonatomic, strong)XLBErrorView *errorV;



@end

@implementation XLBMsgSystemViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = @"系统消息";
    self.naviBar.slTitleLabel.text = @"系统消息";
    [MobClick event:@"SystemMessage"];
    self.view.backgroundColor = [UIColor viewBackColor];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor viewBackColor];
    self.allowRefresh = YES;
    self.allowLoadMore = YES;
}

- (void)refresh {
    [super refresh];
    
    self.page = 0;
    [self getData];
    
}

- (void)loadMore {
    [super loadMore];
    [self getData];
}



- (void)getData {
    self.page++;
    NSDictionary *params = @{@"page":@{@"curr":@(self.page),
                                       @"size":@(30)}};
    kWeakSelf(self);
    [XLBMeRequestModel requestSystemList:params success:^(NSArray<XLBSystemMsgModel *> *models) {
        if (self.page == 1 && models.count==0) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_kb" remind:@""];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            self.errorV.hidden = YES;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.page == 1) {
                [weakSelf.data removeAllObjects];
            }
            [weakSelf.data addObjectsFromArray:models];
            [weakSelf.tableView reloadData];
            if (models.count<30) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(NSString *error) {
        [self.data removeAllObjects];
        [self.tableView reloadData];
        if (self.page ==1) {
            self.errorV.hidden = NO;
            [self.errorV setSubViewsWithImgName:@"pic_wsj" remind:@"网络错误，点击重试"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } more:^(BOOL more) {
        
    }];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.data.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 80;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBSystemMsgModel *model = self.data[indexPath.row];
    if (kNotNil(model.packageName)) {
        MsgSystemImgCell *cell = [tableView dequeueReusableCellWithIdentifier:[MsgSystemImgCell msgSystemImgCellID]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!cell) {
            cell = [[MsgSystemImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MsgSystemImgCell msgSystemImgCellID]];
        }
        cell.model = model;
        return cell;
    }
    else {
        MsgSytemNormalCell *normalCell = [tableView dequeueReusableCellWithIdentifier:[MsgSytemNormalCell msgSystemNormalCellID]];
        if (!normalCell) {
            normalCell = [[MsgSytemNormalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MsgSytemNormalCell msgSystemNormalCellID]];
        }
        normalCell.model = model;
        return normalCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    XLBSystemMsgModel *model = self.data[indexPath.row];
    if (kNotNil(model.packageName) && [model.packageName containsString:@"http"]) {
        BaseWebViewController *webview = [BaseWebViewController new];
        webview.urlStr = model.packageName;
        webview.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webview animated:YES];
        return;
    }
    if (kNotNil(model.remark) && [model.remark isEqualToString:@"1"] && kNotNil(model.initiatorId)) {
        [[CSRouter share] push:@"LXBFeedBackListViewController" Params:@{@"initiatorId":model.initiatorId} hideBar:YES];
    }else {
        [[CSRouter share] push:@"XLBMsgSystemSubViewController" Params:@{@"model":self.data[indexPath.row]} hideBar:YES];
        
    }
}

- (XLBErrorView *)errorV {
    if (!_errorV) {
        _errorV = [[XLBErrorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.naviBar.bottom)];
        _errorV.hidden = YES;
        _errorV.delegate = self;
        [self.tableView addSubview:self.errorV];
    }
    return _errorV;
}

- (void)errorViewTap {
//    [self requestData:YES];
//    self.page = 0;
//    [self getData];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

 
@end
