//
//  ChatViewController.h
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "EaseMessageViewController.h"
#import "UserModel.h"

@protocol ChatViewControllerDelegate <NSObject>

-(void)chatVCDidClickWithUrl:(NSURL *)url;
//点击头像跳转
-(void)chatVCDidSelectUserAtavarWithName:(NSString *)nickName;
//发送调查表
-(void)chatVCMoreViewSendQuestionnaire;
//点击消息cell
-(void)chatVCDidSelectCellWithExt:(NSDictionary *)ext;

@end

@interface ChatViewController : EaseMessageViewController

@property (nonatomic,assign)id<ChatViewControllerDelegate>chatdelegate;


@end
