//
//  XLBIdentityViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/22.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBIdentityViewController.h"
//#import "BQLControl.h"
//#import "UILabel+BULabel.h"
#import "XLBAlertController.h"
#import "XLBMeRequestModel.h"
#import <UIImageView+WebCache.h>

#import "XLBCarDetailScreeningViewController.h"
#import "XLBIdentSuccessViewController.h"

@interface XLBIdentityViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *contentScroll;
@property (nonatomic, strong) UILabel *owner;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UILabel *brand;
@property (nonatomic, strong) UILabel *model;
@property (strong, nonatomic)  UIButton *completeButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSDictionary *carDetailInfomation;
@property (nonatomic, copy) NSString *carImageUrl;
@property (nonatomic, strong) UIImage *carImage;

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *vehicleAreaId;

@end

@implementation XLBIdentityViewController
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (iPhoneX) {
      
        self.completeButton.layer.masksToBounds = YES;
        self.completeButton.layer.cornerRadius = 8;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"行驶证认证";
    self.naviBar.slTitleLabel.text = @"行驶证认证";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vehicleAreaNotifition:) name:@"vehicleAreaIdNotifition" object:nil];
    [self setupSubViews];
}

-(void)vehicleAreaNotifition:(NSNotification *)sender{
    
    NSString *vehicleArea = [NSString stringWithFormat:@"%@",sender.userInfo[@"vehicleAreaId"]];
    NSString *carname = sender.userInfo[@"carname"];
    self.model.text = carname;
    self.vehicleAreaId = vehicleArea;
}


- (void)submitClick:(id)sender {
    
    if(self.carImage && self.carDetailInfomation && kNotNil(self.vehicleAreaId)) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[self.carDetailInfomation objectForKey:@"request_id"] forKey:@"imgId"];
//#warning 从列表带过来，目前列表不可用，暂时使用假数据
        [params setObject:self.vehicleAreaId forKey:@"vehicleAreaId"];
        // [params setObject:@"12" forKey:@"vehicleAreaId"];
        [params setObject:[self.carDetailInfomation objectForKey:@"owner"] forKey:@"owner"];
        [params setObject:[self.carDetailInfomation objectForKey:@"plate_num"] forKey:@"plateNumber"];
        [params setObject:[self.carDetailInfomation objectForKey:@"engine_num"] forKey:@"engineNumber"];
        [params setObject:[self.carDetailInfomation objectForKey:@"vin"] forKey:@"vin"];
        [params setObject:[self.carDetailInfomation objectForKey:@"vehicle_type"] forKey:@"vehicleType"];
        [params setObject:[self.carDetailInfomation objectForKey:@"use_character"] forKey:@"useCharacter"];
        [params setObject:[ZZCHelper dateStringFromString:[self.carDetailInfomation objectForKey:@"issue_date"] type:0] forKey:@"issueDate"];
        [params setObject:[ZZCHelper dateStringFromString:[self.carDetailInfomation objectForKey:@"register_date"] type:0]forKey:@"registerDate"];
        [params setObject:[self.carDetailInfomation objectForKey:@"model"] forKey:@"model"];
        NSLog(@"%@",params);
        kWeakSelf(self);
        [weakSelf showHudWithText:nil];
        [[NetWorking network] POST:kSe params:params cache:NO success:^(id result) {
            NSLog(@"%@",result);
            [weakSelf hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"vehicleArea" object:nil];
            XLBIdentSuccessViewController *vc = [XLBIdentSuccessViewController new];
            vc.isCert = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSString *description) {
            
            [weakSelf hideHud];
            [MBProgressHUD showError:description];
        }];
    }
    else {
        if (!kNotNil(self.vehicleAreaId)) {
            [MBProgressHUD showError:@"请选择车型"];
        }else {
            [MBProgressHUD showError:@"请先上传行驶证"];
        }
    }
}

