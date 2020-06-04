//
//  XLBUpdateInfoViewController.h
//  xiaolaba
//
//  Created by lin on 2017/7/24.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, UpdateType) {
    
    UpdateTypeSign = 0, // 个性签名
    UpdateTypeNick,     // 昵称
    UpdateTypeGroupNickName,      // 群组昵称
    UpdateTypeGroupAnnounct,//群组公告
    UpdateTypeMeGroupNickName,//我的群昵称
    UpdateTypeGroupImg,//群头像
};

@protocol XLBUpdateInfoViewControllerDelegate;
@interface XLBUpdateInfoViewController : BaseViewController

- (instancetype)initWithType:(UpdateType )type string:(NSString *)string;
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *groupNickName;
@property (nonatomic, copy) NSString *groupMeNickName;
@property (nonatomic, copy) NSString *groupAnnounct;


@end

@protocol XLBUpdateInfoViewControllerDelegate <NSObject>

- (void)updateInfoSuccess:(NSString *)updateInfoString type:(UpdateType )type;

@end
