//
//  ConversationViewController.m
//  TangShiService
//
//  Created by vision on 17/5/23.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ConversationViewController.h"
#import "ChatViewController.h"
#import "SystemNewsViewController.h"
#import "TCServicingViewController.h"
#import "TCCommentMineViewController.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseEmotionManager.h"
#import "NSDate+Category.h"
#import "ConversationTableViewCell.h"
#import "ConversationModel.h"
#import "EaseLocalDefine.h"
#import "TCSystemNewsModel.h"
#import "SVProgressHUD.h"
#import "TCCommonNewsModel.h"

@interface ConversationViewController (){
    TCSystemNewsModel    *systemNewsModel;
    TCCommonNewsModel    *commonNewsModel;   //评论消息
    
    BOOL isLogin;
}


@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"消息";
    
    systemNewsModel=[[TCSystemNewsModel alloc] init];
    commonNewsModel = [[TCCommonNewsModel alloc] init];
    
    isLogin=[[NSUserDefaultsInfos getValueforKey:kIsLogin] boolValue];
    
    self.showRefreshHeader = YES;
    self.tableView.backgroundColor=[UIColor bgColor_Gray];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self tableViewDidTriggerHeaderRefresh];
    if (isLogin) {
        [self loadLastestSystemNewsData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?2:self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"ConversationTableViewCell";
    ConversationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[ConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    id model;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            model=systemNewsModel;
        }else{
            model=commonNewsModel;
        }
    }else{
       model=self.dataArray[indexPath.row];
    }
    [cell conversationCellDisplayWithModel:model type:indexPath.section];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            SystemNewsViewController *newsVC=[[SystemNewsViewController alloc] init];
            newsVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:newsVC animated:YES];
        }else{
            TCCommentMineViewController *commentMineVC=[[TCCommentMineViewController alloc] init];
            commentMineVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:commentMineVC animated:YES];
        }
    }else{
        ConversationModel *model=self.dataArray[indexPath.row];
        
        TCServicingViewController* servicingController = [[TCServicingViewController alloc] init];
        servicingController.userModel=model;
        servicingController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:servicingController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1&&self.dataArray.count>0) {
        return 40;
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1&&self.dataArray.count>0) {
        return @"我的患者";
    }else{
        return @"";
    }
}

#pragma mark 获取最后一条消息显示的内容
- (NSString *)latestMessageTitleForConversationModel:(EMConversation *)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            }
                break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            }
                break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[音频]";
            }
                break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            }
                break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            }
                break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}


#pragma mark 获取最后一条消息显示的时间
-(NSString *)latestMessageTimeForConversationModel:(EMConversation *)conversationModel{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}


#pragma mark -- Private Methods
#pragma mark 重新获取会话列表
-(void)refreshConversationData{
    kSelfWeak;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf tableViewDidTriggerHeaderRefresh];
        });
    });
}

