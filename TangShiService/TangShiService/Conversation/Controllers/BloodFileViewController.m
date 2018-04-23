//
//  BloodFileViewController.m
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "BloodFileViewController.h"
#import "BloodFileModel.h"
#import "TCFileTableViewCell.h"

@interface BloodFileViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray          *titleArr;
    BloodFileModel    *sugerFilesModel;
}

@property (nonatomic,strong)UITableView *fileTableView;

@end

@implementation BloodFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"糖档案";
    
    titleArr = @[@"糖尿病类型",@"确诊日期",@"治疗方式",@"并发症及其他疾病",@"既往病史",@"是否吸烟",@"是否喝酒",@"饮食偏好",@"过敏的食物和药物",@"控糖最大困扰",@"身体其他不适"];

    sugerFilesModel=[[BloodFileModel alloc] init];
    
    [self.view addSubview:self.fileTableView];
    [self loadBloodFileData];
}
#pragma mark -- Custom Delegate
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (kIsEmptyString(sugerFilesModel.diabetes_type)) {
            return 1;
        }else{
            if ([sugerFilesModel.diabetes_type isEqualToString:@"正常"]||[sugerFilesModel.diabetes_type isEqualToString:@"不确定"]||[sugerFilesModel.diabetes_type isEqualToString:@"未选择"]||[sugerFilesModel.diabetes_type isEqualToString:@"其他"]||[sugerFilesModel.diabetes_type isEqualToString:@"(null)"]) {
                return 1;
            }else{
                return 2;
            }
        }
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"TCFileTableViewCell";
    TCFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[TCFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;

    if (indexPath.section==0) {
        cell.titleLabel.text = titleArr[indexPath.row];
        cell.type = 1;
        if (indexPath.row==0) {
            if (kIsEmptyString(sugerFilesModel.diabetes_type)||[sugerFilesModel.diabetes_type isEqualToString:@"(null)"]) {
                cell.contentLabel.text = @"未选择";
            }else{
                cell.contentLabel.text=[sugerFilesModel.diabetes_type isEqualToString:@"不确定"]?@"其他":sugerFilesModel.diabetes_type;
            }
        } else {
            if (!kIsEmptyString(sugerFilesModel.diagnosis_year)) {
                if (![sugerFilesModel.diagnosis_year isEqualToString:@"(null)"]&&![sugerFilesModel.diagnosis_year isEqualToString:@"0"]) {
                    NSString *dataStr = nil;
                    if([sugerFilesModel.diagnosis_year rangeOfString:@"-"].location !=NSNotFound){
                        dataStr=sugerFilesModel.diagnosis_year;
                        
                    }else{
                        dataStr=[[TCHelper sharedTCHelper] timeWithTimeIntervalString:sugerFilesModel.diagnosis_year format:@"yyyy-MM-dd"];
                    }
                    
                    cell.contentLabel.text = dataStr;
                } else {
                    cell.contentLabel.text = @"未选择";
                }
            }else{
                cell.contentLabel.text = @"未选择";
            }
            
        }
    }else if (indexPath.section==1){
        cell.titleLabel.text = titleArr[indexPath.row+2];
        if (indexPath.row==0) {
            if ( kIsEmptyString(sugerFilesModel.treatment_method)||[sugerFilesModel.treatment_method isEqualToString:@"(null)"]) {
                cell.contentLabel.text = @"未选择";
            } else {
                cell.contentLabel.text =sugerFilesModel.treatment_method;
            }
            cell.type = 1;
        }else if (indexPath.row==1){
            if ( kIsEmptyString(sugerFilesModel.other_diseases)||[sugerFilesModel.other_diseases isEqualToString:@"(null)"]) {
                cell.contentLabel.text  = @"未选择";
            } else {
                cell.contentLabel.text =sugerFilesModel.other_diseases;
            }
            cell.type = 1;
        }
        
    }else if (indexPath.section==2){
        cell.titleLabel.text = titleArr[indexPath.row+5];
        if (indexPath.row==0) {
            NSInteger isSmoking = [sugerFilesModel.is_smoking integerValue];
            cell.contentLabel.text =isSmoking==1?@"是":@"否";
            cell.type = 1;
        }else if (indexPath.row==1){
            NSInteger isDrinking = [sugerFilesModel.is_drinking integerValue];
            cell.contentLabel.text =isDrinking==1?@"是":@"否";
            cell.type = 1;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2) {
        return 25;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footView.backgroundColor = [UIColor bgColor_Gray];
    return footView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    if (section==2) {
        headView.frame = CGRectMake(0, 0, kScreenWidth, 25);
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth/2, 25)];
        title.text = @"生活习惯";
        title.font = [UIFont systemFontOfSize: 13];
        title.textColor = [UIColor grayColor];
        [headView addSubview:title];
    }
    
    return headView;
}
#pragma mark -- Private methods
-(void)loadBloodFileData{
    __weak typeof(self) weakSelf=self;
    NSString *urlStr=[NSString stringWithFormat:@"%@?user_id=%ld",kGetUserBloodFile,_user_id];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:urlStr success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            [sugerFilesModel setValues:result];
            [weakSelf.fileTableView reloadData];
        }
    } failure:^(NSString *errorStr) {
        
    }];
}
#pragma mark-- Custom Methods
#pragma mark 个人信息
-(UITableView *)fileTableView{
    if (_fileTableView==nil) {
        _fileTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, kNewNavHeight,kScreenWidth,kRootViewHeight) style:UITableViewStylePlain];
        _fileTableView.dataSource=self;
        _fileTableView.delegate=self;
        _fileTableView.tableFooterView=[[UIView alloc] init];
        _fileTableView.backgroundColor=[UIColor bgColor_Gray];
    }
    return _fileTableView;
}


@end
