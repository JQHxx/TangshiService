//
//  TCServiceDetailViewController.h
//  TonzeCloud
//
//  Created by vision on 17/6/21.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "BaseViewController.h"
#import "TCMineServiceModel.h"

@interface TCServiceDetailViewController : BaseViewController

@property (nonatomic,assign)BOOL   isMyServiceIn;
@property (nonatomic,strong)TCMineServiceModel *myService;

@end
