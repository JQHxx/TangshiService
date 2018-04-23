//
//  AppDelegate.m
//  TangShiService
//
//  Created by vision on 17/5/22.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import <Hyphenate/Hyphenate.h>
#import <Hyphenate/EMOptions+PrivateDeploy.h>
#import "EaseSDKHelper.h"
#import "BaseNavigationController.h"
#import "ChatHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"
#import "IQKeyboardManager.h"
//shareSDK分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>


@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    [IQKeyboardManager sharedManager].enable=YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];

    [self initAllInfo];

    NSString *apnsCertName = nil;
    BOOL isProduction;
#if DEBUG
    isProduction=NO;
    apnsCertName = kApnsCertDevName;
#else
    isProduction=YES;
    apnsCertName = kApnsCertDisName;
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = kEaseMobAppKey;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appkey apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    /**********初始化APNs（极光）************/
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //初始化jpush
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:@"App Store"
                 apsForProduction:isProduction];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark 注册通知，将得到的deviceToken传给SDK
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString*deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@" "withString:@""]stringByReplacingOccurrencesOfString:@">"withString:@""];
    MyLog(@"deviceTokenStr : %@",deviceTokenStr);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
        [JPUSHService registerDeviceToken:deviceToken];
    });
}

#pragma mark 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    MyLog(@"注册推送失败------error:%@",error.description);
}

#pragma mark －－ 远程推送
#pragma mark iOS10之前 点击通知栏
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //跳转界面
    MyLog(@"iOS10之前，点击通知栏:%@", userInfo);
    if (self.tabBarViewController) {
        [self.tabBarViewController handerNotificationWithUserInfo:userInfo];
    }
    [[EaseSDKHelper shareHelper] hyphenateApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

#pragma mark iOS10以下系统 前台收到通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    MyLog(@"iOS10以下系统，收到通知:%@", userInfo);
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive) {
        [JPUSHService setBadge:0];
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

#pragma mark - 接收本地推送
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    MyLog(@"didReceiveLocalNotification,userinfo:%@",notification.userInfo);
}


#pragma mark UNUserNotificationCenterDelegate
#pragma mark iOS10及以上前台收到推送回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body; // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *title = content.title; // 推送消息的标题
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        MyLog(@"iOS10 前台收到远程通知----userInfo:%@",userInfo);
    }else {
        MyLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

#pragma mark iOS10 点击推送消息后回调 点击通知栏
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    MyLog(@"系统（iOS10及以上）点击通知栏调用 didReceiveNotificationResponse, userInfo:%@",userInfo);
    //跳转界面
    if (self.tabBarViewController) {
        [self.tabBarViewController handerNotificationWithUserInfo:userInfo];
    }
    completionHandler();
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
#pragma mark iOS10以上收到推送通知 （程序在前台）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSString *body = content.body;    // 推送消息体
    NSString *title = content.title;  // 推送消息的标题
    
    MyLog(@"极光推送 收到推送通知---%@,title:%@,body:%@",request.identifier,title,body);
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        MyLog(@"iOS10 前台收到远程通知:%@", userInfo);
        //iOS10 前台收到远程通知
        [JPUSHService handleRemoteNotification:userInfo];
        //前台收到推送的时候 转成本地通知
        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.alertTitle =[NSString stringWithFormat:@"jpush--alertitle:%@",title];
        notification.alertBody = body;
        notification.userInfo = userInfo;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
    }else {
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        MyLog(@"iOS10 极光推送 收到远程通知:%@", userInfo);
        //跳转界面
        if (self.tabBarViewController) {
            [self.tabBarViewController handerNotificationWithUserInfo:userInfo];
        }
    }else {
        // 判断为本地通知
        MyLog(@"iOS10 极光推送 收到本地通知,userInfo：%@",userInfo);
        //跳转界面
        if (self.tabBarViewController) {
            [self.tabBarViewController handerNotificationWithUserInfo:userInfo];
        }
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif
#pragma mark -初始化
-(void)initAllInfo{
    
    /******shareSD初始化******/
    [ShareSDK registerApp:@"糖士服务端"
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kWechatAppKey appSecret:kWechatAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kTencentAppKey appKey:kTencentAppSecret authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [appInfo SSDKSetupSinaWeiboByAppKey:kWeiboAPPKey appSecret:kWeiboAppSecret redirectUri:kWeiboRedirectUri authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
         
     }];
    
    /*注册微信*/
    [WXApi registerApp:kWechatAppKey];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark  APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

#pragma mark APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    MyLog(@"applicationWillEnterForeground");
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    [[TCHttpRequest sharedTCHttpRequest] refreshUserTokenAction];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [JPUSHService setBadge:0];
    
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- NSNotification
#pragma mark 登录状态改变
- (void)loginStateChange:(NSNotification *)notification{
    BOOL loginSuccess = [notification.object boolValue];
    BOOL isLogin=[[NSUserDefaultsInfos getValueforKey:kIsLogin] boolValue];
    if (loginSuccess&&isLogin) {//登陆成功加载主窗口控制器
        self.tabBarViewController=[[BaseTabBarViewController alloc] init];
        self.window.rootViewController=self.tabBarViewController;
        
        [ChatHelper sharedChatHelper].tabbarVC=self.tabBarViewController;
        [[ChatHelper sharedChatHelper] asyncPushOptions];
        
        NSString *userPhone=[NSUserDefaultsInfos getValueforKey:kUserPhone];
        NSString *tempStr=isTrueEnvironment?@"zs":@"cs";
        NSString *aliasStr=[NSString stringWithFormat:@"%@_%@",tempStr,userPhone];
        [JPUSHService setAlias:aliasStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            MyLog(@"设置推送别名，code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, seq);
            if (iResCode==6002) {
                [JPUSHService setAlias:aliasStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    MyLog(@"再次设置推送别名，code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, seq);
                } seq:5000];
            }
        } seq:5000];
        
        //获取专家信息
        [[TCHttpRequest sharedTCHttpRequest] getMethodWithoutLoadingWithURL:kExpertInfo success:^(id json) {
            NSDictionary *result=[json objectForKey:@"result"];
            if (kIsDictionary(result)&&result.count>0) {
                ExpertModel *expert =[[ExpertModel alloc] init];
                [expert setValues:result];
                [NSUserDefaultsInfos putKey:kExpertInfoKey andValue:result];
            }
        } failure:^(NSString *errorStr) {
            
        }];
    
    }else{//登陆失败加载登陆页面控制器
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        self.window.rootViewController=loginVC;
        
        self.tabBarViewController = nil;
        [ChatHelper sharedChatHelper].tabbarVC = nil;
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserToken];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserSecret];
        
        [[EMClient sharedClient] logout:NO];
        [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
        
        [NSUserDefaultsInfos removeObjectForKey:kExpertInfoKey];
    }
}

#pragma mark -- Public Methods
-(void)pushToLoginVCWithStatus:(NSInteger)status message:(NSString *)message{
    [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
    [[EMClient sharedClient] logout:NO];
    
    [NSUserDefaultsInfos removeObjectForKey:kUserKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserToken];
    
    self.tabBarViewController = nil;
    [ChatHelper sharedChatHelper].tabbarVC = nil;
    [NSUserDefaultsInfos removeObjectForKey:kExpertInfoKey];
    
    kSelfWeak;
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        weakSelf.window.rootViewController=loginVC;
    });
}



