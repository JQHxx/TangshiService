//
//  TCMineServiceModel.h
//  TonzeCloud
//
//  Created by 肖栋 on 17/2/20.
//  Copyright © 2017年 tonze. All rights reserved.
//
/*
 "expert_id": 15,
 "expert_name": "专家1",
 "scheme_name": "低血糖",
 "head_portrait": "uploads/big/20170314\\68ce6c2820d5d8bd9d397cdc343fe59b.png",
 "positional_titles": "一级",
 "service_status": 1,
 "start_time": 1488973295,
 "end_time": 1489543811
 */
#import <Foundation/Foundation.h>

@class TCCommentModel;

@interface TCMineServiceModel : NSObject

@property (nonatomic, copy )NSString    *name;                 //服务名称
@property (nonatomic, copy )NSString    *nick_name;            //用户昵称
@property (nonatomic,assign)NSInteger   type;                  //服务类型 1.图文 2.医疗方案
@property (nonatomic, copy )NSString    *start_time;           //开始时间
@property (nonatomic, copy )NSString    *end_time;             //结束时间
@property (nonatomic, copy )NSString    *head_url;             //头像
@property (nonatomic,assign)NSInteger   service_status;        //服务状态 1 服务中 2 已完成 3 已退款
@property (nonatomic, copy )NSString    *order_sn;             //服务订单号
@property (nonatomic, copy )NSString    *price;                //支付金额
@property (nonatomic,assign)NSInteger   user_id;               //用户编号
@property (nonatomic,strong)NSDictionary*comments;              //评价对象
@property (nonatomic, copy )NSString    *im_username;
@property (nonatomic, copy )NSString    *comment_score;          //评分
@property (nonatomic, copy )NSString    *group_id;              //分组
@property (nonatomic, copy )NSString    *remark;                //备注名

@property (nonatomic, copy )NSString    *im_groupid;              //群聊id

@property (nonatomic, copy) NSString *im_expertname;
@property (nonatomic, copy) NSString *expertUserName;
@property (nonatomic, copy) NSString *expertHeadPic;

@property (nonatomic, copy) NSString *im_helpername;
@property (nonatomic, copy) NSString *helperUserName;
@property (nonatomic, copy) NSString *helperHeadPic;

@end


@interface TCCommentModel : NSObject

@property (nonatomic, copy) NSString    *comment_score;          //评价星级（1~5）
@property (nonatomic,assign)NSInteger   attitude_score;         //服务态度的星级
@property (nonatomic,assign)NSInteger   speed_score;            //回复速度的星级
@property (nonatomic,assign)NSInteger   satisfied_score;        //解决问题的星级
@property (nonatomic, copy )NSString    *add_time;
@property (nonatomic, copy )NSString    *msg;

@end

