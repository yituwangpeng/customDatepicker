//
//  NSDate+DateHelper.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-3.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "NSDate+DateHelper.h"
#import "NSDateFormatter+formatterHelper.h"
@implementation NSDate (DateHelper)


//获取当前日期
+ (NSDate *)localdate
{
    NSDate* date = [NSDate date];//得到0时区日期
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
   
    NSLog(@"时区名字是什么 %@", [zone abbreviation]);
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
+ (NSDate *)gmtDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *gmtDate = [date dateByAddingTimeInterval: -interval];
    return gmtDate;
}
//参数date是0时区日期
+ (NSDate *)localdateByDate:(NSDate *)dateGMT
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    NSDate *localeDate = [dateGMT  dateByAddingTimeInterval: interval];
    return localeDate;
    
}
//获取今天是星期几
-(NSInteger)dayOfWeek{
    NSCalendar*calendar =[NSCalendar currentCalendar];
    NSDateComponents*offsetComponents =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                   fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    NSInteger d=[offsetComponents day];
    static int t[]={0,3,2,5,0,3,5,1,4,6,2,4};
    y -=m <3;
    
    NSInteger result=(y +y/4-y/100+y/400+t[m-1]+d)%7;
    if(result==0){
        result=7;
    }
    return result;
}
//获取每月有多少天
- (NSInteger)monthOfDay{
    NSCalendar*calendar =[NSCalendar currentCalendar];
    NSDateComponents*offsetComponents =[calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                   fromDate:self];
    NSInteger y=[offsetComponents year];
    NSInteger m=[offsetComponents month];
    if(m==2){
        if(y%4==0&&(y%100!=0||y%400==0)){
            return 29;
        }
        return 28;
    }
    if(m==4||m==6||m==9||m==11){
        return 30;
    }
    return 31;
}
//根据年份和月份得出本月有多少天
+ (NSInteger)dayOfMonthWithYear:(int)y Month:(int)m
{
    if(m==2){
        if(y%4==0&&(y%100!=0||y%400==0)){
            return 29;
        }
        return 28;
    }
    if(m==4||m==6||m==9||m==11){
        return 30;
    }
    return 31;
    
}
//本周开始时间
-(NSDate*)beginningOfWeek{
    NSInteger weekday=[self dayOfWeek];
    //转化成当前时区的时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
    NSDate *dateLocalZone = [[self addDay:(weekday-1)*-1]  dateByAddingTimeInterval: interval];
    
    return dateLocalZone;
}
//本周结束时间
-(NSDate*)endOfWeek{
    NSInteger weekday=[self dayOfWeek];
    if(weekday == 7){
        return self;
    }
    //转化成当前时区的时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [NSDate date]];
    NSDate *dateLocalZone = [[self addDay:7- weekday]  dateByAddingTimeInterval: interval];
    
    
    return dateLocalZone;
}
//日期添加几天
-(NSDate*)addDay:(NSInteger)day{
    NSTimeInterval interval =24*60*60;
    return[self dateByAddingTimeInterval:day*interval];
}
//日期格式化(输入是什么，转化出来的就是什么)
-(NSString*)stringWithFormat:(NSString*)format {
    NSDateFormatter*outputFormatter =[NSDateFormatter sharedGmtZoneDateFormatter];
    [outputFormatter setDateFormat:format];

//    [outputFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString*timestamp_str =[outputFormatter stringFromDate:self];
    
    return timestamp_str;
}
//字符串转换成日期（是什么就是什么）
+(NSDate*)localDateFromString:(NSString *)string withFormat:(NSString*)format {
    NSDateFormatter*inputFormatter =[NSDateFormatter sharedGmtZoneDateFormatter];
    [inputFormatter setDateFormat:format];
    NSDate * date =[inputFormatter dateFromString:string];
    return date;
}
//字符串转换成日期(转化成0时区的日期)
+(NSDate*)dateFromString:(NSString *)string withFormat:(NSString*)format
{
    NSDateFormatter*inputFormatter =[NSDateFormatter sharedSystemZoneDateFormatter];
    [inputFormatter setDateFormat:format];
    NSDate * date =[inputFormatter dateFromString:string];
   
    return date;

}
//将一个日期转化成整点日期
+(NSDate*)integralDateFromDate:(NSDate *)date
{
    //整点时间
    NSNumber *year = [NSDate getYear:date];
    NSNumber *month = [NSDate getMonth:date];
    NSNumber *day = [NSDate getDay:date];
    
    NSDate *integralDate = [NSDate localDateFromString:[NSString stringWithFormat:@"%@.%@.%@ %d",year,month,day,0] withFormat:@"yyyy.MM.dd HH"];

    return integralDate;
}
//时间转换成字符串
+(NSString*)stringFromDate:(NSDate*)dateGMT withFormat:(NSString*)format {
    return[dateGMT stringWithFormat:format];
}

