//
//  TCHttpRequest.m
//  TonzeCloud
//
//  Created by vision on 16/10/9.
//  Copyright © 2016年 tonze. All rights reserved.
//

#import "TCHttpRequest.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import "JPUSHService.h"

@interface TCHttpRequest ()<UIAlertViewDelegate>

@end
@implementation TCHttpRequest

singleton_implementation(TCHttpRequest)
#pragma mark - 基本网络请求（GET POST）
-(BOOL)isConnectedToNet{
    BOOL isYes = YES;
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isYes = NO;
            break;
        case ReachableViaWiFi:
            isYes = YES;
            break;
        case ReachableViaWWAN:
            isYes = YES;
            
        default:
            break;
    }
    return isYes;
}

#pragma mark 网络请求封装 post
-(void)postMethodWithURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success failure:(HttpFailure)failure{
    [SVProgressHUD show];
    NSString *urlString=[NSString stringWithFormat:kHostURL,urlStr];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    //请求头信息
    NSString *userKey=[NSUserDefaultsInfos getValueforKey:kUserKey];      //用户Key
    NSString *userToken=[NSUserDefaultsInfos getValueforKey:kUserToken];  //用户Secret
    
    NSString *currentDateStr=[[TCHelper sharedTCHelper] getCurrentDateTime];
    NSInteger timeSp=[[TCHelper sharedTCHelper] timeSwitchTimestamp:currentDateStr format:@"yyyy-MM-dd HH:mm"];  //时间戳
    
    NSString *appToken=[[[NSString stringWithFormat:@"%@%ld%@",kAppID,(long)timeSp,kAppSecret] MD5] uppercaseString];   //app签名
    
    NSDictionary *headDict=[[NSDictionary alloc] init];
    if (!kIsEmptyString(userToken)&&!kIsEmptyString(userKey)) {
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp],@"UserKey":userKey,@"UserToken":userToken};
    }else{
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp]};
    }
    [request setAllHTTPHeaderFields:headDict];
    MyLog(@"headerFields:%@",headDict);
    
    
    NSData *body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    MyLog(@"url:%@,bodyStr:%@",urlString,bodyStr);
    
    // 1> 接收到数据，表示工作正常
    // 2> 没有接收到数据，但是error为nil，表示接收到空数据
    //    通常服务器没有对该请求做任何响应
    // 3> error不为空，表示请求出错
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        if (data != nil) {
            NSString *html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MyLog(@"html:%@",html);
            id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            MyLog(@"json:%@",json);
            NSInteger status=[[json objectForKey:@"status"] integerValue];
             NSString *message=[json objectForKey:@"message"];
            if (status==1) {
                success(json);
            }else if (status==903){
                NSString *gag_time = [[json objectForKey:@"result"] objectForKey:@"gag_time"];
                NSString *gag_desc = [[json objectForKey:@"result"] objectForKey:@"gag_desc"];
                
                message = [NSString stringWithFormat:@"%@,%@,%@",message,gag_time,gag_desc];
                failure(message);
            }else if(status==10000||status==10001||status==10002||status==10003||status==10004){
                AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate pushToLoginVCWithStatus:status message:message];
            }else{
                message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                failure(message);
            }
        } else if (data == nil && connectionError == nil) {
            MyLog(@"接收到空数据");
        } else {
            MyLog(@"error:%@", connectionError.localizedDescription);
            failure(connectionError.localizedDescription);
        }
    }];
}
-(void)postMethodWithoutLoadingForURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *urlString=[NSString stringWithFormat:kHostURL,urlStr];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    //请求头信息
    NSString *userKey=[NSUserDefaultsInfos getValueforKey:kUserKey];      //用户Key
    NSString *userToken=[NSUserDefaultsInfos getValueforKey:kUserToken];  //用户Secret
    
    NSString *currentDateStr=[[TCHelper sharedTCHelper] getCurrentDateTime];
    NSInteger timeSp=[[TCHelper sharedTCHelper] timeSwitchTimestamp:currentDateStr format:@"yyyy-MM-dd HH:mm"];  //时间戳
    
    NSString *appToken=[[[NSString stringWithFormat:@"%@%ld%@",kAppID,(long)timeSp,kAppSecret] MD5] uppercaseString];   //app签名
    
    NSDictionary *headDict=[[NSDictionary alloc] init];
    if (!kIsEmptyString(userToken)&&!kIsEmptyString(userKey)) {
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp],@"UserKey":userKey,@"UserToken":userToken};
    }else{
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp]};
    }
    [request setAllHTTPHeaderFields:headDict];
    MyLog(@"headerFields:%@",headDict);
    
    
    NSData *body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    MyLog(@"url:%@,bodyStr:%@",urlString,bodyStr);
    
    // 1> 接收到数据，表示工作正常
    // 2> 没有接收到数据，但是error为nil，表示接收到空数据
    //    通常服务器没有对该请求做任何响应
    // 3> error不为空，表示请求出错
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSString *html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MyLog(@"html:%@",html);
            id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            MyLog(@"json:%@",json);
            NSInteger status=[[json objectForKey:@"status"] integerValue];
            NSString *message=[json objectForKey:@"message"];
            if (status==1) {
                success(json);
            }else if(status==10000||status==10001||status==10002||status==10003||status==10004){
                AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate pushToLoginVCWithStatus:status message:message];
            }else{
                message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                failure(message);
            }
        } else if (data == nil && connectionError == nil) {
            MyLog(@"接收到空数据");
        } else {
            MyLog(@"error:%@", connectionError.localizedDescription);
            failure(connectionError.localizedDescription);
        }
    }];
}

