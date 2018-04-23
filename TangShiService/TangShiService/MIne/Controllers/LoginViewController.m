//
//  LoginViewController.m
//  TangShiService
//
//  Created by vision on 17/5/23.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "LoginViewController.h"
#import "BackScrollView.h"
#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "ServiceAgreementViewController.h"
#import <Hyphenate/Hyphenate.h>
#import <Hyphenate/EMError.h>
#import "TTGlobalUICommon.h"
#import "ExpertModel.h"
#import "SVProgressHUD.h"
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    UITextField      *loginField;
    UITextField      *passWordField;
    BOOL             isHasChoose;
    UIButton         *loginButton;
}

@property (nonatomic,strong)BackScrollView    *backScrollView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHasChoose=YES;
    
    [self initLoginView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.backScrollView endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [loginField resignFirstResponder];
    [passWordField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if (loginField==textField) {
        if ([textField.text length]<20) {
            return YES;
        }
    }
    if (passWordField==textField) {
        if ([textField.text length]<20) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -- Event Methods
#pragma mark 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark 是否阅读服务协议
-(void)haveReadAgreementAction:(UIButton *)sender{
    sender.selected=!sender.selected;
    
    isHasChoose=sender.selected;
    if (isHasChoose) {
        loginButton.enabled=YES;
        loginButton.backgroundColor=kSystemColor;
    }else{
        loginButton.enabled=NO;
        loginButton.backgroundColor=[UIColor lightGrayColor];
    }
}

#pragma mark 查看服务协议
-(void)checkInAgreementInfo{
    ServiceAgreementViewController *serviceVC=[[ServiceAgreementViewController alloc] init];
    serviceVC.url=[NSURL URLWithString:@"http://api.360tj.com/shared/reg/tsUserProtocol.html"];
    [self presentViewController:serviceVC animated:YES completion:nil];
}

#pragma mark -- 点击空白收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark NSNotification
#pragma mark  键盘弹出
- (void)loginKeyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void(^animation)() = ^{
        if (passWordField.bottom+40>keyBoardBounds.origin.y) {
            self.backScrollView.frame=CGRectMake(0, -(passWordField.bottom+40-keyBoardBounds.origin.y), kScreenWidth, kScreenHeight);
        }
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}
#pragma mark  键盘退出
-(void)loginKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
        self.backScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

#pragma mark  设置密码可见
- (void)setPwVisbleAction:(UIButton *)sender{
    sender.selected=!sender.selected;
    passWordField.secureTextEntry=!sender.selected;
}

#pragma mark  点击登陆
- (void)loginAction{
    [loginField resignFirstResponder];
    [passWordField resignFirstResponder];
    if (kIsEmptyString(loginField.text)) {
        [self.view makeToast:@"账号号不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }else if (kIsEmptyString(passWordField.text)) {
        [self.view makeToast:@"密码不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }else if (passWordField.text.length < 6){
        [self.view makeToast:@"请输入6-20位密码" duration:1.0 position:CSToastPositionCenter];
        return;
    }else if (!isHasChoose){
        return;
    }
    
    NSString *body = [NSString stringWithFormat:@"account=%@&password=%@",loginField.text,passWordField.text];
    [SVProgressHUD show];
    __weak typeof(self) weakSelf=self;
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithoutLoadingForURL:kLoginAPI body:body success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            NSString *userKey=[result valueForKey:@"user_key"];
            NSString *userSec=[result valueForKey:@"user_secret"];
            NSString *userToken=[result valueForKey:@"user_token"];
            NSString *photoStr=[result valueForKey:@"head_portrait"];

            [NSUserDefaultsInfos putKey:kUserKey andValue:userKey];
            [NSUserDefaultsInfos putKey:kUserSecret andValue:userSec];
            [NSUserDefaultsInfos putKey:kUserToken andValue:userToken];
            [NSUserDefaultsInfos putKey:kUserPhone andValue:loginField.text];
            [NSUserDefaultsInfos putKey:kUserPhoto andValue:photoStr];
            [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:YES]];
            [NSUserDefaultsInfos putKey:kUserID andValue:[result valueForKey:@"id"]];
            
            ExpertModel *expert=[[ExpertModel alloc] init];
            [expert setValues:result];
            
            [NSUserDefaultsInfos putKey:kNickName andValue:expert.name];
            [NSUserDefaultsInfos putKey:kImUsername andValue:expert.im_username];
            [NSUserDefaultsInfos putKey:kImPassword andValue:expert.im_password];
            
            //异步登陆账号
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] loginWithUsername:expert.im_username password:expert.im_password];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    if (!error) {
                        //设置是否自动登录
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                        //保存最近一次登录用户名
                        [NSUserDefaultsInfos putKey:kLastLoginUserName andValue:loginField.text];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
                        
                        NSString *tempStr=isTrueEnvironment?@"zs":@"cs";
                        NSString *aliasStr=[NSString stringWithFormat:@"%@_%@",tempStr,loginField.text];
                        [JPUSHService setAlias:aliasStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                            MyLog(@"登录 －－－－设置推送别名，code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, (long)seq);
                        } seq:5000];
                    } else {
                        switch (error.code)
                        {
                            case EMErrorUserNotFound:
                                TTAlertNoTitle(@"用户不存在");
                                break;
                            case EMErrorNetworkUnavailable:
                                TTAlertNoTitle(@"网络未连接!");
                                break;
                            case EMErrorServerNotReachable:
                                TTAlertNoTitle(@"连接服务器失败!");
                                break;
                            case EMErrorUserAuthenticationFailed:
                                TTAlertNoTitle(error.errorDescription);
                                break;
                            case EMErrorServerTimeout:
                                TTAlertNoTitle(@"连接服务器超时!");
                                break;
                            case EMErrorServerServingForbidden:
                                TTAlertNoTitle(@"服务被禁用");
                                break;
                            default:
                                TTAlertNoTitle(@"登录失败");
                                break;
                        }
                    }
                });
            });
            
        }
    } failure:^(NSString *errorStr) {
        [SVProgressHUD dismiss];
        [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];

}

