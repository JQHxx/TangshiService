//
//  TCHttpRequest.h
//  TonzeCloud
//
//  Created by vision on 16/10/9.
//  Copyright © 2016年 tonze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertModel.h"

typedef void (^HttpSuccess)(id json);//请求成功后的回调
typedef void (^HttpFailure)(NSString *errorStr);//请求失败后的回调

@interface TCHttpRequest : NSObject

singleton_interface(TCHttpRequest)


-(BOOL)isConnectedToNet;

-(void)getMethodWithURL:(NSString *)urlStr success:(HttpSuccess)success failure:(HttpFailure)failure;

-(void)postMethodWithURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success failure:(HttpFailure)failure;

-(void)postMethodWithoutLoadingForURL:(NSString *)urlStr body:(NSString *)bodyStr success:(HttpSuccess)success failure:(HttpFailure)failure;

- (void)getMethodWithoutLoadingWithURL:(NSString *)urlStr success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 * 刷新用户凭证
 */
-(void)refreshUserTokenAction;

-(NSString *)getValueWithParams:(id)params;

@end
