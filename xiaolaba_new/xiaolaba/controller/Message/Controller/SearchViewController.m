//
//  SearchViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/1/9.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

/*
 *  备注：搜索控制器 🐾
 */



#import "SearchViewController.h"



#define LazyLoadMethod(variable)    \
- (NSMutableArray *)variable \
{   \
if (!_##variable)  \
{   \
_##variable = [NSMutableArray array];  \
}   \
return _##variable;    \
}


@interface SearchViewController ()<UISearchResultsUpdating, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, retain) MBProgressHUD *hud;
@end


static NSString * const cellIdentifier = @"cellIdentifier";

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initNav];
    [self initNaviBar];

    /// 设置 UI
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.searchController.active == YES) {
        self.tableView.frame = self.view.bounds;
    }else {
        self.tableView.frame = CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom);
    }
}
- (void)initNaviBar {
    UIButton *leftNavItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftNavItem setImage:[UIImage imageNamed:@"icon_fh_z"] forState:UIControlStateNormal];
    [leftNavItem addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setLeftItem:leftNavItem];
}
#pragma mark - 💤 👀 LazyLoad Method 👀
-(void)initNav {
    UIButton *leftNavItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftNavItem setImage:[UIImage imageNamed:@"icon_fh_z"] forState:UIControlStateNormal];
    [leftNavItem addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavItem];
}
-(void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
LazyLoadMethod(dataArr)

- (UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:NULL];
        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
        _searchController.searchBar.tintColor = [UIColor grayColor];
        for (UIView *subView in _searchController.searchBar.subviews) {
            if ([subView isKindOfClass:[UIView  class]]) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
                if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                    UITextField *textField = [subView.subviews objectAtIndex:0];
                    textField.backgroundColor = [UIColor whiteColor];
                    
                    //设置输入框边框的颜色
                    textField.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
                    textField.layer.borderWidth = 1;
                    textField.layer.cornerRadius = 13;
                    textField.layer.masksToBounds = YES;
                    //设置输入字体颜色
                    textField.textColor = [UIColor textBlackColor];
                    
                    //设置默认文字颜色
                    UIColor *color = [UIColor grayColor];
                    [textField setAttributedPlaceholder:
                     [[NSAttributedString alloc] initWithString:@"搜索昵称/手机号码/车牌号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:color}]];
                }
            }
        }
        /// 去除 searchBar 上下两条黑线
        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor =  [UIColor whiteColor].CGColor;
        barImageView.layer.borderWidth = 1;
        self.tableView.tableHeaderView = _searchController.searchBar;
        [_searchController.searchBar sizeToFit];
    }
    
    return _searchController;
}

#pragma mark - 👀 设置 UI 👀 💤

/**
 *  设置 UI
 */
- (void)setupUI
{
    /// 设置 tableView
    [self setupTableView];
    
    switch (self.searchMode)
    {
        case SearchModeRealTime:    /// 实时搜索
        {
            self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
            self.searchController.searchResultsUpdater = self;
            break;
        }
        case SearchModeAction:      /// 点击搜索按钮进行搜索
        {
            self.searchController.searchBar.returnKeyType = UIReturnKeySearch;
            self.searchController.searchBar.delegate = self;
            break;
        }
    }
}

/**
 *  设置 tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
}

#pragma mark - 📕 👀 UITableViewDataSource 👀

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionsInTableViewCofigure)
    {
        return self.numberOfSectionsInTableViewCofigure(tableView, self.searchController.isActive);
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowsInSectionConfigure)
    {
        return self.numberOfRowsInSectionConfigure(tableView, section, self.searchController.isActive);
    }
    
    return (!self.searchController.active) ? self.dataArr.count : self.searchResults.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.cellForRowAtIndexPathConfigure)
//    {
//        return self.cellForRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
//    }
//    
//    return [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//}

#pragma mark - 💉 👀 UITableViewDelegate 👀

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectRowAtIndexPathConfigure)
    {
        self.didSelectRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didDeselectRowAtIndexPathConfigure)
    {
        self.didDeselectRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRowAtIndexPathConfigure)
    {
        return self.heightForRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
    
    return 70;
}

#pragma mark - 💉 👀 UISearchResultsUpdating 👀

#pragma mark - 👀 这里主要处理实时搜索的配置 👀 💤

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    /// 如果不是实时搜索，则直接返回
    if (self.searchMode == SearchModeAction)    return;
    
    
    if (self.updateSearchResultsConfigure)
    {
        /// 获取搜索结果的数据
        self.updateSearchResultsConfigure(self.searchController.searchBar.text);
//        _searchResults = self.updateSearchResultsConfigure(self.searchController.searchBar.text);
        
        /// 刷新 tableView
        [self.tableView reloadData];
    }
}

#pragma mark - 💉 👀 UISearchBarDelegate 👀

#pragma mark - 👀 这里主要处理非实时搜索的配置 👀 💤

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    if (self.updateSearchResultsConfigure)
    {
        /// 获取搜索结果的数据
//        _searchResults = self.updateSearchResultsConfigure(self.searchController.searchBar.text);
        self.updateSearchResultsConfigure(self.searchController.searchBar.text);
        /// 刷新 tableView
        [self.tableView reloadData];
    }
    [self viewDidLayoutSubviews];
}

/**
 *  结束编辑的时候，显示搜索之前的界面，并将 _searchResults 清空
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    _searchResults = nil;
    self.searchController.active = NO;
    self.updateSearchResultsConfigure(nil);
    [self.tableView reloadData];
    [self viewDidLayoutSubviews];
}

/**
 *  开始编辑的时候，显示搜索结果控制器
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    self.searchController.active = YES;
    self.updateSearchResultsConfigure(nil);
    [self.tableView reloadData];
    [self viewDidLayoutSubviews];
}

- (void) showHudWithText:(NSString *)text {
    
    [self.view addSubview:self.hud];
    [_hud show:YES];
    _hud.detailsLabelText = text;
}
- (void) hideHud {
    [_hud removeFromSuperview];
    _hud = nil;
}
@end
