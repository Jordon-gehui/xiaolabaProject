//
//  XLBPictureBrowseViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2017/9/9.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "BaseViewController.h"

@protocol XLBPictureBrowseViewControllerDelegate <NSObject>

@optional

- (void)delectPictureWithIndex:(NSInteger )idex;
- (void)addUserHeaderImageWihtIndex:(NSInteger)index;
@end




@interface XLBPictureBrowseViewController : BaseViewController
@property (nonatomic, assign) BOOL isDelect;
@property (nonatomic, assign) BOOL setImage;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) NSInteger currentIndex;

@end


