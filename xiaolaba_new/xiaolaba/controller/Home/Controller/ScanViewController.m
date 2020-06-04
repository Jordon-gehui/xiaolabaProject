//
//  ScanViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/2.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NetWorking.h"
#import "XLBQRCodeViewController.h"
#import <EaseUI/EaseUI.h>


@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int number;
    NSTimer *timer;
    NSInteger _count;
    BOOL upOrdown;
    AVCaptureDevice *lightDevice;
    
    NSString *cardNO;
    NSString *cardUrlStr;
    NSString *cardID;
}
@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * previewLayer;

@property (nonatomic,strong) UIView *centerView;//扫描的显示视图
@property (nonatomic,retain) UIImageView *imageView;//扫描线
/*** 专门用于保存描边的图层 ***/
@property (nonatomic,strong) CALayer *containerLayer;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self initNaviBar];
    self.naviBar.slTitleLabel.text = @"扫一扫";
    //初始化闪光灯设备
    lightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //扫描范围
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.naviBar.bottom, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_centerView];
    
    //扫描的视图加载
    [self addbackView:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [self addbackView:CGRectMake(0, 120, (self.view.frame.size.width-300)/2, 300)];
    [self addbackView:CGRectMake(CGRectGetWidth(self.view.frame)/2+150, 120, (self.view.frame.size.width-300)/2, 300)];
    [self addbackView:CGRectMake(0, 420, self.view.frame.size.width,CGRectGetHeight(self.view.frame)- 420)];
    
    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2, 120, 30, 2)];
    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2+270, 120, 30, 2)];

    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2+300, 120, 2, 30)];
    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2+300, 120+270, 2, 30)];

    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2, 420, 30, 2)];
    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2+270, 420, 32, 2)];

    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2, 120, 2, 30)];
    [self addlineView:CGRectMake((self.view.frame.size.width-300)/2, 120+270, 2, 30)];

    UILabel *labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 430, self.view.frame.size.width - 30, 30)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码放入框内,自动扫描";
    [self.centerView addSubview:labIntroudction];
    
    UIButton *openLight = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-25, 470, 50, 50)];
    [openLight setImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateNormal];
    [openLight setImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateSelected];
    [openLight addTarget:self action:@selector(openLightWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:openLight];
    
    //扫描线
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-110, 130, 220, 5)];
    _imageView.image = [UIImage imageNamed:@"scanLine"];
    [self.centerView addSubview:_imageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:)name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];
//    // 开始扫描二维码
//    [self startScan];
}
-(void)addbackView:(CGRect)frame{
    UIView *scanningViewFour = [[UIView alloc]initWithFrame:frame];
    scanningViewFour.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.centerView addSubview:scanningViewFour];
}
-(void)addlineView:(CGRect)frame{
    UIView *lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = [UIColor colorWithRed:0.110 green:0.659 blue:0.894 alpha:1.00];
    [self.centerView addSubview:lineView];
}
- (void)subjectAreaDidChange:(NSNotification *)notification
{
    //先进行判断是否支持控制对焦
    if (_device.isFocusPointOfInterestSupported &&[_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error =nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [_device lockForConfiguration:&error];
        [_device setFocusMode:AVCaptureFocusModeAutoFocus];
//        [self focusAtPoint:self.center];
        //操作完成后，记得进行unlock。
        [_device unlockForConfiguration];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanningAnimation) userInfo:nil repeats:YES];
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _count= 0;
    [timer invalidate];
    [self.session stopRunning];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];

}

- (void)startScan {
    if (![self.session canAddInput:self.input]) return;
    [self.session addInput:self.input];
    
    if (![self.session canAddOutput:self.output]) return;
    [self.session addOutput:self.output];
    
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [self.output setRectOfInterest:CGRectMake((120)/kSCREEN_HEIGHT,((kSCREEN_WIDTH-300)/2)/kSCREEN_WIDTH,300/kSCREEN_HEIGHT,300/kSCREEN_WIDTH)];
    self.previewLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:self.containerLayer];
    self.containerLayer.frame = self.view.bounds;

    //更新界面
    _previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.centerView.frame), CGRectGetHeight(self.centerView.frame));
    [self.centerView.layer insertSublayer:self.previewLayer atIndex:0];

    [self.session startRunning];
}

