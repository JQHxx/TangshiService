//
//  Config.h
//  TangShiService
//
//  Created by vision on 17/5/22.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#ifndef Config_h
#define Config_h


#endif /* Config_h */


/********************常用宏定义*****************/
//ios系统版本号
#define kIOSVersion    ([UIDevice currentDevice].systemVersion.floatValue)
// appDelegate
#define kAppDelegate   (AppDelegate *)[[UIApplication  sharedApplication] delegate]
//主窗口
#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]


/*******第三方平台APPKEY********/
/*微博 微信 腾讯*/
#define kWeiboAPPKey             @"3202971467"
#define kWeiboAppSecret          @"cf31d1678bcfe8a01c1f35e75d399e14"
#define kWeiboRedirectUri        @"http://open.weibo.com/apps/3202971467/privilege/oauth"
#define kWechatAppKey            @"wxeb9dd42fde46a85b"
#define kWechatAppSecret         @"693f82d6bbac92fe599781970d0fd079"
#define kTencentAppKey           @"1106210274"
#define kTencentAppSecret        @"aTJ06WyrSE2VqA8W"


//设备尺寸：屏幕宽、高
#define kScreenBounds     [UIScreen mainScreen].bounds
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kTabHeight        49.0
#define kNavHeight        44.0
#define kNewNavHeight     64.0
#define kRootViewHeight   kScreenHeight-kNavHeight-20

//RGB颜色
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0  green:(g)/255.0 blue:(b)/255.0  alpha:1]
#define kSystemColor          [UIColor colorWithHexString:@"#05d380"]
#define kbgBtnColor           [UIColor colorWithHexString:@"#05d380"]
#define kbgView               [UIColor colorWithHexString:@"#f0f0f0"]
#define kLineColor            kRGBColor(200, 199, 204)
#define kSysBlueColor         kRGBColor(77, 165, 248)

#define kDefaultMargin   8
#define PHONE_NUMBER @"0755-86716971"


//字体
#define kFontWithSize(size)      [UIFont systemFontOfSize:size]
#define kBoldFontWithSize(size)  [UIFont boldSystemFontOfSize:size]

///APP版本号
#define APP_VERSION     [[NSBundle mainBundle].infoDictionary      objectForKey:@"CFBundleShortVersionString"]
#define APP_DISPLAY_NAME [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"]

#pragma mark --Judge
//字符串为空判断
#define kIsEmptyString(s)       (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))
//对象为空判断
#define kIsEmptyObject(obj)     (obj == nil || [obj isKindOfClass:[NSNull class]])
//字典类型判断
#define kIsDictionary(objDict)  (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])
//数组类型判断
#define kIsArray(objArray)      (objArray != nil && [objArray isKindOfClass:[NSArray class]])

/// 设置颜色 示例：UIColorHex(0x26A7E8)
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorHex_Alpha(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

//调试
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

/// block self
#define kSelfWeak __weak typeof(self) weakSelf = self
#define kSelfStrong __strong __typeof__(self) strongSelf = weakSelf
/******************第三方SDK**************************/
#define kIMSDKAppid     @"1400031685"
#define kIMAccountType  @"12967"


/*****************AppID和AppToken*******************/
#define kAppID          @"WzADcCcdsSCLBat0"                     //app标识ID
#define kAppSecret      @"xj4AdNPxcXaj4Qqw8jJrqwD0zxy0zqPe"     

#define kEaseMobAppKey  @"1146170209115909#tangshi"        //环信APPkey

/*****************宏定义*********************/
#define kUserKey                   @"kUserKey"
#define kUserSecret                @"kUserSecret"
#define kUserToken                 @"kUserToken"
#define kIsLogin                   @"kIsLogin"
#define kNickName                  @"kNickName"
#define kImUsername                @"kImUsername"
#define kImPassword                @"kImPassword"
#define kUserPhone                 @"kUserPhone"
#define kUserPhoto                 @"kUserPhoto"
#define kHaveUnreadAtMessage       @"kHaveAtMessage"
#define kLastLoginUserName         @"kLastLoginUserName"
#define KNOTIFICATION_LOGINCHANGE  @"loginStateChange"
#define kSetPushOption             @"kSetPushOption"
#define kPushPlaySound             @"kPushPlaySound"              //声音
#define kPushPlayVebration         @"kPushPlayVebration"          //震动
#define kUserID                    @"kUserID" 
#define kGetUnreadMessageNotify    @"kGetUnreadMessageNotify"     //获取未读消息

#define kImMyPatients              @"kImMyPatients"
#define kImAllHelpers              @"kImAllHelpers"
#define kIMUsers                   @"kIMUsers"
#define kIsHelperKey               @"kIsHelperKey"               //当前专家是否助手
#define kExpertInfoKey             @"kExpertInfoKey"

#define kApnsCertDevName           @"tangshiService_dev"         //开发证书
#define kApnsCertDisName           @"tangshiService_dis"         //发布证书

#define kJPushAppKey               @"2b1f1e055a50b2c556674b5f"        //极光推送APPkey


#import "UIColor+Extend.h"
#import "UIViewExt.h"
#import "UIView+Toast.h"
#import "NSUserDefaultsInfos.h"
#import "NSString+Extend.h"
#import "UIImage+Extend.h"
#import "Singleton.h"
#import "Interface.h"
#import "TCHelper.h"
#import "TCHttpRequest.h"
#import "NSObject+Extend.h"
#import "UIImageView+EMWebCache.h"
#import "ChatHelper.h"
#import "UIButton+ImageTitleSpacing.h"
#import "NSDate+Category.h"
#import "NSDate+Extension.h"
#import "TCBlankView.h"
#import "MJRefresh.h"
#import "UIAlertView+Extension.h"
#import "UIButton+EMWebCache.h"
#import "UIDevice+Extend.h"





