//
//  MineViewController.m
//  TangShiService
//
//  Created by vision on 17/5/23.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "MineViewController.h"
#import "MineInfoViewController.h"
#import "FeebackViewController.h"
#import "AboutUsViewController.h"
#import "SetViewController.h"
#import "TCMineServiceViewController.h"
#import "ExpertModel.h"



@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray     *imgArr;
    NSArray     *rowsArr;
    ExpertModel *expert;
    
    BOOL              isFeedbackNewMessage;

}

@property (nonatomic,strong)UITableView  *mineTableView;
//  红点标记
@property (nonatomic,strong)UILabel              *badgeLbl;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"我的";
    self.isHiddenBackBtn = YES;
    isFeedbackNewMessage = YES;

    imgArr=@[@"ic_m_feedback",@"ic_m_call",@"ic_m_about"];
    rowsArr=@[@"意见反馈",@"客服电话",@"关于我们"];
    expert=[[ExpertModel alloc] init];
    [self.view addSubview:self.mineTableView];
    [self requestExpertInfo];
    
    [self loadNewBackMessage];
}

#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==2?rowsArr.count:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0) {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
        imgView.layer.cornerRadius=30;
        imgView.clipsToBounds=YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:expert.head_portrait] placeholderImage:[UIImage imageNamed:@"ic_m_head_156"]];
        [cell.contentView addSubview:imgView];
        
        UILabel *nickNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, 15, kScreenWidth-imgView.right-40, 30)];
        nickNameLbl.text=expert.name;
        nickNameLbl.textColor=[UIColor blackColor];
        nickNameLbl.font=[UIFont boldSystemFontOfSize:16];
        [cell.contentView addSubview:nickNameLbl];
        
        UILabel *ageLbl=[[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, nickNameLbl.bottom,kScreenWidth-imgView.right-40, 30)];
        ageLbl.text=expert.expert_type;
        ageLbl.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:ageLbl];
        
    }else if (indexPath.section==1){
        cell.imageView.image=[UIImage imageNamed:@"ic_user_week"];
        cell.textLabel.text=@"我的服务订单";
    }else if(indexPath.section==2){
        cell.imageView.image=[UIImage imageNamed:imgArr[indexPath.row]];
        cell.textLabel.text=rowsArr[indexPath.row];
        if (indexPath.row==1) {
            cell.accessoryType=UITableViewCellAccessoryNone;
            
            UILabel *phoneLbl=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-190, 12, 160, 20)];
            phoneLbl.font=[UIFont boldSystemFontOfSize:14];
            phoneLbl.textColor = [UIColor lightGrayColor];
            phoneLbl.textAlignment = NSTextAlignmentRight;
            NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@转605",PHONE_NUMBER]];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:kbgBtnColor range:NSMakeRange(0, 13)];
            phoneLbl.attributedText=attributeStr;
            [cell.contentView addSubview:phoneLbl];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }else if (indexPath.row==0){
            [cell.contentView addSubview:self.badgeLbl];
            self.badgeLbl.hidden=isFeedbackNewMessage;
        }
    }else{
        cell.imageView.image=[UIImage imageNamed:@"ic_m_setting"];
        cell.textLabel.text=@"设置";
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        MineInfoViewController *infoVC=[[MineInfoViewController alloc] init];
        infoVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }else if (indexPath.section==1){
        TCMineServiceViewController *myServiceVC=[[TCMineServiceViewController alloc] init];
        myServiceVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myServiceVC animated:YES];
    }else if(indexPath.section==2){
        if (indexPath.row==0){
            FeebackViewController *feebackVC=[[FeebackViewController alloc] init];
            feebackVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:feebackVC animated:YES];
        }else if (indexPath.row==1){
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",PHONE_NUMBER];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            AboutUsViewController *aboutUsVC=[[AboutUsViewController alloc] init];
            aboutUsVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    }else{
        SetViewController *setVC=[[SetViewController alloc] init];
        setVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
#pragma mark -- 获取最新反馈信息
- (void)loadNewBackMessage{
    
    NSString *body = [NSString stringWithFormat:@"role_type=2"];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithoutLoadingForURL:KFeedbackNewMessage body:body success:^(id json) {
        NSInteger result = [[json objectForKey:@"result"] integerValue];
        isFeedbackNewMessage = result==0;
        [self.mineTableView reloadData];
    } failure:^(NSString *errorStr) {
        [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark 获取专家信息
-(void)requestExpertInfo{
    NSDictionary *expertDict=[NSUserDefaultsInfos getValueforKey:kExpertInfoKey];
    if (kIsDictionary(expertDict)&&expertDict.count>0) {
        [expert setValues:expertDict];
        [self.mineTableView reloadData];
    }else{
        __weak typeof(self) weakSelf=self;
        [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:kExpertInfo success:^(id json) {
            NSDictionary *result=[json objectForKey:@"result"];
            if (kIsDictionary(result)&&result.count>0) {
                [expert setValues:result];
                [NSUserDefaultsInfos putKey:kExpertInfoKey andValue:result];
                [weakSelf.mineTableView reloadData];
            }
        } failure:^(NSString *errorStr) {
            [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        }];
    }
    
}


#pragma mark -- Getters and Setters
-(UITableView *)mineTableView{
    if (!_mineTableView) {
        _mineTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight-kTabHeight) style:UITableViewStyleGrouped];
        _mineTableView.dataSource=self;
        _mineTableView.delegate=self;
        _mineTableView.showsVerticalScrollIndicator=NO;
        _mineTableView.tableFooterView=[[UIView alloc] init];
        _mineTableView.backgroundColor=[UIColor bgColor_Gray];
    }
    return _mineTableView;
}

#pragma mark 红色标记
-(UILabel *)badgeLbl{
    if (_badgeLbl==nil) {
        _badgeLbl=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-40, 18, 8, 8)];
        _badgeLbl.backgroundColor=[UIColor redColor];
        _badgeLbl.layer.cornerRadius=5;
        _badgeLbl.clipsToBounds=YES;
        _badgeLbl.textColor=[UIColor whiteColor];
        _badgeLbl.textAlignment=NSTextAlignmentCenter;
        _badgeLbl.font=[UIFont systemFontOfSize:10];
        _badgeLbl.hidden = YES;
    }
    return _badgeLbl;
}
@end
