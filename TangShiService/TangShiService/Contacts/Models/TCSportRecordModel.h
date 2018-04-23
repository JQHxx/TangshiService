//
//  TCSportRecordModel.h
//  UUChartView
//
//  Created by vision on 17/3/16.
//  Copyright © 2017年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSportRecordModel : NSObject

@property (nonatomic, copy) NSString *motion_type;   //运动类型

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, copy) NSString *motion_begin_time;   //运动开始时间

@property (nonatomic, copy) NSString *calorie;          //运动消耗热量

@property (nonatomic, copy) NSString *motion_time;      //运动时长


@end
