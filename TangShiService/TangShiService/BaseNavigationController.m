//
//  BaseNavigationController.m
//  Tianjiyun
//
//  Created by vision on 16/9/20.
//  Copyright © 2016年 vision. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+Extend.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏背景
    
    UIImage *img=[UIImage imageWithColor:kSystemColor size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.tintColor=[UIColor whiteColor];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
