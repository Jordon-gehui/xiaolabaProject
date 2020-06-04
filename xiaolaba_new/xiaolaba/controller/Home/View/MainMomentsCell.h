//
//  MainMomentsCell.h
//  xiaolaba
//
//  Created by 斯陈 on 2019/3/22.
//  Copyright © 2019年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleHornTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MainMomentCellType) {
    MainMomentsDefault,
    MainMomentsOneImageWidthCell,
    MainMomentsOneImageHeightCell,
    MainMomentsTwoImageCell,
    MainMomentsThreeImageCell,
    MainMomentsFourImageCell,
    MainMomentsFiveImageCell,
    MainMomentsSixImageCell,
    MainMomentsSevenImageCell,
    MainMomentsEightImageCell,
    MainMomentsNineImageCell
};

typedef NS_ENUM(NSInteger, MainImageTag) {
    MainFirstImageTag = 100,
    MainSecondImageTag,
    MainThreeImageTag,
    MainFourImageTag,
    MainFiveImageTag,
    MainSixImageTag,
    MainSevenImageTag,
    MainEightImageTag,
    MainNineImageTag
};
@class MainMomentsCell;
@protocol MainMomentsCellDelegate <NSObject>

- (void)cellReLoadDelegate:(NSIndexPath *)index;

@optional
//删除
- (void)deleteCell:(LittleHornTableViewModel *)model;
//头像
- (void)headImageClick:(MainMomentsCell*)cell withId:(NSString *)userID;
//关注
//- (void)followClick:(MainMomentsCell*)cell withId:(NSString *)userID;

- (void)shareModelClick:(MainMomentsCell *)cell withId:(NSString *)contentId model:(LittleHornTableViewModel *)model;
//点赞
- (void)zanBuAddClick:(MainMomentsCell*)cell withId:(NSString *)currentID withLike:(NSString *)like;
//回复

- (void)commentBtnClick:(MainMomentsCell *)cell withID:(NSString *)currentId;
- (void)reportClick:(MainMomentsCell*)cell;
- (void)lookBtnClick:(MainMomentsCell *)cell withId:(NSString *)currentId;

- (void)contentImageClick:(NSArray *)image index:(NSInteger)index;
@optional

@end

@interface MainMomentsCell : UITableViewCell

@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *lookBtn;

@property (nonatomic, weak) id<MainMomentsCellDelegate>delegate;

@property (nonatomic, strong) LittleHornTableViewModel *model;
@property (nonatomic,copy)NSIndexPath *indexPath;

@property(nonatomic,assign)BOOL isSelf;

+ (NSString *)mainMomentCellIDWith:(MainMomentCellType)type;
@end

NS_ASSUME_NONNULL_END
