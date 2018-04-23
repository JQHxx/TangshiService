//
//  TCGroupModel.h
//  TangShiService
//
//  Created by vision on 17/7/18.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"



@interface TCGroupModel : NSObject

@property (nonatomic,assign) NSInteger    group_id;      //分组id
@property (nonatomic, copy ) NSString     *group_name;   //分组名称
@property (nonatomic,assign) NSInteger    sort;          //排序
@property (nonatomic,assign) BOOL         isSelected;       //
@property (nonatomic,strong) NSArray<UserModel*> *member; //用户

@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)BOOL      isExpanded;

@end


