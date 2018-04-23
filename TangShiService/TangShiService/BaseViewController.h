//
//  BaseViewController.h
//  TangShiService
//
//  Created by vision on 17/6/2.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,assign)BOOL isBackBtnHidden;
@property (nonatomic ,assign)BOOL      isHiddenNavBar;     //隐藏导航栏
@property (nonatomic ,assign)BOOL      isHiddenBackBtn;     //隐藏返回按钮
@property (nonatomic ,copy)NSString    *baseTitle;        //标题
@property (nonatomic ,copy)NSString    *leftImageName;
@property (nonatomic ,copy)NSString    *leftTitleName;
@property (nonatomic ,copy)NSString    *rightImageName;
@property (nonatomic ,copy)NSString    *rigthTitleName;
@property (nonatomic, assign) BOOL      rightBtnEnabled;    // 右按钮是否可点击

- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;

-(void)backAction;

-(void)leftButtonAction;
-(void)rightButtonAction;

@end