#pragma mark -- Private methods
#pragma mark  添加推送
- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appkey:(NSString *)appkey apnsCertName:(NSString *)apnsCertName otherConfig:(NSDictionary *)otherConfig{
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isHttpsOnly = [ud boolForKey:@"identifier_httpsonly"];
    
    //初始化环信SDK
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:appkey
                                         apnsCertName:apnsCertName
                                          otherConfig:@{@"httpsOnly":[NSNumber numberWithBool:isHttpsOnly], kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES],@"easeSandBox":[NSNumber numberWithBool:[self isSpecifyServer]]}];
    
    [ChatHelper sharedChatHelper];
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}


-(BOOL)isSpecifyServer{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *specifyServer = [ud objectForKey:@"identifier_enable"];
    if ([specifyServer boolValue]) {
        NSString *apnsCertName = nil;
#if DEBUG
        apnsCertName = kApnsCertDevName;
#else
        apnsCertName = kApnsCertDisName;
#endif
        NSString *appkey = [ud stringForKey:@"identifier_appkey"];
        if (!appkey)
        {
            appkey = @"easemob-demo#chatdemoui";
            [ud setObject:appkey forKey:@"identifier_appkey"];
        }
        NSString *imServer = [ud stringForKey:@"identifier_imserver"];
        if (!imServer)
        {
            imServer = @"msync-im1.sandbox.easemob.com";
            [ud setObject:imServer forKey:@"identifier_imserver"];
        }
        NSString *imPort = [ud stringForKey:@"identifier_import"];
        if (!imPort)
        {
            imPort = @"6717";
            [ud setObject:imPort forKey:@"identifier_import"];
        }
        NSString *restServer = [ud stringForKey:@"identifier_restserver"];
        if (!restServer)
        {
            restServer = @"a1.sdb.easemob.com";
            [ud setObject:restServer forKey:@"identifier_restserver"];
        }
        
        BOOL isHttpsOnly = NO;
        NSNumber *httpsOnly = [ud objectForKey:@"identifier_httpsonly"];
        if (httpsOnly) {
            isHttpsOnly = [httpsOnly boolValue];
        }
        
        [ud synchronize];
        
        EMOptions *options = [EMOptions optionsWithAppkey:appkey];
        if (![ud boolForKey:@"enable_dns"])
        {
            options.enableDnsConfig = NO;
            options.chatPort = [[ud stringForKey:@"identifier_import"] intValue];
            options.chatServer = [ud stringForKey:@"identifier_imserver"];
            options.restServer = [ud stringForKey:@"identifier_restserver"];
        }
        options.apnsCertName = apnsCertName;
        options.enableConsoleLog = YES;
        options.usingHttpsOnly = isHttpsOnly;
        
        [[EMClient sharedClient] initializeSDKWithOptions:options];
        return YES;
    }
    
    return NO;
}



@end
