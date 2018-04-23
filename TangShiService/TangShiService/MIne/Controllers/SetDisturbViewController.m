//
//  SetDisturbViewController.m
//  TangShiService
//
//  Created by vision on 17/6/2.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "SetDisturbViewController.h"

@interface SetDisturbViewController ()<UITableViewDelegate,UITableViewDataSource>{
    EMPushNoDisturbStatus _noDisturbingStatus;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
}

@property(nonatomic,strong)UITableView *periodTableView;

@end

@implementation SetDisturbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=@"功能消息免打扰";
    
    [self.view addSubview:self.periodTableView];
}

#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"开启";
        cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusDay ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"只在夜间开启(22:00-7:00)";
        cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusCustom ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"关闭";
        cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusClose ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return cell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark  UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            _noDisturbingStart = 0;
            _noDisturbingEnd = 24;
            _noDisturbingStatus = EMPushNoDisturbStatusDay;
        } break;
        case 1:
        {
            _noDisturbingStart = 22;
            _noDisturbingEnd = 7;
            _noDisturbingStatus = EMPushNoDisturbStatusCustom;
        }
            break;
        case 2:
        {
            _noDisturbingStart = -1;
            _noDisturbingEnd = -1;
            _noDisturbingStatus = EMPushNoDisturbStatusClose;
        }
            break;
            
        default:
            break;
    }
    
    [tableView reloadData];
    
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    if (options.noDisturbingStartH != _noDisturbingStart || options.noDisturbingEndH != _noDisturbingEnd){
        options.noDisturbStatus = _noDisturbingStatus;
        options.noDisturbingStartH = _noDisturbingStart;
        options.noDisturbingEndH = _noDisturbingEnd;
    }
    EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
    if (error) {
        MyLog(@"设置免打扰失败，code:%u,error:%@",error.code,error.errorDescription);
    }else{
        MyLog(@"设置免打扰成功");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark 时间段设置
-(UITableView *)periodTableView{
    if (!_periodTableView) {
        _periodTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kRootViewHeight) style:UITableViewStyleGrouped];
        _periodTableView.backgroundColor=[UIColor bgColor_Gray];
        _periodTableView.dataSource=self;
        _periodTableView.delegate=self;
        
    }
    return _periodTableView;
}

@end
