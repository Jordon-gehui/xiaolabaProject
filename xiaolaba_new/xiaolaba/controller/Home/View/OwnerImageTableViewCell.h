//
//  OwnerImageTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/14.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *allBtn;
//@property (nonatomic, strong) UIButton *allBigBtn;
@property (nonatomic, copy) NSString *momentsCount;

@property (nonatomic, copy) NSString *momentImg;
@property (nonatomic, assign) BOOL isVoice;
+ (NSString *)cellIdentifie;

@end