#pragma mark -------- 懒加载---------
- (AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (AVCaptureMetadataOutput *)output{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}

-(void)alertViewShow:(NSString*)string Withcancle:(NSString*)canStr withTag:(NSInteger)tag{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:canStr otherButtonTitles:@"确定", nil];
    alert.tag =tag;
    [alert show];
}

-(void) scanHttpIsMoveTheCarWithString:(NSString *)string {
    if([string rangeOfString:@"qrcode"].location !=NSNotFound){

        NSArray *array = [string componentsSeparatedByString:@"/"];
        
        NSDictionary *params = @{@"key":[array lastObject]};
        [self showHudWithText:nil];
        kWeakSelf(self);
        [[NetWorking network] GET2:kScan params:params cache:NO success:^(id result) {
            NSLog(@"---------------------------  %@",result);
            [weakSelf hideHud];
            NSInteger status = [[result objectForKey:@"status"] integerValue];
            if (status ==0) {
                XLBQRCodeViewController *xlb = [XLBQRCodeViewController new];
                xlb.number = [result objectForKey:@"no"];
                xlb.url = [result objectForKey:@"url"];
                [self.navigationController pushViewController:xlb animated:YES];
            }else if(status ==1) {
                [weakSelf alertViewShow:@"该挪车贴已被绑定" Withcancle:nil withTag:0];
            }else{
                [weakSelf alertViewShow:@"该挪车贴无效" Withcancle:nil withTag:0];
                
            }
        } failure:^(NSString *description) {
            [weakSelf hideHud];
            [self.session startRunning];
            [MBProgressHUD showError:description];
        }];
        
    }else{
        [self alertViewShow:@"该挪车贴无效" Withcancle:nil withTag:2];
    }
    
}

-(void) scanHttpWithString:(NSString *)string {
    if([string rangeOfString:@"qrcode"].location !=NSNotFound){

        NSArray *array = [string componentsSeparatedByString:@"/"];
        
        NSDictionary *params = @{@"key":[array lastObject]};
        [self showHudWithText:nil];
        kWeakSelf(self);
        [[NetWorking network] GET2:kScan params:params cache:NO success:^(id result) {
            NSLog(@"---------------------------  %@",result);
            [weakSelf hideHud];
            NSInteger status = [[result objectForKey:@"status"] integerValue];
            if (status ==0) {
                cardNO = [result objectForKey:@"no"];
                cardUrlStr = [result objectForKey:@"url"];
                XLBQRCodeViewController *codeVC = [XLBQRCodeViewController new];
                codeVC.number = cardNO;
                codeVC.url = cardUrlStr;
                codeVC.hidesBottomBarWhenPushed = YES;
                NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
                arr[arr.count-1] = codeVC;
                [self.navigationController setViewControllers:arr animated:YES];
            }else if(status ==1) {
                cardID = [result objectForKey:@"userId"];
                OwnerViewController *ownerVC = [[OwnerViewController alloc]init];
                ownerVC.userID = cardID;
                ownerVC.delFlag = 1;
                ownerVC.hidesBottomBarWhenPushed = YES;
                NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
                arr[arr.count-1] = ownerVC;
                [self.navigationController setViewControllers:arr animated:YES];
            }else{
                [weakSelf alertViewShow:@"该挪车贴无效" Withcancle:nil withTag:0];

            }
        } failure:^(NSString *description) {
            [weakSelf hideHud];
            [self.session startRunning];

            [MBProgressHUD showError:description];
        }];
    }else{
        [self alertViewShow:@"该挪车贴无效" Withcancle:nil withTag:2];
    }
}

