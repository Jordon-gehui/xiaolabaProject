//
//  homeSYRecommendCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/4/25.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol homeSyRecommendCellDelegate <NSObject>

- (void)didSeletedWithuserId:(NSString *)userId :(NSInteger)is_sy;
@end
@interface homeSYRecommendCell : UITableViewCell

@property(nonatomic,weak)id<homeSyRecommendCellDelegate>delegate;
-(void)setViewData:(id)dic :(NSInteger)isSY;

+(NSString *)cellReuseIdentifier;
@end
