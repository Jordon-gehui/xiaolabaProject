//
//  LionChooseView.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LionChooseView;

@protocol SionChooseDelegate <NSObject>

@optional
- (void)allBu:(LionChooseView*)allBu ;//批量管理
- (void)fujinproBu:(LionChooseView*)fujinproBu ;//创建任务


@end




@interface LionChooseView : UIView
@property (nonatomic, strong) UIView   *bgView;

@property (nonatomic, strong) UITableView   *bgTabView;


@property (strong ,nonatomic) UIButton *allBu;//
@property (strong ,nonatomic) UIButton *fujinProBu;//附近的人
@property(nonatomic,weak)  id<SionChooseDelegate> delegate;


- (void)show;

- (void)close;

@end
