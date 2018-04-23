//
//  TCServicingViewController.m
//  TonzeCloud
//
//  Created by vision on 17/6/21.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCServicingViewController.h"
#import "ChatViewController.h"
#import "TCServiceStateViewController.h"
#import "UserDetailViewController.h"
#import "MineInfoViewController.h"
#import "TCServiceDetailViewController.h"
#import "ServiceAgreementViewController.h"
#import "ClickViewGroup.h"
#import "QuestionnaireViewController.h"
#import "TCQuestionnarieModel.h"
#import "QuestionnarieDetailViewController.h"
#import "UserBaseViewController.h"
#import "BloodFileViewController.h"
#import "TCCommentMineViewController.h"
#import "TCHistoryRecordsViewController.h"

@interface TCServicingViewController ()<ClickViewGroupDelegate,TCServiceStateViewControllerDelegate,ChatViewControllerDelegate,QuestionnaireViewControllerDelegate>{
    
}

@property (nonatomic,strong)ClickViewGroup                  *viewGroup;
@property (nonatomic,strong)ChatViewController              *chatVC;
@property (nonatomic,strong)TCServiceStateViewController    *serviceStateVC;

@end

@implementation TCServicingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.userModel.isHelper) {
        NSString *userName=kIsEmptyString(self.userModel.remark)?self.userModel.nick_name:self.userModel.remark;
        self.baseTitle=[NSString stringWithFormat:@"%@-%@",self.userModel.expertUserName,userName];
    }else{
         self.baseTitle=kIsEmptyString(self.userModel.remark)?self.userModel.nick_name:self.userModel.remark;
    }
   
    [self.view addSubview:self.viewGroup];
    [self.view addSubview:self.chatVC.view];
}


#pragma mark -- Custom Delegate
#pragma mark  ClickViewGroupDelegate
-(void)ClickViewGroupActionWithIndex:(NSUInteger)index{
    if (index==0) {
        if (self.serviceStateVC) {
            [self.serviceStateVC.view removeFromSuperview];
            self.serviceStateVC=nil;
        }
        [self.view addSubview:self.chatVC.view];
    }else{
        if (self.chatVC) {
            [self.chatVC.view removeFromSuperview];
            self.chatVC=nil;
        }
        [self.view addSubview:self.serviceStateVC.view];
    }
}

#pragma mark TCServiceStateViewControllerDelegate
#pragma mark 去服务详情页
-(void)serviceStateVCDidSelectedCellWithModel:(TCMineServiceModel *)myService{
    TCServiceDetailViewController *serviceDetailVC=[[TCServiceDetailViewController alloc] init];
    serviceDetailVC.myService=myService;
    [self.navigationController pushViewController:serviceDetailVC animated:YES];
}


#pragma mark ChatViewControllerDelegate
#pragma mark 点击链接
-(void)chatVCDidClickWithUrl:(NSURL *)url{
    ServiceAgreementViewController *serviceVC=[[ServiceAgreementViewController alloc] init];
    serviceVC.url=url;
    [self.navigationController pushViewController:serviceVC animated:YES];
}

#pragma mark 发送调查表
-(void)chatVCMoreViewSendQuestionnaire{
    QuestionnaireViewController *questionVC=[[QuestionnaireViewController alloc] init];
    questionVC.delegate=self;
    questionVC.userId=self.userModel.user_id;
    [self.navigationController pushViewController:questionVC animated:YES];
}

