//
//  ADConferenceDatePicker.m
//  ADConferenceDatePicker
//
//  Created by yitu on 08/02/14.
//  Copyright (c) 2014 wangpeng. All rights reserved.
//

#import "ADViewController.h"

@implementation ADViewController

-(void)viewDidAppear:(BOOL)animated
{
    //New view controller
    UIViewController *pickerViewController = [[UIViewController alloc] init];
    
    //Init the datePicker view and set self as delegate ;default高度是250
    ADConferenceDatePicker *datePicker = [[ADConferenceDatePicker alloc] initWithFrame:self.view.bounds];
    [datePicker setDelegate:self];
    
    //OPTIONAL: Choose the background color
    [datePicker setBackgroundColor:[UIColor yellowColor]];
    
    //Set the data picker as view of the new view controller
    [pickerViewController setView:datePicker];
    
    //Present the view controller
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

//Delegate
-(void)conferenceDatePicker:(ADConferenceDatePicker *)datePicker saveDate:(NSDate *)date {
    NSLog(@"===========%@",[date description]);
}

@end
