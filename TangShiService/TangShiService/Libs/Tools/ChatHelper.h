//
//  ChatHelper.h
//  TangShiService
//
//  Created by vision on 17/5/26.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseSDKHelper.h"
#import "BaseTabBarViewController.h"
#import "ConversationViewController.h"
#import "ChatViewController.h"
#import "ExpertModel.h"

#define kAtYouMessage           1
#define kAtAllMessage           2

typedef void (^SaveImUsersSuccess)(NSInteger count);//请求成功后的回调

@interface ChatHelper : NSObject <EMClientDelegate,EMChatManagerDelegate>

@property (nonatomic,strong)BaseTabBarViewController   *tabbarVC;

singleton_interface(ChatHelper);

- (void)asyncPushOptions;

- (void)saveImUsersForLoadMyusersSuccess:(SaveImUsersSuccess)success;

@end
