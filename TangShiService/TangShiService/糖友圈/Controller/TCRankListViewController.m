//
//  TCRankListViewController.m
//  TonzeCloud
//
//  Created by 肖栋 on 17/11/14.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCRankListViewController.h"
#import "TCSugarFriendsRankModel.h"
#import "TCRankListTableViewCell.h"
#import "TCMyDynamicViewController.h"
#import "HWPopTool.h"

@interface TCRankListViewController ()<UITableViewDelegate,UITableViewDataSource,TCRankListFocusOnDelegate>{

    NSMutableArray *rankListArr;
}

@property (nonatomic ,strong)UITableView *rankListTab;
@end

@implementation TCRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"上周控糖之星";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    self.rigthTitleName = @"规则";
    
    [self.view addSubview:self.rankListTab];
    [self loadRankListData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[HWPopTool sharedInstance]closeAnimation:NO WithBlcok:nil];
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rankListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"TCRankListTableViewCell";
    TCRankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[TCRankListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.rankListDelegate = self;
    TCSugarFriendsRankModel *model = rankListArr[indexPath.row];
    [cell cellRankListModel:model rank:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCSugarFriendsRankModel *model = rankListArr[indexPath.row];
    TCMyDynamicViewController *myDynamicVC = [[TCMyDynamicViewController alloc] init];
    myDynamicVC.news_id = model.user_id;
    myDynamicVC.role_type_ed = model.role_type;
    [self.navigationController pushViewController:myDynamicVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 58;
}
#pragma mark -- TCRankListFocusOnDelegate
- (void)returnFocusOnRankList{
    
    [self loadRankListData];
}
#pragma mark -- Event response
#pragma mark -- 获取排行榜数据
- (void)loadRankListData{
    rankListArr = [[NSMutableArray alloc] init];
    NSString *body = [NSString stringWithFormat:@"%@?role_type=2",KRankLists];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:body success:^(id json) {
        NSArray *result = [json objectForKey:@"result"];
        if (kIsArray(result)&&result.count>0) {
            for (NSDictionary *dict in result) {
                TCSugarFriendsRankModel *rankModel = [[TCSugarFriendsRankModel alloc] init];
                [rankModel setValues:dict];
                [rankListArr addObject:rankModel];
            }
        }
        [self.rankListTab.mj_header endRefreshing];
        [self.rankListTab reloadData];
    } failure:^(NSString *errorStr) {
        [self.rankListTab.mj_header endRefreshing];
        [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark -- 获取排行榜最新数据
- (void)loadRankListNewData{
    
    [self loadRankListData];
}
#pragma mark -- 规则
- (void)rightButtonAction{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth>320?kScreenWidth-100:kScreenWidth-60, 0)];
    contentView.backgroundColor =[UIColor bgColor_Gray];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20,contentView.width-40, 0)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"0x626262"];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"• 上榜规则\n根据上一周内糖友圈的活跃度进行排名；活跃度包括发布动态、评论动态等行为。\n\n• 奖励\n第1名，100积分\n第2名，60积分\n第3名，30积分\n第4-10名，10积分\n\n• 积分发放\n奖励将于榜单更新后的三个工作日内发放\n\n*最终解释权归糖士所有";
    CGSize titleSize = [titleLabel.text sizeWithLabelWidth:contentView.width-40 font:[UIFont systemFontOfSize:16]];
    titleLabel.frame = CGRectMake(20, 20, contentView.width-40, titleSize.height);
    [contentView addSubview:titleLabel];
    
    UIButton *knowButton = [[UIButton alloc] initWithFrame:CGRectMake((contentView.width-120)/2, titleLabel.bottom+20, 120, 40)];
    knowButton.backgroundColor = kbgBtnColor;
    [knowButton setTitle:@"知道了" forState:UIControlStateNormal];
    knowButton.titleLabel.font = [UIFont systemFontOfSize:15];
    knowButton.titleLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    [knowButton addTarget:self action:@selector(knowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    knowButton.layer.cornerRadius = 20;
    [contentView addSubview:knowButton];
    
    contentView.frame = CGRectMake(0, 0,  kScreenWidth>320?kScreenWidth-100:kScreenWidth-60, knowButton.bottom+20);
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:contentView animated:YES];
}
- (void)knowButtonClick{
    [[HWPopTool sharedInstance]closeAnimation:NO WithBlcok:nil];
}
#pragma mark -- setter or getter
- (UITableView *)rankListTab{
    if (_rankListTab==nil) {
        _rankListTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _rankListTab.backgroundColor = [UIColor bgColor_Gray];
        _rankListTab.delegate = self;
        _rankListTab.dataSource = self;
        _rankListTab.showsVerticalScrollIndicator = NO;
        _rankListTab.tableFooterView  =[[UIView alloc] init];
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRankListNewData)];
        header.automaticallyChangeAlpha=YES;     // 设置自动切换透明度(在导航栏下面自动隐藏)
        _rankListTab.mj_header=header;
    }
    return _rankListTab;
}
@end
