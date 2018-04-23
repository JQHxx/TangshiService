//
//  QuestionnarieDetailViewController.m
//  TangShiService
//
//  Created by vision on 17/12/13.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "QuestionnarieDetailViewController.h"
#import "QuestionnarieDetailTableViewCell.h"

@interface QuestionnarieDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{


    NSInteger ra_id;
    UILabel  *titleLabel;
}

@property (nonatomic,strong)UITableView *detailTableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation QuestionnarieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=self.titleStr;
    
    [self.view addSubview:self.detailTableView];
    [self requestQusetionnarieData];
    MyLog(@"调查表详情－－－－id:%ld",self.rs_id);

}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArray[section];
    NSInteger type = [[dict objectForKey:@"type"] integerValue];
    NSArray *dataArr = [dict objectForKey:@"option"];
    if (type==4) {
        return dataArr.count*2;
    }if (type==3||type==5) {
        return 1;
    }
    NSInteger num = 0;
    for (NSDictionary *dict in dataArr) {
        NSInteger val = [[dict objectForKey:@"val"] integerValue];
        if (val==1) {
            num = num +1;
        }
    }
    return num;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSDictionary *dict = self.dataArray[indexPath.section];
    
    static NSString *identfy = @"QuestionnarieDetailTableViewCell";
    QuestionnarieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
    if (cell==nil) {
        cell = [[QuestionnarieDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
    }
    NSInteger type = [[dict objectForKey:@"type"] integerValue];
    if (type==1||type==2) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    } else {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [cell questionnarieDetailData:dict indexPath:indexPath.row section:indexPath.section];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSInteger type=[[dict objectForKey:@"type"] integerValue];
    if (type==5||type==3) {
       NSString *contentStr = [[dict objectForKey:@"option"][0] objectForKey:@"val"];
        CGSize size = [contentStr sizeWithLabelWidth:kScreenWidth-60 font:[UIFont systemFontOfSize:15]];
        return size.height+28+10;
    }else if (type==1||type==2){
        
        NSArray *dataArr = [dict objectForKey:@"option"];
        NSDictionary *dataDict =dataArr[indexPath.row];
        NSString *titleStr = [dataDict objectForKey:@"key"];
        CGSize size = [titleStr sizeWithLabelWidth:kScreenWidth-60 font:[UIFont systemFontOfSize:16]];
        return size.height+28;
    }
    return 48+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArray[section];
    NSString *labStr=[NSString stringWithFormat:@"%ld.%@",section+1,[dict objectForKey:@"title"]];
    CGFloat height = 0.0;
    if ([[dict objectForKey:@"must"] integerValue]==1) {
        NSString *str = [NSString stringWithFormat:@"%@*",labStr];
        height = [str sizeWithLabelWidth:kScreenWidth-56 font:[UIFont systemFontOfSize:18]].height;
    }else{
        NSString *str = labStr;
        height = [str sizeWithLabelWidth:kScreenWidth-56 font:[UIFont systemFontOfSize:18]].height;
    }
    return height+23;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *dict = self.dataArray[section];
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 48)];
    bgView.backgroundColor = kbgBtnColor;
    [headView addSubview:bgView];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
    headImgView.image = [UIImage imageNamed:@"chat_ic_q"];
    [headView addSubview:headImgView];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(headImgView.right+6, 11, kScreenWidth-50, 25)];
    lab.numberOfLines = 0;
    lab.textColor = [UIColor colorWithHexString:@"0x313131"];
    NSString *labStr=[NSString stringWithFormat:@"%ld.%@",section+1,[dict objectForKey:@"title"]];
    if ([[dict objectForKey:@"must"] integerValue]==1) {
        labStr = [NSString stringWithFormat:@"%@*",labStr];
        NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:labStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(labStr.length-1, 1)];
        lab.attributedText=attributeStr;
    }else{
        lab.text = labStr;
    }
    CGSize size = [labStr sizeWithLabelWidth:kScreenWidth-headImgView.right-16 font:[UIFont systemFontOfSize:18]];
    lab.frame = CGRectMake(headImgView.right+6,11,kScreenWidth-56, size.height);
    lab.font=[UIFont systemFontOfSize:18.0f];
    [headView addSubview:lab];

    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footView.backgroundColor = [UIColor bgColor_Gray];
    return footView;
}
#pragma mark -- Private Methods
#pragma mark -- 获取调查表详情
- (void)requestQusetionnarieData{
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"rs_id=%ld&user_id=%ld",self.rs_id,self.userId];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kResearchDetail body:body success:^(id json) {
        NSDictionary *result = [json objectForKey:@"result"];
        if (kIsDictionary(result)) {
            
            self.dataArray = [result objectForKey:@"jsonList"];
            titleLabel.text = [NSString stringWithFormat:@"共%ld题",self.dataArray.count];
        }
        [self.detailTableView reloadData];
    } failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark -- Private Methods
- (UIView *)tableViewHeader{
    UIView *headrView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headrView.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<2; i++) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+i*(kScreenWidth/2+10), 29/2, (kScreenWidth-100)/2, 1)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        [headrView addSubview:lineLabel];
    }
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2, 5, 60, 20)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"0x939393"];
    [headrView addSubview:titleLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 10)];
    bgView.backgroundColor = [UIColor bgColor_Gray];
    [headrView addSubview:bgView];
    
    return headrView;
}
#pragma mark －－ Gettsers and Setters
#pragma mark 数据
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark 调查表列表视图
-(UITableView *)detailTableView{
    if (!_detailTableView) {
        _detailTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, kNewNavHeight, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _detailTableView.backgroundColor=[UIColor bgColor_Gray];
        _detailTableView.dataSource=self;
        _detailTableView.delegate=self;
        _detailTableView.tableFooterView=[[UIView alloc] init];
        _detailTableView.tableHeaderView = [self tableViewHeader];
        _detailTableView.showsVerticalScrollIndicator = NO;
    }
    return _detailTableView;
}

@end
