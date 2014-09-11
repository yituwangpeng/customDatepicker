//
//  NSDate+DateHelper.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)
//获取当前日期
+ (NSDate *)localdate;
+ (NSDate *)gmtDate:(NSDate *)date;
//根据0时区的日期转化成当前日期(参数date是0时区日期)
+ (NSDate *)localdateByDate:(NSDate *)dateGMT;
//获取今天是星期几
-(NSInteger)dayOfWeek;
//获取每月有多少天
- (NSInteger)monthOfDay;
//根据年份和月份 得出本月份的天数
+ (NSInteger)dayOfMonthWithYear:(int)y Month:(int)m;
//本周开始时间
-(NSDate*)beginningOfWeek;
//本周结束时间
-(NSDate*)endOfWeek;
//日期添加几天
-(NSDate*)addDay:(NSInteger)day;

//日期格式化(输入是什么，转化出来的就是什么)
-(NSString*)stringWithFormat:(NSString*)format;
//字符串转换成时间(直接转换成当前日期时间)
+(NSDate*)localDateFromString:(NSString *)string withFormat:(NSString*)format;
//字符串转换成日期(转化成0时区的日期)
+(NSDate*)dateFromString:(NSString *)string withFormat:(NSString*)format;
//将一个日期转化成整点日期
+(NSDate*)integralDateFromDate:(NSDate *)date;
//时间转换成字符串（会在原日期基础上加8个小时）
+(NSString*)stringFromDate:(NSDate*)dateGMT withFormat:(NSString*)string;
+ (BOOL)isAscendingWithOnedate:(NSDate *)onedate anotherdate:(NSDate *)anotherdate;

//根据当前时间计算出当天零时零分距离1970的秒数
+(int)getSecondsOfZeroHourWithDate:(NSDate *)date;

//根据当前时间计算出当天零时零分在0时区距离1970的秒数
+(double)getGmtSecondsOfZeroHourWithDate:(NSDate *)date;
//计算两个日期之间的天
+(int)getTimeintevalBetweenDate:(NSDate *)date  andOtherDate:(NSDate *)otherDate;

//从一个日期中分割出年、月、日、小时、分钟
+(NSNumber*)getYear:(NSDate*)date;
+(NSNumber*)getMonth:(NSDate*)date;
+(NSNumber*)getDay:(NSDate*)date;
+(NSNumber*)getHour:(NSDate*)date;
+(NSNumber*)getMinutes:(NSDate*)date;

//给定日期 返回周几
+ (NSUInteger)getWeekdayFromDate:(NSDate*)date;
//给定日期 返回是今年第几周
+ (NSUInteger)getWeekFromDate:(NSDate*)date;

//给定日期 返回当前日期所在周的开始日期（当前时区）
+ (NSDate *)getCurrentWeekStartDateFromDate:(NSDate*)date;
@end
