//
//  FeebackViewController.m
//  TangShiService
//
//  Created by vision on 17/5/25.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "FeebackViewController.h"
#import "BackScrollView.h"
#import "TCMyFeedbackViewController.h"

@interface FeebackViewController ()<UITextViewDelegate>{
    
    UILabel    *promptLabel;
    UILabel    *countLabel;
    UITextView *idTextView;
}

@property (nonatomic,strong)BackScrollView  *rootScrollView;
//  红点标记
@property (nonatomic,strong)UILabel              *badgeLbl;
@end

@implementation FeebackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle=@"意见反馈";
    self.rigthTitleName = @"我的反馈";
    self.view.backgroundColor=[UIColor whiteColor];
    
     [self initIdeaBackView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadNewBackMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ideaBackKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ideaBackKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark -- NSNotification
#pragma mark 键盘弹出
-(void)ideaBackKeyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void(^animation)() = ^{
        if (idTextView.top+30>keyBoardBounds.origin.y) {
            self.rootScrollView.frame=CGRectMake(0, -(idTextView.top+30-keyBoardBounds.origin.y), kScreenWidth, kRootViewHeight);
        }
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

#pragma mark  键盘退出
-(void)ideaBackKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
        self.rootScrollView.frame = CGRectMake(0, 64, kScreenWidth, kRootViewHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

#pragma mark--UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSString *tString = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    countLabel.text = tString;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]!= 0) {
        promptLabel.hidden = YES;
    }else{
        promptLabel.hidden = NO;
        NSString *tString = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
        countLabel.text = tString;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView==idTextView) {
        
        if ([textView.text length]+text.length>200) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}
#pragma mark -- 点击空白收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
#pragma mark -- Event response
#pragma mark -- 提交反馈
- (void)retainButton{
    BOOL isEmojiBool = [[TCHelper sharedTCHelper] strIsContainEmojiWithStr:idTextView.text];
    if (isEmojiBool) {
        [self.view makeToast:@"不能保存特殊符号" duration:1.0 position:CSToastPositionCenter];
    } else {
        if (idTextView.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写问题或建议！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            // App版本信息
            NSString *version = [NSString getAppVersion];
            // 设备型号
            NSString *systemName = [UIDevice getSystemName];
            // 系统版本
            NSString *systemVersion = [UIDevice getSystemVersion];
            NSString *time = [[TCHelper sharedTCHelper] getCurrentDateTime];
            NSInteger ideaBackTime =[[TCHelper sharedTCHelper] timeSwitchTimestamp:time format:@"yyyy-MM-dd HH:mm"];
            NSString *urlString = [NSString stringWithFormat:@"AccessToken=1&feedback_time=%ld&feedback_content=%@&doSubmit=1&app_version=%@&unit_type=%@&unit_system=%@&role_type=2",(long)ideaBackTime,idTextView.text,version,systemName,systemVersion];
            kSelfWeak;
            [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kAddFeedBack body:urlString success:^(id json) {
                idTextView.text = @"";
                promptLabel.hidden = NO;
                [weakSelf.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
            } failure:^(NSString *errorStr) {
                [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            }];
        }
    }

//    if (idTextView.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写问题或建议！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    } else {
//        __weak typeof(self) weakSelf=self;
//        NSString *body = [NSString stringWithFormat:@"feedback_content=%@",idTextView.text];
//        [[TCHttpRequest sharedTCHttpRequest] postMethodWithURL:kAddFeedBack body:body success:^(id json) {
//            [weakSelf.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSString *errorStr) {
//            [weakSelf.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
//        }];
//    }
}
#pragma mark -- 获取最新反馈信息
- (void)loadNewBackMessage{
    
    NSString *body = [NSString stringWithFormat:@"role_type=2"];
    [[TCHttpRequest sharedTCHttpRequest] postMethodWithoutLoadingForURL:KFeedbackNewMessage body:body success:^(id json) {
        NSInteger result = [[json objectForKey:@"result"] integerValue];
        _badgeLbl.hidden = result==0;
        
    } failure:^(NSString *errorStr) {
        [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark -- 我的反馈
- (void)rightButtonAction{
    TCMyFeedbackViewController *myFeedbackVC = [[TCMyFeedbackViewController alloc] init];
    [self.navigationController pushViewController:myFeedbackVC animated:YES];
}
#pragma mark-- Custom Methods
#pragma mark -- 初始化界面
- (void)initIdeaBackView{
    [self.view addSubview:self.badgeLbl];

    self.rootScrollView=[[BackScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kRootViewHeight)];
    [self.view insertSubview:self.rootScrollView atIndex:0];
    
    UIView *bgView =  [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 210)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.rootScrollView addSubview:bgView];
    
    idTextView = [[UITextView alloc] initWithFrame:CGRectMake(15,16, kScreenWidth-30, 200)];
    idTextView.layer.borderWidth=1;
    idTextView.layer.borderColor = [UIColor bgColor_Gray].CGColor;
    idTextView.layer.masksToBounds = YES;
    idTextView.font = [UIFont systemFontOfSize:15];
    idTextView.delegate = self;
    idTextView.returnKeyType=UIReturnKeyDone;
    [self.rootScrollView addSubview:idTextView];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,23,kScreenWidth-40, 20)];
    promptLabel.text = @"请简要描述你的问题和意见";
    promptLabel.font = [UIFont systemFontOfSize:16];
    promptLabel.textColor = [UIColor lightGrayColor];
    [self.rootScrollView addSubview:promptLabel];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, idTextView.bottom-30, 80, 20)];
    countLabel.text = @"0/200";
    countLabel.textColor = [UIColor lightGrayColor];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont systemFontOfSize:14];
    [self.rootScrollView addSubview:countLabel];
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, idTextView.bottom+10, kScreenWidth, 30)];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.font = [UIFont systemFontOfSize:13];
    tLabel.textColor = [UIColor grayColor];
    tLabel.numberOfLines = 0;
    NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:@"您可在此留下宝贵的建议，或添加糖士官方微信号：tangshi0109反馈。我们将及时给予答复。"];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kbgBtnColor range:NSMakeRange(23, 11)];
    tLabel.attributedText=attributeStr;
    CGSize tSize = [tLabel.text sizeWithLabelWidth:kScreenWidth-40 font:[UIFont systemFontOfSize:13]];
    tLabel.frame = CGRectMake(20, idTextView.bottom+30, kScreenWidth-40, tSize.height);
    [self.rootScrollView addSubview:tLabel];
    
    UIButton *retainBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, tLabel.bottom+30, kScreenWidth-100, 40)];
    [retainBtn setTitle:@"提交" forState:UIControlStateNormal];
    retainBtn.layer.cornerRadius = 5;
    [retainBtn setBackgroundColor:kSystemColor];
    [retainBtn addTarget:self action:@selector(retainButton) forControlEvents:UIControlEventTouchUpInside];
    [self.rootScrollView addSubview:retainBtn];
}
#pragma mark 红色标记
-(UILabel *)badgeLbl{
    if (_badgeLbl==nil) {
        _badgeLbl=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-17, 30, 10, 10)];
        _badgeLbl.backgroundColor=[UIColor redColor];
        _badgeLbl.layer.cornerRadius=5;
        _badgeLbl.clipsToBounds=YES;
        _badgeLbl.textColor=[UIColor whiteColor];
        _badgeLbl.textAlignment=NSTextAlignmentCenter;
        _badgeLbl.font=[UIFont systemFontOfSize:10];
        _badgeLbl.hidden = YES;
    }
    return _badgeLbl;
}

@end
