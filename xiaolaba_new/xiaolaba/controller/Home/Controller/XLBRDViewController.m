//
//  XLBRDViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/4.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBRDViewController.h"
#import "TZImagePickerController.h"
#import "NetWorking.h"
#import "SZTextView.h"
#import "XLBLocation.h"
#import "AddImageView.h"
#import "XLBChooseLocationViewController.h"

#import "HCEmojiKeyboard.h"
static NSString *emoji = @"Resources.bundle/emoji";
static NSString *keyboard = @"Resources.bundle/keyboard";
static NSInteger maxWords = 300;

@interface XLBRDViewController () <TZImagePickerControllerDelegate,AddImageViewViewDelegate,ImageReviewViewControllerDelegate,UITextViewDelegate>

@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, strong) UILabel *leftWord;

@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) AddImageView *addImageView;
@property (nonatomic, strong)NSMutableArray *imageArray;
//键盘
@property (strong, nonatomic) HCEmojiKeyboard *emojiKeyboard;
@property(nonatomic,assign) BOOL keyBoardlsVisible;
@property(nonatomic,retain)UIView *intefaceView;
@end
#define maxImageCount 9
@implementation XLBRDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    self.naviBar.slTitleLabel.text = @"发布动态";
    [self setup];
    [self createEmojiView];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [self intefaceView];
}
-(UIView*)intefaceView {
    if (!_intefaceView) {
        _intefaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        [_intefaceView setBackgroundColor:[UIColor whiteColor]];
        [_intefaceView setHidden:YES];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
        [line setBackgroundColor:[UIColor lineColor]];
        [_intefaceView addSubview:line];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kSCREEN_WIDTH, 0)];
        [line2 setBackgroundColor:[UIColor lineColor]];
        [_intefaceView addSubview:line2];
        UIButton *faceBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 4, 32, 32)];
        faceBtn.tag = 0;
        [faceBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateNormal];
        [faceBtn setBackgroundImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
        [faceBtn addTarget:self action:@selector(clickedFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_intefaceView addSubview:faceBtn];
        [self.view addSubview:_intefaceView];
    }
    return _intefaceView;
}
-(void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightItem setTitle:@"发布" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor normalTextColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
}

- (void)rightClick {
    
    // 发布动态
    if(kNotNil(self.textView.text)||self.imageArray.count>0) {
        
        [self showHudWithText:nil];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.textView.text forKey:@"notion"];
        if ([self.locationLabel.text isEqualToString:@"位置信息"]) {
            [params setObject:@"" forKey:@"location"];
        }else{
            [params setObject:[NSString stringWithFormat:@"%@･%@",[XLBUser user].city,self.locationLabel.text] forKey:@"location"];
//            [params setObject:self.locationLabel.text forKey:@"location"];
        }
        [params setObject:[XLBUser user].longitude forKey:@"longitude"];
        [params setObject:[XLBUser user].latitude forKey:@"latitude"];
        if(self.imageArray.count > 0) {
            UIImage *img;
            if (self.imageArray.count == 1) {
                img = [self.imageArray objectAtIndex:0];
            }
            kWeakSelf(self);
            [[NetWorking network] asyncUploadImages:self.imageArray avatar:NO complete:^(NSArray<NSString *> *names, UploadStatus state) {
                
                [params setObject:names forKey:@"imgs"];
                if (weakSelf.imageArray.count == 1) {
                    [params setObject:[NSString stringWithFormat:@"%.2f",img.size.width] forKey:@"width"];
                    [params setObject:[NSString stringWithFormat:@"%.2f",img.size.height] forKey:@"height"];
                }
                [weakSelf publishComment:params];
            }];
        }else {
            [self publishComment:params];
        }
    }
    else {
        [MBProgressHUD showError:@"说点什么吧..."];
    }
}

- (void)publishComment:(NSDictionary *)params {
    
    kWeakSelf(self);
    [[NetWorking network] POST:kPublish params:params cache:NO success:^(id result) {
        
        [weakSelf hideHud];
        [MBProgressHUD showError:@"发布成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *description) {
        
        [weakSelf hideHud];
        [MBProgressHUD showError:@"发布失败"];
    }];
}

- (void)setup {
    
    _textView = [SZTextView new];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholderTextColor = RGB(200, 200, 200);
    _textView.placeholder = @"说点什么吧...";
    self.textView.delegate = self;
    [self.scrollView addSubview:_textView];
    
    self.leftWord = [UILabel new];
    self.leftWord.textColor = RGB(180, 180, 180);
    self.leftWord.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:self.leftWord];
    
    self.addImageView = [AddImageView new];
    [self.addImageView setBackgroundColor:[UIColor whiteColor]];
    [self.addImageView setDelegate:self];
    [self.scrollView addSubview:self.addImageView];
    
    _locationView = [UIView new];
    _locationView.frame = CGRectMake(0, _textView.bottom + 10, kSCREEN_WIDTH, 40);
    _locationView.backgroundColor =[UIColor whiteColor];
    [self.scrollView addSubview:_locationView];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick)];
    [_locationView addGestureRecognizer:tap];
    
    UIImageView *locationV =[[UIImageView alloc]initWithFrame:CGRectMake(22, 15, 8, 10)];
    locationV.image =[UIImage imageNamed:@"icon_fx_dw"];
    [_locationView addSubview:locationV];
    
    _locationLabel = [UILabel new];
    _locationLabel.frame = CGRectMake(35, 10, kSCREEN_WIDTH-85, 20);
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.textColor = [UIColor textBlackColor];
    _locationLabel.text = @"位置信息";
    [_locationView addSubview:_locationLabel];
    
    UIImageView *right = [UIImageView new];
    right.image =[UIImage imageNamed:@"icon_wd_fh"];
    [_locationView addSubview:right];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX){
            make.top.mas_equalTo(self.view).with.offset(98);
        }else{
            make.top.mas_equalTo(10);
        }
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-20);
        make.height.mas_equalTo(120);
    }];
    [_leftWord mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.textView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.textView.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(18);
    }];
    self.leftWord.text = [NSString stringWithFormat:@"0/%ld",maxWords];
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_textView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-20);
        make.height.mas_equalTo(90);
    }];
    [_locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addImageView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kSCREEN_WIDTH-20);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locationView.mas_right).with.offset(-30);
        make.centerY.mas_equalTo(_locationView);
    }];

}

