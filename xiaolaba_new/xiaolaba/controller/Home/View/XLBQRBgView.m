//
//  XLBQRBgView.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "XLBQRBgView.h"

@interface XLBQRBgView ()

@property (nonatomic, strong)UIImageView *qrBgImage;
@property (nonatomic, strong)UIImageView *qrImage;
@property (nonatomic, strong)UILabel *numberLabel;

@end


@implementation XLBQRBgView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setSubViews];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setNubmer:(NSString *)nubmer {
    self.numberLabel.text = [NSString stringWithFormat:@"No.%@",nubmer];
    _nubmer = nubmer;
}

- (void)setUrl:(NSString *)url {
    NSLog(@"%@",url);
    self.qrImage.image = [self QRCodeInvitationWithQRCodeContent:self.url];
    _url = url;
}
- (void)setSubViews {
    
    self.qrImage = [UIImageView new];
    
    [self addSubview:self.qrImage];
    self.qrBgImage = [UIImageView new];
    
    [self addSubview:self.qrBgImage];
    
    
    
    
    self.numberLabel = [UILabel new];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor = [UIColor grayColor];
    [self addSubview:self.numberLabel];
}


- (UIImage *)QRCodeInvitationWithQRCodeContent:(NSString *)content{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",content];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImages = [filter outputImage];
    //    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    //    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    //    UIGraphicsBeginImageContext(qrUIImage.size);
    //
    //    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    //
    //    UIImage *sImage = [UIImage imageNamed:@"logo"];
    //    CGFloat sImageW = 150;
    //    CGFloat sImageH= sImageW;
    //    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    //    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    //    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    //    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    self.QRImage.image = finalyImage;
     return [self createNonInterpolatedUIImageFormCIImage:qrImages withSize:150];
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

- (void)layoutSubviews {
    kWeakSelf(self);
    
    [weakSelf.qrBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [weakSelf.qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.bottom.right.mas_equalTo(-20);
    }];
    
    [weakSelf.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.qrImage.mas_bottom).mas_offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
}


@end
