//
//  VoiceScreenViewController.h
//  xiaolaba
//
//  Created by 戴葛辉 on 2018/3/22.
//  Copyright © 2018年 jackzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceScreenViewControllerDelegate<NSObject>

- (void)didSeletedWithParame:(NSDictionary *)dict;

@end

@interface VoiceScreenViewController : BaseViewController

@property (nonatomic, weak) id<VoiceScreenViewControllerDelegate>delegate;
@end
