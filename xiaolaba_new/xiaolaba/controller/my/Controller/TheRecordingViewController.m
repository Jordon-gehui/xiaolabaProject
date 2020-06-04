//
//  TheRecordingViewController.m
//  xiaolaba
//
//  Created by 斯陈 on 2018/3/13.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import "TheRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DrawCyclesView.h"
#import "MakingTheCertificationViewController.h"
//#import "lame.h"

@interface TheRecordingViewController ()
{
    UILabel *timeLbl;
    
    NSInteger countDown;
    NSString *videoTime;
    
    NSString *filePath;
    UIButton*recordButton;
    UILabel *recordLbl;
    UIButton*playButton;
    UILabel *playLbl;
    UILabel *tipLbl;
    UILabel *stausLbl;
    UILabel *contentLbl;
    UIButton *afreshBtn;
    UILabel *afreshLbl;
    UIButton *verifyBtn;
    UILabel *verifyLbl;

    AVPlayerItem * songItem;
    AVPlayer *player;
    DrawCyclesView *cView;
}
@property(nonatomic ,strong)AVAudioPlayer *avPlayer;

@property (nonatomic, weak) NSTimer *timer;

@property(nonatomic ,strong) AVAudioRecorder *recorder;
@property(nonatomic ,strong) AVAudioSession *session;

@end


@implementation TheRecordingViewController
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [player pause];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"声音认证";
    self.naviBar.slTitleLabel.text = @"声音认证";
    self.view.backgroundColor = [UIColor whiteColor];
    cView =[[DrawCyclesView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH - 170)/2, self.naviBar.bottom+60, 170, 170)];
    cView.tag = 1;
    cView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cView];
    
    timeLbl= [UILabel new];
    timeLbl.font = [UIFont systemFontOfSize:40];
    timeLbl.textColor = [UIColor textBlackColor];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.numberOfLines = 0;
    timeLbl.text = @"00";
    [self.view addSubview:timeLbl];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cView).with.offset(-5);
        make.centerX.mas_equalTo(cView);
    }];
    UILabel *timeTipLbl = [UILabel new];
    timeTipLbl.font = [UIFont systemFontOfSize:12];
    timeTipLbl.textColor = [UIColor textRightColor];
    timeTipLbl.text = @"录制时长限制5s-60s";
    [self.view addSubview:timeTipLbl];
    [timeTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLbl.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(cView);
    }];
    
    playButton = [UIButton new];
    [playButton setHidden:YES];
    [playButton setImage:[UIImage imageNamed:@"btn_st_h"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    playLbl = [UILabel new];
    playLbl.font = [UIFont systemFontOfSize:15];
    playLbl.text = @"试听";
    playLbl.textColor = [UIColor textBlackColor];
    [self.view addSubview:playLbl];
    
    tipLbl= [UILabel new];
    tipLbl.font = [UIFont systemFontOfSize:14];
    tipLbl.textColor = [UIColor textRightColor];
    tipLbl.numberOfLines = 0;
    if ([[[XLBUser user].userModel.ID stringValue] isEqualToString:@"42327218134736896"] || [[[XLBUser user].userModel.ID stringValue] isEqualToString:@"22099512457715712"]) {
        tipLbl.text = @"1.录制一段简单的自我介绍或者充分展示声音魅力的文字，5s<时长<30s\n2.音质保持清晰，不清晰的声音将无法通过审核";
    }else {
        tipLbl.text = @"1.录制一段简单的自我介绍或者充分展示声音魅力的文字，5s<时长<30s\n2.音质保持清晰，不清晰的声音将无法通过审核\n3.认证通过后，请设置自己的收费标准以及服务时间等";
    }
    [self.view addSubview:tipLbl];

    contentLbl= [UILabel new];
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.textColor = [UIColor textRightColor];
    contentLbl.textAlignment = NSTextAlignmentCenter;
    contentLbl.numberOfLines = 0;
    [contentLbl setHidden:YES];
    contentLbl.text = @"声优认证的录音会出现在首页声优列表和我的主页里\n请一定要把最动听的声音展示给大家";
    [self.view addSubview:contentLbl];
    
    recordButton = [UIButton new];
    [recordButton setImage:[UIImage imageNamed:@"btn_lz_h"] forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [recordButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordDragOutside:) forControlEvents:UIControlEventTouchDragExit];
    [recordButton addTarget:self action:@selector(recordDragInside:) forControlEvents:UIControlEventTouchDragEnter];
    [self.view addSubview:recordButton];
    recordLbl = [UILabel new];
    recordLbl.font = [UIFont systemFontOfSize:15];
    recordLbl.text = @"开始录制";
    recordLbl.textColor = [UIColor textBlackColor];
    [self.view addSubview:recordLbl];
    
    afreshBtn = [UIButton new];
    [afreshBtn setImage:[UIImage imageNamed:@"btn_cl_h"] forState:UIControlStateNormal];
    [afreshBtn addTarget:self action:@selector(afreshClick:) forControlEvents:UIControlEventTouchUpInside];
    [afreshBtn setHidden:YES];
    [self.view addSubview:afreshBtn];
    
    afreshLbl = [UILabel new];
    afreshLbl.font = [UIFont systemFontOfSize:13];
    afreshLbl.text = @"重录";
    afreshLbl.textColor = [UIColor textBlackColor];
    [self.view addSubview:afreshLbl];
    
    verifyBtn = [UIButton new];
    [verifyBtn setImage:[UIImage imageNamed:@"btn_sc_h"] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [verifyBtn setHidden:YES];
    [self.view addSubview:verifyBtn];
    verifyLbl = [UILabel new];
    verifyLbl.font = [UIFont systemFontOfSize:13];
    verifyLbl.text = @"上传";
    verifyLbl.textColor = [UIColor textBlackColor];
    [self.view addSubview:verifyLbl];
    [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view).with.offset(-15);
    }];
    [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLbl.mas_top).with.offset(-50);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(87);
    }];
    [recordLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(recordButton);
        make.top.mas_equalTo(recordButton.mas_bottom).with.offset(2);
    }];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLbl.mas_top).with.offset(-50);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(70);
    }];
    [playLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(playButton);
        make.top.mas_equalTo(playButton.mas_bottom).with.offset(2);
    }];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view).with.offset(-15);
    }];
    [afreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(playButton);
        make.left.mas_equalTo(50);
        make.width.height.mas_equalTo(50);
    }];
    [afreshLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(afreshBtn);
        make.top.mas_equalTo(afreshBtn.mas_bottom).with.offset(2);
    }];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(playButton);
        make.right.mas_equalTo(-50);
        make.width.height.mas_equalTo(50);
    }];
    [verifyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(verifyBtn);
        make.top.mas_equalTo(verifyBtn.mas_bottom).with.offset(2);
    }];
    [self getAVCapture];
    [cView startBtnAction];
    [cView pauseAnimation];
    if (kNotNil([XLBUser user].voiceAkira)) {
        [self isShowRecording:1];
    }else{
        [self isShowRecording:0];
    }
