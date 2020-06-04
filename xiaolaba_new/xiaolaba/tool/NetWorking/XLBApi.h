//
//  XLBApi.h
//  xiaolaba
//
//  Created by lin on 2017/8/1.
//  Copyright © 2017年 jxcode. All rights reserved.
//

#ifndef XLBApi_h
#define XLBApi_h

#ifdef DEBUG

#define HOSTNAME        @""
#else

#define HOSTNAME        @""


#endif

#define kShowAPPStore   @""
#define kAppComment     @""
#define kImagePrefix	@""
#define kDomainUrl      @""

/**
 登陆验证码
 */
#define kLoginCode @""

/**
 登陆
 */
#define kLogin @""

/**
 退出登录
 */
#define kLogout @""

/**
 微信登陆
 */
#define kSpeedy @""
/**
 微信解除
 */

#define kWxCancle @""

/**
 微博解除
 */

#define kWbCancle @""
/**
 微博绑定
 */
#define kWbForbid @""
/**
 微信绑定
 */
#define kWxForbid @""
/**
 用户登录完善信息
 */
#define kComplete @""

/**
 跳过完善信息
 */
#define kSkip @""

/**
 寻车友
 */
#define kFind @""

/**
 寻车友 匿名
 */
#define kFindAnon @""

//寻车友筛选
#define kFindCondition @""

/**
 基础数据
 */
#define kScreening @""

/**
 车品牌
 */
#define kBrands @""

#define kOwner @""
/**
提现列表接口
*/
#define kPayTixian @""

/**
 支付宝sign
 */
#define kPayRsa @""

/**
 支付宝授权
 */
#define kPayAccess @""


/**
 支付宝支付成功
 */
#define kPaySuccess @""


/**
 支付宝支付
 */
#define kPaySign @""

/**
 挪车贴支付宝支付成功
 */
#define kCheTieSuccess @""


/**
 挪车贴支付宝支付
 */
#define kCheTieSign @""

/**
 挪车贴支付宝再次支付
 */
#define kCheTieSignAgain @""

/**
 支付宝提现
 */
#define kPayTransfer @""



/**
 资讯查看
 */
#define kZXkan @""
/**
 评价详情
 
 */
#define kVoiceImp @""

/**
 新闻页评论列表url
 */
#define kNewsDisList @""

/**
 新闻页评论
 */
#define kNewsDiscu @""

/**
 新闻二级评论
 */
#define kNewsDiscuTwo @""
/**
 上传app版本
 */
#define kPostVersion @""
/**
 添加背景音乐
 */
#define kSongAdd @""
/**
 主叫方获取背景音乐
 */
#define kSongGet @""

/**
 获取个人车贴订单
 */
#define kGetCheTieOrder @""

#endif /* XLBApi_h */
