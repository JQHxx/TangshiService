//
//  ContactListViewController.m
//  TangShiService
//
//  Created by vision on 17/5/23.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ContactListViewController.h"
#import "ChatViewController.h"
#import "UserDetailViewController.h"
#import "PatientGroupViewController.h"
#import "BloodAbnormalViewController.h"
#import "ChangeGroupViewController.h"
#import "ContactToolView.h"
#import "ContactHeaderView.h"
#import "ContactTableViewCell.h"
#import "TCGroupModel.h"
#import "UserModel.h"
#import "MJRefresh.h"


static NSString *kHeaderIdentifier = @"HeaderView";

@interface ContactListViewController ()<ContactToolViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray     *groupUsersArray;
}

@property (nonatomic,strong)UIScrollView    *rootScrollView;
@property (nonatomic,strong)ContactToolView *toolView;
@property (nonatomic,strong)UITableView     *contactTableView;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"患者";
    self.isHiddenBackBtn = YES;
    
    groupUsersArray=[[NSMutableArray alloc] init];
    
    [self initContactListView];
    [self tableViewDidTriggerHeaderRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([TCHelper sharedTCHelper].isUserGroupReload) {
        [self tableViewDidTriggerHeaderRefresh];
        [TCHelper sharedTCHelper].isUserGroupReload=NO;
    }
}


#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return groupUsersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TCGroupModel *groupModel=groupUsersArray[section];
    NSArray *memberArr=groupModel.member;
    return groupModel.isExpanded?memberArr.count:0;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    TCGroupModel     *groupModel=groupUsersArray[indexPath.section];
    UserModel *groupUserModel=groupModel.member[indexPath.row];
    [cell contactCellDisplayWithModel:groupUserModel];
    
    // -- 添加移动手势
    UILongPressGestureRecognizer *longPressGeture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGeture:)];
    [cell addGestureRecognizer:longPressGeture];
    
    return cell;
}

#pragma mark TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
    TCGroupModel     *groupModel=groupUsersArray[indexPath.section];
    UserModel *groupUserModel=groupModel.member[indexPath.row];
    UserDetailViewController *userdetailVC=[[UserDetailViewController alloc] init];
    userdetailVC.userID=groupUserModel.user_id;
    userdetailVC.titleStr=kIsEmptyString(groupUserModel.remark)?groupUserModel.nick_name:groupUserModel.remark;
    userdetailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:userdetailVC animated:YES];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ContactHeaderView *view = [[ContactHeaderView alloc] initWithReuseIdentifier:kHeaderIdentifier];
    TCGroupModel *sectionModel=groupUsersArray[section];
    view.sectionModel = sectionModel;
    
    if (sectionModel.count>0) {
        __weak typeof(self) weakself = self;
        view.expandCallback = ^(BOOL isExpanded) {
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
                     withRowAnimation:UITableViewRowAnimationFade];
            if (isExpanded) {
                weakself.contactTableView.frame=CGRectMake(0, weakself.toolView.bottom+10, kScreenWidth,groupUsersArray.count*44+80*sectionModel.member.count);
                weakself.rootScrollView.contentSize=CGSizeMake(kScreenWidth, weakself.contactTableView.top+weakself.contactTableView.contentSize.height+20);
            }else{
                weakself.contactTableView.frame=CGRectMake(0, weakself.toolView.bottom+10, kScreenWidth, kScreenHeight-weakself.toolView.bottom-kTabHeight-10);
                weakself.rootScrollView.contentSize=CGSizeMake(kScreenWidth,kScreenHeight-kTabHeight-kNavHeight-20);
            }
        };
    }
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

#pragma mark -- ContactToolViewDelegate
-(void)contactToolViewDidSelectIndex:(NSInteger)index{
    if (index==2) {
        PatientGroupViewController *groupVC=[[PatientGroupViewController alloc] init];
        groupVC.hidesBottomBarWhenPushed=YES;
        groupVC.groupArray=groupUsersArray;
        [self.navigationController pushViewController:groupVC animated:YES];
    }else{
        BloodAbnormalViewController *abnorrmalVC=[[BloodAbnormalViewController alloc] init];
        abnorrmalVC.type=index+1;
        abnorrmalVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:abnorrmalVC animated:YES];
    }
}