#pragma mark 点击消息cell
-(void)chatVCDidSelectCellWithExt:(NSDictionary *)ext{
    NSString *msgType=ext[@"msg_type"];
    if ([msgType isEqualToString:@"question"]) {  //调查表
        NSDictionary *msgDict=[ext valueForKey:@"msg_info"];
        if (kIsDictionary(msgDict)) {
            QuestionnarieDetailViewController *questionDetailVC=[[QuestionnarieDetailViewController alloc] init];
            questionDetailVC.rs_id=[[msgDict valueForKey:@"rs_id"] integerValue];
            questionDetailVC.titleStr = [msgDict valueForKey:@"name"];
            questionDetailVC.userId=self.userModel.user_id;
            [self.navigationController pushViewController:questionDetailVC animated:YES];
        }
    }else if ([msgType isEqualToString:@"userInfo"]){  //基本信息
        UserBaseViewController *infoVC=[[UserBaseViewController alloc] init];
        infoVC.isServingIn=YES;
        infoVC.userId=self.userModel.user_id;
        [self.navigationController pushViewController:infoVC animated:YES];
    }else if ([msgType isEqualToString:@"bloodRecord"]){ //糖档案
        BloodFileViewController *filesVC=[[BloodFileViewController alloc] init];
        filesVC.user_id=self.userModel.user_id;
        [self.navigationController pushViewController:filesVC animated:YES];
    }else if ([msgType isEqualToString:@"checkForm"]){ //检查单
        TCHistoryRecordsViewController *historyRecordsVC=[[TCHistoryRecordsViewController alloc] init];
        historyRecordsVC.typeStr=@"检查单";
        historyRecordsVC.userID=self.userModel.user_id;
        [self.navigationController pushViewController:historyRecordsVC animated:YES];
    }else if ([msgType isEqualToString:@"comment"]&&!self.userModel.isHelper){ //评价
        TCCommentMineViewController *evaluateVC=[[TCCommentMineViewController alloc] init];
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }
}

#pragma mark 点击头像
-(void)chatVCDidSelectUserAtavarWithName:(NSString *)nickName{
    NSString *userName=kIsEmptyString(self.userModel.remark)?self.userModel.nick_name:self.userModel.remark;
    if ([nickName isEqualToString:userName]) {
        UserDetailViewController  *userDetailVC=[[UserDetailViewController alloc] init];
        userDetailVC.userID=self.userModel.user_id;
        userDetailVC.titleStr=kIsEmptyString(self.userModel.remark)?self.userModel.nick_name:self.userModel.remark;
        [self.navigationController pushViewController:userDetailVC animated:YES];
    }else{
        NSInteger expertID=0;
        NSString *myName=[NSUserDefaultsInfos getValueforKey:kNickName];
        if (self.userModel.isHelper) {  //助手
            expertID=[nickName isEqualToString:myName]?0:self.userModel.expert_id;
        }else{ //专家
            expertID=[nickName isEqualToString:myName]?0:self.userModel.helper_id;
        }
        
        MineInfoViewController *mineInfoVC=[[MineInfoViewController alloc] init];
        mineInfoVC.expert_id=expertID;
        [self.navigationController pushViewController:mineInfoVC animated:YES];
    }
}

#pragma mark QuestionnaireViewControllerDelegate
-(void)questionnaireViewController:(QuestionnaireViewController *)viewController didSelectQuestionnaire:(NSDictionary *)questionDict{
    if (self.chatVC) {
        [self.chatVC sendQuestionnarieMessage:questionDict];
    }
}

#pragma mark -- Getters
#pragma mark 菜单栏
-(ClickViewGroup *)viewGroup{
    if (!_viewGroup) {
        _viewGroup=[[ClickViewGroup alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40) titles:@[@"对话",@"服务情况"] color:kSystemColor];
        _viewGroup.viewDelegate=self;
    }
    return _viewGroup;
}

#pragma mark 对话界面
-(ChatViewController *)chatVC{
    if (!_chatVC) {
        if (kIsEmptyString(self.userModel.im_groupid)) {
            _chatVC=[[ChatViewController alloc] initWithConversationChatter:self.userModel.im_username conversationType:EMConversationTypeChat];
        }else{
           _chatVC=[[ChatViewController alloc] initWithConversationChatter:self.userModel.im_groupid conversationType:EMConversationTypeGroupChat];
        }
        
        _chatVC.userModel=self.userModel;
        _chatVC.view.frame=CGRectMake(0, self.viewGroup.bottom, kScreenWidth, kRootViewHeight-40);
        _chatVC.chatdelegate=self;
    }
    return _chatVC;
}

#pragma mark 服务情况
-(TCServiceStateViewController *)serviceStateVC{
    if (!_serviceStateVC) {
        _serviceStateVC=[[TCServiceStateViewController alloc] init];
        _serviceStateVC.userID=self.userModel.user_id;
        _serviceStateVC.expert_id=self.userModel.expert_id;
        _serviceStateVC.view.frame=CGRectMake(0, self.viewGroup.bottom, kScreenWidth, kRootViewHeight-40);
        _serviceStateVC.controllerDelegate=self;
    }
    return _serviceStateVC;
}

@end
