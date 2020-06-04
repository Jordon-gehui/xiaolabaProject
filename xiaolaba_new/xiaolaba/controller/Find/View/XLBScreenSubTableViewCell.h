//
//  XLBScreenSubTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/18.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLBScreenSubTableViewCellDelegate <NSObject>

- (void)didSeletedSexWith:(NSString *)sex;

@end

@interface XLBScreenSubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sexLbael;

@property (weak, nonatomic) IBOutlet UIButton *notBtn;

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@property (nonatomic, copy) NSString *sex;

@property (weak, nonatomic) id <XLBScreenSubTableViewCellDelegate>delegate;

@end