- (void)showSheet {
    
    kWeakSelf(self);
    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"拍照",@"从相册选取"] title:nil message:nil cancel:YES cancelBlock:^{
        
        NSLog(@"点击了取消");
    } itemBlock:^(NSUInteger index) {
        
        switch (index) {
            case 0: {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    NSLog(@"点击了拍照");
                    [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypeCamera];
                }
                else {
                    NSLog(@"模拟器打不开相机");
                }
            }
                break;
            case 1: {
                [weakSelf chooseCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
                
            default:
                break;
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)chooseCameraOrAlbum:(UIImagePickerControllerSourceType )type {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = type;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = image;
    self.carImage = image;
    [self uploadCarImages:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadCarImages:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *params = @{@"image":encodedString};
    self.vehicleAreaId = @"";
    self.model.text = @"";
    kWeakSelf(self);
    [weakSelf showHudWithText:nil];
    [XLBMeRequestModel identify:params success:^(NSDictionary *result) {
        NSLog(@"%@  %@   %@  %@",result,result[@"issue_date"],result[@"register_date"],result[@"model"]);
        [weakSelf hideHud];
        weakSelf.owner.text = [result objectForKey:@"owner"];
        weakSelf.number.text = [result objectForKey:@"plate_num"];
        weakSelf.brand.text = [result objectForKey:@"model"];
        weakSelf.parentId = [result objectForKey:@"parentId"];
        weakSelf.carDetailInfomation = result;
        
    } failure:^(NSString *error) {
        weakSelf.imageView.image = [UIImage imageNamed:@"btn_xsz_px"];
        [weakSelf hideHud];
        [MBProgressHUD showError:@"出错了，请重试"];
    }];
}

- (void)setupSubViews {
    
    self.view.backgroundColor = RGB(247, 247, 247);
    self.contentScroll.backgroundColor = RGB(247, 247, 247);
    self.completeButton = [UIButton new];
    [self.completeButton setTitle:@"提交" forState:UIControlStateNormal];
    self.completeButton.backgroundColor = RGB(66, 66, 66);
//    UIColor *color = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:self.completeButton.size]];
//    self.completeButton.backgroundColor = color;
    [self.completeButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.completeButton];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-30);
        make.height.mas_equalTo(54);
        if (iPhoneX) {
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-25);
        }else{
            make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-5);
        }
    }];
    CGFloat image_width = kSCREEN_WIDTH -30;
    CGFloat image_height = image_width * 420 / 620.0;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, image_width, image_height)];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 10;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureWithImage:)];
    tap.numberOfTouchesRequired = 1;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.imageView addGestureRecognizer:tap];
    [self.contentScroll addSubview:self.imageView];
    self.imageView.image = [UIImage imageNamed:@"btn_xsz_px"];


    UILabel *hint_label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.bottom + 12, kSCREEN_WIDTH, 8)];
    hint_label.font = [UIFont systemFontOfSize:11];
    hint_label.textColor = [UIColor textBlackColor];
    hint_label.textAlignment = NSTextAlignmentCenter;
    hint_label.text = @"系统识别行驶证，识别错误需重新上传";
//    [hint_label sizeToFit];
    [self.contentScroll addSubview:hint_label];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 10;
    [self.contentScroll addSubview:backView];
    backView.frame = CGRectMake(15, hint_label.bottom+12, kSCREEN_WIDTH-30, 500);

    UILabel *owner_label = [self label_title];
    owner_label.frame = CGRectMake(15, 15, backView.width-30, 0);
    owner_label.text = @"所有人";
    [owner_label sizeToFit];
    [backView addSubview:owner_label];
    
    self.owner.frame = CGRectMake(owner_label.right + 30, owner_label.top, backView.width - (owner_label.right + 45), owner_label.height);
    [backView addSubview:self.owner];
    UIView *line_one = [self line_view];
    [backView addSubview:line_one];
    line_one.frame = CGRectMake(owner_label.left, self.owner.bottom + 12, backView.width-30, 0.8);
    
    UILabel *number_label = [self label_title];
    number_label.frame = CGRectMake(owner_label.left, line_one.bottom + 12, owner_label.width, 0);
    number_label.text = @"车辆号码";
    [number_label sizeToFit];
    [backView addSubview:number_label];
    self.number.frame = CGRectMake(self.owner.left, number_label.top, self.owner.width, number_label.height);
    [backView addSubview:self.number];
    UIView *line_two = [self line_view];
    line_two.frame = CGRectMake(line_one.left, self.number.bottom + 12, line_one.width, line_one.height);
    [backView addSubview:line_two];

    UILabel *brand_label = [self label_title];
    brand_label.frame = CGRectMake(owner_label.left, line_two.bottom + 12, owner_label.width, 0);
    brand_label.text = @"车辆品牌";
    [brand_label sizeToFit];
    [backView addSubview:brand_label];
    self.brand.frame = CGRectMake(self.owner.left, brand_label.top, self.owner.width, brand_label.height);
    [backView addSubview:self.brand];
    UIView *line_three = [self line_view];
    line_three.frame = CGRectMake(line_one.left, self.brand.bottom + 12, line_one.width, line_one.height);
    [backView addSubview:line_three];

    UILabel *model_label = [self label_title];
    model_label.frame = CGRectMake(owner_label.left, line_three.bottom + 12, owner_label.width, 0);
    model_label.text = @"车辆型号";
    [model_label sizeToFit];
    [backView addSubview:model_label];
    [backView addSubview:self.model];

    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wd_fh"]];
    [backView addSubview:arrow];
    self.model.frame = CGRectMake(self.owner.left, model_label.top, self.owner.width-15, owner_label.height);
    arrow.frame = CGRectMake(self.model.right+5, model_label.top + (model_label.height - 14) / 2, 7, 14);
    [backView addSubview:self.model];
    UIView *line_four = [self line_view];
    line_four.frame = CGRectMake(line_one.left, self.model.bottom + 12, line_one.width, line_one.height);
    [backView addSubview:line_four];

    UIButton *button = [UIButton buttonWithType:0];
    [backView addSubview:button];
    button.frame = CGRectMake(self.owner.left, line_three.bottom, self.owner.width, 50);
    [button addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    
    backView.frame = CGRectMake(15, hint_label.bottom+12, kSCREEN_WIDTH-30, line_four.bottom+15);

    self.contentScroll.contentSize = CGSizeMake(kSCREEN_WIDTH, backView.bottom + 12);
}

