//
//  XLBGroupShareViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/6/8.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "XLBGroupShareViewController.h"
#import "XLBGroupShareView.h"
@interface XLBGroupShareViewController ()<XLBShareViewDelegate>

@property (nonatomic, strong) XLBGroupShareView *shareView;

@end

@implementation XLBGroupShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享群二维码";
    self.naviBar.slTitleLabel.text = @"分享群二维码";
    self.shareView = [[XLBGroupShareView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.naviBar.bottom)];
    self.shareView.model = self.model;
    [self.view addSubview:self.shareView];
    [self QRCodeInvitationWithQRCodeContent:self.model.groupHuanxin];
}
- (void)initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"icon_fx"];
    [rightItem setImage:image forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {//没有微信
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]){
            //没有微博
            [rightItem setHidden:YES];
            if (![XLBUser user].isLogin || !kNotNil([XLBUser user].token)) {
                //没有登陆
            }else{
                [rightItem setHidden:NO];
            }
        }
    }
}

- (void)rightClick {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [self setShareViewWithHidden:ShareBtnWeChatHidden];
    }else if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]){
        [self setShareViewWithHidden:ShareBtnWeiBoHidden];
    }else {
        [self setShareViewWithHidden:3];
    }
}

- (void)setShareViewWithHidden:(ShareBtnHidden)hidden {
    XLBShareView *shareView = [[XLBShareView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) type:ShareViewSaveImg isHidden:hidden];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];
}
#pragma mark - share
- (void)shareViewBtnClickWithTag:(UIButton *)sender {
    switch (sender.tag) {
        case ShareViewWeChatBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneSession];
            }
            break;
        case ShareViewWeChatPyqBtnTag:{
            [self shareViewWithWeChatType:WechatShareSceneTimeline];
        }
            break;
        case ShareViewWeiBoBtnTag:{
            UIImage *img = [self.shareView imageWithUIView:self.shareView];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
            break;
            
        default:
            break;
    }
}

- (void)shareViewWithWeChatType:(WechatShareScene)weChatType {
    UIImage *img = [self.shareView imageWithUIView:self.shareView];
    BQLShareModel *shareModel = [BQLShareModel modelWithDictionary:@{@"image":img,}];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_image:shareModel scene:weChatType success:^(id response) {
    } failure:^(NSString *error) {
    }];
}

- (void)QRCodeInvitationWithQRCodeContent:(NSString *)content{
    NSString *urlString;
    if (kNotNil(content)) {
        urlString = [NSString stringWithFormat:@"%@share/down/%@",kDomainUrl,content];
    }else {
        urlString = @"";
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImages = [filter outputImage];
    self.shareView.codeImg.image = [self createNonInterpolatedUIImageFormCIImage:qrImages withSize:206];
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
