//
//  ScroHeadView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/26.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "ScroHeadView.h"

@implementation ScroHeadView
@synthesize scroHeadView,leftImageView,leftImageLabel,rightImageView,rightImageLabel,scroImageView,scroImageLabel,carImageView;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
            scroHeadView = [UIView new];
            scroHeadView.frame = CGRectMake(kSCREEN_WIDTH /2.0, arc4random()%100, 300, 30);
            scroHeadView.backgroundColor = [UIColor textBlackColor];
            [scroHeadView.layer setMasksToBounds:YES];
            [scroHeadView.layer setCornerRadius:15];
            scroHeadView.tag = 100 ;
            scroHeadView.alpha = 0.7;
            scroHeadView.hidden = YES;

            [self addSubview:scroHeadView];


            scroImageView = [UIImageView new];
            scroImageView.frame = CGRectMake(5, 10, 25, 25);
            scroImageView.centerY = scroHeadView.height/2;
            [scroImageView.layer setMasksToBounds:YES];
            [scroImageView.layer setCornerRadius:12];
            scroImageView.tag = 200 ;

            [scroHeadView addSubview:scroImageView];
            
            
            scroImageLabel= [UILabel new];
            scroImageLabel.frame  = CGRectMake(scroImageView.right + 10, 0, 150, 20);
            scroImageLabel.textColor = [UIColor whiteColor];
            scroImageLabel.font = [UIFont systemFontOfSize:14];
            scroImageLabel.centerY = scroHeadView.height/2;
            scroImageLabel.tag = 300 ;

            [scroHeadView addSubview:scroImageLabel];
            
            carImageView = [UIImageView new];
            carImageView.centerY = scroHeadView.height/2;
            [carImageView.layer setMasksToBounds:YES];
            [carImageView.layer setCornerRadius:20];
            carImageView.tag = 400 ;

            [scroHeadView addSubview:carImageView];
            
    
    }
    return self;
}

-(void)setScroModelArr:(NSMutableArray *)scroModelArr{
    _scroImgArr = scroModelArr;

        UIView * scroView = [self viewWithTag:100];
        scroView = nil;
    self.index= 0;
    [self addanimate];
    
}
-(void)addanimate{
    if (self.index>_scroImgArr.count-1) {
        return;
    }
    NSDictionary * dict = _scroImgArr[self.index];
    self.scroModel = [ScroHeadModel mj_objectWithKeyValues:dict];
    
    scroHeadView = [self viewWithTag:100];
    UIImageView * scroImage = [self viewWithTag:200];
    UILabel * scroContent = [self viewWithTag:300];
    UIImageView * scroLastImage = [self viewWithTag:400];
    
    [scroImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.scroModel.img Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@""]];
    //
    [scroLastImage sd_setImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:self.scroModel.brandImg Withtype:IMGAvatar]] placeholderImage:[UIImage imageNamed:@""]];
    //            //动态获取宽度
    CGSize size = [self.scroModel.content sizeWithFont:scroContent.font constrainedToSize:CGSizeMake(MAXFLOAT, scroContent.frame.size.height)];
    //根据计算结果重新设置UILabel的尺寸
    scroContent.width = size.width;
    scroContent.text = self.scroModel.content;
    scroLastImage.frame = CGRectMake(scroContent.right + 5, 3, 30, 25);
    
    if(self.scroModel.brandImg == nil || [self.scroModel.brandImg isEqualToString:@""]){
        
        scroHeadView.width = scroContent.right + 10;
        scroHeadView.x = kSCREEN_WIDTH/2.0-scroHeadView.width;
    }else{
        
        scroHeadView.width = scroLastImage.right + 10;
        scroHeadView.x = kSCREEN_WIDTH/2.0-scroHeadView.width;
        
    }
    //UIViewAnimationOptionRepeat |
    [scroHeadView setHidden:YES];
    [self startAnimate:scroHeadView];
}
-(void)startAnimate:(UIView*)view {
    [view setHidden:NO];
    view.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        view.alpha = 1;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:(2.0)//动画持续时间
                              delay:(1.0)//动画延迟执行的时间
                            options:(UIViewAnimationOptionCurveLinear)//动画的过渡效果
                         animations:^{
                             //执行的动画
                             view.x -= kSCREEN_WIDTH/2.0+view.width;
                             
                         }completion:^(BOOL finished){
                             //动画执行完毕后的操作
                             NSLog(@"结束");
                             if (self.index<self.scroModelArr.count-2) {
                                 self.index++;
                                 [self addanimate];
                             }else{
                                 [view removeFromSuperview];

                             }
                             
                             
                         }];
    }];
    
}
@end













