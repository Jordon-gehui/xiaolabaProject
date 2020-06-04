//
//  XLBMyMoveCardViewController.m
//  xiaolaba
//
//  Created by lin on 2017/7/21.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "XLBMyMoveCardViewController.h"
#import "XLBMyMoveCardCell.h"
#import "ScanViewController.h"
#import "XLBCarDetailModel.h"
#import "XLBMeRequestModel.h"
#import "XLBMeCarQRCodeTableViewCell.h"
#import "XLBMeCarGainCell.h"
#import "XLBAlertController.h"
#import "XLBAddressTool.h"
@interface XLBMyMoveCardViewController () <UITableViewDelegate,UITableViewDataSource,XLBMeCarQRCodeTableViewCellDelegate>

@property (nonatomic, strong) UIImage *qrImg;
@property (nonatomic, strong)NSMutableArray *carData;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *card;
@property (nonatomic, strong) NSMutableArray *friendsData;

@end

@implementation XLBMyMoveCardViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.slTitleLabel.text = @"我的挪车贴";
    [MobClick event:@"Me_MoveCarTie"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusClick) name:@"statusClick" object:nil];
    _qrImg = [UIImage new];
    
    [self meCarRequst];
    
    [self setSubView];
}

- (void)meCarRequst {
    NSDictionary *params = @{@"page":@{@"curr":@(0),
                                       @"size":@(3)}};
    [XLBMeRequestModel requsetInviteFriendsParams:params success:^(NSArray<XLBInviteModel *> *models) {
        [self.friendsData addObjectsFromArray:models];
    } failure:^(NSString *error) {
        NSLog(@"%@",error);
    } more:^(BOOL more) {
    }];
    
    [[NetWorking network] POST:KQRCarImg params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            [self QRCodeInvitationWithQRCodeContent:result[@"url"]];
            self.card = [NSString stringWithFormat:@"%@",result[@"no"]];
        }else{
            self.qrImg = [UIImage imageNamed:@"kongkong"];
            self.card = @"";
        }
        
    } failure:^(NSString *description) {
        self.qrImg = [UIImage imageNamed:@"homenor"];
    }];
    
    [[NetWorking network] POST:kMeCar params:nil cache:NO success:^(id result) {
        if (kNotNil(result)) {
            if (kNotNil([result objectForKey:@"status"]) && kNotNil([result objectForKey:@"List"])) {
                self.status = [result objectForKey:@"status"];
                self.carData = [XLBMeCarQRCodeModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"List"]];
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSString *description) {
        
    }];
        
}

- (void)setSubView {
    self.isGrouped = YES;
    self.tableView.rowHeight = 110;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = [UIView new];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.data addObjectsFromArray:[DefaultList initMoveCarControllerList]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 55;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)statusClick {
    self.status = @"0";
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.carData.count;
    }else if (section == 2) {
        return 2;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    [header addSubview:label];
    
    if (section == 0 && self.carData.count != 0 && self.carData.count < 3) {
        UIButton *addBtn = [[UIButton alloc] init];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_bdnct"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(boundMoveCarCard:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:addBtn];
        
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.width.height.mas_equalTo(19);
            if (section == 0) {
                make.centerY.mas_equalTo(5);
            }else {
                make.centerY.mas_equalTo(0);
            }
            
        }];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (section == 0) {
            make.centerY.mas_equalTo(5);
        }else {
            make.centerY.mas_equalTo(0);
        }
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    label.textColor = [UIColor commonTextColor];
    label.font = [UIFont systemFontOfSize:17];
    NSDictionary *dic = self.data[section];
    label.text = dic[@"header"];
    return header;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 && self.carData.count == 0) {
        UIView *views = [[UIView alloc] init];
        views.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgImg = [UIImageView new];
        bgImg.image = [UIImage imageNamed:@"pic_bdnct"];
        [views addSubview:bgImg];

        UIButton *addBtn = [[UIButton alloc]init];
        [addBtn setImage:[UIImage imageNamed:@"icon_bdnct"] forState:UIControlStateNormal];
        [addBtn setTitle:@" 绑定挪车贴" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
//        addBtn.layer.masksToBounds = YES;
//        addBtn.layer.cornerRadius = 5;
//        addBtn.backgroundColor = [UIColor whiteColor];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [addBtn addTarget:self action:@selector(boundMoveCarCard:) forControlEvents:UIControlEventTouchUpInside];
        [views addSubview:addBtn];
        
//        UIView *lineV = [UIView new];
//
//        lineV.backgroundColor = [UIColor viewBackColor];
//        [views addSubview:lineV];
        
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(90);
            make.center.mas_equalTo(0);
        }];
        
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(bgImg.mas_width).with.offset(0);
            make.height.mas_equalTo(bgImg.mas_height).with.offset(0);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
