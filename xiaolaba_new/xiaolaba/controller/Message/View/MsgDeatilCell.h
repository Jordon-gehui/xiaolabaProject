//
//  MsgDeatilCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/25.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CellStyle) {
    DefaultCellStyle, /**<默认类型：只有文字的视图*/
    HeaderCellStyle, /**<拓展类型：头视图*/
    SwitchCellStyle, /**<拓展类型：带swicth的视图*/
};
@interface MsgDeatilCell : UITableViewCell
@property (nonatomic,strong)UIView *lineV;
@property (nonatomic,strong)UISwitch *switchV;

-(void)setViewData:(id)dic With:(CellStyle)style;

+ (NSString *)reuseIdentifier;
@end
