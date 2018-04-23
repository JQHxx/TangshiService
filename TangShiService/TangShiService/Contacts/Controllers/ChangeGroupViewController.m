//
//  ChangeGroupViewController.m
//  TangShiService
//
//  Created by vision on 17/7/18.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ChangeGroupViewController.h"
#import "EditGroupTableViewCell.h"

@interface ChangeGroupViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray   *groupListArray;
}


@property (nonatomic,strong)UITableView *editGroupTableView;

@end

@implementation ChangeGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"更改分组";
    
    groupListArray=[TCHelper sharedTCHelper].groupUserArray;
    
    [self.view addSubview:self.editGroupTableView];
    
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return groupListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"EditGroupTableViewCell";
    EditGroupTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[EditGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    TCGroupModel *group=groupListArray[indexPath.row];
    group.isSelected=group.group_id==self.groupId;
    [cell editGroupViewCellDisplayWithModel:group];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCGroupModel *group=groupListArray[indexPath.row];
    
    
    __weak typeof(self) weakSelf=self;
    NSString *body=[NSString stringWithFormat:@"user_id=%ld&group_id=%ld",(long)self.user_id,(long)group.group_id];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kChangeUserGroup body:body success:^(id json) {
        for (TCGroupModel *tempGroup in groupListArray) {
            tempGroup.isSelected=tempGroup.group_id==group.group_id;
        }
        [weakSelf.editGroupTableView reloadData];
        [KEY_WINDOW makeToast:@"分组设置成功" duration:1.0 position:CSToastPositionBottom];
        [TCHelper sharedTCHelper].isUserGroupReload=YES;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}


#pragma mark -- Setters and Getters
-(UITableView *)editGroupTableView{
    if (!_editGroupTableView) {
        _editGroupTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _editGroupTableView.delegate=self;
        _editGroupTableView.dataSource=self;
        _editGroupTableView.backgroundColor=[UIColor bgColor_Gray];
        _editGroupTableView.tableFooterView=[[UIView alloc] init];
    }
    return _editGroupTableView;
}


@end
