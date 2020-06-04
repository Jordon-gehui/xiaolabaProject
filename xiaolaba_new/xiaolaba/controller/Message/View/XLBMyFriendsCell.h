//
//  XLBMyFriendsCell.h
//  xiaolaba
//
//  Created by lin on 2017/7/26.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CellLongTapRetrunBlock)(BOOL isDel);
typedef void (^CellTapRetrunBlock)(BOOL isDel);


@interface XLBMyFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (nonatomic, copy)CellLongTapRetrunBlock cellLongTapRetrunBlock;
@property (nonatomic, copy)CellTapRetrunBlock cellTapRetrunBlock;


@end
