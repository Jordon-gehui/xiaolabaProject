//
//  MoveCarVerifyViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MoveCarVerifyViewController.h"
#import "MoveCarView.h"
#import "AddImageView.h"
#import "XLBNoticeViewController.h"
#import "TZImagePickerController.h"
#import "ImageReviewViewController.h"


@interface MoveCarVerifyViewController()<TZImagePickerControllerDelegate,
                                        AddImageViewViewDelegate,
                                        ImageReviewViewControllerDelegate,
                                        UITextFieldDelegate>

@property (nonatomic, strong) UIView *backLineView;
@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, strong) UILabel *tipStrLbl;

@property (nonatomic, strong) UITextField *carNoText;
@property (nonatomic, strong) UITextField *carLocText;

@property (nonatomic, strong) UIView *bttomLineView;
@property(nonatomic , strong)AddImageView *addImageView;

@property (nonatomic, strong) UIButton *carSureBtn;

@property(nonatomic ,strong)UILabel *carContentLbl;
@property(nonatomic ,strong)UILabel *carNoLbl;

@property(nonatomic ,strong)UILabel *carLocLbl;

@property(nonatomic ,strong)UILabel *carImgLbl;

@property(nonatomic ,strong)UILabel *carTipLbl;

@property (nonatomic,strong)NSMutableArray *imgArray;

@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic,copy)NSArray *tipStrArr;

@end

static int carNO = 156;

@implementation MoveCarVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tipStrArr = @[@" 您的爱车已挡道，请您前来挪车！ ",
                  @" 违章停车，请前来挪车！ ",
                  @" 您的车窗未关闭，请速来挪车 ",
                  @" 十万火急，请速来挪车！ "];
    self.title = @"验证信息";
    self.naviBar.slTitleLabel.text = @"验证信息";

    self.scrollView.backgroundColor = [UIColor whiteColor];

    [self initViews];
}
-(void)initViews{
    _carContentLbl = [self addLbl:@"给车主留言"];
    
    _backLineView = [UIView new];
    _backLineView.layer.borderWidth = 1;
    _backLineView.layer.borderColor = [UIColor lineColor].CGColor;
    _backLineView.layer.cornerRadius = 5;
    _backLineView.layer.masksToBounds=YES;

    _textView = [SZTextView new];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholderTextColor = RGB(200, 200, 200);
    _textView.placeholder = @"说点什么吧...";
    [self.backLineView addSubview:_textView];
    
    _tipStrLbl = [UILabel new];
    _tipStrLbl.font = [UIFont systemFontOfSize:12];
    _tipStrLbl.text = @"选择提示信息";
    _tipStrLbl.textColor = RGB(138,143,153);
    [self.backLineView addSubview:_tipStrLbl];
    [self.scrollView addSubview:_backLineView];
    
    _carNoLbl = [self addLbl:@"您的车牌号"];
    
    _carNoText = [self addText];
    _carNoText.tag = carNO;
    
    _carLocLbl = [self addLbl:@"当前位置"];
    
    _carLocText = [self addText];
    
    _carImgLbl = [self addLbl:@"相关图片(最多上传3张)"];
    
    _bttomLineView = [UIView new];
    _bttomLineView.layer.borderWidth = 1;
    _bttomLineView.layer.borderColor = [UIColor lineColor].CGColor;
    _bttomLineView.layer.cornerRadius = 5;
    _bttomLineView.layer.masksToBounds=YES;
    
    _addImageView = [AddImageView new];
    [_addImageView setDelegate:self];
    [_addImageView setMaxImgCount:3 rowNumber:0];
    [_bttomLineView addSubview:_addImageView];
    [self.scrollView addSubview:_bttomLineView];
    
    _carSureBtn = [UIButton new];
    [_carSureBtn setTitle:@"通知车主挪车" forState:UIControlStateNormal];
    [_carSureBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:CGSizeMake(kSCREEN_WIDTH-30, 44)]]];
    [_carSureBtn setTitleColor:UIColorFromRGB(0x3d424c) forState:UIControlStateNormal];
    _carSureBtn.layer.cornerRadius = 22;
    _carSureBtn.layer.masksToBounds = YES;
    [_carSureBtn addTarget:self action:@selector(topSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_carSureBtn];
    
    _carTipLbl= [UILabel new];
    _carTipLbl.font = [UIFont systemFontOfSize:14];
    _carTipLbl.text = @"恶意通知车主挪车，将被拉进黑名单哦!";
    _carTipLbl.textColor = [UIColor textBlackColor];
    _carTipLbl.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:_carTipLbl];
    [self layout];
}
-(void)layout {
    kWeakSelf(self)
    [_carContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
    }];
    [_backLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carContentLbl.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(160+120);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backLineView.mas_left).with.offset(5);
        make.top.mas_equalTo(_backLineView.mas_top).with.offset(5);
        make.right.mas_equalTo(_backLineView.mas_right).with.offset(-5);
        make.height.mas_equalTo(@120);
    }];
    
    [_tipStrLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(_textView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
    }];
    
    _msgBtn = nil;
    for (NSString *messageStr in _tipStrArr) {
        UIButton *button = [UIButton new];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 5;
        [button setBackgroundImage:[UIImage imageNamed:@"btn_xin_s"] forState:UIControlStateSelected];
        [button setTitle:messageStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:RGB(247, 248, 250)];
        [button setTitleColor:RGB(240, 205, 51) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.backLineView addSubview:button];
        if (_msgBtn ==nil) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.tipStrLbl.mas_bottom).with.offset(10);
                make.left.mas_equalTo(weakSelf.backLineView.mas_left).with.offset(5);
                make.height.mas_equalTo(30);
            }];
        }else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.msgBtn.mas_bottom).with.offset(10);
                make.left.mas_equalTo(weakSelf.backLineView.mas_left).with.offset(5);
                make.height.mas_equalTo(30);
            }];
        }
        _msgBtn = button;
    }
    
    [_carNoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_backLineView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
    }];
    [_carNoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carNoLbl.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(44);
    }];
    
    [_carLocLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carNoText.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
    }];
    
    [_carLocText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carLocLbl.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(44);
    }];
    
    [_carImgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carLocText.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
    }];
    [_bttomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carImgLbl.mas_bottom).with.offset(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(100);
    }];
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(_bttomLineView.mas_top).with.offset(5);
        make.width.mas_equalTo(kSCREEN_WIDTH-40);
        make.height.mas_equalTo(90);
    }];
    
    [_carSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_bttomLineView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(44);
    }];
    [_carTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_carSureBtn.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.bottom.mas_lessThanOrEqualTo(weakSelf.scrollView.mas_bottom).with.offset(-10);
    }];

}

