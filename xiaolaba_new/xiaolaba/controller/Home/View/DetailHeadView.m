//
//  DetailHeadView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "DetailHeadView.h"

@implementation DetailHeadView
@synthesize headImageBu,nameLabel,timeLable,followBu,contentLable,cellImageView,adressLable,zanBu,replyLable,lookLable,cellHeight,adressImage,nameImage,shareImage,shareLable,lookImage,topButton;

-(instancetype)init{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, cellHeight)];
    if (self) {
        
        headImageBu = [UIButton new];
        headImageBu.frame = CGRectMake(15, 20, 36, 36);
        headImageBu.tag = 200;
        [headImageBu.layer setMasksToBounds:YES];
        [headImageBu.layer setCornerRadius:18];
        [self addSubview:headImageBu];
        
        
        //昵称
        nameLabel = [UILabel new];
        nameLabel.frame = CGRectMake(headImageBu.right + 10, headImageBu.top - 2, 200, 20);
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        nameLabel.textColor = [UIColor commonTextColor];
        
        [self addSubview:nameLabel];
        
        nameImage = [[UIImageView alloc]init];
        
        [self addSubview:nameImage];
        
        //时间
        timeLable = [UILabel new];
        timeLable.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 3, 200, 15);
        timeLable.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        timeLable.textColor = [UIColor annotationTextColor];
        
        [self addSubview:timeLable];
        
        
        
        topButton = [UIButton new];
        topButton.frame = CGRectMake(0, 0, 200,timeLable.bottom);
        [topButton addTarget:self action:@selector(topBu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:topButton];
        
        //        _tagView = [XLBDEvaluateView new];
        //        _tagView.backgroundColor = [UIColor whiteColor];
        //        [_tagView setFont:7];
        //        [_tagView setlHeight:12];
        //        [_tagView setLwidth:15];
        //        [_tagView setRadius:2];
        //
        //        [self addSubview:_tagView];
        //        _tagView.frame =CGRectMake(headImageBu.left + 5, timeLable.bottom + 10, kSCREEN_WIDTH-30, 15);
        
        //内容
        contentLable = [UILabel new];
        contentLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:contentLable];
        contentLable.textColor = [UIColor colorWithR:102 g:102 b:102];
        
        //动态获取高度
        CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
        contentLable.frame = CGRectMake(headImageBu.left, headImageBu.bottom + 10, kSCREEN_WIDTH - 20, height);
        contentLable.numberOfLines = 0;
        
        
        adressImage = [[UIImageView alloc]init];
        adressImage.image = [UIImage imageNamed:@"icon_fx_dw"];
        [self addSubview:adressImage];
        //地址
        adressLable = [UILabel new];
        adressLable.font = [UIFont systemFontOfSize:11];
        adressLable.textAlignment = NSTextAlignmentLeft;
        adressLable.textColor = [UIColor colorWithR:153 g:153 b:153];
        
        [self addSubview:adressLable];
        
        
        shareImage = [[UIImageView alloc]init];
        shareImage.image = [UIImage imageNamed:@"icon_fx_x"];
        [self addSubview:shareImage];
        
        //分享
        shareLable = [UILabel new];
        shareLable.frame = CGRectMake(headImageBu.right + 10, headImageBu.top - 2, 200, 20);
        shareLable.font = [UIFont systemFontOfSize:14];
        shareLable.text = @"分享";
        shareLable.textColor = [UIColor colorWithR:153 g:153 b:153];
        
        [self addSubview:shareLable];
        
        lookImage = [[UIImageView alloc]init];
        lookImage.image = [UIImage imageNamed:@"icon_kan"];
        [self addSubview:lookImage];
        
        //回复
        lookLable = [UILabel new];
        lookLable.font = [UIFont systemFontOfSize:13];
        lookLable.textColor = [UIColor colorWithR:153 g:153 b:153];
        
        [self addSubview:lookLable];
        
    }
    
    self.height = cellHeight;
    
    return self;
    
}


