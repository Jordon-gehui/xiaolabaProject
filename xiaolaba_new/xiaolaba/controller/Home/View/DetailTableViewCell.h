//
//  DetailTableViewCell.h
//  xiaolaba
//
//  Created by jackzhang on 2017/9/13.
//  Copyright © 2017年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleDetailModel.h"

@class DiscussDiscussList;

@class DetailTableViewCell;
@protocol DetailTableViewCellDelegate <NSObject>

@optional

- (void)clickBu:(DetailTableViewCell*)clickBu withID:(NSString *)discussId withID:(NSString *)momentId withModel:(DetailModel *)buDetailModel;//查看更多

- (void)clickDetailZan:(DetailTableViewCell*)clickDetailZan withID:(NSString *)discussId;//赞

- (void)clickDetailReport:(DetailTableViewCell*)clickDetailReport withID:(NSString *)delID;//举报
- (void)clickDetailDel:(DetailTableViewCell*)clickDetailDel withID:(NSString *)delID;//删除

- (void)clickDetailReply:(DetailTableViewCell*)clickDetailReply withID:(NSString *)discussId withID:(NSString *)momentId withModel:(DetailModel *)buDetailModel;//回复

- (void)clickDetailCancel:(DetailTableViewCell*)clickDetailCancel;//

- (void)cellImageBu:(DetailTableViewCell*)headImageBu withId:(NSString *)userID;//头像

@end


@interface DetailTableViewCell : UITableViewCell

@property (nonatomic,strong) DetailModel *detailModel;
@property (nonatomic,strong) DiscussDiscussList *discussDiscussListModel;
@property (nonatomic,strong) LittleDetailModel *twoModel;
@property (nonatomic,strong) NSMutableArray *twoModelArr;//
@property (nonatomic) CGFloat cellHeight;//
@property (nonatomic,weak)  id<DetailTableViewCellDelegate> DetailDelegate;
@property (strong,nonatomic) NSMutableArray *twoArr;
@property (strong,nonatomic) NSMutableArray *detailtwoArr;
@property (strong,nonatomic) NSMutableArray *discusstwoArr;
@property (strong,nonatomic) UIButton *detailZanBu;
@property (strong,nonatomic) UILabel *detailZanLabel;
@property (strong,nonatomic) UIButton *detailReport;
@property (strong,nonatomic) UIButton *detailReportBu;
@property (strong,nonatomic) NSString *zanDisID;//赞的ID
@property (strong,nonatomic) NSString *disID;//
@property (strong,nonatomic) NSString *momentID;//
@property (strong,nonatomic) UIView *chooseView;
@property (nonatomic,strong) UIButton *topButton;//切换页面

@property (strong,nonatomic) UIButton *cellReportBu;//举报按钮
@property (strong,nonatomic) UIButton *cellReplyBu;//回复按钮
@property (strong,nonatomic) UIButton *cellCancelBu;//取消按钮
@property (strong,nonatomic) UIButton *cellDelBu;//删除按钮
@property (strong,nonatomic) NSString *creatUser;//
@property (strong,nonatomic) NSString *cellReStr;//举报和删除评论的区分字段






@end
