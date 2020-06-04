//
//  LittleTwoHeadView.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleTwoHeadView.h"

@implementation LittleTwoHeadView

@synthesize headImageBu,nameLabel,timeLable,followBu,contentLable,cellImageView,adressLable,zanBu,replyLable,lookLable,cellHeight;

-(instancetype)init{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, cellHeight)];
    if (self) {
        
        headImageBu = [UIButton new];
        headImageBu.frame = CGRectMake(15, 20, 32, 32);
        headImageBu.tag = 200;
        [headImageBu.layer setMasksToBounds:YES];
        [headImageBu.layer setCornerRadius:16];
        [self addSubview:headImageBu];
        
        
        //昵称
        nameLabel = [UILabel new];
        nameLabel.frame = CGRectMake(headImageBu.right + 10, headImageBu.top - 2, 200, 20);
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorWithR:46 g:48 b:45];
        
        [self addSubview:nameLabel];
        
        //时间
        timeLable = [UILabel new];
        timeLable.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 3, 200, 15);
        timeLable.font = [UIFont systemFontOfSize:12];
        timeLable.text = @"fsafdsfa";
        timeLable.textColor = [UIColor colorWithR:145 g:145 b:145];
        
        [self addSubview:timeLable];
        
        
        //内容
        contentLable = [UILabel new];
        contentLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:contentLable];
        contentLable.textColor = [UIColor colorWithR:102 g:102 b:102];
        
        //动态获取高度
        CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
        contentLable.frame = CGRectMake(headImageBu.left, headImageBu.bottom + 10, kSCREEN_WIDTH - 20, height);
        contentLable.numberOfLines = 0;
        
    }
    
    self.height = cellHeight;
    
    return self;
    
}

- (void)setDetaiTwoModel:(DetailModel *)detaiTwoModel{
    
    if ([detaiTwoModel.avatar containsString:@"http"]) {
        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:detaiTwoModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    } else {
        
        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:detaiTwoModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        
    }
    nameLabel.text = detaiTwoModel.nickName;
    timeLable.text = [ZZCHelper dateStringFromNumberTimer:detaiTwoModel.time];;
    
    //内容
    contentLable.text = detaiTwoModel.disc;
    CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
    contentLable.frame = CGRectMake(timeLable.left, headImageBu.bottom + 10, kSCREEN_WIDTH - 70, height);
    
    cellHeight = contentLable.bottom + 20;

}

@end
