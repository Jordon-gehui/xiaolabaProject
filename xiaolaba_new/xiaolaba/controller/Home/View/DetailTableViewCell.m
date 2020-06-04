//
//  DetailTableViewCell.m
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import "DetailTableViewCell.h"


@interface DetailTableViewCell () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *cellTableview;

@property (nonatomic,strong) UIButton *headImageBu;
@property (nonatomic,strong) UILabel *nameLabel;//昵称
@property (nonatomic,strong) UILabel *timeLable;//时间
@property (nonatomic,strong) UIButton *followBu;//关注
@property (nonatomic,strong) UILabel *contentLable;//内容
@property (nonatomic,strong) UILabel *adressLable;//地址
@property (nonatomic,strong) UIButton *zanBu;//点赞功能
@property (nonatomic,strong) UILabel *replyLable;//回复
@property (nonatomic,strong) UILabel *lookLable;//查看
@property (nonatomic,strong) UILabel *line;//查看

@property (nonatomic,strong) UIView *twoView;//二级评论时间

@property (nonatomic,strong) UILabel *twoNickName;//二级评论名字
@property (nonatomic,strong) UILabel *twoDisc;//二级评论内容
@property (nonatomic,strong) UILabel *twoTime;//二级评论时间
@property (nonatomic,strong) UILabel *twoLable;//查看
@property (nonatomic,strong) UIButton *clickBuMore; //查看更多页面


// 子评论数据
@property (strong, nonatomic) NSArray *childRemarks;


@end

@implementation DetailTableViewCell

@synthesize headImageBu,nameLabel,timeLable,followBu,contentLable,adressLable,zanBu,replyLable,lookLable,line,cellHeight,twoNickName,twoDisc,twoTime,twoView,detailZanBu,detailZanLabel,detailReport,detailReportBu,topButton,clickBuMore;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        headImageBu = [UIButton new];
        headImageBu.frame = CGRectMake(10, 10, 32, 32);
        [headImageBu.layer setMasksToBounds:YES];
        [headImageBu.layer setCornerRadius:16];
        [self.contentView addSubview:headImageBu];
        
        //昵称
        nameLabel = [UILabel new];
        nameLabel.frame = CGRectMake(headImageBu.right + 10, headImageBu.top - 2, 200, 20);
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor colorWithR:46 g:48 b:51];;

        [self.contentView addSubview:nameLabel];
        
        
        //时间
        timeLable = [UILabel new];
        timeLable.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 3, 200, 20);
        timeLable.font = [UIFont systemFontOfSize:13];
        timeLable.textColor = [UIColor colorWithR:174 g:181 b:194];;
        [self.contentView addSubview:timeLable];
        
        
        
        topButton = [UIButton new];
        topButton.frame = CGRectMake(0, 0, 120,timeLable.bottom);
        [topButton addTarget:self action:@selector(topBu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:topButton];
        
        //赞
        detailZanBu = [UIButton new];
        [detailZanBu setEnlargeEdge:10];
        detailZanBu.frame = CGRectMake(kSCREEN_WIDTH - 100, headImageBu.top - 2 , 25, 25);
        [detailZanBu setBackgroundImage:[UIImage imageNamed:@"icon_normal_zan"] forState:UIControlStateNormal];
        detailZanBu.tag = 401;
        [detailZanBu addTarget:self action:@selector(clickBu:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:detailZanBu];
        
        
        //zan
        detailZanLabel = [UILabel new];
        detailZanLabel.frame = CGRectMake(detailZanBu.right, nameLabel.top + 3, 30, 20);
        detailZanLabel.font = [UIFont systemFontOfSize:13];
        detailZanLabel.textColor = [UIColor colorWithR:174 g:181 b:194];;
        detailZanLabel.textAlignment = 1;
        [self.contentView addSubview:detailZanLabel];
        
        
        //举报
        detailReport = [UIButton new];
        [detailReport setEnlargeEdge:10];

        detailReport.frame = CGRectMake(kSCREEN_WIDTH - 45, headImageBu.top + 10 , 20, 5);
        [detailReport setBackgroundImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
        [self.contentView addSubview:detailReport];
        
        //举报
        detailReportBu = [UIButton new];
        detailReportBu.frame = CGRectMake(kSCREEN_WIDTH - 45, headImageBu.top  , 30, 30);
        detailReportBu.tag = 402;
        //        detailReport.imageView.image.resizingMode
        [detailReportBu addTarget:self action:@selector(clickBu:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:detailReportBu];
        
        
        //内容
        contentLable = [UILabel new];
        contentLable.frame = CGRectMake(nameLabel.left, timeLable.bottom + 10, kSCREEN_WIDTH - 70, 30);
        contentLable.font = [UIFont systemFontOfSize:15];
        contentLable.numberOfLines = 0;
        contentLable.textColor = [UIColor colorWithR:102 g:102 b:102];;

        [self.contentView addSubview:contentLable];
        //动态获取高度
        
        line = [UILabel new];
        line.backgroundColor = [UIColor colorWithR:247 g:248 b:250];;;
        [self.contentView addSubview:line];
        
        //昵称
        twoView = [UIView new];
//        twoView.frame = CGRectMake(headImageBu.right + 10, headImageBu.top, 200, 20);
        twoView.backgroundColor = [UIColor colorWithR:247 g:248 b:250];;
        twoView.tag = 900;
        [self.contentView addSubview:twoView];
        
        for (NSInteger i = 0; i < 5; i ++) {
              twoDisc = [UILabel new];
            twoDisc.tag = 300 + i;
        }
        
        

        //二级时间
        twoTime = [UILabel new];
        twoTime.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:twoTime];
        
        self.detailtwoArr = [[NSMutableArray alloc]init];;
        self.discusstwoArr = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i < self.discusstwoArr.count; i++ ) {
            
            twoView = [self viewWithTag:900];
            twoView.hidden = YES;
            
            twoDisc = [self viewWithTag:300 + i];
            twoDisc.hidden = YES;
            twoDisc.text = @"";
            
            twoNickName = [self viewWithTag:800 + i];
            twoNickName.hidden = YES;
            twoNickName.text = @"";
            
        }
   
        
    }
    
    return self;
    
}


