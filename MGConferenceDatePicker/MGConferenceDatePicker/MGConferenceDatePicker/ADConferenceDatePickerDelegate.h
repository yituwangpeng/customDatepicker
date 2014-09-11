//
//  ADConferenceDatePicker.m
//  ADConferenceDatePicker
//
//  Created by yitu on 08/02/14.
//  Copyright (c) 2014 wangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADConferenceDatePicker;

//Protocol to return the date
@protocol ADConferenceDatePickerDelegate <NSObject>

@optional
- (void)conferenceDatePicker:(ADConferenceDatePicker *)datePicker saveDate:(NSDate *)date;

@end