#pragma mark 网络请求封装 get
- (void)getMethodWithURL:(NSString *)urlStr success:(HttpSuccess)success failure:(HttpFailure)failure{
    [SVProgressHUD show];
    NSString *urlString=[NSString stringWithFormat:kHostURL,urlStr];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    MyLog(@"%@",urlString);
    
    //请求头信息
    NSString *userKey=[NSUserDefaultsInfos getValueforKey:kUserKey];      //用户Key
    NSString *userToken=[NSUserDefaultsInfos getValueforKey:kUserToken];  //用户Secret
    
    NSString *currentDateStr=[[TCHelper sharedTCHelper] getCurrentDateTime];
    NSInteger timeSp=[[TCHelper sharedTCHelper] timeSwitchTimestamp:currentDateStr format:@"yyyy-MM-dd HH:mm"];  //时间戳
    
    NSString *appToken=[[[NSString stringWithFormat:@"%@%ld%@",kAppID,(long)timeSp,kAppSecret] MD5] uppercaseString];   //app签名
    NSDictionary *headDict=[[NSDictionary alloc] init];
    if (!kIsEmptyString(userToken)&&!kIsEmptyString(userKey)) {
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp],@"UserKey":userKey,@"UserToken":userToken};
    }else{
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp]};
    }
    [request setAllHTTPHeaderFields:headDict];
    MyLog(@"headerFields:%@",headDict);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        if (data != nil) {
            NSString *html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MyLog(@"html:%@",html);
            id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            MyLog(@"json:%@",json);
            NSInteger status=[[json objectForKey:@"status"] integerValue];
            NSString *message=[json objectForKey:@"message"];
            if (status==1) {
                success(json);
            }else if(status==10000||status==10001||status==10002||status==10003||status==10004){
                AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate pushToLoginVCWithStatus:status message:message];
            }else{
                message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                failure(message);
            }
        } else if (data == nil && connectionError == nil) {
            MyLog(@"接收到空数据");
        } else {
            MyLog(@"error:%@", connectionError.localizedDescription);
            failure(connectionError.localizedDescription);
        }
    }];
}


#pragma mark 网络请求封装 get
- (void)getMethodWithoutLoadingWithURL:(NSString *)urlStr success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *urlString=[NSString stringWithFormat:kHostURL,urlStr];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    MyLog(@"%@",urlString);
    
    //请求头信息
    NSString *userKey=[NSUserDefaultsInfos getValueforKey:kUserKey];      //用户Key
    NSString *userToken=[NSUserDefaultsInfos getValueforKey:kUserToken];  //用户Secret
    
    NSString *currentDateStr=[[TCHelper sharedTCHelper] getCurrentDateTime];
    NSInteger timeSp=[[TCHelper sharedTCHelper] timeSwitchTimestamp:currentDateStr format:@"yyyy-MM-dd HH:mm"];  //时间戳
    
    NSString *appToken=[[[NSString stringWithFormat:@"%@%ld%@",kAppID,(long)timeSp,kAppSecret] MD5] uppercaseString];   //app签名
    NSDictionary *headDict=[[NSDictionary alloc] init];
    if (!kIsEmptyString(userToken)&&!kIsEmptyString(userKey)) {
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp],@"UserKey":userKey,@"UserToken":userToken};
    }else{
        headDict=@{@"AppId":kAppID,@"AppToken":appToken,@"TimeStamp":[NSString stringWithFormat:@"%ld",(long)timeSp]};
    }
    [request setAllHTTPHeaderFields:headDict];
    MyLog(@"headerFields:%@",headDict);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSString *html=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MyLog(@"html:%@",html);
            id json=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            MyLog(@"json:%@",json);
            NSInteger status=[[json objectForKey:@"status"] integerValue];
            NSString *message=[json objectForKey:@"message"];
            if (status==1) {
                success(json);
            }else if(status==10000||status==10001||status==10002||status==10003||status==10004){
                AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate pushToLoginVCWithStatus:status message:message];
            }else{
                message=kIsEmptyString(message)?@"暂时无法访问，请稍后再试":message;
                failure(message);
            }
        } else if (data == nil && connectionError == nil) {
            MyLog(@"接收到空数据");
        } else {
            MyLog(@"error:%@", connectionError.localizedDescription);
            failure(connectionError.localizedDescription);
        }
    }];
}


