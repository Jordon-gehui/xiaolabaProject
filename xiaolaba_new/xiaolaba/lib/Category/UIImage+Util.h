//
//  UIImage+Util.h
//  
//
//  Created by cs on 15/9/15.
//  Copyright (c) 2015年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (Util)

+ (UIImage *) colorImage:(UIColor *)color;

- (UIImage*)scaledToSize:(CGSize)targetSize;

- (UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

- (UIImage*)deepCopy;

- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;

- (UIImage*)crop:(CGRect)rect;

- (UIImage*)maskedImage:(UIImage*)maskImage;

- (UIImage*)gaussBlur:(CGFloat)blurLevel;

+ (UIImage *) getVideoPreViewImage:(NSString *) url;

+ (UIImage *)gradually_bottomToTopWithStart:(UIColor *)startColor end:(UIColor *)endColor size:(CGSize )size;


+ (CGSize)getImageSizeWithURL:(id)URL;

@end
