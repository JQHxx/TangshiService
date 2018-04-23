//
//  TCFoodRecordModel.h
//  TonzeCloud
//
//  Created by vision on 17/3/16.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IngredientModel;

@interface TCFoodRecordModel : NSObject


@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *time_slot;    //时间段 用餐类别

@property (nonatomic, assign)NSInteger calorie;  //摄入总能量

@property (nonatomic, strong) NSArray<IngredientModel *> *detail;

@property (nonatomic, copy) NSString *feeding_time;   //用餐日期


@end


@interface IngredientModel : NSObject

@property (nonatomic, copy ) NSString *ingredient_calories;

@property (nonatomic,assign) NSInteger id;

@property (nonatomic, copy ) NSString *ingredient_id;

@property (nonatomic, copy ) NSString *ingredient_weight;

@property (nonatomic, copy ) NSString *food_name;

@property (nonatomic, copy ) NSString *image_url;


@end

