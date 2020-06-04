//
//  LittleDetilTwoTableViewCell.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/17.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "LittleDetilTwoTableViewCell.h"

@implementation LittleDetilTwoTableViewCell
@synthesize headImageBu,nameLabel,timeLable,followBu,contentLable,cellImageView,adressLable,zanBu,replyLable,lookLable,cellHeight,line,detailReport,detailReportBu;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
        timeLable.textColor = [UIColor colorWithR:145 g:145 b:145];
        
        [self addSubview:timeLable];
        
        //举报
        detailReport = [UIButton new];
        detailReport.frame = CGRectMake(kSCREEN_WIDTH - 45, headImageBu.top + 10 , 20, 5);
        [detailReport setBackgroundImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
        [self.contentView addSubview:detailReport];
        
        
        //举报
        detailReportBu = [UIButton new];
        detailReportBu.frame = CGRectMake(kSCREEN_WIDTH - 45, headImageBu.top  , 30, 30);
        detailReportBu.tag = 402;
        //        detailReport.imageView.image.resizingMode
        [detailReportBu addTarget:self action:@selector(detailReportBu:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:detailReportBu];
        
        
        
        //内容
        contentLable = [UILabel new];
        contentLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:contentLable];
        contentLable.textColor = [UIColor colorWithR:102 g:102 b:102];
        
        //动态获取高度
        CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
        contentLable.frame = CGRectMake(headImageBu.left, headImageBu.bottom + 10, kSCREEN_WIDTH - 20, height);
        contentLable.numberOfLines = 0;
        
        //
        line = [UILabel new];
        line.font = [UIFont systemFontOfSize:15];
        [self addSubview:line];
        line.backgroundColor = [UIColor colorWithR:247 g:248 b:250];;
        
        
        self.detaiTwoModelArr = [[NSMutableArray alloc]init];
    }
    
    self.height = cellHeight;
    
    return self;
    
}

- (void)detailReportBu:(UIButton *)bu{
            
        
        NSString *creatUser = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    
    
        if ([creatUser isEqualToString:self.creatUser]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];

            self.cellReStr = @"1";
            [actionSheet showInView:actionSheet];

        }else{

            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles: nil];
            self.cellReStr = @"0";

            [actionSheet showInView:actionSheet];

        }
    
    
}
//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{


    if (buttonIndex == 0) {

        if([self.cellReStr isEqualToString:@"1"]){
            NSLog(@"删除");

            [self.detailDelegate clickDetailDel:self withID:self.cellID];

        }else{
            NSLog(@"举报");
            [self.detailDelegate clickDetailReport:self withID:self.cellID];
        }
    }
}
- (void)setDetaiTwoModel:(LittleTwoModel *)detaiTwoModel{

    
    self.cellID = detaiTwoModel.id;
    NSDictionary * discussion =  [NetWorking dictionaryWithJsonString:detaiTwoModel.discussion];
    self.littltDetailTwoModel = [LittleTwoDetailModel mj_objectWithKeyValues:discussion];
    NSLog(@"fdsafsfdsf=======%@----%@",self.littltDetailTwoModel.disc,detaiTwoModel.id);
    
    [self.detaiTwoModelArr addObject:self.littltDetailTwoModel];
    
    self.creatUser = self.littltDetailTwoModel.userId;
    if ([detaiTwoModel.avatar containsString:@"http"]) {
        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:detaiTwoModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    } else {

        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:detaiTwoModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];

    }
    nameLabel.text = self.littltDetailTwoModel.nickName;
    timeLable.text = [ZZCHelper dateStringFromNumberTimer:self.littltDetailTwoModel.time];

    //内容
    contentLable.text = self.littltDetailTwoModel.disc;
    CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
    contentLable.frame = CGRectMake(timeLable.left, headImageBu.bottom + 10, kSCREEN_WIDTH - 70, height);
    line.frame = CGRectMake(0, contentLable.bottom + 5, kSCREEN_WIDTH, 1);

    cellHeight = line.bottom +  1;

}


@end
