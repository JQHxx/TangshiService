//
//  TCBasewebViewController.m
//  TonzeCloud
//
//  Created by vision on 17/3/21.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "TCBasewebViewController.h"
#import "SVProgressHUD.h"
#import <WebKit/WebKit.h>
#import "IQKeyboardManager.h"
#import "NSString+Extend.h"
#import "UIDevice+Extend.h"
#import "ActionSheetView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "TCMyDynamicViewController.h"
#import "LoginViewController.h"
#import "TCNoInputAccessoryView.h"

@interface TCBasewebViewController ()<WKUIDelegate,WKNavigationDelegate>{
    UIImageView    *shareImageView;
}
@property (nonatomic, strong) WKWebView  *rootWebView;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UILabel *menuNavLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation TCBasewebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle=self.titleText;
    
    shareImageView = [[UIImageView alloc] init];
    if (kIsEmptyString(self.image_url)) {
        shareImageView.image=[UIImage imageNamed:@"img_bg_title"];
    }else{
        [shareImageView sd_setImageWithURL:[NSURL URLWithString:self.image_url] placeholderImage:[UIImage imageNamed:@"img_bg_title"]];
    }
    [self.view addSubview:self.rootWebView];
    
    TCNoInputAccessoryView *inputAccessoryView = [TCNoInputAccessoryView new];
    [inputAccessoryView removeInputAccessoryViewFromWKWebView:self.rootWebView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.progressTintColor = UIColorFromRGB(0xfff100);
    //设置进度条的高度
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    //3.添加KVO，监听WKWebView有一个属性estimatedProgress
    [self.rootWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self requestWebView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar =NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar: YES];
}
#pragma mark - 监听web加载进度
//在监听方法中获取网页加载的进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.rootWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
} 

