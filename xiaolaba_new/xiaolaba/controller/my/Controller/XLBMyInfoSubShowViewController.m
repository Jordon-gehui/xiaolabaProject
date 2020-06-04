//
//  XLBMyInfoSubShowViewController.m
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/7.
//  Copyright © 2017年 jxcode. All rights reserved.
//
#import "NetWorking.h"
#import "XLBMeRequestModel.h"
#import "XLBUser.h"
#import "XLBDEvaluateView.h"
#import "TZImagePickerController.h"
#import "XLBUpdateInfoViewController.h"
#import "XLBAlertController.h"
#import "XLBMyInfoSubCell.h"
#import "XLBMyInfoHeaderView.h"
#import "XLBMyInfoShowHeaderView.h"
#import "XLBMyInfoSubShowViewController.h"
#import "XLBSeleDateView.h"
#import "XLBAreaSelectView.h"
@interface XLBMyInfoSubShowViewController ()<ImageReviewViewControllerDelegate,XLBMyInfoHeaderViewDelegate,TZImagePickerControllerDelegate,XLBUpdateInfoViewControllerDelegate,XLBSeleDateViewDelegate,XLBAreaSelectViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meTableTop;

@property (nonatomic, strong) NSMutableArray *settingSource;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, assign) NSInteger currentUserImage;
@property (nonatomic, assign) BOOL isChanged;
@property (nonatomic, assign) BOOL isAddUserImg;
@property (nonatomic, assign) BOOL isChangeHeadImg;
@property (nonatomic, assign) BOOL isChangeMaterial;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isCamera;

@property (nonatomic, assign) NSInteger currentImg;

@property (nonatomic, strong) XLBMyInfoHeaderView *imgView;

@end

@implementation XLBMyInfoSubShowViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];

    [self.meTable reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [XLBUser user].userModel.nickname;
    self.naviBar.slTitleLabel.text = [XLBUser user].userModel.nickname;
    self.meTableTop.constant = self.naviBar.bottom;
    [self setUp];
    [self setupUser:self.editUser];
}

- (void) initNaviBar {
    [super initNaviBar];
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setImage:[UIImage imageNamed:@"save_icon"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightItem];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
}

- (void)setUp {
    
    _isChangeHeadImg = NO;
    _isAddUserImg = NO;
    _isChangeMaterial = NO;
    [self settingSource];
    XLBUser *user = [XLBUser user];
    CGFloat height = 0;
    CGFloat itemWidth = (kSCREEN_WIDTH - 20) / 4;
    CGFloat image_bg_view_height = itemWidth * 2 + 15;
    if (user.userModel.pick.count > 3) {
        height = image_bg_view_height + 40;
    }else{
        height =  itemWidth + 40;
    }
    kWeakSelf(self);
    weakSelf.meTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    weakSelf.imgView = [[XLBMyInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height) user:user];
    weakSelf.imgView.delegate = self;
    weakSelf.meTable.tableHeaderView = self.imgView;
    weakSelf.meTable.separatorColor = [UIColor lineColor];
    NSLog(@"%@",self.editUser.userModel.pick);
}

