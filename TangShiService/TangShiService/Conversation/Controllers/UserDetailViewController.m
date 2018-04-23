//
//  UserDetailViewController.m
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserBaseViewController.h"
#import "BloodFileViewController.h"
#import "UserModel.h"
#import "BloodRecordModel.h"
#import "ChatViewController.h"
#import "ConversationViewController.h"
#import "TCSugarDataViewController.h"
#import "TCServiceStateViewController.h"
#import "TCHistoryRecordsViewController.h"
#import "ChangeGroupViewController.h"
#import "TCServicingViewController.h"
#import "YBPopupMenu.h"

@interface UserDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,UITextFieldDelegate>{
    UIButton       *moreButton;
    UITextField    *remarkText;
    
    NSArray        *imagesArray;
    NSArray        *titlesArray;
    
    UserModel      *user;

    NSDictionary   *bloodRecordDict;
    
    NSMutableArray  *groupList;
}

@property (nonatomic,strong)UITableView  *userTableView;

@property (nonatomic,strong)UIButton     *toChatButton;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=self.titleStr;
    
    moreButton=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 20, 30, 40)];
    [moreButton setImage:[UIImage imageNamed:@"ic_n_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(showMoreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreButton];
    
    imagesArray=@[@"ic_user_service",@"ic_user_files",@"ic_user_history"];
    titlesArray=@[@"服务情况",@"糖档案",@"所有历史记录"];
    
    user=[[UserModel alloc] init];
    bloodRecordDict=[[NSDictionary alloc] init];
    groupList=[[NSMutableArray alloc] init];
    
    [self.view addSubview:self.userTableView];
    [self.userTableView addSubview:self.toChatButton];
    self.toChatButton.hidden=YES;
    
    [self loaduserDetailInfo];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return user.isHelper&&groupList.count>0?4:3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (user.isHelper&&groupList.count>0){
        if (section==2) {
            return titlesArray.count;
        }else if (section==3){
            return groupList.count;
        }else{
            return 1;
        }
    }else{
      return section==2?titlesArray.count:1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"UserTableViewCell";
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    BOOL flag=user.isHelper&&groupList.count>0&&indexPath.section==3;
    if (flag) {
        cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0);
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"ic_m_head"]];
        [cell.contentView addSubview:imgView];
        
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, 10, kScreenWidth-imgView.right-40, 40)];
        NSString *nickName=kIsEmptyString(user.remark)?user.nick_name:user.remark;
        NSString *expertName=[groupList[indexPath.row] objectForKey:@"expert_name"];
        titleLbl.text=[NSString stringWithFormat:@"%@-%@",expertName,nickName];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:titleLbl];
        
        UIImageView *arrowView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30, (44-15)/2, 20, 20)];
        arrowView.image=[UIImage imageNamed:@"ic_list_arrow_left"];
        [cell.contentView addSubview:arrowView];
        
    }else{
        if (indexPath.section==0) {
            UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2, 10, 60, 60)];
            imgView.layer.cornerRadius=30;
            imgView.clipsToBounds=YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"ic_m_head"]];
            [cell.contentView addSubview:imgView];
            
            UIImageView *sexImageView=[[UIImageView alloc] initWithFrame:CGRectMake(imgView.right, 40,30, 30)];
            [cell.contentView addSubview:sexImageView];
            if (user.sex<1||user.sex>2) {
                sexImageView.hidden=YES;
            }else{
                sexImageView.image=[UIImage imageNamed:user.sex==1?@"ic_m_male":@"ic_m_famale"];
            }
            
            UILabel *ageLbl=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, imgView.bottom+7, 40, 25)];
            NSString *birthdayStr=[[TCHelper sharedTCHelper] timeWithTimeIntervalString:user.birthday format:@"yyyy-MM-dd"];
            if (!kIsEmptyString(birthdayStr)&&[birthdayStr isEqualToString:@"1970-01-01"]) {
                ageLbl.text=@"--";
            }else{
                NSString *ageStr=[[TCHelper sharedTCHelper] dateToOldForTimeSp:user.birthday format:@"yyyy-MM-dd"];
                ageLbl.text=[NSString stringWithFormat:@"%@岁",ageStr];
            }
            ageLbl.font=[UIFont systemFontOfSize:14];
            ageLbl.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:ageLbl];
            
            UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, imgView.bottom+15, 1, 10)];
            line.backgroundColor=kLineColor;
            [cell.contentView addSubview:line];
            
            UILabel *bloodLbl=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2+10, imgView.bottom+7, kScreenWidth/2-10, 25)];
            bloodLbl.text=kIsEmptyString(user.diabetes_type)?@"未知类型":user.diabetes_type;
            bloodLbl.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:bloodLbl];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.section==1){
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
            imgView.image=[UIImage imageNamed:@"ic_user_week"];
            [cell.contentView addSubview:imgView];
            
            UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, 7, kScreenWidth-imgView.right-40, 30)];
            titleLbl.text=@"最近一周血糖档案";
            titleLbl.textColor=[UIColor blackColor];
            titleLbl.font=[UIFont systemFontOfSize:14];
            [cell.contentView addSubview:titleLbl];
            
            UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(10, titleLbl.bottom+7, kScreenWidth-10, 1)];
            line.backgroundColor=kLineColor;
            [cell.contentView addSubview:line];
            
            NSArray *colorsArr=@[@"#fa6f6e",@"#37deba",@"#ffd03e"];
            NSArray *titlesArr=@[@"偏高",@"正常",@"偏低"];
            for (NSInteger i=0; i<3; i++) {
                UILabel *countLbl=[[UILabel alloc] initWithFrame:CGRectMake(10+i*(kScreenWidth/3), line.bottom+5, kScreenWidth/3-20, 35)];
                countLbl.font=[UIFont systemFontOfSize:14];
                countLbl.textColor=[UIColor colorWithHexString:@"#313131"];
                countLbl.textAlignment=NSTextAlignmentCenter;
                NSInteger count=[[bloodRecordDict valueForKey:titlesArr[i]] integerValue];
                NSMutableAttributedString *attributeAtr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld次",(long)count]];
                [attributeAtr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32] range:NSMakeRange(0, attributeAtr.length-1)];
                [attributeAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#626262"] range:NSMakeRange(0, attributeAtr.length-1)];
                countLbl.attributedText=attributeAtr;
                [cell.contentView addSubview:countLbl];
                
                CGFloat contentW=kScreenWidth/3;
                UILabel *badgeLbl=[[UILabel alloc] initWithFrame:CGRectMake(i*contentW+(contentW/2-30), countLbl.bottom+8, 10, 10)];
                badgeLbl.backgroundColor=[UIColor colorWithHexString:colorsArr[i]];
                badgeLbl.layer.cornerRadius=5;
                badgeLbl.clipsToBounds=YES;
                [cell.contentView addSubview:badgeLbl];
                
                UILabel *textLbl=[[UILabel alloc] initWithFrame:CGRectMake(badgeLbl.right, countLbl.bottom, 40, 25)];
                textLbl.textAlignment=NSTextAlignmentCenter;
                textLbl.text=titlesArr[i];
                textLbl.font=[UIFont systemFontOfSize:14];
                textLbl.textColor=[UIColor colorWithHexString:@"#313131"];
                [cell.contentView addSubview:textLbl];
                
            }
            
            UIImageView *arrowView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30, (44-15)/2, 20, 20)];
            arrowView.image=[UIImage imageNamed:@"ic_list_arrow_left"];
            [cell.contentView addSubview:arrowView];
            
            for (NSInteger i=0; i<2; i++) {
                UILabel *line2=[[UILabel alloc] initWithFrame:CGRectMake((i+1)*(kScreenWidth/3),line.bottom+20,1, 35)];
                line2.backgroundColor=kLineColor;
                [cell.contentView addSubview:line2];
            }
            
        }else{
            cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0);
            cell.imageView.image=[UIImage imageNamed:imagesArray[indexPath.row]];
            cell.textLabel.text=titlesArray[indexPath.row];
            
            UIImageView *arrowView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-30, (60-15)/2, 20, 20)];
            arrowView.image=[UIImage imageNamed:@"ic_list_arrow_left"];
            [cell.contentView addSubview:arrowView];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BOOL flag=user.isHelper&&groupList.count>0&&indexPath.section==3;
    if (flag) {
        NSDictionary *groupDict=groupList[indexPath.row];
        user.helperHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
        user.helperUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
        user.expertHeadPic=groupDict[@"head_portrait"];
        user.expertUserName=groupDict[@"expert_name"];
        user.im_expertname=groupDict[@"im_username"];
        user.im_groupid=groupDict[@"im_groupid"];
        user.expert_id=[groupDict[@"expert_id"] integerValue];
        
        TCServicingViewController* servicingController = [[TCServicingViewController alloc] init];
        servicingController.userModel=user;
        [self.navigationController pushViewController:servicingController animated:YES];
    }else{
        if (indexPath.section==0) {
            UserBaseViewController *userBaseVC=[[UserBaseViewController alloc] init];
            userBaseVC.userModel=user;
            [self.navigationController pushViewController:userBaseVC animated:YES];
        }else if(indexPath.section==1){
            TCSugarDataViewController *sugarDataVC=[[TCSugarDataViewController alloc] init];
            sugarDataVC.userID=self.userID;
            [self.navigationController pushViewController:sugarDataVC animated:YES];
        }else{
            if (indexPath.row==0) {
                TCServiceStateViewController *serviceStateVC=[[TCServiceStateViewController alloc] init];
                serviceStateVC.userID=self.userID;
                serviceStateVC.isUserDetail=YES;
                [self.navigationController pushViewController:serviceStateVC animated:YES];
            }else if (indexPath.row==1){
                BloodFileViewController *bloodFileVC=[[BloodFileViewController alloc] init];
                bloodFileVC.user_id=self.userID;
                [self.navigationController pushViewController:bloodFileVC animated:YES];
            }else{
                TCHistoryRecordsViewController *recordsVC=[[TCHistoryRecordsViewController alloc] init];
                recordsVC.userID=self.userID;
                [self.navigationController pushViewController:recordsVC animated:YES];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL flag=user.isHelper&&groupList.count>0&&indexPath.section==3;
    if (flag) {
        return 60;
    }else{
        if (indexPath.section==0) {
            return 110;
        }else if (indexPath.section==1){
            return 120;
        }else{
            return 44;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return user.isHelper&&groupList.count>0&&section==3?30:0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return user.isHelper&&groupList.count>0&&section==3?@"群聊":nil;
}

#pragma mark -- YBPopupMenuDelegate
-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (index== 0) {
        [self remarkUserName];
    }else if(index==1) {
        ChangeGroupViewController *changeGroupVC=[[ChangeGroupViewController alloc] init];
        changeGroupVC.groupId=[user.group_id integerValue];
        changeGroupVC.user_id=self.userID;
        [self.navigationController pushViewController:changeGroupVC animated:YES];
    }
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    [remarkText resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([[TCHelper sharedTCHelper] isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([[TCHelper sharedTCHelper] hasEmoji:string] || [[TCHelper sharedTCHelper] strIsContainEmojiWithStr:string]){
                return NO;
            }
        }
    }
    if ([string isEqualToString:@"n"])
    {
        return YES;
    }
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    return YES;
}


#pragma mark -- Event Response
-(void)toChatForSendMessage{
    BOOL flag=NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ConversationViewController class]]) {
            flag=YES;
        }
    }
    if (flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        TCServicingViewController* servicingController = [[TCServicingViewController alloc] init];
        servicingController.userModel=user;
        [self.navigationController pushViewController:servicingController animated:YES];
    }
}

