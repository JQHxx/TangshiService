//
//  UserBaseViewController.h
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserModel.h"

@interface UserBaseViewController : BaseViewController

@property (nonatomic,assign)BOOL      isServingIn;
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,strong)UserModel *userModel;

@end
