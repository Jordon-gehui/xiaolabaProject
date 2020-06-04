//
//  XLBMeCarQRCodeTableViewCell.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/15.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBCarDetailModel.h"
@class XLBMeCarQRCodeTableViewCell;

@protocol XLBMeCarQRCodeTableViewCellDelegate <NSObject>

@optional

- (void)deleteMoveCarCardWith:(XLBMeCarQRCodeTableViewCell *)deleCell index:(NSString *)index encrypt:(NSString *)encrypt;
@end

@interface XLBMeCarQRCodeTableViewCell : UITableViewCell<UIActionSheetDelegate>

@property(nonatomic, strong)XLBMeCarQRCodeModel *item;

+ (NSString *)cellMeCarQrCodeID;


@property (nonatomic, strong) UILabel *status;

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, weak) id<XLBMeCarQRCodeTableViewCellDelegate>delegate;
@end
