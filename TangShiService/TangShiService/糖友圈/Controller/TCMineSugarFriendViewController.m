//
//  TCMineSugarFriendViewController.m
//  TonzeCloud
//
//  Created by 肖栋 on 17/8/7.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCMineSugarFriendViewController.h"
#import "TCUserDynamicButton.h"
#import "TCMyDynamicViewController.h"
#import "TCNewFriendViewController.h"
#import "TCFocusOnButton.h"
#import "TCFocusOnViewController.h"
#import "TCBeFocusOnViewController.h"
#import "TCMyCommentsViewController.h"
#import "TCMyPraiseViewController.h"
#import "TCLookForMyViewController.h"
#import "TCMySugarFriendModel.h"
#import "MineInfoViewController.h"
#import "SVProgressHUD.h"

@interface TCMineSugarFriendViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray               *_titleArray;
    UIImageView           *sugarTypeImgView;
    UIImageView           *_sexImgView;
    UIButton              *_headImageVButton;
    UILabel               *_nickNameLabel;
    TCUserDynamicButton   *sugarTypeButton;
    TCUserDynamicButton   *getUserButton;

    TCFocusOnButton       *FocusOnButton;
    TCFocusOnButton       *beFocusOnButton;
    
    TCMySugarFriendModel  *mySugarFriendModel;
    
    BOOL                 isReloadMainPage;   //刷新我的个人主页
}

@property (nonatomic ,strong) UITableView  *sugarFriendTab;
@property (nonatomic ,strong) UIView       *navigationView;

@end

@implementation TCMineSugarFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    _titleArray=@[@[@"我的动态"],@[@"新朋友"],@[@"我评论的",@"我赞的"],@[@"@我的",@"评论我的",@"赞我的"]];
    
    [self initMineSugarFriendView];
    [self setNavagationView];
    
    [self loadMineSugarFriendData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (isReloadMainPage) {
      [self loadMineSugarFriendData];
    }
    
}

