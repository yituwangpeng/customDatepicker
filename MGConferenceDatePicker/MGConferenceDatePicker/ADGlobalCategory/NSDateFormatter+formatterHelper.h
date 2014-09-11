//
//  NSDateFormatter+formatterHelper.h
//  ADBLEWatch
//
//  Created by yitu on 14-7-7.
//  Copyright (c) 2014年 addingHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (formatterHelper)
//系统时区DateFormatter
+ (NSDateFormatter *)sharedSystemZoneDateFormatter;
//GMT时区DateFormatter
+ (NSDateFormatter *)sharedGmtZoneDateFormatter;
@end
