//
//  ADConferenceDatePicker.m
//  ADConferenceDatePicker
//
//  Created by yitu on 08/02/14.
//  Copyright (c) 2014 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADConferenceDatePickerDelegate;

//Scroll view
@interface MGPickerScrollView : UITableView

@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;

@end


//Data Picker
@interface ADConferenceDatePicker : UIView <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <ADConferenceDatePickerDelegate>delegate;
@property (nonatomic, strong, readonly) NSDate *selectedDate;

@end