- (void)moreClick {

    if(kNotNil(self.owner.text) &&
       kNotNil(self.number.text) &&
       kNotNil(self.brand.text) &&
       kNotNil(self.parentId)) {
        XLBCarDetailScreeningViewController *car = [[XLBCarDetailScreeningViewController alloc] init];
        car.parentId = self.parentId;
        [self.navigationController pushViewController:car animated:YES];
    }
    else {
        if (!kNotNil(self.carImage)) {
            [MBProgressHUD showError:@"请先上传行驶证"];

        }else {
            [MBProgressHUD showError:@"行驶证识别失败，请重新上传"];

        }
    }
}

- (UIView *)line_view {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(247, 247, 247);
    return line;
}

- (UILabel *)label_title {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGB(88, 88, 88);
    label.font = [UIFont systemFontOfSize:15];
    return label;
}

- (UILabel *)owner {
    
    if(!_owner) {
        _owner = [[UILabel alloc] init];
        _owner.textColor = RGB(166, 166, 166);
        _owner.font = [UIFont systemFontOfSize:15];
        _owner.text = @"";
        _owner.textAlignment = NSTextAlignmentRight;

    }
    return _owner;
}

- (UILabel *)number {
    
    if(!_number) {
        _number = [[UILabel alloc] init];
        _number.textColor = RGB(166, 166, 166);
        _number.font = [UIFont systemFontOfSize:15];
        _number.text = @"";
        _number.textAlignment = NSTextAlignmentRight;

    }
    return _number;
}

- (UILabel *)brand {
    
    if(!_brand) {
        _brand = [[UILabel alloc] init];
        _brand.textColor = RGB(166, 166, 166);
        _brand.font = [UIFont systemFontOfSize:15];
        _brand.text = @"";
        _brand.textAlignment = NSTextAlignmentRight;

    }
    return _brand;
}

- (UILabel *)model {
    
    if(!_model) {
        _model = [[UILabel alloc] init];
        _model.textColor = RGB(166, 166, 166);
        _model.font = [UIFont systemFontOfSize:15];
        _model.textAlignment = NSTextAlignmentRight;
        _model.text = @"请选择你的车辆型号";
    }
    return _model;
}


- (UIScrollView *)contentScroll {
    
    if(!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] init];
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGB(178, 178, 178);
        label.numberOfLines = 0;
        label.text = @"备注：身份认证之后，将被优先推荐到寻车友，魅力值提升只需要一步哦";
        //[self.view addSubview:label];
        [self.view addSubview:_contentScroll];
        if (iPhoneX) {
            _contentScroll.frame = CGRectMake(0, 82, kSCREEN_WIDTH, kSCREEN_HEIGHT - 80);
        }else {
            _contentScroll.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 48);
        }
    }
    return _contentScroll;
}


- (void)tapGestureWithImage:(UITapGestureRecognizer *)tap {
    if ([tap isKindOfClass:[UITapGestureRecognizer class]]) {
        [self showSheet];
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
