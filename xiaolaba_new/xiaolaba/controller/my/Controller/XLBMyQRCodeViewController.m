//
//  XLBMyQRCodeViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/27.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyQRCodeViewController.h"
#import <UIImageView+WebCache.h>
#import "XLBMeRequestModel.h"
#import <AFNetworking.h>
@interface XLBMyQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@end

@implementation XLBMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"打印挪车卡";
    [self setup];
}

- (void)setup {
    
    // 测试图片

    [[NetWorking network] POST:KQRCarImg params:nil cache:NO success:^(id result) {
        NSLog(@"%@",result);
        
        
    } failure:^(NSString *description) {
        NSLog(@"%@",description);
        
    }];
    
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:@""]] placeholderImage:nil];
    
    [self.downButton setBackgroundImage:[UIImage imageNamed:@"anjian"] forState:UIControlStateNormal];
    NSString *string = @"使用说明：\n用户可点击下方按钮下载车贴保存至手机相册，然后自行打印放置于车内即可";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    // Adjust the spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.f;
    paragraphStyle.alignment = self.hintLabel.textAlignment;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(34, 180, 153) range:NSMakeRange(0, 5)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(152, 152, 152) range:NSMakeRange(5, string.length - 5)];
    self.hintLabel.attributedText = attributedString;
}

- (IBAction)downClick:(id)sender {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinshSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinshSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        //保存失败
    }else {
        //保存成功
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