#pragma mark 更多弹出框
-(void)showMoreAction{
    [YBPopupMenu showRelyOnView:moreButton titles:@[@"备注名称",@"更改分组"] icons:@[@"",@""] menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.borderWidth = 0.5;
        popupMenu.borderColor = [UIColor colorWithHexString:@"0xeeeeeee"];
        popupMenu.delegate = self;
        popupMenu.textColor = [UIColor colorWithHexString:@"0x626262"];
        popupMenu.fontSize = 14;
    }];
}

#pragma mark -- Private methods
#pragma mark 加载用户信息
-(void)loaduserDetailInfo{
    __weak typeof(self) weakself = self;
    NSString *userStr=[NSString stringWithFormat:@"%@?user_id=%ld",kGetUserDetail,(long)self.userID];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:userStr success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            NSArray *bloodList=[result valueForKey:@"blood_list"];
            NSInteger highCount=0;
            NSInteger normalCount=0;
            NSInteger lowCount=0;
            if (bloodList.count>0) {
                for (NSInteger i=0; i<bloodList.count; i++) {
                    NSDictionary *dict=bloodList[i];
                    BloodRecordModel *record=[[BloodRecordModel alloc] init];
                    [record setValues:dict];
                    
                    NSString *periodCh=[[TCHelper sharedTCHelper] getPeriodChNameForPeriodEn:record.time_slot]; //时间段 英文转中文
                    NSDictionary *limitDict=[[TCHelper sharedTCHelper] getNormalValueDictWithPeriodString:periodCh]; // 获取对应时间段的血糖值范围
                    double maxValue=[limitDict[@"max"] doubleValue];
                    double minValue=[limitDict[@"min"] doubleValue];
                    double value=[record.glucose doubleValue];
                    if (value>0.01) {
                        if (value<minValue) {
                            lowCount++;
                        }else if (value>maxValue) {
                            highCount++;
                        }else{
                            normalCount++;
                        }
                    }
                }
            }
            bloodRecordDict=@{@"偏高":[NSNumber numberWithInteger:highCount],
                              @"正常":[NSNumber numberWithInteger:normalCount],
                              @"偏低":[NSNumber numberWithInteger:lowCount]};
            
            
            
            NSDictionary *userInfoDict=[result valueForKey:@"user_info"];
            [user setValues:userInfoDict];
            
            NSArray *helperList=[result valueForKey:@"helperList"];
            
            BOOL isHelper=[[result valueForKey:@"is_helper"] boolValue];
            user.isHelper=isHelper;
            self.toChatButton.hidden=user.isHelper&&kIsArray(helperList)&&helperList.count>0;
            
            if (kIsArray(helperList)&&helperList.count>0) {
                if (isHelper) {  //当前用户为助手
                    user.im_helpername=kIsEmptyString(user.im_helpername)?[NSUserDefaultsInfos getValueforKey:kImUsername]:user.im_helpername;
                    groupList=[NSMutableArray arrayWithArray:helperList];
                }else{   //当前用户为专家
                    NSDictionary *helperDict=helperList[0];
                    user.helperHeadPic=helperDict[@"head_portrait"];
                    user.helperUserName=helperDict[@"expert_name"];
                    user.im_helpername=helperDict[@"im_username"];
                    user.expertHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                    user.expertUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
                    user.im_groupid=helperDict[@"im_groupid"];
                }
            }else{
                user.expertHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                user.expertUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
            }
        }
        [weakself.userTableView reloadData];
    } failure:^(NSString *errorStr) {
        [weakself.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark 备注名称
-(void)remarkUserName{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"备注名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"请输入备注名称"];
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setDelegate:self];
        remarkText=textField;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    __weak typeof(self) weakSelf=self;
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        alertController.textFields.firstObject.text = [alertController.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *toBeString=alertController.textFields.firstObject.text;
        NSString *remarkName=nil;
        if (toBeString.length<1) {
            [weakSelf.view makeToast:@"分组名称不能为空" duration:1.0 position:CSToastPositionCenter];
        }else if (toBeString.length>8) {
            [weakSelf.view makeToast:@"不能超过8个字" duration:1.0 position:CSToastPositionCenter];
        }else{
            [alertController.textFields.firstObject resignFirstResponder];
            remarkName=toBeString;
            NSString *body=[NSString stringWithFormat:@"user_id=%ld&remark=%@",(long)self.userID,remarkName];
            [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kSetRemarkName body:body success:^(id json) {
                self.baseTitle=user.remark=remarkName;
                weakSelf.title=remarkName;
                [TCHelper sharedTCHelper].isUserGroupReload=YES;
            } failure:^(NSString *errorStr) {
                [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            }];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    alertController.view.layer.cornerRadius = 20;
    alertController.view.layer.masksToBounds = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- Setters and Getters
-(UITableView *)userTableView{
    if (!_userTableView) {
        _userTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStyleGrouped];
        _userTableView.delegate=self;
        _userTableView.dataSource=self;
        _userTableView.backgroundColor=[UIColor bgColor_Gray];
        _userTableView.tableFooterView=[[UIView alloc] init];
    }
    return _userTableView;
}

#pragma mark 聊天按钮
-(UIButton *)toChatButton{
    if (!_toChatButton) {
        _toChatButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 420, kScreenWidth-40, 45)];
        [_toChatButton setTitle:@"发消息" forState:UIControlStateNormal];
        _toChatButton.backgroundColor=kSystemColor;
        [_toChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toChatButton.layer.cornerRadius=5;
        _toChatButton.clipsToBounds=YES;
        [_toChatButton addTarget:self action:@selector(toChatForSendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toChatButton;
}

@end
