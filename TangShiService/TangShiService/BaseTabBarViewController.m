//
//  BaseTabBarViewController.m
//  Tianjiyun
//
//  Created by vision on 16/9/20.
//  Copyright © 2016年 vision. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "MineViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "ChatHelper.h"
#import "TCFriendGroupViewController.h"
#import "TCMySugarFriendModel.h"
#import "PPBadgeView.h"
#import "TCBasewebViewController.h"
#import "TCServicingViewController.h"
#import "ConversationModel.h"
#import "TCArticleLibraryViewController.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"type";
static NSString *kConversationChatter = @"ConversationChatter";

@interface BaseTabBarViewController (){
    
    EMConnectionState _connectionState;
    NSInteger _messagesNumber;   // 消息个数
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
///
@property (nonatomic ,strong)  UITabBarItem * messageItem;
@property (nonatomic ,strong)  UITabBarItem * friendItem;
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kTabHeight)];
    backView.backgroundColor =[UIColor whiteColor];
    
    UILabel *lineLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineLab.backgroundColor=kbgBtnColor;
    [backView addSubview:lineLab];
    
    [self.tabBar insertSubview:backView atIndex:0];
    [self.tabBar setTintColor:kSystemColor];
    self.tabBar.opaque=YES;
    // 隐藏tabbar顶端的灰色线条
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    [self initTabBar];
    
    BOOL isLogin=[[NSUserDefaultsInfos getValueforKey:kIsLogin] boolValue];
    if (isLogin) {
        [self loadFriendGroupMessageNumber];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chanageBadgeNumber:) name:@"FriendGroupBadgeNumberNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadMessageCount:) name:kGetUnreadMessageNotify object:nil];
    
}


#pragma mark ====== 获取糖友圈消息个数 =======
- (void)loadFriendGroupMessageNumber{
    NSString *body = [NSString stringWithFormat:@"role_type=2"];
    kSelfWeak;
    [[TCHttpRequest sharedTCHttpRequest]postMethodWithoutLoadingForURL:KLoadMySugarFriendInfo body:body success:^(id json) {
        NSDictionary *result = [json objectForKey:@"result"];
        if (kIsDictionary(result)) {
            TCMySugarFriendModel *mySugarFriendModel = [[TCMySugarFriendModel alloc] init];
            [mySugarFriendModel setValues:result];
            _messagesNumber = mySugarFriendModel.ated + mySugarFriendModel.liked + mySugarFriendModel.new_followed + mySugarFriendModel.commented;
            
            NSString *numberStr = [NSString stringWithFormat:@"%ld",(long)_messagesNumber];
            if (_messagesNumber > 0 && _messagesNumber < 100) {
                [weakSelf.friendItem pp_addBadgeWithText:numberStr];
                [weakSelf.friendItem pp_moveBadgeWithX:-9 Y:18];
            }else if (_messagesNumber > 100){
                [weakSelf.friendItem pp_addBadgeWithText:@"99+"];
                [weakSelf.friendItem pp_moveBadgeWithX:-9 Y:18];
            }
        }
    } failure:^(NSString *errorStr) {
        
    }];
}
#pragma mark ====== 通知改变糖友圈Badge 数量 =======

- (void)chanageBadgeNumber:(NSNotification *)sender{
    NSString *numberStr = [sender object];
    NSInteger badgeNumber = [numberStr integerValue];
    if (badgeNumber > 0 && badgeNumber <= 99) {
        [self.friendItem pp_addBadgeWithText:numberStr];
        [self.friendItem pp_moveBadgeWithX:-9 Y:18];
    }else if (badgeNumber > 99){
        [self.friendItem pp_addBadgeWithText:@"99+"];
        [self.friendItem pp_moveBadgeWithX:-9 Y:18];
    }else{
        [self.friendItem pp_hiddenBadge];
    }
}

#pragma mark 消息未读数
-(void)getUnreadMessageCount:(NSNotification *)notify{
    NSInteger unreadCount=[[notify object] integerValue];
    if (unreadCount > 0 && unreadCount <= 99) {
        [self.messageItem pp_addBadgeWithText:[NSString stringWithFormat:@"%ld",unreadCount]];
        [self.messageItem pp_moveBadgeWithX:0 Y:5];
    }else if (unreadCount > 99){
        [self.messageItem pp_addBadgeWithText:@"99+"];
        [self.messageItem pp_moveBadgeWithX:0 Y:5];
    }else{
        [self.messageItem pp_hiddenBadge];
    }
}

