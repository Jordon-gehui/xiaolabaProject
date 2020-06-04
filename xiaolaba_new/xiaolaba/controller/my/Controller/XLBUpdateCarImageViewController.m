//
//  XLBUpdateCarImageViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/12.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBUpdateCarImageViewController.h"

@interface XLBUpdateCarImageViewController ()


    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
    
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTop;
@property (weak, nonatomic) IBOutlet UIView *qrBgView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
    
@property (weak, nonatomic) IBOutlet UIView *qrImageBgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrBgImage;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UIButton *DownLoadBtn;
@end

@implementation XLBUpdateCarImageViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (iPhoneX) {
        self.bgViewTop.constant = 104;
    }else if (iPhone5s) {
        self.bgViewWidth.constant = 305;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"打印挪车贴";
    self.naviBar.slTitleLabel.text = @"打印挪车贴";
    [MobClick event:@"Print_CarTie"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
}
- (void)setup {
    
    // 测试图片
    self.DownLoadBtn.layer.masksToBounds = YES;
    self.DownLoadBtn.layer.cornerRadius = 5;
    self.DownLoadBtn.backgroundColor =  RGB(61, 66, 67);
    
    self.qrImageBgView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.qrImageBgView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    self.qrImageBgView.layer.shadowOffset = CGSizeMake(0, 3);
    self.qrImageBgView.layer.cornerRadius = 15;
    
    self.qrBgView.layer.masksToBounds = YES;
    self.qrBgView.layer.cornerRadius = 14;
    [[NetWorking network] POST:KQRCarImg params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        if (kNotNil(result)) {
            [self QRCodeInvitationWithQRCodeContent:result[@"url"]];
            self.IDLabel.text = [NSString stringWithFormat:@"No:%@",result[@"no"]];
        }
        
    } failure:^(NSString *description) {
        NSLog(@"%@",description);
        self.qrImage.image = [UIImage imageNamed:@"homenor"];
        
    }];
    
    
//    UIColor *btnColor = [UIColor colorWithPatternImage:[UIImage gradually_bottomToTopWithStart:[UIColor shadeStartColor] end:[UIColor shadeEndColor] size:self.DownLoadBtn.size]];
//    self.DownLoadBtn.backgroundColor = btnColor;

//    NSString *string = @"使用说明：\n用户可点击下方按钮下载车贴保存至手机相册，然后自行打印放置于车内即可";
    // Adjust the spacing
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 8.f;
//    paragraphStyle.alignment = self.remindLabel.textAlignment;
//    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(0, 5)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(152, 152, 152) range:NSMakeRange(5, string.length - 5)];
//    self.remindLabel.attributedText = attributedString;
    self.remindLabel.text = @"点击下方按钮保存至手机相册\n然后自行打印使用即可";
}

- (void)QRCodeInvitationWithQRCodeContent:(NSString *)content{

    NSString *urlString = [NSString stringWithFormat:@"%@",content];

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImages = [filter outputImage];
    self.qrImage.image = [self createNonInterpolatedUIImageFormCIImage:qrImages withSize:self.qrImage.size.width];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

-(UIImage *)convertViewToImage:(UIView *)view{
    CGSize size = view.bounds.size;
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)downLoadBtnClick:(id)sender {
    
    UIImage *image = [self convertViewToImage:self.qrBgView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinshSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        //保存失败
        [MBProgressHUD showError:@"保存失败"];
    }else {
        //保存成功
        [MBProgressHUD showSuccess:@"保存成功"];
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
