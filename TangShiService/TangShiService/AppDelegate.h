//
//  AppDelegate.h
//  TangShiService
//
//  Created by vision on 17/5/22.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) BaseTabBarViewController  *tabBarViewController;


-(void)pushToLoginVCWithStatus:(NSInteger)status message:(NSString *)message;


@end