#pragma mark -- Public methods
#pragma mark 播放铃声和震动
-(void)playSoundAndVibrationWithMessage:(EMMessage *)message{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    NSString *sound=[NSUserDefaultsInfos getValueforKey:kPushPlaySound];
    if (kIsEmptyString(sound)) {
        [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    }else{
        if ([sound integerValue]>0) {
            [[EMCDDeviceManager sharedInstance] playNewMessageSound];
        }
    }
    
    // 收到消息时，震动
    NSString *vebration=[NSUserDefaultsInfos getValueforKey:kPushPlayVebration];
    if (kIsEmptyString(vebration)) {
        [[EMCDDeviceManager sharedInstance] playVibration];
    }else{
        if ([vebration integerValue]>0) {
            [[EMCDDeviceManager sharedInstance] playVibration];
        }
    }
    
    NSArray *usersArr=[NSUserDefaultsInfos getValueforKey:kIMUsers];
    if (kIsArray(usersArr)&&usersArr.count>0) {
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
        for (NSDictionary *userDict in usersArr) {
            NSString *imUserName=[userDict valueForKey:@"im_username"];
            if ([imUserName isEqualToString:message.from]) {
                [tempArr addObject:imUserName];
                break;
            }
        }
        //筛选患者
        if (tempArr.count==0) {  //没有用户  重新拉取患者信息
            [[ChatHelper sharedChatHelper] saveImUsersForLoadMyusersSuccess:^(NSInteger count) {
                if (self.conversationVC) {
                    [self.conversationVC refreshConversationData];
                }
            }];
        }
    }
    
    if (self.conversationVC) {
        [self.conversationVC refreshConversationData];
    }
}

#pragma mark 显示推送消息
-(void)showNotificationWithMessage:(EMMessage *)message{
    EMMessageBody *messageBody = message.body;
    NSString *messageStr = nil;
    switch (messageBody.type) {
        case EMMessageBodyTypeText:
        {
            messageStr = ((EMTextMessageBody *)messageBody).text;
            messageStr = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:messageStr];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            messageStr = @"[图片]";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            messageStr = @"[位置]";
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            messageStr = @"[语音]";
        }
            break;
        case EMMessageBodyTypeVideo:{
            messageStr = @"[视频]";
        }
            break;
        default:
            break;
    }
    
    NSString *alertBody=[NSString stringWithFormat:@"%@",messageStr];
    NSArray *usersArr=[NSUserDefaultsInfos getValueforKey:kIMUsers];
    if (kIsArray(usersArr)&&usersArr.count>0) {
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
        for (NSDictionary *userDict in usersArr) {
            NSString *imUserName=[userDict valueForKey:@"im_username"];
            if ([imUserName isEqualToString:message.from]) {
                [tempArr addObject:imUserName];
                NSString *nickName=[userDict valueForKey:@"nickName"];
                alertBody=[NSString stringWithFormat:@"%@：%@",nickName,messageStr];
                break;
            }
        }
        
        //筛选患者
        if (tempArr.count==0) {  //没有用户  重新拉取患者信息
            [[ChatHelper sharedChatHelper] saveImUsersForLoadMyusersSuccess:^(NSInteger count) {
                if (self.conversationVC) {
                    [self.conversationVC refreshConversationData];
                }
            }];
        }
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:4] forKey:kMessageType];
    [userInfo setObject:message.from forKey:@"f"];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        [UIApplication sharedApplication].applicationIconBadgeNumber+=1;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (self.conversationVC) {
        [self.conversationVC refreshConversationData];
    }
}
#pragma mark 处理推送通知
-(void)handerNotificationWithUserInfo:(NSDictionary *)userInfo{
    MyLog(@"handerUserNotificationWithUserInfo--%@",userInfo);
    
    if (kIsDictionary(userInfo)&&userInfo.count>0) {
        self.selectedIndex=0;
        BaseNavigationController *nav=self.viewControllers[0];
        BaseViewController *controller=nav.viewControllers[0];
        
        NSInteger type=[[userInfo valueForKey:@"type"] integerValue];
        if (type==2) {
            NSInteger message_id=[[userInfo valueForKey:@"message_id"] integerValue];
            NSInteger message_user_id=[[userInfo valueForKey:@"message_user_id"] integerValue];
            NSString *urlString=nil;
            TCBasewebViewController *webVC=[[TCBasewebViewController alloc] init];
            webVC.titleText=@"消息详情";
            urlString = [NSString stringWithFormat:@"%@?message_id=%ld&message_user_id=%ld",kNewsWebUrl,(long)message_id,(long)message_user_id];
            webVC.urlStr=urlString;
            webVC.hidesBottomBarWhenPushed=YES;
            [controller.navigationController pushViewController:webVC animated:YES];
        }else{
            if (![self.navigationController.topViewController isKindOfClass:[TCServicingViewController class]]) {
                NSString *urlStr=[NSString stringWithFormat:@"%@?user_im=%@",kGetUserInfo,[userInfo objectForKey:@"f"]];
                [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:urlStr success:^(id json) {
                    NSDictionary *result=[json objectForKey:@"result"];
                    BOOL isHelper=[[json objectForKey:@"is_helper"] boolValue];
                    NSDictionary *helperDict=[json objectForKey:@"helperList"];
                    if (kIsDictionary(result)) {
                        UserModel *user=[[UserModel alloc] init];
                        [user setValues:result];
                        user.isHelper=isHelper;
                        
                        if (kIsDictionary(helperDict)&&helperDict.count>0) {
                            if (isHelper) {  //当前用户为助手
                                user.expertHeadPic=helperDict[@"head_portrait"];
                                user.expertUserName=helperDict[@"expert_name"];
                                user.helperHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                                user.helperUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
                            }else{   //当前用户为专家
                                user.helperHeadPic=helperDict[@"head_portrait"];
                                user.helperUserName=helperDict[@"expert_name"];
                                user.expertHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                                user.expertUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
                            }
                        }else{
                            user.expertHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                            user.expertUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
                        }
                        
                        TCServicingViewController *servicingVC=[[TCServicingViewController alloc] init];
                        servicingVC.title = kIsEmptyString(user.remark)?user.nick_name:user.remark;
                        servicingVC.userModel=user;
                        servicingVC.hidesBottomBarWhenPushed=YES;
                        [controller.navigationController pushViewController:servicingVC animated:YES];
                    }
                } failure:^(NSString *errorStr) {
                    
                }];
            }
        }
    }
}
#pragma mark -- Private methods
#pragma mark 初始化tabbar
-(void)initTabBar{
    self.conversationVC=[[ConversationViewController alloc] init];
    BaseNavigationController *nav1=[[BaseNavigationController alloc] initWithRootViewController:self.conversationVC];
    _messageItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[[UIImage imageNamed:@"h_ic_msg_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"h_ic_msg_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nav1.tabBarItem = _messageItem;
    
    ContactListViewController *contactsVC=[[ContactListViewController alloc] init];
    BaseNavigationController *nav2=[[BaseNavigationController alloc] initWithRootViewController:contactsVC];
    UITabBarItem * homeItem = [[UITabBarItem alloc] initWithTitle:@"患者" image:[[UIImage imageNamed:@"h_ic_patient_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"h_ic_patient_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nav2.tabBarItem = homeItem;
    
    TCFriendGroupViewController *friendGroupVC=[[TCFriendGroupViewController alloc] init];
    BaseNavigationController *nav3=[[BaseNavigationController alloc] initWithRootViewController:friendGroupVC];
    _friendItem = [[UITabBarItem alloc] initWithTitle:@"糖友圈" image:[[UIImage imageNamed:@"h_ic_friend_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"h_ic_friend_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nav3.tabBarItem = _friendItem;
    
    
    TCArticleLibraryViewController *articleLibraryVC = [[TCArticleLibraryViewController alloc]init];
    BaseNavigationController *nav4=[[BaseNavigationController alloc] initWithRootViewController:articleLibraryVC];
    UITabBarItem  *articleLibraryItem = [[UITabBarItem alloc] initWithTitle:@"糖百科" image:[[UIImage imageNamed:@"h_ic_baike_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"h_ic_baike_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nav4.tabBarItem = articleLibraryItem;
    
    
    MineViewController *mineVC=[[MineViewController alloc] init];
    BaseNavigationController *nav5=[[BaseNavigationController alloc] initWithRootViewController:mineVC];
    UITabBarItem * personalItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"h_ic_mine_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"h_ic_mine_sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    nav5.tabBarItem = personalItem;
    
    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
}




@end
