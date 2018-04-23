//
//  TCServiceStateViewController.h
//  TonzeCloud
//
//  Created by vision on 17/6/21.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TCMineServiceModel.h"

@protocol TCServiceStateViewControllerDelegate <NSObject>

//选择cell
-(void)serviceStateVCDidSelectedCellWithModel:(TCMineServiceModel *)myService;

@end


@interface TCServiceStateViewController : BaseViewController

@property (nonatomic,assign)id<TCServiceStateViewControllerDelegate>controllerDelegate;

@property (nonatomic,assign)NSInteger userID;
@property (nonatomic,assign)NSInteger expert_id;
@property (nonatomic,assign)BOOL      isUserDetail;

@end
