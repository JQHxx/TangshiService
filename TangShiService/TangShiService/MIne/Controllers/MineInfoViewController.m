 //
//  MineInfoViewController.m
//  TangShiService
//
//  Created by vision on 17/5/25.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "MineInfoViewController.h"
#import "ExpertModel.h"
#import "FileTableViewCell.h"

@interface MineInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSArray           *infoTitleArr;
    NSMutableArray    *infoValueArr;
    
    UIButton          *imgButton;
    
    ExpertModel       *expert;

}

@property (nonatomic,strong)UITableView  *infoTableView;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"个人信息";
    
    expert=[[ExpertModel alloc] init];
    infoTitleArr=@[@[@"头像"],@[@"真实姓名",@"性别",@"专家分类",@"职称",@"所属单位",@"所属地区",@"简介"]];
    infoValueArr=[[NSMutableArray alloc] init];
    
    [self.view addSubview:self.infoTableView];
    [self loadExpertInfo];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return infoTitleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [infoTitleArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"myInfoCell";
    FileTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }
    
    NSString *titleStr=infoTitleArr[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 30,80, 20)];
        titleLbl.textColor=[UIColor blackColor];
        titleLbl.font=[UIFont boldSystemFontOfSize:16];
        titleLbl.text=titleStr;
        [cell.contentView addSubview:titleLbl];
        
        imgButton=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70, 10, 60, 60)];
        imgButton.layer.cornerRadius=30;
        imgButton.clipsToBounds=YES;
        if (infoValueArr.count>0) {
            NSString *headImg=infoValueArr[indexPath.section][indexPath.row];
            [imgButton sd_setImageWithURL:[NSURL URLWithString:headImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_m_head_156"]];
        }else{
            [imgButton setImage:[UIImage imageNamed:@"ic_m_head_156"] forState:UIControlStateNormal];
        }
        [imgButton addTarget:self action:@selector(lookBigImage) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:imgButton];

    }else{
        if (indexPath.row==1) {
            NSString *valueStr=infoValueArr.count>0?infoValueArr[indexPath.section][indexPath.row]:@"3";
            if ([valueStr integerValue]!=3) {
                [cell fileCellDisplayWithTitle:titleStr detailText:[valueStr integerValue]==1?@"男":@"女" indexPath:1];
            }else{
                [cell fileCellDisplayWithTitle:titleStr detailText:@"未知" indexPath:1];
            }
        } else {
            NSString *valueStr=@"";
            if (infoValueArr.count>0) {
                valueStr=infoValueArr[indexPath.section][indexPath.row];
            }
            [cell fileCellDisplayWithTitle:titleStr detailText:valueStr indexPath:indexPath.row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"如需修改资料，请联系客服" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
    [alert show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else{
        if (indexPath.row==6&&infoValueArr.count>0) {
            NSString *titleStr=infoTitleArr[1][6];
            NSString *valueStr=infoValueArr[1][6];
            return [FileTableViewCell getFileCellHeightWithTitle:titleStr detailText:valueStr];
        }
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",PHONE_NUMBER];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark -- Private Methods
#pragma mark 加载专家信息
-(void)loadExpertInfo{
    __weak typeof(self) weakSelf=self;
    NSString *urlStr=[NSString stringWithFormat:@"%@?expert_id=%ld",kExpertInfo,(long)self.expert_id];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:urlStr success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            [expert setValues:result];
            NSMutableArray *tempArr1=[[NSMutableArray alloc] init];
            [tempArr1 addObject:expert.head_portrait];
            [infoValueArr addObject:tempArr1];
            
            NSMutableArray *tempArr2=[[NSMutableArray alloc] init];
            [tempArr2 addObject:expert.name];
            [tempArr2 addObject:expert.sex];
            [tempArr2 addObject:expert.expert_type];
            [tempArr2 addObject:expert.positional_titles];
            [tempArr2 addObject:expert.company];
            [tempArr2 addObject:expert.region];
            [tempArr2 addObject:expert.brief_introduction];
            
            [infoValueArr addObject:tempArr2];
            [weakSelf.infoTableView reloadData];
        }
    } failure:^(NSString *errorStr) {
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
   
}
#pragma mark 放大图片
- (void)lookBigImage{

    [[TCHelper sharedTCHelper] scanBigImageWithImageView:imgButton.imageView];
}
#pragma mark -- Setters and Getters
#pragma mark 个人信息
-(UITableView *)infoTableView{
    if (!_infoTableView) {
        _infoTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStyleGrouped];
        _infoTableView.delegate=self;
        _infoTableView.dataSource=self;
        _infoTableView.showsVerticalScrollIndicator=NO;
        _infoTableView.tableFooterView=[[UIView alloc] init];
        _infoTableView.backgroundColor=[UIColor bgColor_Gray];
    }
    return _infoTableView;
}


@end