#pragma mark --UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 0);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
    
    UILabel *bagdeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    bagdeLabel.font=[UIFont systemFontOfSize:14];
    bagdeLabel.backgroundColor=[UIColor redColor];
    bagdeLabel.textColor=[UIColor whiteColor];
    if (indexPath.section==0) {
        cell.imageView.image = [UIImage imageNamed:@"my_dynamic"];
        bagdeLabel.text=[NSString stringWithFormat:@"%ld",(long)mySugarFriendModel.news];
        bagdeLabel.backgroundColor=[UIColor clearColor];
        bagdeLabel.textColor=[UIColor lightGrayColor];
        
    }else if(indexPath.section==1){
        bagdeLabel.text=mySugarFriendModel.new_followed>99?@"99+":[NSString stringWithFormat:@"%ld",(long)mySugarFriendModel.new_followed];
    }else if (indexPath.section==2){
        
    }else{
        if (indexPath.row==0) {
            bagdeLabel.text=mySugarFriendModel.ated>99?@"99+":[NSString stringWithFormat:@"%ld",(long)mySugarFriendModel.ated];
        }else if(indexPath.row==1){
            bagdeLabel.text=mySugarFriendModel.commented>99?@"99+":[NSString stringWithFormat:@"%ld",(long)mySugarFriendModel.commented];
        }else{
            bagdeLabel.text=mySugarFriendModel.liked>99?@"99+":[NSString stringWithFormat:@"%ld",(long)mySugarFriendModel.liked];
        }
    }
    bagdeLabel.layer.cornerRadius=10;
    bagdeLabel.clipsToBounds=YES;
    bagdeLabel.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:bagdeLabel];
    
    if ([bagdeLabel.text integerValue]>0) {
        if (indexPath.section==0) {
            bagdeLabel.textAlignment=NSTextAlignmentRight;
            bagdeLabel.frame=CGRectMake(kScreenWidth-110,  (44-20)/2.0, 80, 20);
        }else{
            if ([bagdeLabel.text integerValue]>99) {
                bagdeLabel.frame=CGRectMake(kScreenWidth-70, (44-20)/2.0, 40, 20);
            }else if([bagdeLabel.text integerValue]>9){
                bagdeLabel.frame=CGRectMake(kScreenWidth-60, (44-20)/2.0, 30, 20);
            }else{
                bagdeLabel.frame=CGRectMake(kScreenWidth-50, (44-20)/2.0, 20, 20);
            }
        }
        bagdeLabel.hidden=NO;
    }else{
        bagdeLabel.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        TCMyDynamicViewController *myDynamicVC = [[TCMyDynamicViewController alloc] init];
        myDynamicVC.isMyDynamic=YES;
        myDynamicVC.news_id = [[mySugarFriendModel.user_info objectForKey:@"user_id"] integerValue];
        myDynamicVC.role_type_ed = [[mySugarFriendModel.user_info objectForKey:@"role_type"] integerValue];
        [self.navigationController pushViewController:myDynamicVC animated:YES];
    }else if (indexPath.section==1){
        TCNewFriendViewController *newFriendVC = [[TCNewFriendViewController alloc] init];
        [self.navigationController pushViewController:newFriendVC animated:YES];
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            TCMyCommentsViewController *myCommentsVC = [[TCMyCommentsViewController alloc] init];
            myCommentsVC.type = 1;
            [self.navigationController pushViewController:myCommentsVC animated:YES];
        }else{
            TCMyPraiseViewController *myPraiseVC = [[TCMyPraiseViewController alloc] init];
            myPraiseVC.type = 1;
            [self.navigationController pushViewController:myPraiseVC animated:YES];
        }
    }else{
        if (indexPath.row==0) {
            TCLookForMyViewController *loodForMyVC = [[TCLookForMyViewController alloc] init];
            [self.navigationController pushViewController:loodForMyVC animated:YES];
        }else if (indexPath.row==1){
            TCMyCommentsViewController *commentsMyVC = [[TCMyCommentsViewController alloc] init];
            commentsMyVC.type = 0;
            [self.navigationController pushViewController:commentsMyVC animated:YES];
        }else{
            TCMyPraiseViewController *praiseMyVC = [[TCMyPraiseViewController alloc] init];
            praiseMyVC.type = 0;
            [self.navigationController pushViewController:praiseMyVC animated:YES];
        }
    }
    isReloadMainPage=YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark -- UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y=scrollView.contentOffset.y;
    if (y < -kMineSugarViewHeight) {
        CGRect frame=sugarTypeImgView.frame;
        frame.origin.y=y;
        frame.size.height=-y;
        sugarTypeImgView.frame=frame;
    }
}
#pragma mark -- Event Response
#pragma mark -- 获取消息数和个人信息
- (void)loadMineSugarFriendData{
    NSString *body = [NSString stringWithFormat:@"role_type=2&role_type_ed=0"];
    if (!isReloadMainPage) {
        [SVProgressHUD show];
    }
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithoutLoadingForURL:KLoadMySugarFriendInfo body:body success:^(id json) {
        if (!isReloadMainPage) {
            [SVProgressHUD dismiss];
        }
        NSDictionary *result = [json objectForKey:@"result"];
        if (kIsDictionary(result)) {
          mySugarFriendModel=[[TCMySugarFriendModel alloc] init];
          [mySugarFriendModel setValues:result];
      
          FocusOnButton.numTitle = [NSString stringWithFormat:@"%ld",mySugarFriendModel.follow];
          beFocusOnButton.numTitle =[NSString stringWithFormat:@"%ld",mySugarFriendModel.followed];
          //用户
          [_headImageVButton sd_setImageWithURL:[NSURL URLWithString:[mySugarFriendModel.user_info objectForKey:@"head_url"]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_m_head_156"]];
          
          _nickNameLabel.text =[mySugarFriendModel.user_info objectForKey:@"nick_name"];
          CGSize size = [_nickNameLabel.text sizeWithLabelWidth:kScreenWidth font:[UIFont systemFontOfSize:16]];
          _nickNameLabel.frame =CGRectMake(_headImageVButton.right+15,_headImageVButton.top +4,size.width+10, 20);
          _sexImgView.frame =CGRectMake(_nickNameLabel.right,_nickNameLabel.top-5 , 30, 30);
          
          NSInteger sex=[[mySugarFriendModel.user_info objectForKey:@"sex"] integerValue];
          if (sex!=3) {
              _sexImgView.image =[UIImage imageNamed:sex==1?@"ic_m_male1":@"ic_m_famale1"];
          }
          NSString *sugarTitle =[mySugarFriendModel.user_info objectForKey:@"diabetes_type"];
          NSString *timeString =[mySugarFriendModel.user_info objectForKey:@"diagnosis_time"];
          if (sugarTitle.length>0) {
              if ([sugarTitle isEqualToString:@"其他"]||[sugarTitle isEqualToString:@"正常"]) {
                  sugarTypeButton.title = [NSString stringWithFormat:@"%@",sugarTitle];
              }else{
                  sugarTypeButton.title = [NSString stringWithFormat:@"%@ %@",sugarTitle,timeString];
              }
          }else{
              sugarTypeButton.title = @"编辑糖档案";
          }
          
          [self.sugarFriendTab reloadData];
            
        }
    } failure:^(NSString *errorStr) {
        if (!isReloadMainPage) {
           [SVProgressHUD dismiss];
        }
        [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}


#pragma mark -- 设置导航栏
- (void)setNavagationView{
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
    [self.view addSubview:_navigationView];
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 22, 40, 40)];
    [backBtn setImage:[UIImage drawImageWithName:@"back.png" size:CGSizeMake(12, 19)] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
    [backBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:backBtn];

}
#pragma MARK -- 关注／被关注
- (void)focusOnButton:(UIButton *)button{
    if (button.tag==100) {
        TCFocusOnViewController *focusOnVC = [[TCFocusOnViewController alloc] init];
        focusOnVC.user_id = self.news_id;
        focusOnVC.type = 1;
        [self.navigationController pushViewController:focusOnVC animated:YES];
    } else {
        TCBeFocusOnViewController *brFocusOnVC = [[TCBeFocusOnViewController alloc] init];
        brFocusOnVC.user_id = self.news_id;
        brFocusOnVC.type = 1;
        [self.navigationController pushViewController:brFocusOnVC animated:YES];
    }
    isReloadMainPage=YES;
}
#pragma mark -- 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 个人信息
- (void)gettoUserInfoVC{
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc] init];
    [self.navigationController pushViewController:mineInfoVC animated:YES];
}
#pragma mark -- 查看大图
- (void)lookBigImage{

    [[TCHelper sharedTCHelper] scanBigImageWithImageView:_headImageVButton.imageView];
}
#pragma mark -- Event Methon
#pragma mark -- 初始化界面
- (void)initMineSugarFriendView{
    
    _sugarFriendTab=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _sugarFriendTab.backgroundColor=[UIColor bgColor_Gray];
    _sugarFriendTab.delegate=self;
    _sugarFriendTab.dataSource=self;
    _sugarFriendTab.showsVerticalScrollIndicator=NO;
    _sugarFriendTab.contentInset=UIEdgeInsetsMake(kMineSugarViewHeight, 0, 0, 0);
    [self.view addSubview:_sugarFriendTab];
    _sugarFriendTab.tableFooterView=[[UIView alloc] init];
    
    //背景图片
    sugarTypeImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -kMineSugarViewHeight, kScreenWidth, kMineSugarViewHeight)];//mine_bg
    sugarTypeImgView.image=[UIImage imageNamed:@"background"];
    sugarTypeImgView.userInteractionEnabled=YES;
    [_sugarFriendTab addSubview:sugarTypeImgView];
    sugarTypeImgView.autoresizesSubviews=YES;   //设置autoresizesSubviews让子类自动布局

    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 80, 64, 64)];
    bgImgView.layer.cornerRadius = 32;
    bgImgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    bgImgView.image = [UIImage imageNamed:@"head"];
    [sugarTypeImgView addSubview:bgImgView];
    
    //头像和昵称
    _headImageVButton=[[UIButton alloc] initWithFrame:CGRectMake(25, 83 , 58, 58)];
    _headImageVButton.layer.cornerRadius=29;
    _headImageVButton.backgroundColor = [UIColor bgColor_Gray];
    _headImageVButton.clipsToBounds=YES;
    _headImageVButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;  //自动布局，自使用顶部
    [_headImageVButton addTarget:self action:@selector(lookBigImage) forControlEvents:UIControlEventTouchUpInside];
    [sugarTypeImgView addSubview:_headImageVButton];
    
    _nickNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(_headImageVButton.right+15,_headImageVButton.top +7, kScreenWidth/2, 20)];
    _nickNameLabel.textColor=[UIColor whiteColor];
    _nickNameLabel.font=[UIFont systemFontOfSize:16];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [sugarTypeImgView addSubview:_nickNameLabel];
    
    _sexImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_nickNameLabel.right,_nickNameLabel.top-5 , 30, 30)];
    _sexImgView.layer.cornerRadius = 15;
    _sexImgView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;
    [sugarTypeImgView addSubview:_sexImgView];
    

    sugarTypeButton = [[TCUserDynamicButton alloc] initWithFrame:CGRectMake(_headImageVButton.right+15, _nickNameLabel.bottom+10, 119, 27) img:@"time"];
    sugarTypeButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;
    [sugarTypeImgView addSubview:sugarTypeButton];
    
    getUserButton = [[TCUserDynamicButton alloc] initWithFrame:CGRectMake(sugarTypeButton.right+11, sugarTypeButton.top, 83, 27) img:@"personal_imformation"];
    getUserButton.title = @"个人信息";
    getUserButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;
    [getUserButton addTarget:self action:@selector(gettoUserInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [sugarTypeImgView addSubview:getUserButton];
    
    UIView *blackBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kImgViewHeight-55, kScreenWidth, 55)];
    blackBgView.backgroundColor = [UIColor blackColor];
    blackBgView.alpha = 0.1;
    blackBgView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;
    [sugarTypeImgView addSubview:blackBgView];
    
    UILabel *blackBgLine = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, kImgViewHeight-43, 1, 31)];
    blackBgLine.backgroundColor = [UIColor colorWithHexString:@"0xdcdcdc"];
    blackBgLine.autoresizingMask=UIViewAutoresizingFlexibleTopMargin ;
    [sugarTypeImgView addSubview:blackBgLine];
    
    FocusOnButton = [[TCFocusOnButton alloc] initWithFrame:CGRectMake(0, kImgViewHeight-55, kScreenWidth/2, 55) title:@"关注"];
    FocusOnButton.tag = 100;
    FocusOnButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [FocusOnButton addTarget:self action:@selector(focusOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [sugarTypeImgView addSubview:FocusOnButton];
    
    beFocusOnButton = [[TCFocusOnButton alloc] initWithFrame:CGRectMake(kScreenWidth/2, kImgViewHeight-55, kScreenWidth/2,55) title:@"被关注"];
    beFocusOnButton.tag = 101;
    [beFocusOnButton addTarget:self action:@selector(focusOnButton:) forControlEvents:UIControlEventTouchUpInside];
    beFocusOnButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [sugarTypeImgView addSubview:beFocusOnButton];
}

@end