#pragma mark - WKWKNavigationDelegate Methods
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    if (self.isSystemNewsIn) {
        [TCHelper sharedTCHelper].isSystemNewsReload=YES;
        if (self.backBlock) {
            self.backBlock();
        }
    }
    if (self.type==BaseWebViewTypeArticle) {
        if (self.backBlock) {
            self.backBlock();
        }
    }
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    if (self.type == BaseWebViewTypeArticle||self.type==BaseWebViewTypeNewsArticle) {
        [self handleCustomAction:URL];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark -- Private Methods
#pragma mark -----  js事件处理 -------
- (void)handleCustomAction:(NSURL *)URL{
    NSString    *scheme = [URL absoluteString];
    NSArray     *urlArray = [scheme componentsSeparatedByString:@"?"];
    NSString    *urlTag = urlArray[1];
    NSArray     *shareArr = [urlTag componentsSeparatedByString:@"&"];
    NSString    *shareTag = shareArr[0];
    NSString    *typeStr = [urlTag substringWithRange:NSMakeRange(0, 4)];
    NSString    *artStr = [urlTag substringWithRange:NSMakeRange(0, 5)];
    
    if ([shareTag isEqualToString:@"share=1"]) {
        // 分享
        NSString *shareStr =shareArr[1];
        NSArray  *titleArr = [shareStr componentsSeparatedByString:@"="];
        NSString *titleStr = [titleArr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        [self shareAction:titleStr];
    }else if([typeStr isEqualToString:@"type"]){
        // 点击人或者头像
        NSArray *dataArray =[urlTag componentsSeparatedByString:@"&"];
        NSString    *role_type =[dataArray[0] substringFromIndex:5];
        NSString    *useIdStr = [dataArray[1] substringFromIndex:7];
        TCMyDynamicViewController *userInfoVC = [[TCMyDynamicViewController alloc] init];
        userInfoVC.news_id = [useIdStr integerValue];
        userInfoVC.role_type_ed = [role_type integerValue];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else if ([artStr isEqualToString:@"artId"]){
        NSArray     *artArray = [urlTag componentsSeparatedByString:@"&"];
        NSString    *artID = [artArray[0] substringFromIndex:6];
        NSString    *imgUrl = [artArray[1] substringFromIndex:7];
//        NSString    *classifyId =[artArray[2] substringFromIndex:11];
        NSString    *titleStr =[[artArray[3] substringFromIndex:9]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        TCBasewebViewController *webVC=[[TCBasewebViewController alloc] init];
        webVC.type=BaseWebViewTypeArticle;
        webVC.titleText=@"糖士-糖百科";
        webVC.shareTitle = titleStr;
        webVC.image_url = imgUrl;
        webVC.articleID = [artID integerValue];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([urlTag isEqualToString:@"keyboard=1"]){
        //无需处理用于客户端登录判断
    }
}
#pragma mark -- Private Methods
-(void)requestWebView{
    if (_type == BaseWebViewTypeArticle||_type==BaseWebViewTypeNewsArticle) {
        // App版本信息
        NSString *version = [NSString getAppVersion];
        // 设备型号
        NSString *systemName = [UIDevice getSystemName];
        // 系统版本
        NSString *systemVersion = [UIDevice getSystemVersion];
        NSString *userKey=[NSUserDefaultsInfos getValueforKey:kUserKey];      //用户Key
        NSString *url =_type==BaseWebViewTypeArticle?[NSString stringWithFormat:@"%@?key=%@&artId=%ld&type=2&appVersion=%@&systemName=%@&systemVersion=%@",kWebUrl,userKey,(long)_articleID,version,systemName,systemVersion]:[NSString stringWithFormat:@"%@?key=%@&artId=%ld&type=2&appVersion=%@&systemName=%@&systemVersion=%@&message_id=%ld&message_user_id=%ld",kWebUrl,userKey,(long)_articleID,version,systemName,systemVersion,(long)self.message_id,(long)self.message_user_id];
        MyLog(@"文章地址：%@",url);
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [self.rootWebView loadRequest:req];
    }else{
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
        [self.rootWebView loadRequest:req];
    }
}
#pragma mark -- 分享文章
- (void)shareAction:(NSString *)title{
    NSArray *titlearr = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博",@""];
    NSArray *imageArr = @[@"ic_pub_share_wx",@"ic_pub_share_pyq",@"ic_pub_share_qq",@"ic_pub_share_qzone",@"ic_pub_share_wb",@""];
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {

        if (btnTag==0||btnTag==1||btnTag==2||btnTag==3) {
            //分享代码
            [self shareWeixin:btnTag title:title];
            
        }else if (btnTag==4){
            [self shareSinaWithBtnTag:btnTag title:title];
        }else{
            
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}
#pragma mark -- 分享微信／qq
- (void)shareWeixin:(NSInteger)btnTag title:(NSString *)title{
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@?artId=%ld&flag=true",kWebUrl,(long)_articleID];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (shareImageView) {
        [shareParams SSDKSetupShareParamsByText:btnTag==1?title:@"糖士-糖百科"
                                         images:shareImageView.image
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shareUrl]]
                                          title:title
                                           type:SSDKContentTypeAuto];
    }
    [shareParams SSDKEnableUseClientShare];
    if (btnTag==0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            //微信
            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                [self shareSuccessorError:state btnTag:btnTag];
            }];
        }else{
            [self.view makeToast:@"请先安装微信客户端" duration:1.0 position:CSToastPositionCenter];
        }
        
    }else if (btnTag==1){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            //微信
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                [self shareSuccessorError:state btnTag:btnTag];
            }];
        }else{
            [self.view makeToast:@"请先安装微信客户端" duration:1.0 position:CSToastPositionCenter];
        }
        
    }else if (btnTag==2){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                [self shareSuccessorError:state btnTag:btnTag];
            }];
        }else{
            [self.view makeToast:@"请先安装QQ客户端" duration:1.0 position:CSToastPositionCenter];
        }
        
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                [self shareSuccessorError:state btnTag:btnTag];
            }];
        }else{
            [self.view makeToast:@"请先安装QQ客户端" duration:1.0 position:CSToastPositionCenter];
        }
        
    }
}
#pragma mark -- 分享新浪
- (void)shareSinaWithBtnTag:(NSInteger)btnTag title:(NSString *)title{
//    NSString *shareUrl=self.urlStr;
    NSString *shareUrl=[NSString stringWithFormat:@"%@?artId=%ld&flag=true",kWebUrl,(long)_articleID];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",title,
                                             [NSURL URLWithString:shareUrl]]
                                     images:shareImageView.image
                                        url:[NSURL URLWithString:shareUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKEnableUseClientShare];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) {
        //新浪微博
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            [self shareSuccessorError:state btnTag:btnTag];
        }];
    }else{
        [self.view makeToast:@"请先安装新浪微博客户端" duration:1.0 position:CSToastPositionCenter];
    }
}
#pragma mark -- 分享成功／失败／取消
- (void)shareSuccessorError:(NSInteger)state btnTag:(NSInteger)btnTag{
    if (state==1) {
        [self.view makeToast:@"分享成功" duration:1.0 position:CSToastPositionCenter];
       
    }else if (state==2){
        [self.view makeToast:@"分享失败" duration:1.0 position:CSToastPositionCenter];
    }else{
        if (btnTag == 2 || btnTag == 3) {
            
        }else{
            [self.view makeToast:@"分享取消" duration:1.0 position:CSToastPositionCenter];
        }
    }
}
#pragma mark -- setters and getters
-(WKWebView *)rootWebView{
    if (_rootWebView==nil) {
        _rootWebView=[[WKWebView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth, kRootViewHeight)];
        _rootWebView.UIDelegate=self;
        _rootWebView.navigationDelegate = self;
    }
    return _rootWebView;
}
- (void)dealloc {
    [self.rootWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
