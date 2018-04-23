//
//  QuestionnaireViewController.m
//  TangShiService
//
//  Created by vision on 17/12/12.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "TCQuestionnarieTableViewCell.h"
#import "QuestionnarieDetailViewController.h"

@interface QuestionnaireViewController ()<UITableViewDataSource,UITableViewDelegate,QuestionnaireCellDelegate>{

    NSMutableArray *dataArr;
}

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)UITableView *listTableView;

@end

@implementation QuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"调查表";
        
    [self.view addSubview:self.listTableView];
    [self reqestQuestionnaireData];
}

#pragma mark -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"TCQuestionnarieTableViewCell";
    TCQuestionnarieTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[TCQuestionnarieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.questionaireDelegate = self;
    TCQuestionnarieModel *model=self.dataArray[indexPath.row];
    [cell setQuestionnarieModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCQuestionnarieModel *model  = self.dataArray[indexPath.row];
    QuestionnarieDetailViewController *questionDetailVC = [[QuestionnarieDetailViewController alloc] init];
    questionDetailVC.titleStr = model.name;
    questionDetailVC.rs_id = model.rs_id;
    questionDetailVC.userId = self.userId;
    [self.navigationController pushViewController:questionDetailVC animated:YES];
}

#pragma mark -- Private Methods
#pragma mark -- 发送调查表
- (void)didSelectQuestionnaire:(TCQuestionnarieModel *)model{
    NSDictionary *dataDict = nil;
    for (NSDictionary *dict in dataArr) {
        if ([[dict objectForKey:@"rs_id"] integerValue]==model.rs_id) {
            dataDict = dict;
        }
    }
    if ([self.delegate respondsToSelector:@selector(questionnaireViewController:didSelectQuestionnaire:)]) {
        [self.delegate questionnaireViewController:self didSelectQuestionnaire:dataDict];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark -- 获取调查表列表
-(void)reqestQuestionnaireData{
    kSelfWeak;
    NSString *body=[NSString stringWithFormat:@"page_num=1&page_size=30&user_id=%ld",(long)self.userId];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kResearchList body:body success:^(id json) {
        NSArray *result=[json objectForKey:@"result"];
        if (kIsArray(result)&&result.count>0) {
            dataArr = [NSMutableArray arrayWithArray:result];
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (NSDictionary *dict in result) {
                TCQuestionnarieModel *model=[[TCQuestionnarieModel alloc] init];
                [model setValues:dict];
                [tempArr addObject:model];
            }
            weakSelf.dataArray=tempArr;
        }
        [weakSelf.listTableView reloadData];
    } failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
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
-(UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, kNewNavHeight, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _listTableView.backgroundColor=[UIColor bgColor_Gray];
        _listTableView.separatorStyle = NO;
        _listTableView.dataSource=self;
        _listTableView.delegate=self;
        _listTableView.tableFooterView=[[UIView alloc] init];
        _listTableView.showsVerticalScrollIndicator = NO;
    }
    return _listTableView;
}

@end