-(void)locationClick {
    
    XLBChooseLocationViewController *choseView = [[XLBChooseLocationViewController alloc]init];
    kWeakSelf(self)
    choseView.returnBlock = ^(id data) {
        NSString *sring = data;
        if (sring.length ==0) {
            weakSelf.locationLabel.text = @"位置信息";
        }else
         weakSelf.locationLabel.text = sring;
    };
    [self.navigationController pushViewController:choseView animated:YES];
}

#pragma  mark -AddimageViewdelegate
- (void)updateAddimageViewHeight:(CGFloat)heifloat {
    NSLog(@"+++++%lf",heifloat);
    [_addImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(heifloat);
    }];
}

-(void)addImageView:(NSInteger)index {
    [self addClick:(maxImageCount-self.imageArray.count)];
}
- (void)selectBtnImageView:(NSString *)index {
    ImageReviewViewController *viewC = [[ImageReviewViewController alloc] init];
    viewC.isDelect = YES;
    viewC.delegate = self;
    viewC.imageArray = self.imageArray;
    viewC.currentIndex = index;
    viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewC animated:YES completion:nil];
}

- (void)delectPictureWithIndex:(NSInteger )idex {
    [self.imageArray removeObjectAtIndex:idex];
    [_addImageView initViewWith:self.imageArray];
}

- (void)addClick:(NSUInteger)max {
    
    if(max > 0) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:max delegate:self];
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.photoWidth = 1024.0;
        imagePickerVc.photoPreviewMaxWidth = 3072.0;
        kWeakSelf(self);
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.imageArray addObject:obj];
            }];
            [_addImageView initViewWith:weakSelf.imageArray];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)imageShowWithIndex:(NSInteger)index images:(NSMutableArray *)images {
    _imageArray = images;
//    XLBPictureBrowseViewController *viewC = [[XLBPictureBrowseViewController alloc] init];
//    viewC.delegate = self;
//    viewC.isDelect = NO;
//    viewC.imageArray = images;
//    viewC.currentIndex = index;
//    [self.navigationController presentViewController:viewC animated:YES completion:nil];
}
- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length < (maxWords + 1)) {
        self.leftWord.text = [NSString stringWithFormat:@"%li/%li",textView.text.length,maxWords];
    }else {
        self.textView.text = [textView.text substringToIndex:maxWords];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Emoji键盘
- (void)createEmojiView {
    
    _emojiKeyboard = [HCEmojiKeyboard sharedKeyboard];
    _emojiKeyboard.showAddBtn = NO;
    [_emojiKeyboard addBtnClicked:^{
        NSLog(@"clicked add btn");
    }];
    [_emojiKeyboard sendEmojis:^{
        //赋值
        [_textView resignFirstResponder];
//                _showLab.text = _textWindow.text;
    }];
}
//改变键盘状态
- (void)clickedFaceBtn:(UIButton *)button{
    if (button.tag == 1){
        self.textView.inputView = nil;
        [button setBackgroundImage:[UIImage imageNamed:emoji] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:keyboard] forState:UIControlStateNormal];
        [_emojiKeyboard setTextInput:self.textView];
    }
    [self.textView reloadInputViews];
    button.tag = (button.tag+1)%2;
    [_textView becomeFirstResponder];
}
//  键盘弹出触发该方法
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"键盘弹出");
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat endHeight = frame.size.height;
    _intefaceView.frame = CGRectMake(0, self.view.size.height-endHeight-40, kSCREEN_WIDTH, 40);
    _intefaceView.hidden = NO;
    _intefaceView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _intefaceView.alpha = 1;
    }];
    _keyBoardlsVisible =YES;
    [self.view setUserInteractionEnabled:YES];
}
//  键盘隐藏触发该方法
- (void)keyboardDidHide:(NSNotification *)notification
{
    NSLog(@"键盘隐藏");
    _keyBoardlsVisible =NO;
    [UIView animateWithDuration:0.3 animations:^{
        _intefaceView.alpha = 0;
    } completion:^(BOOL finished) {
        _intefaceView.hidden = YES;
    }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


@end