#pragma mark 刷新获取数据
-(void)tableViewDidTriggerHeaderRefresh{
    NSArray *patientsArr=[NSUserDefaultsInfos getValueforKey:kImMyPatients];
    NSArray *helperList=[NSUserDefaultsInfos getValueforKey:kImAllHelpers];
    if (kIsArray(patientsArr)&&patientsArr.count>0&&kIsArray(helperList)&&helperList.count>0) {
        MyLog(@"获取本地患者数据");
        [self parseConversationWithPatients:patientsArr helperList:helperList];
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
    }else{
        MyLog(@"获取服务器患者数据");
        __weak typeof(self) weakself = self;
        [[TCHttpRequest sharedTCHttpRequest] getMethodWithoutLoadingWithURL:kGetUsers success:^(id json) {
            NSArray *list=[json objectForKey:@"result"];
            if (kIsArray(list)&&list.count>0) {
                //保存我的患者列表
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
                
                [weakself parseConversationWithPatients:list helperList:helperList];
            }
            [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
        } failure:^(NSString *errorStr) {
            [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
        }];
    }
}

#pragma mark 
- (void)parseConversationWithPatients:(NSArray *)list  helperList:(NSArray *)helperList{
    BOOL isHelper=[[NSUserDefaultsInfos getValueforKey:kIsHelperKey] boolValue];
    
    NSArray *conversations=[[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    MyLog(@"会话未读消息数:%ld",(long)unreadCount);
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetUnreadMessageNotify object:[NSNumber numberWithInteger:unreadCount]];
    
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for (EMConversation *converstion in sorted) {
        for (NSDictionary *dict in list) {
            ConversationModel *model=[[ConversationModel alloc] init];
            [model setValues:dict];
            model.isHelper=isHelper;
            
            if (isHelper) {  //当前用户为助手
                for (NSDictionary *helperDict in helperList) {
                    if ([helperDict[@"im_username"] isEqualToString:model.im_expertname]) {
                        model.expertHeadPic=helperDict[@"head_portrait"];
                        model.expertUserName=helperDict[@"expert_name"];
                        model.expert_id=[helperDict[@"expert_id"] integerValue];
                        break;
                    }
                }
                model.helperHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                model.helperUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
            }else{   //当前用户为专家
                for (NSDictionary *helperDict in helperList) {
                    if ([helperDict[@"im_username"] isEqualToString:model.im_helpername]) {
                        model.helperHeadPic=helperDict[@"head_portrait"];
                        model.helperUserName=helperDict[@"expert_name"];
                        model.helper_id=[helperDict[@"expert_id"] integerValue];
                        break;
                    }
                }
                model.expertHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                model.expertUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
            }
            
            //最新一条消息
            if ([model.im_groupid isEqualToString:converstion.conversationId]||[model.im_username isEqualToString:converstion.conversationId]) {
                model.lastMsg=[self latestMessageTitleForConversationModel:converstion];
                model.lastMsgTime=[self latestMessageTimeForConversationModel:converstion];
                model.unreadCount=converstion.unreadMessagesCount;
                
                if ([model.im_groupid isEqualToString:converstion.conversationId]) {
                    model.lastMsgHeadPic=model.photo;
                    NSString *userName=kIsEmptyString(model.remark)?model.nick_name:model.remark;
                    model.lastMsgUserName=isHelper?[NSString stringWithFormat:@"%@-%@",model.expertUserName,userName]:userName;
                }else{
                    model.im_groupid=@"";
                    model.lastMsgHeadPic=model.photo;
                    model.lastMsgUserName=kIsEmptyString(model.remark)?model.nick_name:model.remark;
                }
                [tempArr addObject:model];
            }
        }
    }
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:tempArr];
    [self.tableView reloadData];
}

#pragma mark 获取最新系统消息
-(void)loadLastestSystemNewsData{
    __weak typeof(self) weakself = self;
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithoutLoadingForURL:kGetExpertMessage body:nil success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            
            NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
            NSInteger unreadCount = 0;
            for (EMConversation *conversation in conversations) {
                unreadCount += conversation.unreadMessagesCount;
            }
            MyLog(@"系统未读消息数:%ld",(long)unreadCount);
            
            //系统消息
            BOOL isMessageRead=[[result valueForKey:@"message_count"] boolValue];
            NSDictionary *messageInfo=[result valueForKey:@"message_info"];
            if (kIsDictionary(messageInfo)&&messageInfo.count>0) {
                [systemNewsModel setValues:messageInfo];
            }else{
                systemNewsModel = [[TCSystemNewsModel alloc]init];
            }
            systemNewsModel.isRead=isMessageRead;
            
            commonNewsModel.newsIndex=1;
            NSDictionary *articleInfo=[result valueForKey:@"article_info"];
            BOOL isCommentRead=[[articleInfo valueForKey:@"is_read"] boolValue];
            commonNewsModel.hasNewMessages=isCommentRead;
        }
        [weakself.tableView reloadData];
    } failure:^(NSString *errorStr) {
        
    }];
}


@end
