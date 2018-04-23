//
//  MineInfoViewController.h
//  TangShiService
//
//  Created by vision on 17/5/25.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ExpertModel.h"

@interface MineInfoViewController : BaseViewController

@property (nonatomic,assign)NSInteger   expert_id;

@property (nonatomic,strong)ExpertModel *model;

@end
