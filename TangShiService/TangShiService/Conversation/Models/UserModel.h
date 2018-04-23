//
//  UserModel.h
//  TangShiService
//
//  Created by vision on 17/5/24.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *weight;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *labour_intensity;

@property (nonatomic, copy) NSString *bmi;

@property (nonatomic, copy) NSString *im_username;

@property (nonatomic, copy) NSString *diabetes_type;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic,assign)NSInteger num;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *im_groupid;

@property (nonatomic,assign)NSInteger expert_id;
@property (nonatomic, copy) NSString *im_expertname;
@property (nonatomic, copy) NSString *expertUserName;
@property (nonatomic, copy) NSString *expertHeadPic;

@property (nonatomic,assign)NSInteger helper_id;
@property (nonatomic, copy) NSString *im_helpername;
@property (nonatomic, copy) NSString *helperUserName;
@property (nonatomic, copy) NSString *helperHeadPic;

@property (nonatomic,assign)BOOL     isHelper;

@end
