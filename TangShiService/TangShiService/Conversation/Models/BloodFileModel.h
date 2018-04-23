//
//  BloodFileModel.h
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodFileModel : NSObject


@property(nonatomic, copy)NSString *diabetes_type;                 //糖尿病类型
@property(nonatomic, copy)NSString *diagnosis_year;                //确认日期
@property(nonatomic, copy)NSString *treatment_method;              //治疗方法
@property(nonatomic, copy)NSString *diastolic_blood_pressure;      //舒张压
@property(nonatomic, copy)NSString *systolic_pressure;             //收缩压
@property(nonatomic, copy)NSString *other_diseases;                //并发症
@property(nonatomic,strong)NSNumber *is_smoking;                   //是否吸烟
@property(nonatomic,strong)NSNumber *is_drinking;                  //是否喝酒

@end