+ (BOOL)isAscendingWithOnedate:(NSDate *)onedate anotherdate:(NSDate *)anotherdate{
    //现将两个日期转化成同一时区的
    
    NSString *onestr = [onedate stringWithFormat:@"yyyyMMdd"];
    NSString *anotherstr = [anotherdate stringWithFormat:@"yyyyMMdd"];
    
    int a = [onestr intValue];
    int b = [anotherstr intValue];
    return a < b ? YES : NO;
    
}



///////////////////////////////////////////////////////////////////
//这里输入什么日期，分割处来的就是什么
+(NSNumber*)getDateFormat:(NSDate*)date with:(NSString*)formatter{
    
    NSDateFormatter* df = [NSDateFormatter sharedGmtZoneDateFormatter];
    [df setDateFormat:formatter];

    // 初始化手环时间时已经转成当地时间
    // 这里设置成格林威治时间
//    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];

    return [NSNumber numberWithInt:[[df stringFromDate:date] intValue]];
}
+(NSNumber*)getYear:(NSDate*)date{
    return [self getDateFormat:date with:@"yyyy"];
}

+(NSNumber*)getMonth:(NSDate*)date{
    return [self getDateFormat:date with:@"MM"];
}

+(NSNumber*)getDay:(NSDate*)date{
    return [self getDateFormat:date with:@"dd"];
}

+(NSNumber*)getHour:(NSDate*)date{
    return [self getDateFormat:date with:@"HH"];
}

+(NSNumber*)getMinutes:(NSDate*)date{
    return [self getDateFormat:date with:@"mm"];
}


//根据当前时间计算出当天零时零分距离1970的秒数
+(int)getSecondsOfZeroHourWithDate:(NSDate *)date
{
    NSNumber *year = [NSDate getYear:date];
    NSNumber *month = [NSDate getMonth:date];
    NSNumber *day = [NSDate getDay:date];
    
    NSDate *datezero = [NSDate dateFromString:[NSString stringWithFormat:@"%@:%@:%@",year,month,day] withFormat:@"yyyy:MM:dd"];
    double seconds = [datezero timeIntervalSince1970];
    return (int)seconds;
}
//根据当前时间计算出当天零时零分在0时区距离1970的秒数
+(double)getGmtSecondsOfZeroHourWithDate:(NSDate *)date
{
    NSNumber *year = [NSDate getYear:date];
    NSNumber *month = [NSDate getMonth:date];
    NSNumber *day = [NSDate getDay:date];
    
    NSDate *datezero = [NSDate dateFromString:[NSString stringWithFormat:@"%@:%@:%@ %d",year,month,day,0] withFormat:@"yyyy:MM:dd HH"];
    double seconds = [datezero timeIntervalSince1970];
    return seconds;

}
//计算两个日期之间的天
+(int)getTimeintevalBetweenDate:(NSDate *)date  andOtherDate:(NSDate *)otherDate{
    int secondsDate = [NSDate getSecondsOfZeroHourWithDate:date];
    int secondsOtherDate = [NSDate getSecondsOfZeroHourWithDate:otherDate];
    return (secondsDate- secondsOtherDate)/(3600*24);
}

//给定日期 返回周几
+ (NSUInteger)getWeekdayFromDate:(NSDate*)date
{
    NSDate *gmtDate = [NSDate gmtDate:date];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:2];//从周一开始
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    components = [calendar components:unitFlags fromDate:gmtDate];
    
    NSUInteger weekday = [components weekday];
    
    return weekday;
    
}

//给定日期 返回是今年第几周
+ (NSUInteger)getWeekFromDate:(NSDate*)date
{
    NSDate *gmtDate = [NSDate gmtDate:date];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:2];//从周一开始
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit;
    
    components = [calendar components:unitFlags fromDate:gmtDate];
    
    NSUInteger week = [components week];
    
    return week;

}
//给定日期 返回当前日期所在周的开始日期（当前时区）
+ (NSDate *)getCurrentWeekStartDateFromDate:(NSDate*)date
{
    NSDate *gmtDate = [NSDate gmtDate:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:2];//从周一开始
    NSDate *sDate;
    NSTimeInterval TIOfWeek;
    
    if ([calendar rangeOfUnit:NSWeekCalendarUnit startDate:&sDate interval:&TIOfWeek forDate:gmtDate]){
        NSLog(@"当周起始日期是   %@",[NSDate localdateByDate:sDate]);
        return [NSDate localdateByDate:sDate];
    }else{
        return date;
    }
    
    
}
@end
