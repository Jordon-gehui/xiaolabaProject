//
//  UIImageCollectionViewCell.h
//  ImageReview
//
//  Created by gyf on 16/5/3.
//  Copyright © 2016年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageCellClickDelegate<NSObject>
- (void)ImageCellDidClick;
- (void)saveImgWithImg:(UIImage *)img;
@end
@interface UIImageCollectionViewCell : UICollectionViewCell
@property(nonatomic , assign) NSObject<ImageCellClickDelegate> *delegate;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong)id img;

@end
