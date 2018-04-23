//
//  NSUserDefaultsInfos.m
//  TonzeCloud
//
//  Created by vision on 17/2/20.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "NSUserDefaultsInfos.h"

@implementation NSUserDefaultsInfos

+(void)putKey:(NSString *)key andValue:(NSObject *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(id )getValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id result= [defaults objectForKey:key];
    if(!result){
        result = nil;
    }
    return result;
}

+(void)removeObjectForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

@end