- (void)setTwoModel:(LittleDetailModel *)twoModel{

    
    self.zanDisID = twoModel.ID;
    self.creatUser = twoModel.createUser;
    self.disID =twoModel.ID;
    self.momentID = twoModel.momentId;

    if (![twoModel.liked isEqualToString:@"0"]) {
        
        [detailZanBu setBackgroundImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        detailZanBu.enabled = NO;
        
    }else{
        
        [detailZanBu setBackgroundImage:[UIImage imageNamed:@"icon_normal_zan"] forState:UIControlStateNormal];
        detailZanBu.enabled = YES;
    }
    
 
    NSDictionary * discussion =  [NetWorking dictionaryWithJsonString:twoModel.discussion];
    self.detailModel = [DetailModel mj_objectWithKeyValues:discussion];
    if (self.detailModel) {
        [self.detailtwoArr addObject:self.detailModel];
    }
    
    nameLabel.text = self.detailModel.nickName;
    
    timeLable.text = [ZZCHelper dateStringFromNumberTimer:self.detailModel.time];
    
    detailZanLabel.text = twoModel.likes;
    
    if ([twoModel.avatar containsString:@"http"]) {
        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:twoModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
    } else {
        
        //头像
        [headImageBu sd_setBackgroundImageWithURL:[NSURL URLWithString:[JXutils judgeImageheader:twoModel.avatar Withtype:IMGAvatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weitouxiang"]];
        
    }
    //内容
    contentLable.text = self.detailModel.disc;
    CGFloat height =  [ZZCHelper textHeightFromTextString:contentLable.text width:kSCREEN_WIDTH - 20 fontSize:15];
    contentLable.frame = CGRectMake(timeLable.left, headImageBu.bottom + 10, kSCREEN_WIDTH - 70, height);
    
    for (NSInteger i = 0; i < twoModel.discussDiscussList.count; i++ ) {
        
        twoView = [self viewWithTag:900];
        twoView.hidden = YES;
        
        twoDisc = [self viewWithTag:300 + i];
        twoDisc.hidden = YES;
        twoDisc.text = @"";
        twoDisc = nil;
        [twoDisc removeFromSuperview];
        twoNickName = [self viewWithTag:800 + i];
        twoNickName.hidden = YES;
        twoNickName.text = @"";
        twoNickName = nil;
        [twoNickName removeFromSuperview];
        
        clickBuMore.hidden = YES;


    }
    
    if (twoModel.discussDiscussList.count > 0 ) {
        
        NSArray * arr = [twoModel.discussDiscussList mj_JSONObject];
        
        for (NSDictionary *detailTwoDic in arr) {
            
            NSDictionary * detailDiscussion =   [NetWorking dictionaryWithJsonString:detailTwoDic[@"discussion"]];
            
            self.discussDiscussListModel = [DiscussDiscussList mj_objectWithKeyValues:detailDiscussion];
            
            [self.discusstwoArr addObject:self.discussDiscussListModel];

        }
//
    }
    
    if (twoModel.discussDiscussList.count > 0 ) {

        twoView.hidden = NO;

        CGFloat lableHeight = 0.0;
        
        for (NSInteger i = 0; i < twoModel.discussDiscussList.count; i++ ) {
            
                self.discussDiscussListModel = [self.discusstwoArr mj_JSONObject][i];
          
                //二级评论
                twoDisc = [UILabel new];
                twoDisc.font = [UIFont systemFontOfSize:14];
                twoDisc.numberOfLines = 0;
                twoDisc.tag = 300 + i;
                twoDisc.textColor = [UIColor colorWithR:102 g:102 b:102];;
                
                [twoView addSubview:twoDisc];
                
                //            //内容
                twoDisc.text = self.discussDiscussListModel.disc;
                CGFloat height =  [ZZCHelper textHeightFromTextString:twoDisc.text width:kSCREEN_WIDTH - headImageBu.width - 85 - 50 fontSize:15];
                
                if (i == 0) {
                    twoDisc.frame = CGRectMake(100, 5 , kSCREEN_WIDTH - headImageBu.width - 40 - 45 - 50, height);
                }else{
                    
                    UILabel *twoLabl = [self viewWithTag:300 + i - 1];
                    twoDisc.frame = CGRectMake(100,twoLabl.bottom + 5 , kSCREEN_WIDTH - headImageBu.width - 40 - 45 - 50, height);
                }
                //
                lableHeight = twoDisc.bottom;
                
                //二级昵称
                twoNickName = [UILabel new];
                twoNickName.font = [UIFont systemFontOfSize:14];
                twoNickName.frame = CGRectMake(5,twoDisc.top , 90, 20);
                twoNickName.text = [NSString stringWithFormat:@"%@:",self.discussDiscussListModel.nickName];
                twoNickName.textColor = [UIColor colorWithR:66 g:124 b:197];
                twoNickName.tag = 800 + i;
            
                [twoView addSubview:twoNickName];
            
                //动态获取宽度
                CGSize size = [[NSString stringWithFormat:@"%@:",self.discussDiscussListModel.nickName] sizeWithFont:twoNickName.font constrainedToSize:CGSizeMake(MAXFLOAT, twoNickName.frame.size.height)];
                //根据计算结果重新设置UILabel的尺寸
                twoNickName.width = size.width;
                twoDisc.x = twoNickName.right + 10;
            
            if (lableHeight >= 85.f) {
                    
                    //            twoDisc.bottom = 70;
                    twoDisc.hidden = YES;
                    twoNickName.hidden = YES;
                    twoNickName.text = @"";
                    twoDisc.text = @"";
                    twoView.frame = CGRectMake(contentLable.left , contentLable.bottom + 5, kSCREEN_WIDTH - headImageBu.width - 30, 110);
                    
                    line.frame = CGRectMake(contentLable.left, twoView.bottom + 10, kSCREEN_WIDTH - 60, 1);
                    
                    cellHeight = headImageBu.height + 20 + contentLable.height + 20 + twoView.height ;
                    
                    clickBuMore = [UIButton new];
                    [clickBuMore setTitle:@"查看更多>" forState:UIControlStateNormal];
                    clickBuMore.frame = CGRectMake(5, 85, 100, 20);
                    [clickBuMore setTitleColor: [UIColor colorWithR:66 g:124 b:197] forState:UIControlStateNormal];
                    clickBuMore.tag = 400;
                    clickBuMore.titleLabel.font = [UIFont systemFontOfSize:14];
                    [clickBuMore addTarget:self action:@selector(clickBu:) forControlEvents:UIControlEventTouchUpInside];
                    [twoView addSubview:clickBuMore];
                    
                    return;
                }else{
                    
                    twoView.frame = CGRectMake(contentLable.left , contentLable.bottom + 5, kSCREEN_WIDTH - headImageBu.width - 30, lableHeight + 10);
                    
                    line.frame = CGRectMake(contentLable.left, twoView.bottom + 10, kSCREEN_WIDTH - 60, 1);
                    
                    cellHeight = headImageBu.height + 20 + contentLable.height + 20 + twoView.height ;
                }
            
        }
        
    }else{
    
        twoView.hidden = YES;
        twoDisc.hidden = YES;
        twoNickName.hidden = YES;
        twoNickName.text = @"";
        twoDisc.text = @"";
        line.frame = CGRectMake(contentLable.left, contentLable.bottom + 10, kSCREEN_WIDTH - 60, 1);
        
        cellHeight = headImageBu.height + 20 + contentLable.height + 20;
        
    }

}

- (void)clickBu:(UIButton *)bu{
    
    
    bu.selected = !bu.selected;

    switch (bu.tag) {
        case 400:
            if ([self.DetailDelegate respondsToSelector:@selector(clickBu:withID:withID:withModel:)]) {
                [self.DetailDelegate clickBu:self withID:self.disID withID:self.momentID withModel:self.detailModel];
            }
            
            break;
        case 401:

            [self.DetailDelegate clickDetailZan:self withID:self.zanDisID];
            
            break;
        case 402:

            [self delAndReport];
            break;
     
               default:
            break;
    }
    
}
- (void)delAndReport{
    
    
    
    NSString *creatUser = [NSString stringWithFormat:@"%@",[XLBUser user].userModel.ID];
    
    if ([creatUser isEqualToString:self.creatUser]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"回复", nil];

        self.cellReStr = @"1";
        [actionSheet showInView:actionSheet];

    }else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"回复", nil];
        self.cellReStr = @"0";

        [actionSheet showInView:actionSheet];

    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 0) {
        
        if([self.cellReStr isEqualToString:@"1"]){
            NSLog(@"删除");

            [self.DetailDelegate clickDetailDel:self withID:self.disID];

        }else{
            NSLog(@"举报");
            [self.DetailDelegate clickDetailReport:self withID:self.disID];
        }
    }else if (buttonIndex == 1){
        
        NSLog(@"回复");
        [self.DetailDelegate clickDetailReply:self withID:self.disID withID:self.momentID withModel:self.detailModel];
    }
}

- (void)topBu:(UIButton *)topBu{
    
    [self.DetailDelegate cellImageBu:self withId:self.creatUser];
}

@end