- (NSMutableArray *)settingSource {
    if(!_settingSource) {
        _settingSource = [[DefaultList initMeInfoList] mutableCopy];
    }
    return _settingSource;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingSource.count - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.settingSource[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }else{
        return 10.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor viewBackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.section == 1) {
            if ([self.sign sizeWithMaxWidth:184.0f*kiphone6_ScreenHeight font:[UIFont systemFontOfSize:15]].height < 44.0f) {
                return 44.0f*kiphone6_ScreenHeight;
            }
            return [self.sign sizeWithMaxWidth:184.0f*kiphone6_ScreenHeight font:[UIFont systemFontOfSize:15]].height;
        }
        return 44.0f*kiphone6_ScreenHeight;
    }
    return 44.0f*kiphone6_ScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    XLBMyInfoSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLBMyInfoSubCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XLBMyInfoSubCell class]) owner:self options:nil].lastObject;
    }
    NSDictionary *data = self.settingSource[indexPath.section][indexPath.row];
    cell.XLBTitle.text = [data objectForKey:@"title"];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.XLBDetailTitle.text = self.nickName;
                    break;
                case 1:
                    cell.XLBDetailTitle.text = self.sex;
                    break;
                case 2:
                    cell.XLBDetailTitle.text = self.birthday;
                    break;
                case 3:
                    cell.XLBDetailTitle.text = self.city;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.XLBDetailTitle.text = self.sign;
            cell.XLBSubTitleHeight.constant = [self.sign sizeWithMaxWidth:184.0f*kiphone6_ScreenHeight font:[UIFont systemFontOfSize:15]].height;
            if (self.sign.length > 16) {
                cell.XLBDetailTitle.textAlignment = NSTextAlignmentLeft;
            }else {
                cell.XLBDetailTitle.textAlignment = NSTextAlignmentRight;
            }
            break;
            
        default:
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    [self updateClick:UpdateTypeNick string:self.nickName];
                }
                    break;
                case 1: {
                    [self sexClick];
                }
                    break;
                case 2: {
                    [self ageClick];
                }
                    break;
                case 3: {
                    [self seletedCity];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0: {
                    [self updateClick:UpdateTypeSign string:self.sign];
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default: {
        }
            break;
    }
}


- (void)addClick:(NSUInteger)max {
//    if(max > 0 && self.imgView) {
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:max delegate:self];
//        imagePickerVc.allowPickingOriginalPhoto = NO;
//        imagePickerVc.allowCrop = YES;
//        kWeakSelf(self);
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            NSMutableArray *array = [NSMutableArray array];
//            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSString *ID = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//                [dict setValue:obj forKey:@"picks"];
//                [dict setValue:@"No" forKey:@"isUser"];
//                [dict setValue:ID forKey:@"id"];
//                [array addObject:dict];
//            }];
//            [self.meTable reloadData];
//            self.isChanged = YES;
//            self.isChangeHeadImg = YES;
//            [weakSelf.imgView insertImages:array];
//        }];
//        [self presentViewController:imagePickerVc animated:YES completion:nil];
//    }
    if (max > 8) return;
    if (max > 0 && self.imgView) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        if (_isCamera == YES) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    kWeakSelf(self);

    NSMutableArray *arrar = [NSMutableArray array];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:image forKey:@"picks"];
    [dict setValue:@"No" forKey:@"isUser"];
    [dict setValue:@"6" forKey:@"id"];
    [arrar addObject:dict];
    [self.meTable reloadData];
    self.isChanged = YES;
    self.isChangeHeadImg = YES;
    if (_isSelect == YES) {
        _isSelect = NO;
        [weakSelf.imgView selectImgWithImgDict:dict index:_currentImg];
    }else {
        _isCamera = NO;
        [weakSelf.imgView insertImages:arrar];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)deleteImgWithIndex:(NSInteger)idex max:(NSUInteger)max{
    UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"拍照",@"从相册重新上传",@"删除"] title:nil message:nil cancel:YES cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        if (index == 0) {
            _isCamera = YES;
            [self addClick:max];
        }else if(index == 1){
            _isSelect = YES;
            _currentImg = idex;
            //max 上传最大数，给固定值是执行修改替换
            [self addClick:7];
        }else {
            self.isChanged = YES;
            self.isChangeHeadImg = YES;
            [self.imgView deleteImageWithIndex:idex];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)delectPictureWithIndex:(NSInteger)idex {
    self.isChanged = YES;
    self.isChangeHeadImg = YES;
    [self.imgView deleteImageWithIndex:idex];
}
- (void)changedImageIndex {
    self.isChangeHeadImg = YES;
    self.isChanged = YES;
}
- (void)updateClick:(UpdateType )type string:(NSString *)string {
    XLBUpdateInfoViewController *update = [[XLBUpdateInfoViewController alloc] initWithType:type string:string];
    update.delegate = self;
    [self.navigationController pushViewController:update animated:YES];
}

