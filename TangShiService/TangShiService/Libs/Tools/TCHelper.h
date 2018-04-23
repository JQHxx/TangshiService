//
//  TCHelper.h
//  TonzeCloud
//
//  Created by vision on 17/2/20.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertModel.h"

@interface TCHelper : NSObject

singleton_interface(TCHelper);
@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,assign)BOOL      isSystemNewsReload;    //系统消息刷新
@property (nonatomic,strong)NSArray   *sugarPeriodArr;      //血糖记录时间段
@property (nonatomic,strong)NSArray   *sugarPeriodEnArr;    //血糖记录时间段英文名

@property (nonatomic,assign)BOOL      isUserGroupReload;   //刷新患者分组
@property (nonatomic,strong)NSMutableArray   *groupUserArray;

@property (nonatomic,assign)BOOL      isNewDynamicRecord;    // 是否更新动态内容列表
///
@property (nonatomic, assign) BOOL    isFocusOnDynamicListReload ;  // 是否刷新关注人动态列表
@property (nonatomic,assign)BOOL      isDeleteDynamic;       //删除动态刷新
@property (nonatomic,assign)BOOL      isSearchKeyboard;      //搜索键盘是否弹出
@property (nonatomic, assign) NSInteger  dynamicTextNumber;  //动态限制字数

/*
 * @brief 不同时间段血糖值正常范围
 */
-(NSDictionary *)getNormalValueDictWithPeriodString:(NSString *)periodStr;

/*
 * @brief 不同血糖值范围内显示颜色
 */
-(UIColor *)getTextColorWithSugarValue:(double)value period:(NSString *)periodStr;

/**
 * @brief  血糖
 * 判断当前时间是在哪个时间段（返回时间段名称）
 */
-(NSString *)getInPeriodOfCurrentTime;

/**
 * @brief  血糖
 * 判断某一时间在哪个时间段 (血糖)
 */
-(NSString *)getInPeriodOfHour:(NSInteger )hour minute:(NSInteger)minute;

/**
 * @brief  血糖
 * 时间段（返回时间段英文名称）
 */
-(NSString *)getPeriodEnNameForPeriod:(NSString *)period;

/**
 * @brief  血糖
 * 时间段（返回时间段中文名称）
 */
-(NSString *)getPeriodChNameForPeriodEn:(NSString *)period;

/**
 * @brief  饮食
 * 判断当前时间是在哪个时间段（返回时间段名称）
 */
-(NSString *)getDietPeriodOfCurrentTime;

/**
 * @brief  饮食
 * 饮食时间段 中文转英文
 */
-(NSString *)getDietPeriodEnNameWithPeriod:(NSString *)period;

/**
 * @brief  饮食
 * 饮食时间段 英文转中文
 */
-(NSString *)getDietPeriodChNameWithPeriod:(NSString *)period;

/**
 * @brief  饮食
 * 饮食时间段 英文转中文  带时间
 */
-(NSString *)getDietPeriodChTimeNameWithPeriod:(NSString *)period;

/**
  @brief 今天往前一段时间 如一周 days＝7，一个月days＝30  三个月 days＝90
 */
-(NSMutableArray *)getDateFromTodayWithDays:(NSInteger)days;

/**
 @brief 某一时间段
 */
-(NSMutableArray *)getDateFromStartDate:(NSString *)startDate toEndDate:(NSString *)endDate format:(NSString *)format;

/**
 * @brief 获取最近一周的日期（月/日）（返回时间数组，如@[@"2/10",@"2/11",@"2/12",@"2/13",@"2/14",@"2/15",@"2/16"]）
 */
-(NSMutableArray *)getDateOfCurrentWeek;

/**
 *@bref 获取当前时间（年月日时分秒）
 */
-(NSString *)getCurrentDateTime;

/**
 *@bref 获取当天日期（年月日）
 */
-(NSString *)getCurrentDate;

/**
 *@bref 获取days之前的日期(一周 6；20天 19)
 */
-(NSString *)getLastWeekDateWithDays:(NSInteger)days;

/**
 *@bref 将某个时间转化成 时间戳
 */
-(NSInteger)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format;

/**
 *@bref 时间戳转化为时间
 */
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString format:(NSString *)format;

/**
 *@bref 时间戳（毫秒）转化为时间
 */
-(NSString *)getDateTimeFromMilliSeconds:(long long) miliSeconds;

-(NSInteger)getTimeIntervalWithDate:(NSString *)aDateStr;

/*
 *   @bref 处理时间返回格式   (先将时间戳转换成所需要的格式)
 */
- (NSString *)dateToRequiredString:(NSString *)timeString;
/*
 *@bref
 */
-(void)calculateTargetIntakeEnergyWithHeight:(NSInteger)height weight:(double)weight labor:(NSString *)laborIntensity;

/*
 *@bref 生成当天的某个点
 */
- (NSDate *)getCustomDate:(NSDate *)currentDate WithHour:(NSInteger)hour;

/***
 * @bref  比较两个日期的大小
 */
- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;

/***
 * @bref  根据出生日期时间戳返回年龄
 */
-(NSString *)dateToOldForTimeSp:(NSString *)timeString format:(NSString *)format;
/*
 *浏览大图
 */
-(void)scanBigImageWithImageView:(UIImageView *)currentImageview;
/*
 *限制emoji表情输入
 */
-(BOOL)strIsContainEmojiWithStr:(NSString*)str;
/***
 * @bref  限制第三方键盘（常用的是搜狗键盘）的表情
 */
- (BOOL)hasEmoji:(NSString*)string;
/***
 * @bref  判断当前是不是在使用九宫格输入
 */
-(BOOL)isNineKeyBoard:(NSString *)string;
/*
 *   @bref 处理禁言时间返回格式
 */
- (NSString *)dateGagtimeToRequiredString:(NSInteger)time;





@end