- (void)scanGroupWithGroupID:(NSString *)groupID {
    if ([groupID rangeOfString:@"share"].location != NSNotFound) {
        NSArray *array = [groupID componentsSeparatedByString:@"/"];
        NSString *groupStr = [array lastObject];
        [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:groupStr completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                [[NetWorking network] POST:kUsli params:@{@"userIds":aGroup.owner,@"groupIds":@""} cache:NO success:^(id result) {
                    NSLog(@"%@",result);
                    NSString *owner = [NSString stringWithFormat:@"%@",result[0][@"nickname"]];
                    [[CSRouter share] push:@"XLBJoinGroupViewController" Params:@{@"groupID":groupStr,@"groupDetail":aGroup,@"owner":owner} hideBar:YES];
                } failure:^(NSString *description) {
                    [MBProgressHUD showError:@"获取群信息失败"];
                }];
            }else {
                [MBProgressHUD showError:@"获取群信息失败"];
            }
        }];
    }else {
        [MBProgressHUD showError:@"无效二维码"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.session startRunning];
    if (buttonIndex ==1) {
        if (alertView.tag ==2) {//扫描绑定挪车贴
                [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark --------AVCaptureMetadataOutputObjectsDelegate ---------
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
    
    if (object == nil) return;
    // 只要扫描到结果就会调用
//    self.customLabel.text = object.stringValue;
    if (object.type == AVMetadataObjectTypeFace) {
        return;
    }
    if (!object.stringValue) {
        return;
    }
    NSLog(@"%@",object.stringValue);
    [self.session stopRunning];
    if ([_type isEqualToString:@"1"]) {
        [self scanHttpIsMoveTheCarWithString:object.stringValue];
    }else if([_type isEqualToString:@"2"]){
        [self scanHttpWithString:object.stringValue];
    }else if ([_type isEqualToString:@"3"]) {
        [self scanGroupWithGroupID:object.stringValue];
    }
    // 清除之前的描边
    [self clearLayers];
    
    // 对扫描到的二维码进行描边
    AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];
    
    // 绘制描边
    [self drawLine:obj];
}

- (void)drawLine:(AVMetadataMachineReadableCodeObject *)objc{
    NSArray *array = objc.corners;
    
    // 1.创建形状图层, 用于保存绘制的矩形
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    // 设置线宽
    layer.lineWidth = 2;
    // 设置描边颜色
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.创建UIBezierPath, 绘制矩形
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    int index = 0;
    
    CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[index++]);
    // 把点转换为不可变字典
    // 把字典转换为点，存在point里，成功返回true 其他false
    CGPointMakeWithDictionaryRepresentation(dict, &point);
    
    // 设置起点
    [path moveToPoint:point];
    
    // 2.2连接其它线段
    for (int i = 1; i<array.count; i++) {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)array[i], &point);
        [path addLineToPoint:point];
    }
    // 2.3关闭路径
    [path closePath];
    
    layer.path = path.CGPath;
    // 3.将用于保存矩形的图层添加到界面上
    [self.containerLayer addSublayer:layer];
}


-(void)openLightWay:(UIButton *)sender {
    
    if (![lightDevice hasTorch]) {//判断是否有闪光灯
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前设备没有闪光灯，不能提供手电筒功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [lightDevice lockForConfiguration:nil];
        [lightDevice setTorchMode:AVCaptureTorchModeOn];
        [lightDevice unlockForConfiguration];
    }
    else
    {
        [lightDevice lockForConfiguration:nil];
        [lightDevice setTorchMode: AVCaptureTorchModeOff];
        [lightDevice unlockForConfiguration];
    }
}

//扫描动画
- (void)scanningAnimation {
    if (upOrdown == NO) {
        number ++;
        _imageView.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-115, 130+2*number, 230, 5);
        if (2*number == 280) {
            upOrdown = YES;
        }
    }
    else {
        number --;
        _imageView.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-115, 130+2*number, 230, 5);
        if (number == 0) {
            upOrdown = NO;
        }
    }
}


- (void)clearLayers{
    if (self.containerLayer.sublayers)    {
        for (CALayer *subLayer in self.containerLayer.sublayers){
            [subLayer removeFromSuperlayer];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