-(void)messageClick:(UIButton*)button {
    [button setSelected:!button.isSelected];
    if (button.isSelected) {
        NSString *text = _textView.text;
        _textView.text = [NSString stringWithFormat:@"%@%@",text,button.titleLabel.text];
    }else {
        NSString *text = _textView.text;
        NSString *stringWithoutQuotation = [text stringByReplacingOccurrencesOfString:button.titleLabel.text withString:@""];
        _textView.text = [NSString stringWithFormat:@"%@",stringWithoutQuotation];
    }
}
-(UILabel*)addLbl:(NSString*)text {
    UILabel *lbl= [UILabel new];
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.text = text;
    lbl.textColor = [UIColor textBlackColor];
    
    [self.scrollView addSubview:lbl];
    return lbl;
}

-(UITextField *)addText {
    UITextField *text = [UITextField new];
    text.layer.borderColor= [UIColor lineColor].CGColor;
    text.layer.borderWidth= 1.0f;
    text.layer.cornerRadius = 3;
    text.returnKeyType = UIReturnKeyDone;
    text.layer.masksToBounds = YES;
    [text setDelegate:self];
    [self.scrollView addSubview:text];
    return text;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag ==carNO) {
        if (![JXutils checkCarID:textField.text]) {
            [MBProgressHUD showError:@"请输入正确的车牌号"];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) topSureBtn {
    NSLog(@"点击确定");
    if (!kNotNil(_carNoText.text)) {
        [MBProgressHUD showError:@"车牌号不能为空"];
        return;
    }
    if (!kNotNil(_textView.text)) {
        [MBProgressHUD showError:@"消息不能为空"];
        return;
    }
    if(![JXutils checkCarID:_carNoText.text]) {
        [MBProgressHUD showError:@"车牌号格式不正确"];
        return;
    }
    kWeakSelf(self);
    [self showHudWithText:nil];
    NSMutableDictionary *params = [@{@"userId":_carId,@"message":_textView.text,@"licensePlate":_carNoText.text,@"location":_carLocText.text} mutableCopy];
    if(self.imgArray.count > 0) {
        [[NetWorking network] asyncUploadImages:weakSelf.imgArray avatar:NO complete:^(NSArray<NSString *> *names, UploadStatus state) {
            NSString *sring = [names componentsJoinedByString:@","];
            [params setObject:sring forKey:@"imgs"];
            [weakSelf publishMoveCar:params];
        }];
    }
    else {
        [self publishMoveCar:params];
    }

}
-(void) publishMoveCar:(NSDictionary*)params {
    kWeakSelf(self);
    [[NetWorking network] POST:KMoveCarDetails params:params cache:NO success:^(id result) {
        NSLog(@"%@",result);
        [weakSelf hideHud];
        XLBNoticeViewController *noticeVC = [XLBNoticeViewController new];
        noticeVC.userId = _carId;
        noticeVC.imgUrl = _imgUrl;
        noticeVC.nickname = _nickname;
        noticeVC.isVerify = YES;
        noticeVC.moveCarId = [result objectForKey:@"id"];
        [self.navigationController pushViewController:noticeVC animated:YES];
        
    } failure:^(NSString *description) {
        [weakSelf hideHud];
        [MBProgressHUD showError:description];
        
    }];
}
#pragma  mark -AddimageViewdelegate
- (void)updateAddimageViewHeight:(CGFloat)heifloat {
    NSLog(@"+++++%lf",heifloat);
    [_addImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(heifloat);
    }];
}

-(void)addImageView:(NSInteger)index {
    [self addClick:(3-self.imgArray.count)];
}
-(void)selectBtnImageView:(NSInteger)index {
    ImageReviewViewController *ViewC = [[ImageReviewViewController alloc] init];
    ViewC.isDelect = YES;
    ViewC.imageArray = self.imgArray;
    ViewC.currentIndex = [NSString stringWithFormat:@"%li",index];
    ViewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:ViewC animated:YES completion:nil];
}

- (void)delectPictureWithIndex:(NSInteger )idex {
    [self.imgArray removeObjectAtIndex:idex];
    [_addImageView initViewWith:self.imgArray];
}

- (void)addClick:(NSUInteger)max {
    
    if(max > 0) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:max delegate:self];
        imagePickerVc.allowPickingOriginalPhoto = NO;
        kWeakSelf(self);
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.imgArray addObject:obj];
            }];
            [_addImageView initViewWith:weakSelf.imgArray];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

-(NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray=[NSMutableArray array];
    }
    return _imgArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
