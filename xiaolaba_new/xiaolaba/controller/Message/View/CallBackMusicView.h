//
//  CallBackMusicView.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/5/31.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallBackMusicView;
@protocol CallBackMusicViewDelegate <NSObject>
- (void)addCallBackMusic:(CallBackMusicView*)musicView;//添加音乐
@end

@interface CallBackMusicView : UIView
@property(nonatomic,strong)NSArray *musicList;
@property(nonatomic,strong)NSMutableArray *choseDataList;
@property (nonatomic, weak) id<CallBackMusicViewDelegate>delegate;

-(void)showView;
@end
