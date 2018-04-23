//
//  ChatHelper.m
//  TangShiService
//
//  Created by vision on 17/5/26.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ChatHelper.h"
#import "MBProgressHUD.h"
#import "JPUSHService.h"

static ChatHelper *helper = nil;

@implementation ChatHelper

+(ChatHelper *)sharedChatHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatHelper alloc] init];
    });
    return helper;
}

#pragma mark 初始化
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

#pragma mark -- Private Methods
#pragma mark 初始化
- (void)initHelper{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

#pragma mark 清除数据
- (void)_clearHelper{
    self.tabbarVC = nil;
    
    [[EMClient sharedClient] logout:NO];
}

#pragma mark 保存环信用户信息
- (void)saveImUsersForLoadMyusersSuccess:(SaveImUsersSuccess)success{
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithoutLoadingWithURL:kGetUsers success:^(id json) {
        //保存我的患者列表
        NSArray *list=[json objectForKey:@"result"];
        [NSUserDefaultsInfos putKey:kImMyPatients andValue:list];
        
        //保存助手列表
        NSArray *helperList=[json objectForKey:@"helperList"];
        [NSUserDefaultsInfos putKey:kImAllHelpers andValue:helperList];
        
        //是否助手
        BOOL  isHelper=[[json objectForKey:@"is_helper"] boolValue];
        [NSUserDefaultsInfos putKey:kIsHelperKey andValue:[NSNumber numberWithBool:isHelper]];
        
        //保存环信用户昵称到本地
        NSMutableArray *tempImUserArr=[[NSMutableArray alloc] init];
        for (NSDictionary *userDict in list) {       //我的患者
            UserModel *user=[[UserModel alloc] init];
            [user setValues:userDict];
            NSString *userName=kIsEmptyString(user.remark)?user.nick_name:user.remark;
            NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:userName,@"nickName",user.im_username,@"im_username",nil];
            [tempImUserArr addObject:dict];
        }
        
        for (NSDictionary *helperDict in helperList) {
            NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[helperDict valueForKey:@"expert_name"],@"nickName",[helperDict valueForKey:@"im_username"],@"im_username",nil];
            [tempImUserArr addObject:dict];
        }
        [NSUserDefaultsInfos putKey:kIMUsers andValue:tempImUserArr];
        
        success(tempImUserArr.count);
        
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark - EMClientDelegate
#pragma mark 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    MyLog(@"didConnectionStateChanged");
}

#pragma mark 当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice
{
    [self _clearHelper];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark 自动登录完成时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)error{
    if (error) {
        MyLog(@"环信自动登录失败,code:%u,error:%@",error.code,error.errorDescription);
    } else if([[EMClient sharedClient] isConnected]){
        MyLog(@"环信自动登录成功");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL flag = [[EMClient sharedClient] migrateDatabaseToLatestSDK];
            if (flag) {
                [self setApnsNickName];
                [self saveImUsersForLoadMyusersSuccess:^(NSInteger count) {
                    
                }];
            }
        });
    }
}

#pragma mark 当前登录账号已经被从服务器端删除时会收到该回调
- (void)userAccountDidRemoveFromServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark 服务被禁用
- (void)userDidForbidByServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"servingIsBanned", @"Serving is banned") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - EMChatManagerDelegate
#pragma mark 会话列表发生变化
-(void)conversationListDidUpdate:(NSArray *)aConversationList{
    MyLog(@"conversationListDidUpdate");
}

#pragma mark 收到消息
-(void)messagesDidReceive:(NSArray *)aMessages{
    for(EMMessage *message in aMessages){
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state==UIApplicationStateActive) {
            [self.tabbarVC playSoundAndVibrationWithMessage:message];
        }else{
           [self.tabbarVC showNotificationWithMessage:message];
        }
    }
}
 
#pragma mark -- Publc methods
#pragma mark 设置APNS昵称
-(void)setApnsNickName{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *nickName=[NSUserDefaultsInfos getValueforKey:kNickName];
        EMError *error=[[EMClient sharedClient] setApnsNickname:nickName];
        if (!error) {
            MyLog(@"成功设置APNS昵称：%@",nickName);
        }else{
            MyLog(@"设置APNS昵称失败，code:%u,error:%@",error.code,error.errorDescription);
        }
    });
}

#pragma mark 从服务器获取推送属性
- (void)asyncPushOptions{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMPushOptions *options =[[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
        options.displayStyle=EMPushDisplayStyleMessageSummary;
        
        EMError *error2 = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
        if (!error2) {
            MyLog(@"设置推送显示详情成功");
        }else{
            MyLog(@"设置推送显示详情失败,code:%u,error:%@",error2.code,error.errorDescription);
        }
    });
}

- (void)dealloc{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

@end
