//
//  ConversationModel.h
//  TangShiService
//
//  Created by vision on 17/5/31.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface ConversationModel : UserModel


@property (nonatomic, copy )NSString  *lastMsg;

@property (nonatomic, copy )NSString  *lastMsgTime;

@property (nonatomic,assign)NSInteger unreadCount;

@property (nonatomic, copy )NSString  *lastMsgHeadPic;

@property (nonatomic, copy )NSString  *lastMsgUserName;

@end
