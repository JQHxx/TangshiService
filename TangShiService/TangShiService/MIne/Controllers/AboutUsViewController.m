//
//  AboutUsViewController.m
//  TangShiService
//
//  Created by vision on 17/5/25.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "AboutUsViewController.h"
#import "IntroduceViewController.h"
#import "ServiceAgreementViewController.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *aboutTableView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"关于我们";
    
    [self.view addSubview:self.aboutTableView];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.textColor = UIColorFromRGB(0x343434);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==0) {
        cell.textLabel.text = @"公司简介";
    }else{
        cell.textLabel.text = @"服务协议";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 220;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-225)/2, 30, 225, 115)];
    imgView.image=[UIImage imageNamed:@"糖士logo"];
    [header addSubview:imgView];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, imgView.bottom, 150, 30)];
    titleLabel.textColor=kSystemColor;
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=APP_DISPLAY_NAME;
    [header addSubview:titleLabel];
    
    UILabel *versionLabel=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, titleLabel.bottom, 150, 20)];
    versionLabel.textColor=[UIColor lightGrayColor];
    versionLabel.font=[UIFont systemFontOfSize:12];
    versionLabel.textAlignment=NSTextAlignmentCenter;
    versionLabel.text=[NSString stringWithFormat:@"V%@", APP_VERSION];
    [header addSubview:versionLabel];
    
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        IntroduceViewController *introduceVC=[[IntroduceViewController alloc] init];
        [self.navigationController pushViewController:introduceVC animated:YES];
    }else{
        ServiceAgreementViewController *serviceVC=[[ServiceAgreementViewController alloc] init];
        serviceVC.url=[NSURL URLWithString:@"http://api.360tj.com/shared/reg/tsUserProtocol.html"];
        [self.navigationController pushViewController:serviceVC animated:YES];
    }
}


#pragma mark -- Setters and Getters
-(UITableView *)aboutTableView{
    if (!_aboutTableView) {
        _aboutTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _aboutTableView.dataSource=self;
        _aboutTableView.delegate=self;
        _aboutTableView.backgroundColor=[UIColor bgColor_Gray];
        _aboutTableView.showsVerticalScrollIndicator=NO;
        _aboutTableView.tableFooterView=[[UIView alloc] init];
        _aboutTableView.bounces=NO;
    }
    return _aboutTableView;
}


@end
