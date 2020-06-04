//
//  MusicPlayerView.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/6/1.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "MusicPlayerView.h"
#import "PlayingView.h"

@interface MusicPlayerView()
{
    UIView *bottomView;
    UIView *mlineV;
    UISlider *slider;
    UIButton *patternBtn;
    UIButton *lastBtn;
    UIButton *nextBtn;
    UIButton *addMusicBtn;
    NSArray *musicList;
    NSInteger chooseIndex;
}
@property(nonatomic,strong)UIView *musiccontroller;
@end
@implementation MusicPlayerView
#define viewTag 222
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    self.isplay = YES;
    self.ispatern = YES;
    self.index = 0;
    chooseIndex = self.index;
    self.volume = 0.5;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
//    [self addGestureRecognizer:tap];
    bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 9;
    bottomView.layer.borderWidth = 1;
    bottomView.layer.borderColor = [UIColor lineColor].CGColor;
    bottomView.layer.masksToBounds = YES;
    [self addSubview:bottomView];
    UIImageView *musicImg = [UIImageView new];
    [bottomView addSubview:musicImg];
    musicImg.image = [UIImage imageNamed:@"icon_syth_yy"];
    UILabel *titleL = [UILabel new];
    titleL.text = @"音乐";
    titleL.textColor = [UIColor commonTextColor];
    titleL.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:titleL];
    UIButton *closeBtn = [UIButton new];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeBtn setTitleColor:[UIColor commonTextColor] forState:0];
    [closeBtn setTitle:@"完成" forState:0];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setEnlargeEdge:10];
    [bottomView addSubview:closeBtn];
    mlineV =[UIView new];
    mlineV.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:mlineV];
    
    [musicImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(bottomView).with.offset(15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicImg);
        make.left.mas_equalTo(musicImg.mas_right).with.offset(10);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicImg);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(bottomView).with.offset(-15);
    }];
    [mlineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(musicImg.mas_bottom).with.offset(14);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kSCREEN_WIDTH-15);
        make.height.mas_equalTo(1);
    }];
}
-(void)setList:(NSArray*)array{
    for (int i = 0; i<3; i++) {
        UIView *view = [bottomView viewWithTag:i+viewTag];
        if (view !=nil) {
            [view removeFromSuperview];
        }
    }
    if (array.count>0) {
        musicList = array;
        for (int i = 0; i<array.count; i++) {
            UIView *musicNameV;
            NSDictionary *dic = [array objectAtIndex:i];
            if (chooseIndex >=array.count -1) {
                chooseIndex = 0;
            }
            if (i==chooseIndex) {
                musicNameV = [self addMusicViewWithName:[dic objectForKey:@"label"] withTime:[dic objectForKey:@"description"] withSelect:YES];
            }else{
                musicNameV = [self addMusicViewWithName:[dic objectForKey:@"label"] withTime:[dic objectForKey:@"description"] withSelect:NO];
            }
            musicNameV.tag = i+viewTag;
            [bottomView addSubview:musicNameV];
            if (i ==0) {
                [musicNameV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(mlineV.mas_bottom);
                    make.left.right.mas_equalTo(bottomView);
                    make.height.mas_equalTo(45);
                }];
            }else{
                [musicNameV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(mlineV.mas_bottom).with.offset(i*45);
                    make.left.right.mas_equalTo(bottomView);
                    make.height.mas_equalTo(45);
                }];
            }
            if (i ==array.count-1) {
                if (_musiccontroller ==nil) {
                    [bottomView addSubview:self.musiccontroller];
                }else{
                    [self musiccontroller];
                }
                [self.musiccontroller mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(musicNameV.mas_bottom);
                    make.left.right.mas_equalTo(bottomView);
                    make.height.mas_equalTo(120);
                    make.bottom.mas_equalTo(bottomView).with.offset(-10);
                }];
            }
        }
    }
    
}
-(UIView*)addMusicViewWithName:(NSString *)name withTime:(NSString*)time withSelect:(BOOL)isSelect {
    UIView *musicV = [UIView new];
    UILabel *titleL = [UILabel new];
    titleL.text = name;
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.tag = 1;
    [musicV addSubview:titleL];
    PlayingView *playingView = [[PlayingView alloc]initWithSize:CGSizeMake(20, 15) lineWidth:3 lineColor:[UIColor shadeStartColor]];
    playingView.tag = 2;
    [musicV addSubview:playingView];
//    UIImageView *imgV = [UIImageView new];
//    imgV.image = [UIImage imageNamed:@"icon_syth_yg"];
//    [musicV addSubview:imgV];
    if (isSelect) {
//        [imgV setHidden:NO];
        [playingView setHidden:NO];
        titleL.textColor = [UIColor shadeStartColor];
    }else{
//        [imgV setHidden:YES];
        [playingView setHidden:YES];
        titleL.textColor = [UIColor commonTextColor];
    }
//    imgV.tag = 2;
    UILabel *timeL = [UILabel new];
    timeL.text = time;
    timeL.textColor = [UIColor annotationTextColor];
    timeL.font = [UIFont systemFontOfSize:13];
    [musicV addSubview:timeL];
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor lineColor];
    [musicV addSubview:lineV];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicV);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(kSCREEN_WIDTH-30-100);
    }];
    [playingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicV);
        make.left.mas_equalTo(titleL.mas_right).with.offset(5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(musicV);
        make.right.mas_equalTo(musicV).with.offset(-15);
    }];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(musicV);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(musicV);
        make.height.mas_equalTo(1);
    }];
    return musicV;
}
- (UIView *)musiccontroller {
    if (_musiccontroller==nil) {
        _musiccontroller = [UIView new];
        UIImageView *volumeImg = [UIImageView new];
        volumeImg.image = [UIImage imageNamed:@"icon_syrx_yl"];
        [_musiccontroller addSubview:volumeImg];
        slider = [UISlider new];
        slider.minimumValue = 0;// 设置最小值
        slider.maximumValue = 1;// 设置最大值
        slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
        slider.continuous = YES;// 设置可连续变化
        slider.minimumTrackTintColor = [UIColor blackColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [_musiccontroller addSubview:slider];
        patternBtn = [UIButton new];
        [patternBtn addTarget:self action:@selector(patternBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [patternBtn setImage:[UIImage imageNamed:@"icon_bfms_lb"] forState:0];
        [patternBtn setEnlargeEdge:10];
        [_musiccontroller addSubview:patternBtn];
        
        lastBtn = [UIButton new];
        [lastBtn setImage:[UIImage imageNamed:@"icon_syth_syq"] forState:0];
        [lastBtn setEnlargeEdge:10];
        [lastBtn addTarget:self action:@selector(lastBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_musiccontroller addSubview:lastBtn];
        
        self.playBtn = [UIButton new];
        [self.playBtn setEnlargeEdge:10];
        [self.playBtn setImage:[UIImage imageNamed:@"icon_syth_zt"] forState:0];
        [self.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_musiccontroller addSubview:self.playBtn];
        
        nextBtn = [UIButton new];
        [nextBtn setEnlargeEdge:10];
        [nextBtn setImage:[UIImage imageNamed:@"icon_syth_xyq"] forState:0];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_musiccontroller addSubview:nextBtn];
        
        addMusicBtn = [UIButton new];
        [addMusicBtn setEnlargeEdge:10];
        [addMusicBtn setImage:[UIImage imageNamed:@"icon_syth_tx"] forState:0];
        [addMusicBtn addTarget:self action:@selector(addMusicBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_musiccontroller addSubview:addMusicBtn];
        [volumeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_musiccontroller).with.offset(20);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(18);
        }];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(volumeImg);
            make.left.mas_equalTo(volumeImg.mas_right).with.offset(10);
            make.right.mas_equalTo(_musiccontroller).with.offset(-15);
            make.height.mas_equalTo(20);
        }];
        [patternBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(volumeImg.mas_bottom).with.offset(30);
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(20);
        }];
        [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(patternBtn);
            make.centerX.mas_equalTo(_musiccontroller).with.offset(-60);
            make.width.height.mas_equalTo(20);
        }];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(patternBtn);
            make.centerX.mas_equalTo(_musiccontroller);
            make.width.height.mas_equalTo(25);
        }];
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(patternBtn);
            make.centerX.mas_equalTo(_musiccontroller).with.offset(60);
            make.width.height.mas_equalTo(20);
        }];
        [addMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(patternBtn);
            make.right.mas_equalTo(-20);
            make.width.height.mas_equalTo(20);
        }];
        
    }
    slider.value = self.volume;// 设置初始值
    if (self.isplay) {
        [self.playBtn setImage:[UIImage imageNamed:@"icon_syth_zt"] forState:0];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"icon_syth_bf"] forState:0];
    }
    if (self.ispatern) {
        [patternBtn setImage:[UIImage imageNamed:@"icon_bfms_lb"] forState:0];
    }else{
        [patternBtn setImage:[UIImage imageNamed:@"icon_bfms_xh"] forState:0];
    }

    return _musiccontroller;
}
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.volume = slider.value;
    [self.delegate setMusicVolume:self volume:slider.value];
}
-(void)patternBtnClick{
    if (self.ispatern) {
        [patternBtn setImage:[UIImage imageNamed:@"icon_bfms_xh"] forState:0];
        self.ispatern = NO;
    }else{
        [patternBtn setImage:[UIImage imageNamed:@"icon_bfms_lb"] forState:0];
        self.ispatern = YES;
    }
    [self.delegate patternMusic:self pattern:self.ispatern];

}
-(void)lastBtnClick{
    if (chooseIndex>0) {
        chooseIndex-=1;
    }else{
        chooseIndex = musicList.count-1;
    }
    [self setSelect];
    [self.delegate nextMusic:self index:chooseIndex];
}
-(void)playBtnClick{
    if (self.isplay) {
        self.isplay = NO;
    }else{
        self.isplay = YES;
    }
    
    [self.delegate isPlayMusic:self isPlay:self.isplay];
}
-(void)nextBtnClick{
    if (chooseIndex<musicList.count-1) {
        chooseIndex+=1;
    }else{
        chooseIndex = 0;
    }
    [self setSelect];
    [self.delegate nextMusic:self index:chooseIndex];

}
-(void)addMusicBtnClick{ //更换和添加背景音
    [self.delegate addMusic:self];
}

- (void)showView {
    CGFloat height = 0;
    if (musicList.count>0) {
        height =45*musicList.count;
    }
    bottomView.frame = CGRectMake(1, kSCREEN_HEIGHT, kSCREEN_WIDTH-2, 160+height);
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(1, kSCREEN_HEIGHT-160-height, kSCREEN_WIDTH-2, 160+height);
    }];
}
-(void)setSelect{
    for (int i = 0; i<musicList.count; i++) {
        UIView *select =[bottomView viewWithTag:i+viewTag];
        PlayingView *playing = [select viewWithTag:2];
        UILabel *titleL = [select viewWithTag:1];
        if (i ==chooseIndex) {
            [playing setHidden:NO];
            titleL.textColor = [UIColor shadeStartColor];
            
        }else{
            [playing setHidden:YES];
            titleL.textColor = [UIColor commonTextColor];
            
        }
    }
}
-(void)setIndex:(NSInteger)index {
    _index = index;
    chooseIndex = index;
}
- (void)closeView {
    CGFloat height = 0;
    if (musicList.count>0) {
        height =45*musicList.count;
    }
    [self.delegate closeMusic:self];
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(1, kSCREEN_HEIGHT, kSCREEN_WIDTH-2, 160+height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
@end
