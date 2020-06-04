//
//  MyViewController.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/9.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "MyViewController.h"
#import "XLBMeViewController.h"
#import "XLBMeHeaderView.h"
#import "XLBMeCell.h"
#import "XLBFllowFansViewController.h"
#import "XLBMeRequestModel.h"
//#import "MyInfoShowVC.h"
#import "XLBAlertController.h"
#import "NetWorking.h"
#import "XLBMyFriendsViewController.h"
#import "XLBIdentityViewController.h"
#import "XLBMyInfoShowSubViewController.h"
#import "XLBSystemSettingViewController.h"
@interface MyViewController ()<XLBMeHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *settingSource;
@property (nonatomic, strong) XLBUser *user;
@property (nonatomic, strong) XLBMeHeaderView *headerView;
@end

@implementation MyViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    kWeakSelf(self);
    //    [weakSelf showHudWithText:nil];
    //    if(self.headerView) {
    //        [XLBMeRequestModel requestInfo:^(XLBUser *user) {
    //            [weakSelf hideHud];
    //            [self.headerView updateUser:user];
    //            [self updateList:user];
    //            [weakSelf.meTable reloadData];
    //        } failure:^(NSString *error) {
    //            [MBProgressHUD showError:@"出错了"];
    //
    //        }];
    //    }
    //    else {
    [weakSelf showHudWithText:nil];
    [XLBMeRequestModel requestInfo:^(XLBUser *user) {
        
        
        [weakSelf hideHud];
        weakSelf.user = user;
        BOOL status = [user.userModel.status integerValue] == 30 ? YES:NO;
        weakSelf.headerView = [[XLBMeHeaderView alloc] initWithUser:user complete:status];
        weakSelf.headerView.delegate = weakSelf;
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        weakSelf.tableView.tableFooterView = [UIView new];
        [weakSelf updateList:user];
        
    } failure:^(NSString *error) {
        [weakSelf hideHud];
    }];
    //    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";

    // Do any additional setup after loading the view.
}


- (NSMutableArray *)settingSource {
    if(!_settingSource) {
        _settingSource = [[DefaultList initMeList] mutableCopy];
    }
    return _settingSource;
}

- (void)updateList:(XLBUser *)user {
    
    BOOL status = [user.userModel.status integerValue] == 30 ? YES:NO;
    NSString *phone = user.userModel.phone;
    NSArray <NSArray *>*temp = [NSArray arrayWithArray:self.settingSource];
    [self.settingSource removeAllObjects];
    [temp enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(idx == 0) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray <NSDictionary *>*x = [NSArray arrayWithArray:obj];
            [x enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:obj];
                if(kNotNil([mudic objectForKey:@"title"]) && [[mudic objectForKey:@"title"] isEqualToString:@"账户信息"]) {
                    [mudic setValue:phone forKey:@"subtitle"];
                    [mudic setValue:@"a2a2a2" forKey:@"subtitle_color"];
                }
                else if(kNotNil([obj objectForKey:@"title"]) && [[obj objectForKey:@"title"] isEqualToString:@"身份认证"]) {
                    [mudic setValue:status ? @"已认证":@"未认证" forKey:@"subtitle"];
                    [mudic setValue:status ? @"a7a7a7":@"a7a7a7" forKey:@"subtitle_color"];
                }
                [array addObject:mudic];
            }];
            [self.settingSource addObject:array];
        }
        else {
            [self.settingSource addObject:obj];
        }
    }];
    
    [self.tableView reloadData];
}

- (void)headerViewUpdateInfoClick {
    
    XLBMyInfoShowSubViewController *info = [[XLBMyInfoShowSubViewController alloc] init];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}



/**
 关注
 */
- (void)headerViewFollowClick {
    //    NSLog(@"关注");
    XLBFllowFansViewController *fllow = [[XLBFllowFansViewController alloc] initWith:FllowFansTypeFllow];
    fllow.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fllow animated:YES];
}

/**
 粉丝
 */
- (void)headerViewFollowerClick {
    //    NSLog(@"粉丝");
    XLBFllowFansViewController *fans = [[XLBFllowFansViewController alloc] initWith:FllowFansTypeFans];
    fans.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fans animated:YES];
}

/**
 好友
 */
- (void)headerViewMomentClick {
    //    NSLog(@"动态");
    //    //[[BQLRouter router] push:@"XLBMyFriendsViewController" hideBar:YES];
    XLBMyFriendsViewController *friends = [[XLBMyFriendsViewController alloc] init];
    friends.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friends animated:YES];
}

/**
 修改头像
 */

- (void)headerUserImageUpdateClick {
    [self showSheet];
}

- (void)headerViewCertiClick {
    XLBIdentityViewController *creti = [[XLBIdentityViewController alloc] init];
    creti.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:creti animated:YES];
    //     [[BQLRouter router] push:@"XLBIdentityViewController" hideBar:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.settingSource.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.settingSource[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section == self.settingSource.count - 1) {
        return 0.f;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f*kiphone6_ScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    XLBMeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMeCell class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMeCell class]) owner:self options:nil].lastObject;
    }
    NSDictionary *data = self.settingSource[indexPath.section][indexPath.row];
    NSLog(@"%@",data);
    cell.keyValue = data;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
            
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [[BQLRouter router] push:@"XLBAccountViewController" hideBar:YES];
                }
                    break;
                case 1: {
                    [[BQLRouter router] push:@"XLBIdentityViewController" hideBar:YES];
                }
                    break;
                case 2: {
                    [[BQLRouter router] push:@"XLBMoveRecordsViewController" hideBar:YES];
                }
                    break;
                case 3: {
                    [[BQLRouter router] push:@"XLBMyMoveCardViewController" hideBar:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [[BQLRouter router] push:@"LXBFeedBackListViewController" hideBar:YES];
                }
                    break;
                case 1: {
                    [[BQLRouter router] push:@"XLBSystemSettingViewController" hideBar:YES];
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
    [self uploadUserImages:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadUserImages:(UIImage *)image {
    [MBProgressHUD showMessage:@""];
    [[NetWorking network] asyncUploadImage:image avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
        if (state == UploadStatusSuccess) {
            if (names) {
                NSDictionary *parameter = @{@"nickname":@"",
                                            @"sex":@"",
                                            @"age":@"",
                                            @"city":@"",
                                            @"signature":@"",
                                            @"img":names[0],};
                [XLBMeRequestModel reviseInfo:parameter error:^(NSString *error) {
                    NSLog(@"保存用户信息%@",error);
                    if (kNotNil(error)) {
                        [MBProgressHUD showError:@"出错了，请重试"];
                    }
                    [self viewWillAppear:YES];
                    [MBProgressHUD hideHUD];
                    
                }];
            }
        }
    }];
    
    //    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //    NSDictionary *params = @{@"image":encodedString};
    //    BlockWeakSelf(weakSelf, self);
    //    [self show];
    //    [XLBMeRequestModel identify:params success:^(NSDictionary *result) {
    //
    //        [weakSelf hide];
    //
    //    } failure:^(NSString *error) {
    //
    //        [weakSelf hide];
    //        [weakSelf showMsg:@"出错了，请重试" bottom:YES];
    //    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
