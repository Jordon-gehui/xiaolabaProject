//
//  VoiceCallEndView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "VoiceCallEndView.h"
#import "SZTextView.h"
#import "VoiceImpressCollectionViewCell.h"
#import "ReportChatViewController.h"
@interface VoiceCallEndView ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

{
    NSString *seletedStar;
    NSString *seletedImp;
    NSString *remark;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *subView;

@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *leftLine;
@property (nonatomic, strong) UILabel *rightLine;
@property (nonatomic, strong) UIButton *oneStarBtn;
@property (nonatomic, strong) UIButton *twoStarBtn;
@property (nonatomic, strong) UIButton *threeStarBtn;
@property (nonatomic, strong) UILabel *evaluateLabel;
@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UICollectionView *impressCollectionV;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *reportBtn;
@property (nonatomic, strong) SZTextView *commentTextV;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) NSMutableArray *seletedArr;

@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation VoiceCallEndView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NetWorking network] POST:kAssess params:nil cache:NO success:^(id result) {
            NSLog(@"%@",result);
            if (kNotNil(result)) {
                NSDictionary *dic = [result objectAtIndex:0];
                NSArray *arr = dic[@"listDict"];
                [self.data addObjectsFromArray:arr];
                [self.impressCollectionV reloadData];
            }
        } failure:^(NSString *description) {
            self.data = [NSMutableArray arrayWithObjects:@"声音甜美",@"成熟声音",@"热情开朗",@"知识渊博",@"能说会道",@"活泼可爱", nil];
        }];
        [self seletedArr];
        [self setSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        [self setSubViews];
        [self seletedArr];
        seletedStar = @"0";
        [[NetWorking network] POST:kAssess params:nil cache:NO success:^(id result) {
            NSLog(@"%@",result);
            if (kNotNil(result)) {
                NSDictionary *dic = [result objectAtIndex:0];
                NSArray *arr = dic[@"listDict"];
                [self.data addObjectsFromArray:arr];
                [self.impressCollectionV reloadData];
            }
        } failure:^(NSString *description) {
            self.data = [NSMutableArray arrayWithObjects:@{@"label":@"声音甜美",@"value":@"1",},@{@"label":@"成熟声音",@"value":@"2",},@{@"label":@"热情开朗",@"value":@"3",},@{@"label":@"知识渊博",@"value":@"4",},@{@"label":@"能说会道",@"value":@"5",},@{@"label":@"活泼可爱",@"value":@"6",}, nil];
        }];
    }
    return self;
}
- (void)setNickname:(NSString *)nickname {
    
    self.nickName.text = [NSString stringWithFormat:@"%@",nickname];
    _nickname = nickname;
}
- (void)setVoiceCallId:(NSString *)voiceCallId {
    _voiceCallId = voiceCallId;
    NSLog(@"%@",voiceCallId);
}
- (void)setImg:(NSString *)img {
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    _img = img;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VoiceImpressCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VoiceImpressCollectionViewCell voiceImpressCellID] forIndexPath:indexPath];
    cell.impressImg.hidden = YES;
    cell.backgroundColor = [UIColor colorWithR:247 g:248 b:250];
    cell.impressLabel.text = self.data[indexPath.item][@"label"];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"--选中");
    VoiceImpressCollectionViewCell * cell = (VoiceImpressCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.impressImg.hidden = NO;
    [_seletedArr addObject:[NSString stringWithFormat:@"%li",indexPath.row + 1]];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---取消选中");
    VoiceImpressCollectionViewCell * cell = (VoiceImpressCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.impressImg.hidden = YES;
    [_seletedArr removeObject:[NSString stringWithFormat:@"%li",indexPath.row + 1]];

}
- (void)starBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            [self.oneStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_s"] forState:0];
            [self.twoStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_n"] forState:0];
            [self.threeStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_n"] forState:0];
            seletedStar = @"1";
        }
            break;
        case 101:{
            [self.oneStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_s"] forState:0];
            [self.twoStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_s"] forState:0];
            [self.threeStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_n"] forState:0];
            seletedStar = @"2";

        }
            break;
        case 102:{
            [self.oneStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_s"] forState:0];
            [self.twoStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_s"] forState:0];
            [self.threeStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_s"] forState:0];
            seletedStar = @"3";
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *assess = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (assess.length == 300) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]){
        [self.commentTextV resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSLog(@"键盘弹出");
    [UIView animateWithDuration:0.5 animations:^{
        self.subView.top = - 100;
    } completion:^(BOOL finished) {
        
    }];
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide:(NSNotification *)notification {
    NSLog(@"键盘隐藏");
    [UIView animateWithDuration:2 animations:^{
        self.subView.top = 0;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
- (void)setSubViews {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    [self addSubview:self.bgView];
    
    self.subView = [UIView new];
    self.subView.backgroundColor = [UIColor whiteColor];
    self.subView.layer.masksToBounds = YES;
    self.subView.layer.cornerRadius = 10;
    [self.bgView addSubview:self.subView];
    
    
    self.userImg = [UIImageView new];
    self.userImg.image = [UIImage imageNamed:@"weitouxiang"];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 25;
    [self.subView addSubview:self.userImg];
    
    self.nickName = [UILabel new];
    self.nickName.text = @"戴葛辉";
    self.nickName.textColor = [UIColor commonTextColor];
    self.nickName.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.nickName.textAlignment = NSTextAlignmentCenter;
    [self.subView addSubview:self.nickName];
    
    self.remindLabel = [UILabel new];
    self.remindLabel.text = @"对ta评价";
    self.remindLabel.textColor = [UIColor commonTextColor];
    self.remindLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.subView addSubview:self.remindLabel];
    
    self.leftLine = [UILabel new];
    self.leftLine.backgroundColor = [UIColor blackColor];
    [self.subView addSubview:self.leftLine];
    
    self.rightLine = [UILabel new];
    self.rightLine.backgroundColor = [UIColor blackColor];
    [self.subView addSubview:self.rightLine];
    
    self.oneStarBtn = [UIButton new];
    [self.oneStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_n"] forState:0];
    [self.oneStarBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.oneStarBtn.tag = 100;
    [self.subView addSubview:self.oneStarBtn];
    
    self.twoStarBtn = [UIButton new];
    [self.twoStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_n"] forState:0];
    [self.twoStarBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.twoStarBtn.tag = 101;
    [self.subView addSubview:self.twoStarBtn];
    
    self.threeStarBtn = [UIButton new];
    [self.threeStarBtn setBackgroundImage:[UIImage imageNamed:@"btn_pj_n"] forState:0];
    [self.threeStarBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.threeStarBtn.tag = 102;
    [self.subView addSubview:self.threeStarBtn];
    
    self.evaluateLabel = [UILabel new];
    self.evaluateLabel.textAlignment = NSTextAlignmentCenter;
    self.evaluateLabel.textColor = [UIColor shadeStartColor];
    self.evaluateLabel.text = @"挺满意，是我喜欢的类型";
    self.evaluateLabel.font = [UIFont systemFontOfSize:10];
    [self.subView addSubview:self.evaluateLabel];
    
    self.centerLabel = [UILabel new];
    self.centerLabel.text = @"选择对声优的印象";
    self.centerLabel.textColor = [UIColor minorTextColor];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont systemFontOfSize:12];
    [self.subView addSubview:self.centerLabel];
    
    UICollectionViewFlowLayout *folwLayout = [[UICollectionViewFlowLayout alloc] init];
    folwLayout.itemSize = CGSizeMake(75, 33);
    folwLayout.minimumLineSpacing = 8;
    folwLayout.minimumInteritemSpacing = 5;
    folwLayout.sectionInset = UIEdgeInsetsMake(5, 8, 5,8);
    self.impressCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) collectionViewLayout:folwLayout];
    [self.impressCollectionV registerClass:[VoiceImpressCollectionViewCell class] forCellWithReuseIdentifier:[VoiceImpressCollectionViewCell voiceImpressCellID]];
    self.impressCollectionV.delegate = self;
    self.impressCollectionV.dataSource = self;
    self.impressCollectionV.showsVerticalScrollIndicator = NO;
    self.impressCollectionV.scrollEnabled = NO;
    self.impressCollectionV.allowsMultipleSelection = YES;
    self.impressCollectionV.backgroundColor = [UIColor whiteColor];
    [self.subView addSubview:self.impressCollectionV];
    
    
    self.commentLabel = [UILabel new];
    self.commentLabel.text = @"我要反馈";
    self.commentLabel.textColor = [UIColor minorTextColor];
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.font = [UIFont systemFontOfSize:12];
    [self.subView addSubview:self.commentLabel];
    
    self.reportBtn = [UIButton new];
    [self.reportBtn setTitle:@"我要举报" forState:0];
    [self.reportBtn setTitleColor:[UIColor shadeStartColor] forState:0];
    self.reportBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subView addSubview:self.reportBtn];
    
    self.commentTextV = [SZTextView new];
    self.commentTextV.layer.masksToBounds = YES;
    self.commentTextV.layer.cornerRadius = 5;
    self.commentTextV.layer.borderWidth = 1;
    self.commentTextV.placeholder = @"请输入您留言...";
    self.commentTextV.returnKeyType = UIReturnKeyDone;
    self.commentTextV.delegate = self;
    self.commentTextV.layer.borderColor = [UIColor lineColor].CGColor;
    self.commentTextV.font = [UIFont systemFontOfSize:14];
    [self.subView addSubview:self.commentTextV];
    
    self.submitBtn = [UIButton new];
    [self.submitBtn setTitle:@"提交评价" forState:0];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    [self.submitBtn setBackgroundColor:[UIColor assistColor]];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subView addSubview:self.submitBtn];
    
    self.cancleBtn = [UIButton new];
    [self.cancleBtn setTitle:@"放弃评价" forState:0];
    self.cancleBtn.layer.masksToBounds = YES;
    self.cancleBtn.layer.cornerRadius = 5;
    [self.cancleBtn setBackgroundColor:[UIColor colorWithR:161 g:161 b:161]];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subView addSubview:self.cancleBtn];
    
}
- (void)reportBtnClick:(UIButton *)sender {
    NSLog(@"%@",self.seletedArr);
    [self removeFromSuperview];
    UIViewController *viewC = [self topViewController];
    ReportChatViewController *chat = [ReportChatViewController new];
    chat.hidesBottomBarWhenPushed = YES;
    chat.reportType = @"1";
    chat.detailID = self.voiceCallId;
    [viewC.navigationController pushViewController:chat animated:YES];
}
- (void)submitBtnClick:(UIButton *)sender {
    NSString *impressionTy;
    if (self.seletedArr.count == 0) {
        impressionTy = @"0";
    }else {
        impressionTy = [self.seletedArr componentsJoinedByString:@","];
    }
    NSDictionary *dict = @{@"huanxinNo":self.voiceCallId,@"praiseStar":seletedStar,@"impressionType":impressionTy,@"assess":self.commentTextV.text,};
    [[NetWorking network] POST:kPayAssess params:dict cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [MBProgressHUD showSuccess:@"评价成功"];
        [self removeFromSuperview];
    } failure:^(NSString *description) {
        [MBProgressHUD showError:@"评价失败"];
        [self removeFromSuperview];
    }];
}
- (void)cancleBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
- (NSMutableArray *)seletedArr {
    if (!_seletedArr) {
        _seletedArr = [NSMutableArray array];
    }
    return _seletedArr;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
- (void)layoutSubviews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(450);
    }];
    
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subView.mas_top).with.offset(13);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImg.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
        
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickName.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subView.mas_left).with.offset(28);
        make.right.mas_equalTo(self.remindLabel.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self.remindLabel.mas_centerY).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftLine.mas_centerY).with.offset(0);
        make.left.mas_equalTo(self.remindLabel.mas_right).with.offset(5);
        make.right.mas_equalTo(self.subView.mas_right).with.offset(-28);
        make.height.mas_equalTo(1);
    }];
    
    [self.twoStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindLabel.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
        make.width.height.mas_equalTo(27);
    }];
    
    [self.oneStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.twoStarBtn);
        make.centerY.mas_equalTo(self.twoStarBtn.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.twoStarBtn.mas_left).with.offset(-28);
    }];
    
    [self.threeStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.twoStarBtn);
        make.centerY.mas_equalTo(self.twoStarBtn.mas_centerY).with.offset(0);
        make.left.mas_equalTo(self.twoStarBtn.mas_right).with.offset(28);
    }];
    
    [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.twoStarBtn.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.evaluateLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.subView.mas_left).with.offset(15);
    }];
    
    [self.impressCollectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.subView.mas_left).with.offset(10);
        make.right.mas_equalTo(self.subView.mas_right).with.offset(-10);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
        make.height.mas_equalTo(80);
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.impressCollectionV.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.subView.mas_left).with.offset(15);
    }];
    
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.commentLabel.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.subView.mas_right).with.offset(-15);
    }];
    
    [self.commentTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.subView.mas_left).with.offset(20);
        make.right.mas_equalTo(self.subView.mas_right).with.offset(-20);
        make.centerX.mas_equalTo(self.subView.mas_centerX).with.offset(0);
        make.height.mas_equalTo(74);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentTextV.mas_bottom).with.offset(15);
        make.left.mas_equalTo(self.subView.mas_centerX).with.offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(35);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.submitBtn);
        make.centerY.mas_equalTo(self.submitBtn.mas_centerY).with.offset(0);
        make.right.mas_equalTo(self.subView.mas_centerX).with.offset(-15);
    }];
    
}
@end
