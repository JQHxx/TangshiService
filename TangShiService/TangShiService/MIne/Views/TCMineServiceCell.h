//
//  TCMineServiceCell.h
//  TonzeCloud
//
//  Created by 肖栋 on 17/2/19.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCMineServiceModel.h"

@protocol TCMineServiceDelegate <NSObject>
@required
- (void)chatDeledalegate:(NSInteger)index;
@end
@interface TCMineServiceCell : UITableViewCell

@property (nonatomic,assign) id <TCMineServiceDelegate> serviceDelegate;

-(void)cellDisplayWithDict:(TCMineServiceModel *)myServiceModel index:(NSInteger)index;

@end