- (void)sexClick {
    UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleActionSheet items:@[@"男",@"女"] title:nil message:nil cancel:YES cancelBlock:^{
        
    } itemBlock:^(NSUInteger index) {
        if (index == 0) {
            self.sex = @"男";
        }else {
            self.sex = @"女";
        }
        self.isChanged = YES;
        _isChangeMaterial = YES;

        NSIndexPath *indexPate = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.meTable reloadRowsAtIndexPaths:@[indexPate] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)ageClick {
    XLBSeleDateView *dateView = [[XLBSeleDateView alloc] init];
    dateView.delegate = self;
    dateView.currentDate = self.birthday;
    [dateView show:self.view];
}
- (void)dateSelectView:(XLBSeleDateView *)view didSelectbirthday:(NSString *)birthday {
    self.birthday = birthday;
    self.isChanged = YES;
    _isChangeMaterial = YES;

    NSIndexPath *indexPate = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.meTable reloadRowsAtIndexPaths:@[indexPate] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)seletedCity {
    [self.view endEditing:YES];
    XLBAreaSelectView *areaView = [[XLBAreaSelectView alloc] init];
    areaView.delegate = self;
    [areaView show:self.view];
}

- (void)areaSelectView:(XLBAreaSelectView *)view
         didSelectArea:(NSString *)area
              province:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district {
    

    NSLog(@"%@ %@  %@ %@",area,province,city,district);
    self.address = [NSString stringWithFormat:@"%@,%@,%@",province,city,district];
    self.city = [NSString stringWithFormat:@"%@%@",city,district];
    _isChangeMaterial = YES;
    _isChanged = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.meTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)signClick {
    XLBUpdateInfoViewController *update = [[XLBUpdateInfoViewController alloc] initWithType:UpdateTypeSign string:self.sign];
    [self.navigationController pushViewController:update animated:YES];
}



- (void)updateInfoSuccess:(NSString *)updateInfoString type:(UpdateType)type{
    
    switch (type) {
        case UpdateTypeNick:
            self.nickName = updateInfoString;
            break;
        case UpdateTypeSign:
            self.sign = updateInfoString;
            break;

        default:
            break;
    }
    self.isChanged = YES;
    _isChangeMaterial = YES;
    [self.meTable reloadData];
}



- (void)rightClick {
    if ([self.birthday isEqualToString:@"未填写"]) {
        [MBProgressHUD showError:@"请选择生日"];
    }else {
        [self.imgView saveClick];
    }
}

- (void)saveClick:(NSMutableArray *)saveArray userPictureUrl:(NSString *)userPictureUrl{
    if (!kNotNil(saveArray)) return;
    [saveArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"isUser"] isEqualToString:@"YES"]) {
            [saveArray removeObject:obj];
        }
        [saveArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"isAdd"] isEqualToString:@"YES"]) {
                [saveArray removeObject:obj];
            }
        }];
    }];
    [self uploadUserImages:saveArray userPictureUrl:userPictureUrl];
}

- (void)uploadUserImages:(NSMutableArray *)images userPictureUrl:(NSString *)userPictureUrl{
    if (_isChangeHeadImg == NO && _isAddUserImg == NO && _isChangeMaterial == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        if (_isChangeHeadImg == YES && _isAddUserImg == NO && _isChangeMaterial == NO) {
            //只上传精选图
            [self adddPickWithImgArray:images];
        }
        else if (_isChangeHeadImg == YES && _isAddUserImg == YES && _isChangeMaterial == NO){
            //上传精选图和头像
            [self addPicksWithArrayNotNilWithArray:images userPictureUrl:userPictureUrl];
        }else if(_isChangeHeadImg == NO && _isChangeMaterial == YES){
            //不上传精选图
            [self updateUserInfoWithUserPictureUrl:userPictureUrl];
        }else {
            [self addPicksWithArrayNotNilWithArray:images userPictureUrl:userPictureUrl];
        }
    }


}

