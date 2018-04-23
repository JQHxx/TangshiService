//
//  TCSugarModel.h
//  TonzeCloud
//
//  Created by vision on 17/2/23.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSugarModel : NSObject

@property (nonatomic, copy) NSString *measurement_time;   //测量时间

@property (nonatomic, copy) NSString *way;           //添加方式 ，设备或手动

@property (nonatomic, copy) NSString *time_slot;    //时间段

@property (nonatomic, copy) NSString *glucose;      //血糖值


@end
