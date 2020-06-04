//
//  ImageReviewViewController.h
//  ImageReview
//
//  Created by gyf on 16/5/3.
//  Copyright © 2016年 owen. All rights reserved.
//


@protocol ImageReviewViewControllerDelegate <NSObject>


@optional

- (void)delectPictureWithIndex:(NSInteger )idex;
- (void)addUserHeaderImageWihtIndex:(NSInteger)index;

@end

@interface ImageReviewViewController : BaseViewController

@property (nonatomic, weak) id <ImageReviewViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, copy) NSString *currentIndex;

@property (nonatomic, assign) BOOL isDelect;

@property (nonatomic, assign) BOOL setImage;

@property (nonatomic, assign) BOOL getUser;

@end
