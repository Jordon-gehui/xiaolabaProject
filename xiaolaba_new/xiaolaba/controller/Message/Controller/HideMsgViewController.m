//
//  HideMsgViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/11/7.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "HideMsgViewController.h"
#import "PassWordView.h"
#import <Hyphenate/Hyphenate.h>
#import <IMessageModel.h>
#import <EaseMessageModel.h>
#import <UIImage+Resource.h>
@interface HideMsgViewController ()<PassWordViewDelegate>
{
    FMDatabase *_db;
}
@property (nonatomic,retain)UILabel *tipLbl;
@property (nonatomic,retain)UILabel *tipContentLbl;
@property (nonatomic,retain)PassWordView *passWordView;

@property (nonatomic,retain)UIButton *nextBtn;

@end

@implementation HideMsgViewController

- (void)viewDidLoad {
    self.title = @"输入密码";
    self.naviBar.slTitleLabel.text = @"输入密码";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createDB];
    [self initView];
}
-(void)initNaviBar {
    [super initNaviBar];
    UIButton *rightNav = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightNav setTitle:@"重置" forState:0];
    [rightNav setTitleColor:[UIColor textBlackColor] forState:0];
    rightNav.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightNav addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar setRightItem:rightNav];

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNav];
}
-(void)rightItemClick:(UIButton *)button {
    [self.passWordView initPassWord];
}

-(void)initView {
    UIView *backView = [UIView new];
    backView.backgroundColor = RGB(61, 66, 76);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviBar.mas_bottom);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(85);
    }];
    self.tipLbl = [UILabel new];
    self.tipLbl.textColor = [UIColor whiteColor];
    self.tipLbl.font = [UIFont systemFontOfSize:19];
    NSString *attText = @"输入隐藏聊天记录密码";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:attText];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightColor] range:NSMakeRange(2,6)];
    [text addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(2,6)];
    self.tipLbl.attributedText = text;
    [self.view addSubview:self.tipLbl];
    [self.tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView).with.offset(20);
        make.centerX.mas_equalTo(self.view);
    }];
    self.tipContentLbl = [UILabel new];
    self.tipContentLbl.textColor = [UIColor whiteColor];
    self.tipContentLbl.text = @"密码需谨慎，忘记后无法找回";
    self.tipContentLbl.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.tipContentLbl];
    [self.tipContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLbl.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(self.view);
    }];
    self.passWordView = [PassWordView new];
    [self.passWordView setDelegate:self];
    [self.view addSubview:_passWordView];
    [self.passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_bottom).with.offset(40);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(300*kiphone6_ScreenWidth);
        make.height.mas_equalTo(50*kiphone6_ScreenWidth);
    }];
    self.nextBtn = [UIButton new];
    [self.nextBtn setTitle:@"完成" forState:0];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.backgroundColor = [UIColor lightColor];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passWordView.mas_bottom).with.offset(50);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(50);
    }];
}

- (void)createDB {
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"messageCache_xlb.sqlite"];
    NSLog(@"%@",filename);
    _db = [FMDatabase databaseWithPath:filename];
    if ([_db open]) {
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS messageCache_xlb (key text NOT NULL, startTime text NOT NULL, stopTime text NOT NULL, isRead text NOT NULL, messageID text NOT NULL);"];
        if (result) {
            NSLog(@"成功创表");
            
            
        } else {
            NSLog(@"创表失败");
        }
    }
    
    
    [_db close];
}
-(void)nextBtnClick:(UIButton *)button {
    if ([self.nextBtn.backgroundColor isEqual:[UIColor lineColor]]) {
        return;
    }
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:_model.em_id type:EMConversationTypeChat createIfNotExist:NO];
    [conversation markAllMessagesAsRead:nil];
    NSString *key = [NSString stringWithFormat:@"%@/%@/%@",[XLBUser user].userModel.ID,_model.em_id,self.passWordView.passText];
    NSUserDefaults *userDe = [NSUserDefaults standardUserDefaults];
    [conversation loadMessagesStartFromId:nil count:INT_MAX searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        EMMessage *mess = aMessages[0];
        EMMessage *lastMes = [aMessages lastObject];
        NSNumber *startTime = [NSNumber numberWithLongLong:mess.timestamp];

        if ([userDe objectForKey:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,_model.em_id]] != nil) {

            startTime = [NSNumber numberWithLongLong:[[userDe objectForKey:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,_model.em_id]] longLongValue]+1];
        }
        NSNumber *startNum = [NSNumber numberWithLongLong:lastMes.timestamp];
        [userDe setObject:startNum forKey:[NSString stringWithFormat:@"%@/%@",[XLBUser user].userModel.ID,_model.em_id]];
        [userDe synchronize];

        NSString *stopTime = [NSString stringWithFormat:@"%@",startNum];
        if ([_db open]) {
            NSString *update = [NSString stringWithFormat:@"UPDATE messageCache_xlb SET key= '%@', isRead=0 WHERE isRead=1 and key like '%@/%@%%'",key,[XLBUser user].userModel.ID,_model.em_id];
            BOOL res = [_db executeUpdate:update];
            if (res) {
                NSLog(@"修改成功");
            }else {
                NSLog(@"修改失败");
            }
            
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO messageCache_xlb(key, startTime, stopTime, isRead, messageID) VALUES ('%@', '%@', '%@','%@', '%@')",key,[startTime stringValue],stopTime,@"0",lastMes.messageId];
            BOOL ress = [_db executeUpdate:insert];
            if (ress) {
                NSLog(@"插入成功");
            }else {
                NSLog(@"插入失败");
            }
            NSLog(@"%@  %@",[startTime stringValue],stopTime);
            
            [_db close];
            
            [[[EMClient sharedClient] chatManager] deleteConversation:_em_id isDeleteMessages:NO completion:^(NSString *aConversationId, EMError *aError) {
                if (self.returnBlock) {
                    
                    self.returnBlock(self.passWordView.passText);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
        }
        
    }];
   
}

- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
#pragma mark - PassWordDelegate
-(void) dpBeginInput:(PassWordView *)pass  {
    pass.passText = nil;
    [self.nextBtn setTitleColor:[UIColor textBlackColor] forState:0];
    self.nextBtn.backgroundColor = [UIColor lineColor];
}
-(void) dpFinishedInput:(PassWordView *)pass {
    NSLog(@"%@", pass.passText);
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.nextBtn.backgroundColor = [UIColor lightColor];
}
-(void) passwordDidChanged:(PassWordView *)pass {
    NSLog(@"%@", pass.passText);
    [self.nextBtn setTitleColor:[UIColor textBlackColor] forState:0];
    self.nextBtn.backgroundColor = [UIColor lineColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