- (void)adddPickWithImgArray:(NSMutableArray *)images {
    kWeakSelf(self);
    [weakSelf showHudWithText:@""];
    if (images.count < 1) {
        NSDictionary *dict = @{@"imgs":@[]};
        [XLBMeRequestModel addsPicks:dict error:^(NSString *error) {
            [weakSelf hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
            if ([self.delegate respondsToSelector:@selector(saveSuccessClick)]) {
                [self.delegate saveSuccessClick];
            }
            if (!kNotNil(images)||images.count == 0) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }
        }];
        
    }else {
        NSMutableArray *array = [NSMutableArray array];
        [images enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"picks"] isKindOfClass:[UIImage class]]) {
                UIImage *image = obj[@"picks"];
                [array addObject:image];
            }else {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:obj[@"picks"] Withtype:IMGNormal]]];
                UIImage *image = [UIImage imageWithData:data];
                [array addObject:image];
            }
        }];
        
        [[NetWorking network] asyncUploadImages:array avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
            if (!kNotNil(names)) return;
            NSDictionary *dict = @{@"imgs":names};
            [XLBMeRequestModel addsPicks:dict error:^(NSString *error) {
                NSLog(@"%@",error);
                if (error) {
                    [weakSelf hideHud];
                    [self performSelector:@selector(performClick) withObject:self afterDelay:2];
                }else {
                    
                    
                    NSString *isSex = [self.sex isEqualToString:@"男"] ? @"1" : @"0";
                    if (!kNotNil(self.sign)) {
                        self.sign = @"";
                    }
                    NSDictionary *parameter = @{@"nickname":self.nickName,
                                                @"sex":isSex,
                                                @"birthdate":self.birthday,
                                                @"signature":self.sign,
                                                @"domicile":self.address,
                                                @"img":names[0],};
                    NSLog(@"%@",parameter);
                    [XLBMeRequestModel reviseInfo:parameter error:^(NSString *error) {
                        NSLog(@"保存用户信息%@",error);
                        [weakSelf hideHud];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                        if ([self.delegate respondsToSelector:@selector(saveSuccessClick)]) {
                            [self.delegate saveSuccessClick];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    
                }
            }];
        }];
        
    }
}

