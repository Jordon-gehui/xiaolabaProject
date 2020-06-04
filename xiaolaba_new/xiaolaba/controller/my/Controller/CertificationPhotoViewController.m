//
//  CertificationPhotoViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "CertificationPhotoViewController.h"

@interface CertificationPhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *photoImg;
    UIImage *photo;
    UIButton *sureBtn;
    
    UIButton *afreshBtn;
    UIButton *verifyBtn;
}
@property(nonatomic,strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController

@end

@implementation CertificationPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片认证";
    self.naviBar.slTitleLabel.text = @"照片认证";
    self.view.backgroundColor = [UIColor whiteColor];
    photoImg = [UIImageView new];
    photoImg.backgroundColor = [UIColor whiteColor];
    photoImg.layer.cornerRadius = 5;
    photoImg.layer.masksToBounds = YES;
    [photoImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapPhotoImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCamera)];
    [photoImg addGestureRecognizer:tapPhotoImg];
    [self.view addSubview:photoImg];
    
    UIImageView *bottomImgView = [UIImageView new];
    bottomImgView.image = [UIImage imageNamed:@"pic_rz_bg"];
    [self.view addSubview:bottomImgView];
    
    UILabel *tipLbl =[UILabel new];
    tipLbl.font = [UIFont systemFontOfSize:14];
    tipLbl.textColor = [UIColor commonTextColor];
    tipLbl.textAlignment = NSTextAlignmentCenter;
    tipLbl.numberOfLines = 2;
    tipLbl.text = @"上传认证的照片仅用于后台审核\n我们不会以任何形式泄露您的隐私，请放心自拍";
    [self.view addSubview:tipLbl];
    
    sureBtn = [self addButton:@"确认上传" addTargrt:@selector(sureClick:)];
    [sureBtn setHidden:NO];
    sureBtn.layer.cornerRadius = 5;
    [self.view addSubview:sureBtn];

    afreshBtn = [self addButton:@"重新上传" addTargrt:@selector(afreshClick:)];
    afreshBtn.layer.cornerRadius = 5;
    [afreshBtn setHidden:YES];
    [self.view addSubview:afreshBtn];
    
    verifyBtn = [self addButton:@"确认上传" addTargrt:@selector(sureClick:)];
    verifyBtn.layer.cornerRadius = 5;
    [verifyBtn setHidden:YES];
    [self.view addSubview:verifyBtn];
    
    [photoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom).with.offset(120);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(110);
    }];
    [bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(56*kiphone6_ScreenWidth);
    }];
    [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomImgView.mas_top).with.offset(-20);
        make.centerX.mas_equalTo(self.view);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLbl.mas_top).with.offset(-40);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(50);
    }];
    [afreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLbl.mas_top).with.offset(-40);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLbl.mas_top).with.offset(-40);
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    if (kNotNil([XLBUser user].imgAkira)) {
        [self showPhoto:1];
    }else{
        [self showPhoto:0];
    }
    // Do any additional setup after loading the view.
}
-(UIButton*)addButton:(NSString*)title addTargrt:(SEL)action {
    UIButton *button = [UIButton new];
    button.clipsToBounds = YES;
    button.backgroundColor =  RGB(61, 66, 67);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)sureClick:(UIButton*)sender {
    if (photo ==nil) {
        [MBProgressHUD showError:@"请先进行拍照"];
        return;
    }
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] asyncUploadImage:photo avatar:NO complete:^(NSArray<NSString *> *names, UploadStatus state) {
        photo = nil;
        NSLog(@"========%@",names);
        [weakSelf uploadPhotoName:[names firstObject]];
    }];
}
-(void)uploadPhotoName:(NSString*)name{
    [[NetWorking network] POST:kCertificationImg params:@{@"imgAkira":name} cache:NO success:^(id result) {
        [self hideHud];
        [XLBUser user].imgStatus = @"1";
        [XLBUser user].imgAkira = name;
        if ([[XLBUser user].voiceStatus isEqualToString:@"0"]) {
            [[CSRouter share]push:@"TheRecordingViewController" Params:@{@"isPushTo":@"2"} hideBar:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];

        }
    } failure:^(NSString *description) {
        [self hideHud];
    }];
}
-(void)showPhoto:(NSInteger)isShow{
    if (isShow) {
        if (photo!=nil) {
            photoImg.image = photo;
        }else if (kNotNil([XLBUser user].imgAkira)) {
            [photoImg sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:[XLBUser user].imgAkira Withtype:IMGNormal]] placeholderImage:[UIImage imageNamed:@"btn_sczp_h"]];
        }
        [sureBtn setHidden:YES];
        [afreshBtn setHidden:NO];
        [verifyBtn setHidden:NO];
    }else{
        [sureBtn setHidden:NO];
        [afreshBtn setHidden:YES];
        [verifyBtn setHidden:YES];
        photo = nil;
        photoImg.image = [UIImage imageNamed:@"btn_sczp_h"];
    }
}
-(void)afreshClick:(UIButton*)sender {
    [self showPhoto:0];
}
-(void)openCamera {
    NSUInteger sourceType = 0;
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        //拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}
#pragma mark -实现图片选择器代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    photo = image;
    photoImg.image = image;  //给UIimageView赋值已经选择的相片
    [self showPhoto:1];
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
