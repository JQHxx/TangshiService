//
//  TCMineServiceViewController.m
//  TonzeCloud
//
//  Created by 肖栋 on 17/2/19.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCMineServiceViewController.h"
#import "TCMineServiceCell.h"
#import "TCMineServiceModel.h"
#import "TCServicingViewController.h"
#import "ClickViewGroup.h"
#import "TCServiceDetailViewController.h"
#import "ConversationModel.h"
#import "MJRefresh.h"
#import "TCBlankView.h"

@interface TCMineServiceViewController()<UITableViewDataSource,UITableViewDelegate,ClickViewGroupDelegate,TCMineServiceDelegate>{
    NSMutableArray      *myServiceArray;     //我的服务
    NSInteger           servicePage;      //服务页数
    NSInteger           selectIndex;

}

@property (nonatomic,strong)ClickViewGroup      *myServiceMenu;
@property (nonatomic,strong)UITableView         *myServiceTableView;
@property (nonatomic,strong)TCBlankView         *blankView;

@end

@implementation TCMineServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"我的服务订单";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    
    myServiceArray = [[NSMutableArray alloc] init];
    
    servicePage=1;
    selectIndex=0;
    
    [self initServiceView];
    [self loadNewMineServiceData];
}


#pragma mark --UITableViewDelegate and UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myServiceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"TCMineServiceCell";
    TCMineServiceCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[TCMineServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.serviceDelegate=self;
    
    TCMineServiceModel *mineModel =myServiceArray[indexPath.row];
    mineModel.service_status=selectIndex+1;
    [cell cellDisplayWithDict:mineModel index:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCMineServiceModel *mineModel =myServiceArray[indexPath.row];
    
    TCServiceDetailViewController *serviceDetailVC=[[TCServiceDetailViewController alloc] init];
    serviceDetailVC.myService=mineModel;
    serviceDetailVC.isMyServiceIn=YES;
    [self.navigationController pushViewController:serviceDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 168;
}

#pragma mark ClickViewGroupDelegate
-(void)ClickViewGroupActionWithIndex:(NSUInteger)index{
    selectIndex=index;
    [myServiceArray removeAllObjects];
    [self loadNewMineServiceData];
}


#pragma mark --TCMineServiceDelegate
- (void)chatDeledalegate:(NSInteger)index{
    TCMineServiceModel *mineModel =myServiceArray[index];
    
    UserModel *model=[[UserModel alloc] init];
    model.im_username=mineModel.im_username;
    model.user_id=mineModel.user_id;
    model.nick_name=mineModel.nick_name;
    model.photo=mineModel.head_url;
    model.im_expertname=mineModel.im_expertname;
    model.expertUserName=mineModel.expertUserName;
    model.expertHeadPic=mineModel.expertHeadPic;
    model.im_helpername=mineModel.im_helpername;
    model.helperHeadPic=mineModel.helperHeadPic;
    model.helperUserName=mineModel.helperUserName;
    model.im_groupid=mineModel.im_groupid;
    model.remark=mineModel.remark;
    
    TCServicingViewController *servicingVC=[[TCServicingViewController alloc] init];
    servicingVC.userModel=model;
    servicingVC.title=model.nick_name;
    [self.navigationController pushViewController:servicingVC animated:YES];
}


#pragma mark -- Private Methods
#pragma mark -- 请求服务列表
- (void)requestMyServiceData{
    __weak typeof(self) weakSelf=self;
    NSArray *arr=@[@"1",@"0"];
    NSString *urlString = [NSString stringWithFormat:@"%@?page_size=20&page_num=%ld&status=%@",kGetMyServiceOrders,(long)servicePage,arr[selectIndex]];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:urlString success:^(id json) {
        NSArray  *dataArray = [json objectForKey:@"result"];
        NSArray *helperList=[json objectForKey:@"helperList"];
        BOOL  isHelper=[[json objectForKey:@"is_helper"] boolValue];
        
        if (kIsArray(dataArray)) {
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (int i=0; i<dataArray.count; i++) {
                TCMineServiceModel *mineModel = [[TCMineServiceModel alloc] init];
                [mineModel setValues:dataArray[i]];
                
                if (isHelper) {  //当前用户为助手
                    for (NSDictionary *helperDict in helperList) {
                        if ([helperDict[@"im_username"] isEqualToString:mineModel.im_expertname]) {
                            mineModel.expertHeadPic=helperDict[@"head_portrait"];
                            mineModel.expertUserName=helperDict[@"expert_name"];
                            break;
                        }
                    }
                    mineModel.helperHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                    mineModel.helperUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
                }else{   //当前用户为专家
                    for (NSDictionary *helperDict in helperList) {
                        if ([helperDict[@"im_username"] isEqualToString:mineModel.im_helpername]) {
                            mineModel.helperHeadPic=helperDict[@"head_portrait"];
                            mineModel.helperUserName=helperDict[@"expert_name"];
                            break;
                        }
                    }
                    mineModel.expertHeadPic=[NSUserDefaultsInfos getValueforKey:kUserPhoto];
                    mineModel.expertUserName=[NSUserDefaultsInfos getValueforKey:kNickName];
                }
                
                [tempArr addObject:mineModel];
            }
            weakSelf.myServiceTableView.mj_footer.hidden=tempArr.count<20;
            if (servicePage==1) {
                myServiceArray=tempArr;
                weakSelf.blankView.hidden=myServiceArray.count>0;
            }else{
                [myServiceArray addObjectsFromArray:tempArr];
            }
            [weakSelf.myServiceTableView reloadData];
        }
        [weakSelf.myServiceTableView.mj_header endRefreshing];
        [weakSelf.myServiceTableView.mj_footer endRefreshing];
    } failure:^(NSString *errorStr) {
        [weakSelf.myServiceTableView.mj_header endRefreshing];
        [weakSelf.myServiceTableView.mj_footer endRefreshing];
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark -- 加载最新数据
-(void)loadNewMineServiceData{
    servicePage =1;
    [self requestMyServiceData];
}

#pragma mark -- 加载更多数据
-(void)loadMoreMineServiceData{
    servicePage++;
    [self requestMyServiceData];
}

#pragma mark -- 初始化界面
- (void)initServiceView{
    [self.view addSubview:self.myServiceMenu];
    [self.view addSubview:self.myServiceTableView];
    [self.myServiceTableView addSubview:self.blankView];
    self.blankView.hidden=YES;
}

#pragma mark -- Getters and Setters
#pragma mark  菜单栏
-(ClickViewGroup *)myServiceMenu{
    if (!_myServiceMenu) {
        _myServiceMenu=[[ClickViewGroup alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, 40) titles:@[@"服务中",@"已结束"] color:kSystemColor];
        _myServiceMenu.viewDelegate=self;
    }
    return _myServiceMenu;
}

-(UITableView *)myServiceTableView{
    if (!_myServiceTableView) {
        _myServiceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.myServiceMenu.bottom, kScreenWidth, kScreenHeight-65-40)];
        _myServiceTableView.backgroundColor = [UIColor clearColor];
        _myServiceTableView.delegate = self;
        _myServiceTableView.dataSource = self;
        _myServiceTableView.showsVerticalScrollIndicator=NO;
        _myServiceTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_myServiceTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewMineServiceData)];
        header.automaticallyChangeAlpha=YES;     // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.lastUpdatedTimeLabel.hidden=YES;  //隐藏时间
        _myServiceTableView.mj_header=header;
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMineServiceData)];
        footer.automaticallyRefresh = NO;// 禁止自动加载
        _myServiceTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _myServiceTableView;
}


-(TCBlankView *)blankView{
    if (!_blankView) {
        _blankView=[[TCBlankView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kRootViewHeight-40) img:@"img_tips_no" text:@"暂无数据"];
    }
    return _blankView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
