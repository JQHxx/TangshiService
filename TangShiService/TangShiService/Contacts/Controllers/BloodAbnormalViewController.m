//
//  BloodAbnormalViewController.m
//  TangShiService
//
//  Created by vision on 17/7/11.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "BloodAbnormalViewController.h"
#import "UserDetailViewController.h"
#import "ContactTableViewCell.h"
#import "TCBlankView.h"
#import "DownListMenu.h"
#import "TCMenuModel.h"
#import "TCGroupModel.h"

@interface BloodAbnormalViewController ()<UITableViewDelegate,UITableViewDataSource,DownListMenuDelegate>{
    UIImageView      *arrowImageView;
    DownListMenu     *listMenu;

    NSArray          *menuValueArr;
    NSString         *titleStr;
    NSString         *menuStr;
    
    NSMutableArray   *patientListArr;
    
    UIButton         *backBtn;
}


@property (nonatomic,strong)UIView           *titleView;
@property (nonatomic,strong)UILabel          *titleLab;
@property (nonatomic,strong)UITableView      *patientTableView;
@property (nonatomic,strong)TCBlankView      *blankView;


@end

@implementation BloodAbnormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuValueArr=@[@"7",@"15",@"30"];
    titleStr=self.type==1?@"偏高患者":@"偏低患者";
    menuStr=@"7";
    self.isBackBtnHidden = YES;
    
    [self.view addSubview:self.titleView];
    
    [self.view addSubview:self.patientTableView];
    [self.patientTableView addSubview:self.blankView];
    self.blankView.hidden=YES;
    
    [self requestBloodAbnormalPatientData];
    
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return patientListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ContactTableViewCell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UserModel *model = [patientListArr  objectAtIndex:indexPath.row];
    [cell contactCellDisplayWithModel:model];
    return cell;
}

#pragma mark TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UserModel *model = [patientListArr objectAtIndex:indexPath.row];
    
    UserDetailViewController *userdetailVC=[[UserDetailViewController alloc] init];
    userdetailVC.userID=model.user_id;
    userdetailVC.titleStr=kIsEmptyString(model.remark)?model.nick_name:model.remark;
    userdetailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:userdetailVC animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark DownListMenuDelegate
-(void)downListMenuDidSelectedMenu:(NSInteger)index{
    menuStr=menuValueArr[index];
    self.titleLab.text=[NSString stringWithFormat:@"%@（%@天）",titleStr,menuStr];
    CGFloat titleW=[self.titleLab.text boundingRectWithSize:CGSizeMake(200, 20) withTextFont:self.titleLab.font].width;
    self.titleLab.frame=CGRectMake((kScreenWidth-titleW-15)/2, 20, titleW, 44);
    arrowImageView.frame=CGRectMake(self.titleLab.right, 35, 15, 15);
    [self requestBloodAbnormalPatientData];
}

#pragma mark -- Event Response
-(void)selectTitleViewAction{
    if (!listMenu) {
        listMenu=[[DownListMenu alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, menuValueArr.count*44)];
        listMenu.menuArray=[self getMenuListInfo];
        listMenu.viewDelegate=self;
        listMenu.backUpCoverBlock=^(){
            listMenu=nil;
        };
        [listMenu downListMenuShow];
    }else{
        [listMenu backUpCoverAction];
    }
}

#pragma mark -- Private Methods
#pragma mark 获取患者列表
-(void)requestBloodAbnormalPatientData{
    __weak typeof(self) weakself = self;
    patientListArr=[[NSMutableArray alloc] init];
    NSString *urlStr=[NSString stringWithFormat:@"%@?type=%ld&time_span=%@",kGetSugarUsers,(long)self.type,menuStr];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:urlStr success:^(id json) {
        NSArray *list=[json objectForKey:@"result"];
        if (kIsArray(list)&&list.count>0) {
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (NSDictionary *dict in list) {
                UserModel *user=[[UserModel alloc] init];
                [user setValues:dict];
                [tempArr addObject:user];
            }
            patientListArr=tempArr;
        }
        weakself.blankView.hidden=list.count>0;
        [weakself.patientTableView reloadData];
    } failure:^(NSString *errorStr) {
        [weakself.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark 获取菜单列表信息
-(NSMutableArray *)getMenuListInfo{
    NSMutableArray *tempTitleArr=[[NSMutableArray alloc] init];
    for (NSString *tempTitle in menuValueArr) {
        TCMenuModel *menu=[[TCMenuModel alloc] init];
        menu.menu_name=[NSString stringWithFormat:@"%@天",tempTitle];
        menu.isSelected=[tempTitle isEqualToString:menuStr];
        [tempTitleArr addObject:menu];
    }
    return tempTitleArr;
}
#pragma mark -- 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- Setters
-(UIView *)titleView{
    if (!_titleView) {
        _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _titleView.backgroundColor=kSystemColor;
        _titleView.userInteractionEnabled=YES;
        
        backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 22, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"back.png"size:CGSizeMake(12, 19)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:backBtn];
        
        UILabel *titleLab=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLab.font=[UIFont systemFontOfSize:18];
        titleLab.text=[NSString stringWithFormat:@"%@（%@天）",titleStr,menuStr];
        titleLab.textColor=[UIColor whiteColor];
        CGFloat titleW=[titleLab.text boundingRectWithSize:CGSizeMake(200, 20) withTextFont:titleLab.font].width;
        titleLab.frame=CGRectMake((kScreenWidth-titleW-15)/2,20, titleW, 44);
        [_titleView addSubview:titleLab];
        self.titleLab=titleLab;
        
        arrowImageView=[[UIImageView alloc] initWithFrame:CGRectMake(titleLab.right, 35, 15, 15)];
        arrowImageView.image=[UIImage imageNamed:@"ic_top_arrow_down"];
        [_titleView addSubview:arrowImageView];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTitleViewAction)];
        [_titleView addGestureRecognizer:tapGesture];
        
    }
    return _titleView;
}

#pragma mark 患者列表
-(UITableView *)patientTableView{
    if (!_patientTableView) {
        _patientTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _patientTableView.dataSource=self;
        _patientTableView.delegate=self;
        _patientTableView.backgroundColor=[UIColor bgColor_Gray];
        _patientTableView.tableFooterView=[[UIView alloc] init];
    }
    return _patientTableView;
}

#pragma mark 空白页
-(TCBlankView *)blankView{
    if (!_blankView) {
        _blankView=[[TCBlankView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 200) img:@"img_tips_no" text:@"暂无患者"];
    }
    return _blankView;
}

@end
