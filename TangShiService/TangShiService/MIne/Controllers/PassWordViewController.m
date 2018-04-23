//
//  PassWordViewController.m
//  TangShiService
//
//  Created by 肖栋 on 17/9/6.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()<UITextFieldDelegate>{
    
    UITextField     *oldpassTextField;
    UITextField     *newpassFiled;
    UITextField     *againpassFiled;
    
}
@end
@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"修改密码";
    self.view.backgroundColor = [UIColor bgColor_Gray];
    [self initAlertPassWordView];
}
#pragma mark -- textfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{       NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
        
    }
    if (textField.text.length+string.length > 20)
    {
        return NO;
    }
    return YES;
}
#pragma mark -- Event response
#pragma mark -- 修改密码
- (void)certainButton{
    if (kIsEmptyString(oldpassTextField.text)||kIsEmptyString(newpassFiled.text)||kIsEmptyString(againpassFiled.text)) {
        [self.view makeToast:@"密码不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (newpassFiled.text.length<6||againpassFiled.text.length<6) {
        [self.view makeToast:@"新密码不能少于6位" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(![newpassFiled.text isEqualToString:againpassFiled.text]){
        [self.view makeToast:@"两次输入密码不一致" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *body=[NSString stringWithFormat:@"old_passwd=%@&new_passwd=%@&confirm_passwd=%@",oldpassTextField.text,newpassFiled.text,againpassFiled.text];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kChangePassWord body:body success:^(id json) {
        [self.view makeToast:@"修改成功" duration:1.0 position:CSToastPositionCenter];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorStr) {
        [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark -- 点击空白收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
#pragma mark-- Custom Methods
#pragma mark -- 初始化界面
- (void)initAlertPassWordView{
    UIView *oldpassView = [[UIView alloc] initWithFrame:CGRectMake(0,74, kScreenWidth, 50)];
    oldpassView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oldpassView];
    
    oldpassTextField=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-60, 30)];
    oldpassTextField.placeholder=@"请输入原始密码";
    oldpassTextField.returnKeyType=UIReturnKeyDone;
    oldpassTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    oldpassTextField.font=[UIFont systemFontOfSize:14];
    oldpassTextField.secureTextEntry=YES;
    oldpassTextField.delegate=self;
    oldpassTextField.returnKeyType=UIReturnKeyDone;
    [oldpassView addSubview:oldpassTextField];
    
    UIView *newpassView = [[UIView alloc] initWithFrame:CGRectMake(0,oldpassView.bottom+10, kScreenWidth, 50)];
    newpassView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newpassView];
    
    newpassFiled=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-60, 30)];
    newpassFiled.placeholder=@"请输入新密码（密码6-20位）";
    newpassFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    newpassFiled.returnKeyType=UIReturnKeyDone;
    newpassFiled.font=[UIFont systemFontOfSize:14];
    newpassFiled.secureTextEntry=YES;
    newpassFiled.delegate=self;
    newpassFiled.returnKeyType=UIReturnKeyDone;
    [newpassView addSubview:newpassFiled];
    
    UIView * againpassView = [[UIView alloc] initWithFrame:CGRectMake(0,newpassView.bottom+1, kScreenWidth, 50)];
    againpassView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:againpassView];
    
    againpassFiled=[[UITextField alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-60, 30)];
    againpassFiled.returnKeyType=UIReturnKeyDone;
    againpassFiled.placeholder=@"请再次输入新密码";
    againpassFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    againpassFiled.font=[UIFont systemFontOfSize:14];
    againpassFiled.secureTextEntry=YES;
    againpassFiled.delegate=self;
    againpassFiled.returnKeyType=UIReturnKeyDone;
    [againpassView addSubview:againpassFiled];
    
    UIButton *certainButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-241)/2, againpassView.bottom+80, 241, 40)];
    [certainButton setTitle:@"确认" forState:UIControlStateNormal];
    [certainButton addTarget:self action:@selector(certainButton) forControlEvents:UIControlEventTouchUpInside];
    certainButton.layer.cornerRadius = 3;
    certainButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [certainButton setBackgroundColor:kSystemColor];
    [self.view addSubview:certainButton];
}
@end