-(void)callServicePhoneAction{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",PHONE_NUMBER];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


#pragma mark -- Private Methods
#pragma mark  初始化登陆界面
- (void)initLoginView{
    _backScrollView = [[BackScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.backScrollView atIndex:0];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 84, 80, 80)];
    imgView.image=[UIImage imageNamed:@"login_logo"];
    [self.backScrollView addSubview:imgView];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, imgView.bottom, 150, 30)];
    titleLabel.textColor=kSystemColor;
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=APP_DISPLAY_NAME;
    [self.backScrollView addSubview:titleLabel];
    
    loginField = [[UITextField alloc] initWithFrame:CGRectMake(40+20, titleLabel.bottom+30, kScreenWidth-100, 38)];
    loginField.returnKeyType=UIReturnKeyDone;
    loginField.keyboardType=UIKeyboardTypePhonePad;
    loginField.delegate = self;
    loginField.text = [NSUserDefaultsInfos getValueforKey:kLastLoginUserName];
    loginField.tag = 100;
    loginField.font = [UIFont systemFontOfSize:16];
    loginField.placeholder = @"请输入手机号";
    [self.backScrollView addSubview:loginField];
    
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(40+20, loginField.bottom+15, kScreenWidth-100, 38)];
    passWordField.clearsOnBeginEditing = YES;
    passWordField.returnKeyType=UIReturnKeyDone;
    passWordField.delegate = self;
    passWordField.tag = 101;
    passWordField.placeholder  = @"请输入密码";
    passWordField.font = [UIFont systemFontOfSize:16];
    passWordField.secureTextEntry = YES;
    [self.backScrollView addSubview:passWordField];
    
    UIButton *seeButton = [[UIButton alloc] initWithFrame:CGRectMake(passWordField.right-10, passWordField.top+10, 30, 20)];
    [seeButton setImage:[UIImage imageNamed:@"ic_login_noeye"] forState:UIControlStateNormal];
    [seeButton setImage:[UIImage imageNamed:@"ic_login_eye"] forState:UIControlStateSelected];
    [seeButton addTarget:self action:@selector(setPwVisbleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:seeButton];
    
    for (int i= 0; i<2; i++) {
        UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, titleLabel.bottom+35+53*i, 30, 30)];
        phoneImg.image = [UIImage imageNamed:i==0?@"ic_login_num":@"ic_login_code"];
        [self.backScrollView addSubview:phoneImg];
        
        UILabel *loginlbl = [[UILabel alloc] initWithFrame:CGRectMake(60, loginField.bottom+53*i, kScreenWidth-80, 1)];
        loginlbl.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.backScrollView addSubview:loginlbl];
    }
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, passWordField.bottom+30, kScreenWidth-40, 40)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.backgroundColor = kbgBtnColor;
    loginButton.layer.cornerRadius=5;
    loginButton.clipsToBounds=YES;
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:loginButton];
    
    UIButton *agreeBtn=[[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-240)/2, loginButton.bottom+20, 120, 30)];
    [agreeBtn setImage:[UIImage imageNamed:@"ic_eqment_pick_un"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"ic_eqment_pick_on"] forState:UIControlStateSelected];
    [agreeBtn setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    agreeBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, -5);
    [agreeBtn addTarget:self action:@selector(haveReadAgreementAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
    agreeBtn.selected=YES;
    
    UILabel *articleLab=[[UILabel alloc] initWithFrame:CGRectMake(agreeBtn.right, agreeBtn.top, 120, 30)];
    articleLab.text=@"《糖士服务协议》";
    articleLab.textColor=kSystemColor;
    articleLab.font=[UIFont systemFontOfSize:14];
    articleLab.userInteractionEnabled=YES;
    [self.view addSubview:articleLab];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkInAgreementInfo)];
    [articleLab addGestureRecognizer:tapGesture];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20, kScreenHeight-90, kScreenWidth-40, 30)];
    lab.text=@"暂不开放注册，如有疑问请咨询客服";
    lab.textAlignment=NSTextAlignmentCenter;
    lab.font=[UIFont systemFontOfSize:14];
    lab.textColor=[UIColor lightGrayColor];
    [self.view addSubview:lab];
    
    UILabel *phoneLab=[[UILabel alloc] initWithFrame:CGRectMake(50, lab.bottom, kScreenWidth-100, 30)];
    phoneLab.textAlignment=NSTextAlignmentCenter;
    phoneLab.font=[UIFont systemFontOfSize:14];
    phoneLab.textColor=[UIColor lightGrayColor];
    NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@转605",PHONE_NUMBER]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kbgBtnColor range:NSMakeRange(0, 13)];
    phoneLab.attributedText=attributeStr;
    phoneLab.userInteractionEnabled=YES;
    [self.view addSubview:phoneLab];
    
    UITapGestureRecognizer  *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callServicePhoneAction)];
    [phoneLab addGestureRecognizer:tap];
    
}



@end
