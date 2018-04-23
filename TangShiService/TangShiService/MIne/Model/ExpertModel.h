//
//  ExpertModel.h
//  TangShiService
//
//  Created by vision on 17/5/25.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertModel : NSObject

@property(nonatomic,copy)NSString  *head_portrait;               //头像
@property(nonatomic,copy)NSString  *name;                        //姓名
@property(nonatomic,copy)NSString  *positional_titles;           //职称
@property(nonatomic,copy)NSString  *expert_type;                 //专家分类
@property(nonatomic,copy)NSString  *company;                      //所属单位
@property(nonatomic,copy)NSString  *region;                       //所属地区
@property(nonatomic,copy)NSString  *phone;                        //手机号
@property(nonatomic,copy)NSString  *username;                     //用户名
@property(nonatomic,copy)NSString  *brief_introduction;           //简介
@property(nonatomic,copy)NSString  *im_username;                  //环信IM用户名
@property(nonatomic,copy)NSString  *im_password;                  //环信IM密码
@property(nonatomic,copy)NSString  *sex;                          //性别


@end
