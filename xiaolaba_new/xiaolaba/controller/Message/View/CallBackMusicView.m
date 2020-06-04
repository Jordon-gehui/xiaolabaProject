//
//  CallBackMusicView.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/5/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CallBackMusicView.h"
#import "BackMusicCell.h"

@interface CallBackMusicView()<UITableViewDelegate,UITableViewDataSource>
{
   CGFloat Viewheight;
    UIView *bottomView;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableSet *chooseList;

@end

static NSString *Identifier = @"callBackMusicCell";
@implementation CallBackMusicView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
//    [self addGestureRecognizer:tap];
    bottomView = [UIView new];
    bottomView.layer.cornerRadius = 9;
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = [UIColor lineColor].CGColor;
    bottomView.layer.masksToBounds = YES;
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIImageView *musicImg = [UIImageView new];
    [bottomView addSubview:musicImg];
    musicImg.image = [UIImage imageNamed:@"icon_syth_yy"];
    UILabel *titleL = [UILabel new];
    titleL.text = @"音乐";
    titleL.textColor = [UIColor commonTextColor];
    titleL.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:titleL];
    UIButton *closeBtn = [UIButton new];
    [closeBtn setTitleColor:[UIColor commonTextColor] forState:0];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeBtn setTitle:@"完成" forState:0];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setEnlargeEdge:10];
    [bottomView addSubview:closeBtn];
    UIView *lineV =[UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:lineV];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.showsVerticalScrollIndicator = NO;
    [bottomView addSubview:_tableView];
    [_tableView registerClass:[BackMusicCell class] forCellReuseIdentifier:Identifier];
    _tableView.estimatedRowHeight = 55;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [musicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(bottomView).with.offset(15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicImg);
        make.left.mas_equalTo(musicImg.mas_right).with.offset(10);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicImg);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(bottomView).with.offset(-15);
    }];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(musicImg.mas_bottom).with.offset(14);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-15);
        make.height.mas_equalTo(1);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(musicImg.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(bottomView);
        make.bottom.mas_equalTo(bottomView).with.offset(-5);
    }];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    BackMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[BackMusicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }
    NSDictionary *dic = [self.musicList objectAtIndex:indexPath.row];
    if ([self.chooseList containsObject:indexPath]) {
        [cell setModel:dic choose:YES];
    }else{
        [cell setModel:dic choose:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.chooseList containsObject:indexPath]) {
        [self.chooseList removeObject:indexPath];
    }else{
        if (self.chooseList.count<3) {
            [self.chooseList addObject:indexPath];
        }else{
            [MBProgressHUD showError:@"最多选择三首"];
            return;
        }
    }
    [self.tableView reloadData];
}

- (void)showView {
    if(self.musicList.count>=5){
        Viewheight = 350;
    }else{
        Viewheight = 350-(4-self.musicList.count)*65;
    }
    
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    bottomView.frame = CGRectMake(1, kSCREEN_HEIGHT, kSCREEN_WIDTH-2, Viewheight);
    self.hidden = NO;
    if (self.choseDataList.count>0) {
        for (int i=0; i<self.musicList.count; i++) {
            NSDictionary *tempD = [self.musicList objectAtIndex:i];
            for (NSDictionary *dic in self.choseDataList) {
                if ([[tempD objectForKey:@"url"] isEqualToString:[dic objectForKey:@"url"]]) {
                    [self.chooseList addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
    }
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(1, kSCREEN_HEIGHT-Viewheight, kSCREEN_WIDTH-2, Viewheight);
    }];
}

-(void)closeView {
    NSMutableArray *choseList = [NSMutableArray array];
    if (self.chooseList.count!=0) {
        for (NSIndexPath *index in self.chooseList) {
            [choseList addObject:[self.musicList objectAtIndex:index.row]];
        }
    }
    self.choseDataList = choseList;
    [self.delegate addCallBackMusic:self];
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(1, kSCREEN_HEIGHT, kSCREEN_WIDTH-2, Viewheight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(NSArray *)musicList {
    if (_musicList==nil) {
        _musicList = [NSArray array];
    }
    return _musicList;
}
-(NSMutableArray*)choseDataList{
    if (_choseDataList==nil) {
        _choseDataList = [NSMutableArray array];
    }
    return _choseDataList;
}
-(NSMutableSet*)chooseList{
    if (_chooseList ==nil) {
        _chooseList = [NSMutableSet set];
    }
    return _chooseList;
}

@end
