//
//  UserBaseViewController.m
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "UserBaseViewController.h"
#import "UserModel.h"

@interface UserBaseViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray           *userArray;
    NSMutableArray    *userBaseArray;
    
}

@property (nonatomic,strong)UITableView   *baseTableView;

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"基本信息";
    
    userArray=@[@"性别",@"出生日期",@"身高",@"体重",@"BMI",@"劳动强度"];

    userBaseArray=[[NSMutableArray alloc] init];
    
    [self.view addSubview:self.baseTableView];
    
    if (self.isServingIn) {
       [self loaduserDetailInfo];
    }else{
       [self initUserBaseData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=userArray[indexPath.row];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",userBaseArray[indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark -- Private methods
#pragma mark 加载用户信息
-(void)loaduserDetailInfo{
    __weak typeof(self) weakself = self;
    NSString *userStr=[NSString stringWithFormat:@"%@?user_id=%ld",kGetUserDetail,(long)self.userId];
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithURL:userStr success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            UserModel *user=[[UserModel alloc] init];
            NSDictionary *userInfoDict=[result valueForKey:@"user_info"];
            [user setValues:userInfoDict];
            weakself.userModel=user;
            [weakself initUserBaseData];
        }
    } failure:^(NSString *errorStr) {
        [weakself.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}

#pragma mark 初始化界面
-(void)initUserBaseData{
    NSString *sexStr=nil;
    if (self.userModel.sex<1||self.userModel.sex>2) {
        sexStr=@"";
    }else{
        sexStr=self.userModel.sex==1?@"男":@"女";
    }
    [userBaseArray addObject:sexStr];
    NSString *birthday=[[TCHelper sharedTCHelper] timeWithTimeIntervalString:_userModel.birthday format:@"yyyy-MM-dd"];
    [userBaseArray addObject:(!kIsEmptyString(birthday)&&[birthday isEqualToString:@"1970-01-01"])?@"":birthday];
    
    NSInteger height=[self.userModel.height integerValue];
    double    weight=[self.userModel.weight doubleValue];
    double bmi=0.0;
    if (height>0&weight>0.0) {
        bmi=weight/(double)((height/100.0)*(height/100.0));
    }else{
        bmi=0.0;
    }
    NSString *heightStr=height==0?@"":[NSString stringWithFormat:@"%ldcm",(long)height];
    [userBaseArray addObject:heightStr];
    NSString *weightStr=weight>0.0?[NSString stringWithFormat:@"%.1fkg",weight]:@"";
    [userBaseArray addObject:weightStr];
    NSString *bmiStr=bmi>0?[NSString stringWithFormat:@"%.1f",bmi]:@"";
    [userBaseArray addObject:bmiStr];
    [userBaseArray addObject:_userModel.labour_intensity];

    [self.baseTableView reloadData];
}

#pragma mark -- Setters and Getters
#pragma mark 基本信息列表
-(UITableView *)baseTableView{
    if (!_baseTableView) {
        _baseTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight) style:UITableViewStylePlain];
        _baseTableView.delegate=self;
        _baseTableView.dataSource=self;
        _baseTableView.tableFooterView=[[UIView alloc] init];
        _baseTableView.backgroundColor=[UIColor bgColor_Gray];
    }
    return _baseTableView;
}

@end