//    [self createRecord];
    // Do any additional setup after loading the view.
}

-(void)getAVCapture{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}
-(void)isShowRecording:(NSInteger)isShow{
    if (isShow == 1) {
        [contentLbl setHidden:NO];
        [stausLbl setHidden:NO];
        [tipLbl setHidden:YES];
        [recordButton setHidden:YES];
        [recordLbl setHidden:YES];
        [afreshBtn setHidden:NO];
        [afreshLbl setHidden:NO];
        [verifyBtn setHidden:NO];
        [verifyLbl setHidden:NO];
        [playButton setHidden:NO];
        [playLbl setHidden:NO];
    }else{
        [stausLbl setHidden:YES];
        [tipLbl setHidden:NO];
        [contentLbl setHidden:YES];
        [recordButton setHidden:NO];
        [recordLbl setHidden:NO];
        [playButton setHidden:YES];
        [playLbl setHidden:YES];
        [verifyBtn setHidden:YES];
        [verifyLbl setHidden:YES];
        [afreshBtn setHidden:YES];
        [afreshLbl setHidden:YES];
    }
}
-(void)afreshClick:(UIButton*)sender {
    [self isShowRecording:0];
    timeLbl.text = [NSString stringWithFormat:@"00"];
    [cView pauseAnimation];
    [self.timer invalidate];
    [player pause];
    _timer = nil;
}

-(void)verifyClick:(UIButton*)sender {
    if (filePath ==nil) {
        [MBProgressHUD showError:@"请先进行录音"];
        return;
    }
    [self showHudWithText:nil];
    kWeakSelf(self);
    [[NetWorking network] asyncUploadTheRecording:filePath complete:^(NSString *name, UploadStatus state) {
        NSLog(@"llllllll %li== %@",state,name);
        [weakSelf uploadVoiceName:name];
    }];
}

-(void)uploadVoiceName:(NSString*)name{
    [[NetWorking network] POST:kCertificationVoice params:@{@"voiceAkira":name,@"voiceTime":videoTime} cache:NO success:^(id result) {
        [self hideHud];
        [XLBUser user].voiceStatus = @"1";
        [XLBUser user].voiceAkira = name;
        if ([self.isPushTo isEqualToString:@"3"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else  {
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            if ([self.isPushTo isEqualToString:@"2"]){
                [array removeLastObject];
            }
            MakingTheCertificationViewController *vc=[[MakingTheCertificationViewController alloc]init];
            vc.hidesBottomBarWhenPushed =YES;
            array[array.count-1] =vc;
            [self.navigationController setViewControllers:array animated:YES];
        }
    } failure:^(NSString *description) {
        [self hideHud];
        [MBProgressHUD showError:@"上传失败"];
    }];
}

- (void)beginRecording{
    NSLog(@"开始录音");
    [self addTimer];
  
    [cView resumeAnimation];
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    //2.获取文件路径
    NSURL *recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 11025],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self stopRecord:nil];
        });
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
}

