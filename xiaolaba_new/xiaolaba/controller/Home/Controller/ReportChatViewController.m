//
//  ReportChatViewController.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ReportChatViewController.h"
#import "ReportChatModel.h"
#import "ReportChatCollectionViewCell.h"


@interface ReportChatViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    UIView * backView;
    NSInteger oldIndex;
}


@property(nonatomic,strong)UITextView * textView;

@property(nonatomic,strong)ReportChatModel * reportModel;
@property(nonatomic,strong)NSMutableArray *reportModelArr;



@end

@implementation ReportChatViewController


- (NSMutableArray *)reportModelArr{
    
    if (!_reportModelArr) {
        _reportModelArr = [NSMutableArray array];
    }
    return _reportModelArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    self.naviBar.slTitleLabel.text = @"举报";
    self.view.backgroundColor = [UIColor colorWithR:247 g:247 b:247];
    
    [self getDataFromServer];
    [self creatUI];

   
    // Do any additional setup after loading the view.
}

- (void)creatUI{

    backView = [UIView new];
    backView.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    if (iPhoneX) {
        backView.frame =CGRectMake(0, 88, kSCREEN_WIDTH, 300);
    }else{
        backView.frame =CGRectMake(0, 64, kSCREEN_WIDTH, 300);
    }
    [self.view addSubview:backView];
    
    UILabel *label = [UILabel new];
    label.text = @"填写详情";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor textBlackColor];
    label.textColor = [UIColor colorWithR:92 g:95 b:102];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(15, 15, kSCREEN_WIDTH, 20);
    [backView addSubview:label];
    
    UIView * leftView = [UIView new];
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.frame =CGRectMake(0, label.bottom + 10, 15,150);
    [backView addSubview:leftView];
  
    _textView = [UITextView new];
    _textView.frame = CGRectMake(10, label.bottom + 10, kSCREEN_WIDTH, 150);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UIColor colorWithR:92 g:95 b:102];

    _textView.delegate = self;
    //    textView.textInputMod
    [backView addSubview:_textView];
    
    
    UILabel *labelTwo = [UILabel new];
    labelTwo.text = @"请选择举报原因";
    labelTwo.font = [UIFont systemFontOfSize:14];
    labelTwo.textColor = [UIColor textBlackColor];
    labelTwo.backgroundColor = [UIColor clearColor];
    labelTwo.textColor = [UIColor colorWithR:92 g:95 b:102];

    labelTwo.frame = CGRectMake(15, _textView.bottom + 10, kSCREEN_WIDTH, 20);
    [backView addSubview:labelTwo];
    
    
    
    UIButton * button = [UIButton new];
    [button setTitle:@"举报" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(sendMes) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    if (iPhoneX) {
        button.layer.cornerRadius = 8;
    }
//    button.tag = 5;
    button.backgroundColor = [UIColor colorWithR:174 g:181 b:194];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX) {
            make.left.mas_equalTo(self.view).with.offset(15);
            make.right.mas_equalTo(self.view).with.offset(-15);
            make.bottom.mas_equalTo(self.view).with.offset(-20);
        }else{
            make.right.left.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(50);
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([@"\n" isEqualToString:text] == YES)
        
    {
        
        [_textView resignFirstResponder];
            
        return NO;
        
    }
    
    return YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [self.view endEditing:YES];
    [_textView resignFirstResponder];
    
    
}
- (void)sendMes{
    
    if (_textView.text == nil || [_textView.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入举报详情"];
        
        return;

    }
    
    NSDictionary *dict = @{@"foreignId":_detailID,@"description":_textView.text,@"type":self.reportType};
    
    [[NetWorking network] POST:kReportDel params:dict cache:NO success:^(id result) {
        
        NSLog(@"------------------举报--%@--dic--%@ ",result,dict);
     
        [MBProgressHUD showError:@"举报成功，我们将在24小时内给您答复"];
        
        [self.navigationController popViewControllerAnimated:YES];

        
    } failure:^(NSString *description) {
        
        
        
    }];
    
    
}

- (void)getDataFromServer{
    
    [[NetWorking network] POST:kReport params:nil cache:NO success:^(id result) {
        
        for (NSDictionary *dict in result) {
                
            self.reportModelArr  = [ReportChatModel mj_objectArrayWithKeyValuesArray:dict[@"listDict"]];
            
        }
        
        [self createCollectionView];
        
    } failure:^(NSString *description) {

    }];
    
}


- (UICollectionViewLayout *)customLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //item的尺寸
    layout.itemSize = CGSizeMake((kSCREEN_WIDTH - 45)/3,30);
    //section内边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10,10);
    
    return layout;
}

- (void)createCollectionView{
    CGRect frame = CGRectMake(0, backView.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - 50-backView.bottom);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self customLayout]];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.allowsMultipleSelection=YES;
    [_collectionView registerClass:[ReportChatCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).with.offset(40);
        make.left.right.mas_equalTo(0);
        if (iPhoneX) {
            make.bottom.mas_equalTo(-80);
        }else
        make.bottom.mas_equalTo(-50);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.reportModelArr.count;
//    return [ReportChatModel getData].count;
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReportChatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    //添加标题label
    [cell.layer setMasksToBounds:YES];
    [cell.layer setCornerRadius:4];
    
    cell.isselected = NO;
    
    cell.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
//    cell.reportModel = [ReportChatModel getData][indexPath.item];
    if (self.reportModelArr.count > 0) {
        
        cell.reportModel = self.reportModelArr[indexPath.item];

    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"--选中");
    
    ReportChatCollectionViewCell *myCollectionCell = (ReportChatCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    myCollectionCell.reportLable.highlightedTextColor = [UIColor colorWithR:254 g:222 b:2];
    myCollectionCell.backgroundColor = [UIColor colorWithR:254 g:254 b:226];
    myCollectionCell.layer.borderWidth = 0.5;
    [myCollectionCell.layer setMasksToBounds:YES];
    [myCollectionCell.layer setCornerRadius:4];
    myCollectionCell.layer.borderColor = [UIColor colorWithR:255 g:227 b:0].CGColor;
    
    oldIndex = indexPath.item;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"---取消选中");
    
    ReportChatCollectionViewCell *myCollectionCell = (ReportChatCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    myCollectionCell.reportLable.highlightedTextColor = [UIColor textBlackColor];
    myCollectionCell.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    myCollectionCell.layer.borderWidth = 0.5;
    [myCollectionCell.layer setMasksToBounds:YES];
    [myCollectionCell.layer setCornerRadius:4];
    myCollectionCell.layer.borderColor = [UIColor whiteColor].CGColor;
    
    oldIndex = indexPath.item;
}


@end
