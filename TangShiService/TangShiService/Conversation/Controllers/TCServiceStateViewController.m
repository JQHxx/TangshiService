//
//  TCServiceStateViewController.m
//  TonzeCloud
//
//  Created by vision on 17/6/21.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCServiceStateViewController.h"
#import "TCServiceDetailViewController.h"
#import "TCServiceStateCell.h"
#import "TCMineServiceModel.h"
#import "TCBlankView.h"

@interface TCServiceStateViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray  *currentServicesArray;
    NSMutableArray  *historyServicesArray;
}

@property (nonatomic,strong)UITableView   *stateTableView;
@property (nonatomic,strong)TCBlankView      *blankView;

@end

@implementation TCServiceStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=self.isUserDetail?@"服务情况":@"";
    
    if (self.isUserDetail) {
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backItem];
    }
    
    
    currentServicesArray=[[NSMutableArray alloc] init];
    historyServicesArray=[[NSMutableArray alloc] init];
    
    [self.view addSubview:self.stateTableView];
    [self.stateTableView addSubview:self.blankView];
    self.blankView.hidden=YES;
    
    [self requestMyServiceStateInfo];
}



#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?currentServicesArray.count:historyServicesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"TCServiceStateCell";
    TCServiceStateCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[TCServiceStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    TCMineServiceModel *service=indexPath.section==0?currentServicesArray[indexPath.row]:historyServicesArray[indexPath.row];
    cell.myService=service;
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCMineServiceModel *service=indexPath.section==0?currentServicesArray[indexPath.row]:historyServicesArray[indexPath.row];
    if (self.isUserDetail) {
        TCServiceDetailViewController *serviceDetailVC=[[TCServiceDetailViewController alloc] init];
        serviceDetailVC.myService=service;
        [self.navigationController pushViewController:serviceDetailVC animated:YES];
    }else{
        if ([_controllerDelegate respondsToSelector:@selector(serviceStateVCDidSelectedCellWithModel:)]) {
            [_controllerDelegate serviceStateVCDidSelectedCellWithModel:service];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headStr=@"";
    if (section==0) {
        headStr=currentServicesArray.count>0?@"当前服务":@"";
    }else{
        headStr=historyServicesArray.count>0?@"服务历史":@"";
    }
    return headStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headHeight=5;
    if (section==0) {
        headHeight=currentServicesArray.count>0?30:5;
    }else{
        headHeight=historyServicesArray.count>0?30:5;
    }
    return headHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


#pragma mark -- Event response
#pragma mark 返回
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Private Methods
#pragma mark 获取服务情况
-(void)requestMyServiceStateInfo{
    __weak typeof(self) weakSelf=self;
    NSString *urlString = [NSString stringWithFormat:@"%@?user_id=%ld&expert_id=%ld",kGetUserServices,(long)self.userID,(long)self.expert_id];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:urlString success:^(id json) {
        NSArray  *dataArray = [json objectForKey:@"result"];
        NSMutableArray *currentTempArray = [[NSMutableArray alloc] init];
        NSMutableArray *historyTempArray = [[NSMutableArray alloc] init];
        if (kIsArray(dataArray)) {
            for (int i=0; i<dataArray.count; i++) {
                TCMineServiceModel *mineModel = [[TCMineServiceModel alloc] init];
                NSDictionary *dict=[dataArray objectAtIndex:i];
                [mineModel setValues:dict];
                if (mineModel.service_status==1) {
                    [currentTempArray addObject:mineModel];
                }else{
                    [historyTempArray addObject:mineModel];
                }
            }
            weakSelf.blankView.hidden=dataArray.count>0;
            currentServicesArray=currentTempArray;
            historyServicesArray=historyTempArray;
            [weakSelf.stateTableView reloadData];
        }
    }failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}


#pragma mark -- Getters
#pragma mark 服务情况
-(UITableView *)stateTableView{
    if (!_stateTableView) {
        CGFloat tableHeight=self.isUserDetail?kRootViewHeight:kRootViewHeight-40;
        _stateTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.isUserDetail?64:0, kScreenWidth, tableHeight) style:UITableViewStyleGrouped];
        _stateTableView.delegate=self;
        _stateTableView.dataSource=self;
        _stateTableView.backgroundColor=[UIColor bgColor_Gray];
        _stateTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _stateTableView;
}


#pragma mark 空白页
-(TCBlankView *)blankView{
    if (!_blankView) {
        _blankView=[[TCBlankView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 200) img:@"img_tips_no" text:@"暂无服务"];
    }
    return _blankView;
}

@end