-(void)addTimer{
    countDown = 30;
    if (!_timer) {
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
}

-(void)updateTime{
    countDown --;
    timeLbl.text = [NSString stringWithFormat:@"%02ld",30-countDown];
    if (countDown==0) {
        [self.timer invalidate];
        _timer = nil;
        [self isShowRecording:1];
        [self stopRecord:nil];
        self.navigationController.interactivePopGestureRecognizer.enabled =NO;
    }
}

- (void)recordButtonTouchDown:(UIButton*)sender {
    [sender setImage:[UIImage imageNamed:@"btn_zt_h"] forState:0];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self beginRecording];
}

// 手指在录音按钮外部时离开
- (void)recordButtonTouchUpOutside:(UIButton*)sender {
    NSLog(@"手指在按钮外部离开");
    [sender setImage:[UIImage imageNamed:@"btn_lz_h"] forState:0];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self stopRecord:nil];
}

//手指在录音按钮内部时离开
- (void)recordButtonTouchUpInside:(UIButton*)sender {
    NSLog(@"手指在按钮内松开");
    [sender setImage:[UIImage imageNamed:@"btn_lz_h"] forState:0];
    if (countDown<=25) {
        videoTime = [NSString stringWithFormat:@"%ld",30-countDown];
        [self isShowRecording:1];
        [self stopRecord:nil];
    }else{
        [MBProgressHUD showError:@"录音时间不能小于5s"];
        timeLbl.text = [NSString stringWithFormat:@"00"];
        [self stopRecord:nil];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
}

//手指移动到录音按钮外部
- (void)recordDragOutside:(UIButton*)sender {
    NSLog(@"手指在按钮外部");
    [sender setImage:[UIImage imageNamed:@"btn_lz_h"] forState:0];
}

//手指移动到录音按钮内部
- (void)recordDragInside:(UIButton*)sender {
    [sender setImage:[UIImage imageNamed:@"btn_zt_h"] forState:0];

}

- (void)pauseRecord:(UIButton*)sender{
    NSLog(@"暂停录音");
    [cView pauseAnimation];
    [self.recorder pause];
}

- (void)stopRecord:(UIButton*)sender{
    NSLog(@"停止录音");
    [cView pauseAnimation];
    [_timer invalidate];
    _timer = nil;
    if ([self.recorder isRecording]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
        [self.recorder stop];
    }
    

    NSFileManager *manager = [NSFileManager defaultManager];
    NSString*text;
    if ([manager fileExistsAtPath:filePath]){
//        [self audio_PCMtoMP3];
//        text = [NSString stringWithFormat:@"录了 %ld 秒,文件大小为 %.2fKb",COUNTDOWN - (long)countDown,[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0];
        
    }else{
        text = @"最多录30秒";
    }
    NSLog(@"%@",text);
}

-(void)playVideo:(UIButton*)sender {
    NSLog(@"播放录音");
    [self.recorder stop];
    if ([playLbl.text isEqualToString:@"试听"]) {
        [sender setImage:[UIImage imageNamed:@"btn_st_zt"] forState:0];
        playLbl.text = @"暂停";
        [cView resumeAnimation];
        if (filePath ==nil&&!kNotNil([XLBUser user].voiceAkira)) {
            return;
        }
        [self addTimer];
        //    kImagePrefix
        //    pick/E6CE5F45-BD98-4157-8F36-505B3AD3DED8.wav
        //pick/74D79DF4-15CA-45A2-BD66-B52544AB5A2F.mp3
        NSURL *recordFileUrl;
        if (filePath!=nil) {
            recordFileUrl = [NSURL fileURLWithPath:filePath];
        }else if ([XLBUser user].voiceAkira) {
            recordFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",kImagePrefix,[XLBUser user].voiceAkira]];
        }
        songItem = [[AVPlayerItem alloc]initWithURL:recordFileUrl];
        player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        
        id timeObserve = [player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds(songItem.duration);
            if (current) {
                
            }
        }];
        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    }else{
        [sender setImage:[UIImage imageNamed:@"btn_st_h"] forState:0];
        playLbl.text = @"试听";
        [cView pauseAnimation];
        [player pause];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (player.status) {
            case AVPlayerStatusUnknown:
//                BASE_INFO_FUN(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                [player play];
                countDown = 30;
//                status = SUPlayStatusReadyToPlay;
                break;
            case AVPlayerStatusFailed:
                [self stopRecord:nil];
//                BASE_INFO_FUN(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}
- (void)playbackFinished:(NSNotification *)notice {
    [playButton setImage:[UIImage imageNamed:@"btn_st_h"] forState:0];
    playLbl.text = @"试听";
    [cView pauseAnimation];
    timeLbl.text = [NSString stringWithFormat:@"0"];
    [self.recorder stop];
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
