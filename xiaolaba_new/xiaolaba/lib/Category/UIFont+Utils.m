//
//  UIFont+Utils.m
//  xiaolaba
//
//  Created by 斯陈 on 2017/9/5.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

//仅用于导航栏标题文字和其他页面标题文字:活动标题
+(UIFont *)emphasizeFont {
    return [UIFont systemFontOfSize:18];
}
//常用重要列表文字标题，例如:列表标题、各种设置列表、评论内容
+(UIFont *)extrudeFont {
    return [UIFont systemFontOfSize:16];
}
//常用带头像列表文字标题，例如:二级导航文字、带头像列表标题、 详情文字、输入提示文字
+(UIFont *)headlineFont {
    return [UIFont systemFontOfSize:15];
}
//用于较重要小标题，例如:副标题、按钮文字
+(UIFont *)subtitleFont {
    return [UIFont systemFontOfSize:14];
}
//用于详情描述文字，例如:详细信息、卡片标题等
+(UIFont *)contentFont {
    return [UIFont systemFontOfSize:13];
}
//用于较重要的,例如:提示信息、数据描述、警示文字、错误提示等
+(UIFont *)hintFont {
    return [UIFont systemFontOfSize:12];
}
//用于菜单栏文字，例如:底部菜单栏文字、极少部分的备注信息
+(UIFont *)remarkFont {
    return [UIFont systemFontOfSize:11];
}

@end