- (void)setLittleModel:(LittleHornTableViewModel *)littleModel{
    
    _littleModel = littleModel;
    //    [self.tagView insertSign:littleModel.tags];
    
    if ([littleModel.avatar containsString:@"http"]) {
        
        //头像
        [headImageBu sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:littleModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    } else {
        
        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:littleModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        
    }
    
    nameLabel.text = littleModel.nickName;
    //动态获取宽度
    CGSize size = [littleModel.nickName sizeWithFont:nameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, nameLabel.frame.size.height)];
    //根据计算结果重新设置UILabel的尺寸
    nameLabel.width = size.width;
    nameImage.frame = CGRectMake(nameLabel.right + 7, nameLabel.top , 25, 20);
    
    if ([littleModel.brandImg containsString:@"http"]) {
        
        //车标
        [nameImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:littleModel.brandImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@""]];
    } else {
        //车标
        [nameImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:littleModel.brandImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@""]];
        
    }
    
    timeLable.text = littleModel.publishDate;
    
    //关注
    //内容
    if ([littleModel.moment hasSuffix:@"\n"]) {
        //        NSString *b = [littleModel.moment substringToIndex:[littleModel.moment length]-1];
        NSString *b = [littleModel.moment stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        contentLable.text = b;
        
    }else
        contentLable.text = littleModel.moment;
    
    
    adressLable.text = littleModel.location;
    //分享
    shareLable.text = [NSString stringWithFormat:@"分享 %@",littleModel.shares];
    //评论
    lookLable.text = [NSString stringWithFormat:@"浏览量 %@",littleModel.views];
    
    CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
    
    //    if (littleModel.tags.count > 0) {
    //        contentLable.frame = CGRectMake(headImageBu.left, self.tagView.bottom + 15, kSCREEN_WIDTH - 20, height);
    //    }else
    contentLable.frame = CGRectMake(headImageBu.left, headImageBu.bottom + 15, kSCREEN_WIDTH - 20, height);
    for (NSInteger i = 0; i < _littleModel.imgs.count; i++ ) {
        cellImageView = [UIImageView new];
        cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        cellImageView.hidden = NO;
        //        cellImageView.layer.cornerRadius = 10;
        cellImageView.userInteractionEnabled = YES;
        //将多余的部分切掉
        cellImageView.layer.masksToBounds = YES;
        cellImageView.tag = 300+ i;
        [self addSubview:cellImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [cellImageView addGestureRecognizer:tap];
        if (i == 0) {
            if (kNotNil(_littleModel.moment)) {
                cellImageView.frame = CGRectMake(15, contentLable.bottom + 10,50, 50);
            }else {
                cellImageView.frame = CGRectMake(15, headImageBu.bottom + 10,50, 50);
            }
        }else {
            UIImageView *twoIamgeView = [self viewWithTag: 300 + i - 1] ;
            cellImageView.frame = CGRectMake(15, twoIamgeView.bottom + 10 ,50, 50);
        }
    }
    [self viewReload];
}
-(void)viewReload {
    for (NSInteger i = 0; i < _littleModel.imgs.count; i++ ) {
        UIImageView* imageView = [self viewWithTag: 300 + i] ;
        
        NSString *urlStrAll = [JXutils judgeImageheader:_littleModel.imgs[i] Withtype:IMGNormal];
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStrAll];
        CGSize imageSize = cachedImage.size;
        CGFloat width  = kSCREEN_WIDTH-30;
        if (imageSize.width<(kSCREEN_WIDTH-30)) {
            width = imageSize.width;
        }
        CGFloat height = (cachedImage.size.height *width)/ cachedImage.size.width;
        
        if (cachedImage) {
            [imageView setImage:cachedImage];
            if (i == 0) {
                if (kNotNil(_littleModel.moment)) {
                    imageView.frame = CGRectMake(15, contentLable.bottom + 10,width, height);
                }else {
                    imageView.frame = CGRectMake(15, headImageBu.bottom + 10,width, height);
                }
            }else{
                UIImageView *twoIamgeView = [self viewWithTag: 300 + i - 1] ;
                imageView.frame = CGRectMake(15, twoIamgeView.bottom + 10 ,width, height);
                
            }
        }else {
            [self downloadImage:urlStrAll forIndexPath:0];
            [imageView setImage:[UIImage imageNamed:@"pic_home_jz"]];
            if (i == 0) {
                if (kNotNil(_littleModel.moment)) {
                    imageView.frame = CGRectMake(15, contentLable.bottom + 10,50, 50);
                }else {
                    imageView.frame = CGRectMake(15, headImageBu.bottom + 10,50, 50);
                }
            }else{
                UIImageView *twoIamgeView = [self viewWithTag: 300 + i - 1] ;
                imageView.frame = CGRectMake(15, twoIamgeView.bottom + 10 ,50, 50);
                
            }
        }
        
    }
    
    [self setViewFrameWithModel];
}
- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    kWeakSelf(self)
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // do nothing
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf viewReload];
            if (weakSelf.imageDelegate) {
                [weakSelf.imageDelegate headImageHeadSize:cellHeight];
            }
        });
    }];
}
-(void)setViewFrameWithModel {
    if (_littleModel.imgs.count > 0) {
        if (_littleModel.location == nil || [_littleModel.location isEqualToString:@""]) {
            
            adressLable.hidden = YES;
            adressImage.hidden = YES;
            shareImage.frame = CGRectMake(15, cellImageView.bottom + 10, 20, 20);
            shareLable.frame = CGRectMake(shareImage.right + 10, shareImage.top , 60, 20);
            lookImage.frame = CGRectMake(shareLable.right + 20, shareImage.top , 20, 20);
            lookLable.frame = CGRectMake(lookImage.right + 10, lookImage.top, 150, 20);
            cellHeight = shareImage.bottom + 20;
            
            
        }else{
            adressLable.hidden = NO;
            adressImage.hidden = NO;
            adressImage.frame = CGRectMake(contentLable.left, cellImageView.bottom + 15, 8, 10);
            adressLable.frame = CGRectMake(adressImage.right + 5, cellImageView.bottom + 12, 200, 20);
            shareImage.frame = CGRectMake(adressImage.left, adressImage.bottom + 10, 20, 20);
            shareLable.frame = CGRectMake(shareImage.right + 10, shareImage.top , 60, 20);
            lookImage.frame = CGRectMake(shareLable.right + 20, shareImage.top , 20, 20);
            lookLable.frame = CGRectMake(lookImage.right + 10, lookImage.top, 150, 20);
            cellHeight = shareImage.bottom + 20;
            
        }
    }else{
        
        if (_littleModel.location == nil || [_littleModel.location isEqualToString:@""]) {
            
            adressLable.hidden = YES;
            adressImage.hidden = YES;
            shareImage.frame = CGRectMake(15, contentLable.bottom + 10, 20, 20);
            shareLable.frame = CGRectMake(shareImage.right + 10, shareImage.top , 60, 20);
            lookImage.frame = CGRectMake(shareLable.right + 20, shareImage.top , 20, 20);
            lookLable.frame = CGRectMake(lookImage.right + 10, lookImage.top, 150, 20);
            cellHeight = shareImage.bottom + 20;
            
            
        }else{
            
            adressLable.hidden = NO;
            adressImage.hidden = NO;
            adressImage.frame = CGRectMake(contentLable.left, contentLable.bottom + 15, 8, 10);
            adressLable.frame = CGRectMake(adressImage.right + 5, contentLable.bottom + 10, 200, 20);
            shareImage.frame = CGRectMake(adressImage.left, adressImage.bottom + 10, 20, 20);
            shareLable.frame = CGRectMake(shareImage.right + 10, shareImage.top , 60, 20);
            lookImage.frame = CGRectMake(shareLable.right + 20, shareImage.top , 20, 20);
            lookLable.frame = CGRectMake(lookImage.right + 10, lookImage.top, 150, 20);
            cellHeight = shareImage.bottom + 20;
        }
    }
}
- (void)topBu:(UIButton *)topBu{
    
    [self.imageDelegate headImageBu:self withId:_littleModel.createUser];
}

#pragma mark-头标点击事件
- (void)onTap:(UITapGestureRecognizer *)sender{
    
    UIImageView * imageView =(UIImageView *) [sender view];
    if ([self.imageDelegate respondsToSelector:@selector(imageBu:withURL:withIndex:)]) {
        [self.imageDelegate imageBu:self withURL:imageView.sd_imageURL withIndex:(imageView.tag - 300)];
    }
    
    
}

@end
