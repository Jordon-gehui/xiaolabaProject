//
//  CallRecordsCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/23.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallOrderModel.h"
@protocol CallRecordsCellDelegate <NSObject>
- (void)callHeaderImgClick:(NSString *)modelid issy:(NSString*)isSY;

@optional
- (void)callBtnClickWithModel:(CallOrderModel *)callModel;

@end
@interface CallRecordsCell : UITableViewCell
@property (nonatomic,weak)id<CallRecordsCellDelegate>delegate;
-(void)setViewData:(id)dic isPlace:(NSInteger)place;
-(void)setViewData:(id)dic issecectCalling:(NSInteger)calling;

+(NSString *)cellReuseIdentifier;
+(NSString *)cellDeatilsIdentifier;
@end