- (void)updateUserInfoWithUserPictureUrl:(NSString *)pictureUrl {
    kWeakSelf(self);
    [weakSelf  showHudWithText:@""];
    NSString *isSex = [self.sex isEqualToString:@"男"] ? @"1" : @"0";
    if (!kNotNil(self.sign)) {
        self.sign = @"";
    }
    NSDictionary *parameter = @{@"nickname":self.nickName,
                                @"sex":isSex,
                                @"birthdate":self.birthday,
                                @"signature":self.sign,
                                @"domicile":self.address,
                                @"img":pictureUrl,};
    NSLog(@"%@",parameter);
    [XLBMeRequestModel reviseInfo:parameter error:^(NSString *error) {
        NSLog(@"保存用户信息%@",error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
        if ([self.delegate respondsToSelector:@selector(saveSuccessClick)]) {
            [self.delegate saveSuccessClick];
        }
        [self performSelector:@selector(performClick) withObject:self afterDelay:2];
    }];
    
    [weakSelf hideHud];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPicksWithArrayNotNilWithArray:(NSMutableArray *)images userPictureUrl:(NSString *)userPictureUrl{
    kWeakSelf(self);
    [weakSelf showHudWithText:@""];
    if (images.count == 0 || !kNotNil(images)) {
        NSDictionary *dict = @{@"imgs":@[]};
        [XLBMeRequestModel addsPicks:dict error:^(NSString *error) {
            [weakSelf hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
            if (!kNotNil(self.sign)) {
                self.sign = @"";
            }
            NSString *isSex = [self.sex isEqualToString:@"男"] ? @"1" : @"0";
            NSDictionary *parameter = @{@"nickname":self.nickName,
                                        @"sex":isSex,
                                        @"birthdate":self.birthday,
                                        @"signature":self.sign,
                                        @"domicile":self.address,
                                        @"img":userPictureUrl,};
            NSLog(@" >>>%@",parameter);
            [XLBMeRequestModel reviseInfo:parameter error:^(NSString *error) {
                if ([self.delegate respondsToSelector:@selector(saveSuccessClick)]) {
                    [self.delegate saveSuccessClick];
                }
                if (!kNotNil(images)||images.count == 0) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                }
            }];
            
        }];
        
        
    }else {
        
        NSMutableArray *array = [NSMutableArray array];
        [images enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"picks"] isKindOfClass:[UIImage class]]) {
                UIImage *image = obj[@"picks"];
                [array addObject:image];
            }else {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[JXutils judgeImageheader:obj[@"picks"] Withtype:IMGNormal]]];
                UIImage *image = [UIImage imageWithData:data];
                [array addObject:image];
            }
            
        }];
        [[NetWorking network] asyncUploadImages:array avatar:YES complete:^(NSArray<NSString *> *names, UploadStatus state) {
            if (!kNotNil(names)) return;
            NSDictionary *dict = @{@"imgs":names};
            [XLBMeRequestModel addsPicks:dict error:^(NSString *error) {
                
                NSLog(@"%@",error);
                if (error) {
                    [weakSelf hideHud];
                    [MBProgressHUD showError:@"出错了，请重试"];
                    [self performSelector:@selector(performClick) withObject:self afterDelay:2];
                }else {
                    if (!kNotNil(self.sign)) {
                        self.sign = @"";
                    }
                    NSString *isSex = [self.sex isEqualToString:@"男"] ? @"1" : @"0";
                    NSDictionary *parameter = @{@"nickname":self.nickName,
                                                @"sex":isSex,
                                                @"birthdate":self.birthday,
                                                @"signature":self.sign,
                                                @"domicile":self.address,
                                                @"img":names[0],};
                    NSLog(@" >>>%@",parameter);
                    [XLBMeRequestModel reviseInfo:parameter error:^(NSString *error) {
                        if (kNotNil(error)) {
                            [weakSelf hideHud];
                            [MBProgressHUD showError:@"修改失败"];
                        }else {
                            [weakSelf hideHud];
                            if ([self.delegate respondsToSelector:@selector(saveSuccessClick)]) {
                                [self.delegate saveSuccessClick];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSuccess" object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
        }];
    }
    

}

- (void)performClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backClick:(id)sender {
    if (self.isChanged == YES) {
        kWeakSelf(self);
        UIAlertController *alert = [XLBAlertController alertControllerWith:UIAlertControllerStyleAlert items:@[@"继续编辑",@"放弃"] title:@"放弃对资料的修改" message:nil cancel:NO cancelBlock:^{
            
        } itemBlock:^(NSUInteger index) {
            
            if(index == 0) {
//                [weakSelf rightClick];
            }
            if (index == 1) {
                [weakSelf performClick];
            }
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self performClick];
    }
}


- (void)setupUser:(XLBUser *)user {
    
    self.nickName = user.userModel.nickname;
    self.sex = [user.userModel.sex boolValue] ? @"男":@"女";
    self.address = @"";
    if (kNotNil(user.userModel.domicile)) {
        self.address = user.userModel.domicile;
        if ([user.userModel.domicile containsString:@","]) {
            NSArray *strArr = [user.userModel.domicile componentsSeparatedByString:@","];
            self.city = [NSString stringWithFormat:@"%@%@",strArr[1],strArr[2]];
        }else {
            self.city = user.userModel.domicile;
        }
    }
    self.sign = user.userModel.signature;
    if (!kNotNil(user.userModel.birthdate)) {
        self.birthday = @"未填写";
    }else {
        self.birthday = [ZZCHelper dateStringFromNumberTimer:user.userModel.birthdate type:1];
    }
    [self.meTable reloadData];
}

- (void)changedViewHeight:(CGFloat)height {
    self.meTable.sectionHeaderHeight = height;
    [self.meTable reloadData];
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
