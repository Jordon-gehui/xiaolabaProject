//
//  MsgDeatilViewController.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "BaseTablePage.h"

typedef void (^RetrunDelAllBlock)(BOOL isDel);
typedef void (^RetrunBlackListBlock)(BOOL isBlack);
@interface MsgDeatilViewController : BaseTablePage

@property (nonatomic,assign)BOOL isBlack;
@property (nonatomic,assign)NSInteger isFriend;
@property (nonatomic,copy)NSDictionary *userDic;
@property (nonatomic, copy)RetrunDelAllBlock retrunDelAllBlock;
@property (nonatomic, copy)RetrunBlackListBlock retrunBlackListBlock;


@end
