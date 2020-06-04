//
//  MusicPlayerView.h
//  xiaolaba
//
//  Created by 斯陈 on 2018/6/1.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicPlayerView;
@protocol MusicPlayerViewDelegate <NSObject>
- (void)lastMusic:(MusicPlayerView*)musicView index:(NSInteger)index;
- (void)nextMusic:(MusicPlayerView*)musicView index:(NSInteger)index;
- (void)setMusicVolume:(MusicPlayerView*)musicView volume:(CGFloat)volume;//音量
- (void)patternMusic:(MusicPlayerView*)musicView pattern:(BOOL)isPattern;//播放模式
- (void)isPlayMusic:(MusicPlayerView *)musicView isPlay:(BOOL)isPlay;//是否播放
- (void)addMusic:(MusicPlayerView*)musicView;//添加音乐
- (void)closeMusic:(MusicPlayerView*)musicView;//隐藏试图

@end
@interface MusicPlayerView : UIView
@property (nonatomic,strong)UIButton *playBtn;

@property (nonatomic,assign)CGFloat volume;
@property (nonatomic,assign)BOOL isplay;
@property (nonatomic,assign)BOOL ispatern;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic, weak) id<MusicPlayerViewDelegate>delegate;


- (void)setList:(NSArray*)array;
-(void)setSelect;
- (void)showView;
- (void)closeView;
@end