#pragma mark -- Event response
#pragma mark 长安
- (void)longPressGeture:(UILongPressGestureRecognizer*)recognise{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)recognise;
    
    CGPoint location = [longPress locationInView:self.contactTableView];
    NSIndexPath *indexPath = [self.contactTableView indexPathForRowAtPoint:location];
    TCGroupModel *groupModel=groupUsersArray[indexPath.section];
    UserModel *userModel=groupModel.member[indexPath.row];
    if (longPress.state == UIGestureRecognizerStateBegan){
        __weak typeof(self) weakself = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"更改分组" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            MyLog(@"点击了确定按钮");
            ChangeGroupViewController  *changeGroupVC=[[ChangeGroupViewController alloc] init];
            changeGroupVC.hidesBottomBarWhenPushed=YES;
            changeGroupVC.groupId=groupModel.group_id;
            changeGroupVC.user_id=userModel.user_id;
            [weakself.navigationController pushViewController:changeGroupVC animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            MyLog(@"点击了取消按钮");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    
    }
}

#pragma mark -- Private Methods
#pragma mark  初始化界面
-(void)initContactListView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.toolView];
    [self.rootScrollView addSubview:self.contactTableView];
}


#pragma mark 获取患者列表
-(void)tableViewDidTriggerHeaderRefresh{
    __weak typeof(self) weakself = self;
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:kGetUsersGroup success:^(id json) {
        NSArray *list=[json objectForKey:@"result"];
        if (kIsArray(list)&&list.count>0) {
            NSArray *tempGroupArr=[list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSNumber *sort1=[obj1 objectForKey:@"sort"];
                NSNumber *sort2=[obj2 objectForKey:@"sort"];
                return [sort1 compare:sort2];
            }];
            
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (NSDictionary *dict in tempGroupArr) {
                TCGroupModel *model=[[TCGroupModel alloc] init];
                [model setValues:dict];
                NSArray *memberArr=model.member;
                NSMutableArray *tempMemberArr=[[NSMutableArray alloc] init];
                for (NSDictionary *memberDict in memberArr) {
                    UserModel *userModel=[[UserModel alloc] init];
                    [userModel setValues:memberDict];
                    [tempMemberArr addObject:userModel];
                }
                model.member=tempMemberArr;
                model.count=tempMemberArr.count;
                [tempArr addObject:model];
            }
            
            groupUsersArray=tempArr;
            [TCHelper sharedTCHelper].groupUserArray=groupUsersArray;
            [weakself.contactTableView reloadData];
            weakself.contactTableView.frame=CGRectMake(0, weakself.toolView.bottom+10, kScreenWidth, weakself.contactTableView.contentSize.height);
            weakself.rootScrollView.contentSize=CGSizeMake(kScreenWidth, weakself.contactTableView.top+weakself.contactTableView.contentSize.height);
        }
        [weakself.rootScrollView.mj_header endRefreshing];
    } failure:^(NSString *errorStr) {
        [weakself.rootScrollView.mj_header endRefreshing];
        [weakself.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark -- Setters
#pragma mark 根滚动视图
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kRootViewHeight-kTabHeight)];
        _rootScrollView.backgroundColor=[UIColor bgColor_Gray];
        _rootScrollView.showsVerticalScrollIndicator=NO;
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
        header.automaticallyChangeAlpha=YES;     // 设置自动切换透明度(在导航栏下面自动隐藏)
        _rootScrollView.mj_header=header;
    }
    return _rootScrollView;
}

#pragma mark 分组管理
-(ContactToolView *)toolView{
    if (!_toolView) {
        _toolView=[[ContactToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _toolView.toolDelegate=self;
    }
    return _toolView;
}

#pragma mark 患者列表
-(UITableView *)contactTableView{
    if (!_contactTableView) {
        _contactTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.toolView.bottom+10, kScreenWidth, kScreenHeight-self.toolView.bottom-kTabHeight-30) style:UITableViewStyleGrouped];
        _contactTableView.showsVerticalScrollIndicator=NO;
        _contactTableView.dataSource=self;
        _contactTableView.delegate=self;
        _contactTableView.scrollEnabled=NO;
        _contactTableView.backgroundColor=[UIColor bgColor_Gray];
    }
    return _contactTableView;
}


@end
