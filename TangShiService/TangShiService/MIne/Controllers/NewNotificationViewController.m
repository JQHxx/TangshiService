//
//  NewNotificationViewController.m
//  TangShiService
//
//  Created by 肖栋 on 17/9/6.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "NewNotificationViewController.h"

@interface NewNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BOOL                   isSetNewSound;
    BOOL                   isSetVibration;
    
    BOOL                   isSetNewFriend;
    BOOL                   isSetLookForMe;
    BOOL                   isSetComments;
    BOOL                   isSetPraise;
    
    NSArray                *titleArr;
    NSInteger               fun_type;
    NSInteger               isopen;
    
    NSDictionary           *result;
}

@property (nonatomic,strong)UITableView  *setNewNotificationTab;

@end

@implementation NewNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.baseTitle = @"消息通知";
    
    titleArr = @[@[@"新消息通知"],@[@"声音",@"振动"],@[@"新朋友提醒",@"@我的提醒",@"评论我的提醒",@"赞我的提醒"]];
//    NSString *sound=[SSKeychain passwordForService:kPushPlaySound account:kSetPushOption];
    NSString *sound=[NSUserDefaultsInfos getValueforKey:kPushPlaySound];
    isSetNewSound=[sound integerValue]>0?YES:NO;
    
//    NSString *vebration=[SSKeychain passwordForService:kPushPlayVebration account:kSetPushOption];
    NSString *vebration=[NSUserDefaultsInfos getValueforKey:kPushPlayVebration];
    isSetVibration=[vebration integerValue]>0?YES:NO;
    
    [self.view addSubview:self.setNewNotificationTab];
    [self requestFreindReminderDataForType:0 isOpen:NO];

}
#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.text=titleArr[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        cell.detailTextLabel.text = [self isNotificationSettings]?@"已启用":@"已关闭";
    }else if (indexPath.section==1){
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-70, 5.0f, 60.0f, 34.0f)];
        switchView.on = indexPath.row==0?isSetNewSound:isSetVibration;
        switchView.tag=indexPath.row+10;
        [switchView addTarget:self action:@selector(setPushSwitchAction:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
        [cell.contentView addSubview: switchView];
    }else{
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-70, 5.0f, 60.0f, 34.0f)];
        switchView.on = isSetNewFriend;
        switchView.tag= indexPath.row+10;
        [switchView addTarget:self action:@selector(setsugarSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview: switchView];
        
        if (indexPath.row==0) {
            switchView.on = isSetNewFriend;
        }else if (indexPath.row==1){
            switchView.on = isSetLookForMe;
        }else if (indexPath.row==2){
            switchView.on = isSetComments;
        }else{
            switchView.on = isSetPraise;
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = [UIColor bgColor_Gray];
    if (section==1) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth/2, 20)];
        titleLabel.text = @"聊天消息提醒";
        titleLabel.textColor = [UIColor grayColor];
        [headView addSubview:titleLabel];
    }else if (section==2){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth/2, 20)];
        titleLabel.text = @"糖友圈提醒";
        titleLabel.textColor = [UIColor grayColor];
        [headView addSubview:titleLabel];
    }
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        NSString *title =@"请在iPhone的“设置” - “通知”中找到“糖士服务端”，并允许通知";
        CGSize size = [title sizeWithLabelWidth:kScreenWidth-10 font:[UIFont systemFontOfSize:15]];
        return size.height+20;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    footView.backgroundColor = [UIColor bgColor_Gray];
    if (section==0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-10, 0)];
        titleLabel.text = @"请在iPhone的“设置” - “通知”中找到“糖士服务端”，并允许通知";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.numberOfLines = 0;
        CGSize size = [titleLabel.text sizeWithLabelWidth:kScreenWidth-20 font:[UIFont systemFontOfSize:15]];
        titleLabel.frame = CGRectMake(10, 5, kScreenWidth-10, size.height);
        [footView addSubview:titleLabel];
        footView.frame = CGRectMake(0, 0, kScreenWidth, size.height+10);
    }
    return footView;
}
#pragma mark -- Event Response
#pragma mark 消息声音和震动设置
-(void)setPushSwitchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (switchButton.tag==10) {
        isSetNewSound=isButtonOn;
        NSNumber *soundOn=[NSNumber numberWithBool:isSetNewSound];
        [NSUserDefaultsInfos putKey:kPushPlaySound andValue:[NSString stringWithFormat:@"%@",soundOn]];
//        [SSKeychain setPassword:[NSString stringWithFormat:@"%@",soundOn] forService:kPushPlaySound account:kSetPushOption];
    }else{
        isSetVibration=isButtonOn;
        NSNumber *vebrationOn=[NSNumber numberWithBool:isSetVibration];
        [NSUserDefaultsInfos putKey:kPushPlayVebration andValue:[NSString stringWithFormat:@"%@",vebrationOn]];
//        [SSKeychain setPassword:[NSString stringWithFormat:@"%@",vebrationOn] forService:kPushPlayVebration account:kSetPushOption];
    }
}
#pragma mark 新朋友／@我的／我评论的／我赞的提醒
-(void)setsugarSwitchAction:(UISwitch *)sender{
    isopen = sender.on;
    if (sender.tag==10) {
        fun_type= 1;
    }else if(sender.tag==11){
        fun_type= 2;
    }else if (sender.tag==12){
        fun_type= 3;
    }else{
        fun_type= 4;
    }
    [self requestFreindReminderDataForType:fun_type isOpen:isopen];
}
#pragma mark -- Private Methods
#pragma mark 糖友圈提醒查看
-(void)requestFreindReminderDataForType:(NSInteger)type isOpen:(BOOL)isOpen{
    NSString *body=[NSString stringWithFormat:@"doSubmit=0&role_type=2"];
    if (type==0) {
        body=@"doSubmit=0&role_type=2";
    }else{
        body=[NSString stringWithFormat:@"doSubmit=1&role_type=2&fun_type=%ld&is_news_attr=%ld",fun_type,isopen];
    }
    kSelfWeak;
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kattr_setUpdate body:body success:^(id json) {
        result=[json objectForKey:@"result"];
        isSetNewFriend =  [[result valueForKey:@"is_news_follow"] boolValue];
        isSetLookForMe =  [[result valueForKey:@"is_news_at"] boolValue];
        isSetComments  =  [[result valueForKey:@"is_news_comment"] boolValue];
        isSetPraise    =  [[result valueForKey:@"is_news_like"] boolValue];

        [_setNewNotificationTab reloadData];
    } failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark -- Setters and Getters
#pragma mark 信息设置列表
-(UITableView *)setNewNotificationTab{
    if (!_setNewNotificationTab) {
        _setNewNotificationTab=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _setNewNotificationTab.dataSource=self;
        _setNewNotificationTab.delegate=self;
        _setNewNotificationTab.backgroundColor=[UIColor bgColor_Gray];
    }
    return _setNewNotificationTab;
}

#pragma mark 判断是否开启通知
-(BOOL)isNotificationSettings{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        MyLog(@"推送关闭 8.0");
        return NO;
    }else{
        MyLog(@"推送打开 8.0");
        return YES;
    }
}

@end
