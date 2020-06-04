//
//  PraiseTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickSubLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImg;

@property (weak, nonatomic) IBOutlet UIButton *userBtn;


@property (nonatomic, strong) XLBFllowFansModel *fansModel;

@property (nonatomic, strong) PraiseModel *praiseModel;

@end
