//
//  BloodRecordModel.h
//  TangShiService
//
//  Created by vision on 17/5/31.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodRecordModel : NSObject

@property (nonatomic, copy) NSString *measurement_time;   //测量时间

@property (nonatomic, copy) NSString *way;           //添加方式 ，设备或手动

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *deviceid;     //设备ID

@property (nonatomic, copy) NSString *time_slot;    //时间段

@property (nonatomic, copy) NSString *glucose;      //血糖值

@property (nonatomic, copy) NSString *code;

@end