-(void)refreshUserTokenAction{
    NSString *userKey=[NSUserDefaultsInfos getValueforKey:kUserKey];             //用户key
    NSString *userSecret=[NSUserDefaultsInfos getValueforKey:kUserSecret];       //用户secret
    if (!kIsEmptyString(userKey)) {
        NSString *currentDateStr=[[TCHelper sharedTCHelper] getCurrentDateTime];
        NSInteger timeSp=[[TCHelper sharedTCHelper] timeSwitchTimestamp:currentDateStr format:@"yyyy-MM-dd HH:mm"];  //时间戳
        NSString *userSign=[NSString stringWithFormat:@"%@%ld%@",userKey,(long)timeSp,userSecret];          //签名
        NSString *body=[NSString stringWithFormat:@"user_key=%@&user_sign=%@&timestamp=%ld",userKey,[[userSign MD5] uppercaseString],(long)timeSp];
        __weak typeof(self) weakSelf =self;
        [self postMethodWithoutLoadingForURL:kGetTokenAPI body:body success:^(id json) {
            NSDictionary *result=[json objectForKey:@"result"];
            NSString *userToken=[result valueForKey:@"user_token"];
            [NSUserDefaultsInfos putKey:kUserToken andValue:userToken];
            [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:YES]];
          
            //登录环信
            NSString *imUsername=[NSUserDefaultsInfos getValueforKey:kImUsername];
            NSString *imPassword=[NSUserDefaultsInfos getValueforKey:kImPassword];
            if (!kIsEmptyString(imUsername)&&!kIsEmptyString(imPassword)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    EMError *error = [[EMClient sharedClient] loginWithUsername:imUsername password:imPassword];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            //设置是否自动登录
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            
                            [[ChatHelper sharedChatHelper] saveImUsersForLoadMyusersSuccess:^(NSInteger count) {
                                
                            }];
                            
                            NSString *tempStr=isTrueEnvironment?@"zs":@"cs";
                            NSString *aliasStr=[NSString stringWithFormat:@"%@_%@",tempStr,[NSUserDefaultsInfos getValueforKey:kUserPhone]];
                            [JPUSHService setAlias:aliasStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                                MyLog(@"登录 －－－－设置推送别名，code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, (long)seq);
                            } seq:5000];
                        } else {
                            MyLog(@"error:%@",error.errorDescription);
                        }
                    });
                });
            }
            [weakSelf loadExpertBaseInfo];
            
        } failure:^(NSString *errorStr) {
            [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
        }];
    }
 }
#pragma mark --其他数据转json数据
-(NSString *)getValueWithParams:(id)params{
    SBJsonWriter *writer=[[SBJsonWriter alloc] init];
    NSString *value=[writer stringWithObject:params];
    MyLog(@"value:%@",value);
    return value;
}

#pragma mark 获取专家信息
-(void)loadExpertBaseInfo{
    [[TCHttpRequest sharedTCHttpRequest] getMethodWithoutLoadingWithURL:kExpertInfo success:^(id json) {
        NSDictionary *result=[json objectForKey:@"result"];
        if (kIsDictionary(result)&&result.count>0) {
            [NSUserDefaultsInfos putKey:kExpertInfoKey andValue:result];
            ExpertModel *model=[[ExpertModel alloc] init];
            [model setValues:result];
            
        }
    } failure:^(NSString *errorStr) {
        
    }];
    
}


@end
