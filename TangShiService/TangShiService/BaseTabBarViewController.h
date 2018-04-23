//
//  BaseTabBarViewController.h
//  Tianjiyun
//
//  Created by vision on 16/9/20.
//  Copyright © 2016年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationViewController.h"
#import "ContactListViewController.h"
#import <Hyphenate/Hyphenate.h>
#import <UserNotifications/UserNotifications.h>

@interface BaseTabBarViewController : UITabBarController

@property (nonatomic,strong)ConversationViewController *conversationVC;


-(void)handerNotificationWithUserInfo:(NSDictionary *)userInfo;

//播放铃声和震动
- (void)playSoundAndVibrationWithMessage:(EMMessage *)message;
//显示推送消息
- (void)showNotificationWithMessage:(EMMessage *)message;

@end
