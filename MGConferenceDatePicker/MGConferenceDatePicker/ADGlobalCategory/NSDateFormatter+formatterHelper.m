//
//  NSDateFormatter+formatterHelper.m
//  ADBLEWatch
//
//  Created by yitu on 14-7-7.
//  Copyright (c) 2014年 addingHome. All rights reserved.
//

#import "NSDateFormatter+formatterHelper.h"

@implementation NSDateFormatter (formatterHelper)
+ (NSDateFormatter *)sharedSystemZoneDateFormatter {
    static NSDateFormatter *sharedDateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDateFormatter = [[NSDateFormatter alloc] init];
        [sharedDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return sharedDateFormatter;
}
//GMT时区DateFormatter
+ (NSDateFormatter *)sharedGmtZoneDateFormatter
{
    static NSDateFormatter *sharedGmtDateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGmtDateFormatter = [[NSDateFormatter alloc] init];
        [sharedGmtDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    });
    return sharedGmtDateFormatter;

}
@end