//
//        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(10);
//            make.width.mas_equalTo(kSCREEN_WIDTH);
//            make.bottom.mas_equalTo(views.mas_bottom);
//        }];
        return views;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0.001;
    }else if (section == 0) {
        return 45;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 && self.carData.count == 0) {
        return 100;
    }
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    if (indexPath.section == 1) {
        XLBMeCarQRCodeTableViewCell *qrCell = [tableView dequeueReusableCellWithIdentifier:[XLBMeCarQRCodeTableViewCell cellMeCarQrCodeID]];
        if (!qrCell) {
            qrCell = [[XLBMeCarQRCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XLBMeCarQRCodeTableViewCell cellMeCarQrCodeID]];
        }
        qrCell.selectionStyle = UITableViewCellSelectionStyleNone;
        qrCell.item = self.carData[indexPath.row];
        qrCell.cellIndex = indexPath.row;
        qrCell.delegate = self;
        return qrCell;
    }else if (indexPath.section == 0){
        XLBMyMoveCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMyMoveCardCell class])];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMyMoveCardCell class]) owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *index = [NSString stringWithFormat:@"%li",indexPath.section];
        if (kNotNil(self.qrImg) && kNotNil(self.card)) {
            NSDictionary *dict = @{@"index":index,@"qrImg":self.qrImg,@"card":self.card,};
            cell.model = dict;
        }
        return cell;

    }else {
        XLBMeCarGainCell *qrCell = [tableView dequeueReusableCellWithIdentifier:[XLBMeCarGainCell carGainCellID]];
        if (!qrCell) {
            qrCell = [[XLBMeCarGainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XLBMeCarGainCell carGainCellID]];
        }
        qrCell.selectionStyle = UITableViewCellSelectionStyleNone;
        qrCell.cellIndex = indexPath.row;
        return qrCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            [[CSRouter share]push:@"XLBUpdateCarImageViewController" Params:nil hideBar:YES];
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    if ([self.status isEqualToString:@"-1"]) {
                        [[CSRouter share]push:@"BuyCarAllowanceViewController" Params:@{@"data":self.friendsData} hideBar:YES];
                    }else {
                        [self showAlert];
                    }
                }
                break;
                case 1: {
                    [MobClick event:@"Buy_CarTie"];
                    [[CSRouter share]push:@"PayCheTieViewController" Params:@{@"type":@"2"} hideBar:YES];
                }
                break;
                
                default:
                break;
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)deleteMoveCarCardWith:(XLBMeCarQRCodeTableViewCell *)deleCell index:(NSString *)index encrypt:(NSString *)encrypt{
    if (!kNotNil(index)) return;
    [self.carData removeObjectAtIndex:[index integerValue]];
    [self.tableView reloadData];
}


- (void)showAlert {
    NSString *alertString = @"你已申请挪车贴，不能再次申请，关注公众号“小喇叭挪车”，更多精美挪车贴等你来取~";

    UIAlertController *alertController = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"确定"] title:nil message:alertString cancel:NO cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        
    }];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, alertString.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, alertString.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)boundMoveCarCard:(UIButton *)boundBtn {
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.type = @"1";
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)QRCodeInvitationWithQRCodeContent:(NSString *)content{
    NSString *urlString = [NSString stringWithFormat:@"%@",content];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImages = [filter outputImage];
    self.qrImg = [self createNonInterpolatedUIImageFormCIImage:qrImages withSize:75];
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
- (NSMutableArray *)friendsData {
    if (!_friendsData) {
        _friendsData = [NSMutableArray array];
    }
    return _friendsData;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"statusClick" object:nil];
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
