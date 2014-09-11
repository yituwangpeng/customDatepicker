//
//  ADConferenceDatePicker.m
//  ADConferenceDatePicker
//
//  Created by yitu on 08/02/14.
//  Copyright (c) 2014 wangpeng. All rights reserved.
//

#import "ADConferenceDatePicker.h"
#import "ADConferenceDatePickerDelegate.h"
#import "NSDate+DateHelper.h"
//Check screen macros
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//Editable macros
#define PICKER_BG_COLOR UIColorFromRGB(0x272a35)
#define TEXT_COLOR UIColorFromRGB(0xFFD200)
#define SELECTED_TEXT_COLOR UIColorFromRGB(0xFFD200)
#define SAVE_AREA_COLOR [UIColor colorWithWhite:0.95 alpha:1.0]
#define BAR_SEL_COLOR [UIColor colorWithRed:76.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:0.8]

//Editable constants
static const float VALUE_HEIGHT = 60.0;
static const float SAVE_AREA_HEIGHT = 70.0;
static const float SAVE_AREA_MARGIN_TOP = 20.0;

//Editable values
static const float PICKER_HEIGHT = 250.0;
static NSString  * const FONT_NAME = @"MStiffHeiHKS-UltraBold";

//Static macros and constants
#define SELECTOR_ORIGIN (PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0)
#define PICKER_ORIGIN_Y self.bounds.size.height-PICKER_HEIGHT
#define BAR_SEL_ORIGIN_Y PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0


//Custom scrollView
@interface MGPickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;

@end


@implementation MGPickerScrollView

//Constants
const float LBL_BORDER_OFFSET = 8.0;

//Configure the tableView
- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues
      withTextAlign:(NSTextAlignment)align andTextSize:(float)txtSize {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake(BAR_SEL_ORIGIN_Y, 0.0, BAR_SEL_ORIGIN_Y, 0.0)];
        
        _cellFont = [UIFont fontWithName:FONT_NAME size:txtSize];
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
    }
    return self;
}


//Dehighlight the last cell
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

//Highlight a cell
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

@end


//Custom Data Picker
@interface ADConferenceDatePicker ()

@property (nonatomic, strong) NSArray *arrHours;
@property (nonatomic, strong) NSArray *arrMinutes;

@property (nonatomic, strong) MGPickerScrollView *svHours;//hour pikerview
@property (nonatomic, strong) MGPickerScrollView *svMins;//minute pikerview

@property (nonatomic, strong) UIButton *saveButton;

@end


@implementation ADConferenceDatePicker

//-(void)drawRect:(CGRect)rect {
//    [self initialize];
//    [self buildControl];
//}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
        [self buildControl];
    }
    return self;
}

- (void)initialize {
    
  
    //Create array Hours
    NSMutableArray *arrHours = [[NSMutableArray alloc] initWithCapacity:12];
    for(int i=0; i<24; i++) {//24小时
        [arrHours addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    _arrHours = [NSArray arrayWithArray:arrHours];
    
    //Create array Minutes
    NSMutableArray *arrMinutes = [[NSMutableArray alloc] initWithCapacity:60];
    for(int i=0; i<60; i++) {
        [arrMinutes addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
    }
    _arrMinutes = [NSArray arrayWithArray:arrMinutes];
    
}


- (void)buildControl {
    //Create a view as base of the picker
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, PICKER_ORIGIN_Y, self.frame.size.width, PICKER_HEIGHT)];
    [pickerView setBackgroundColor:PICKER_BG_COLOR];
    
    //
    
    //Layer gradient
    CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
    gradientLayerTop.frame = CGRectMake(0.0, 0.0, pickerView.frame.size.width, PICKER_HEIGHT/2.0);
    gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)pickerView.backgroundColor.CGColor, nil];
    gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
    gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
    
    CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
    gradientLayerBottom.frame = CGRectMake(0.0, PICKER_HEIGHT/2.0, pickerView.frame.size.width, PICKER_HEIGHT/2.0);
    gradientLayerBottom.colors = gradientLayerTop.colors;
    gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
    gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
    
    //Create bar selector
    UIView *barSel = [[UIView alloc] initWithFrame:CGRectMake(0.0, BAR_SEL_ORIGIN_Y, self.frame.size.width, VALUE_HEIGHT)];
    [barSel setBackgroundColor:BAR_SEL_COLOR];
    [barSel setBackgroundColor:[UIColor clearColor]];

    UILabel *separatorLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, barSel.frame.size.width, barSel.frame.size.height)];
    separatorLable.backgroundColor = [UIColor clearColor];
    separatorLable.textAlignment = NSTextAlignmentCenter;
    separatorLable.textColor = TEXT_COLOR;
    separatorLable.font = [UIFont fontWithName:FONT_NAME size:50.0];
    separatorLable.text = @":";
    
    [barSel addSubview:separatorLable];
    
     _svHours = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(10, 0.0, 150, PICKER_HEIGHT) andValues:_arrHours withTextAlign:NSTextAlignmentCenter  andTextSize:50.0];
    _svHours.tag = 1;
    [_svHours setDelegate:self];
    [_svHours setDataSource:self];
    
    //Create the third column (minutes) of the picker
      _svMins = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svHours.frame.origin.x+150, 0.0, 150, PICKER_HEIGHT) andValues:_arrMinutes withTextAlign:NSTextAlignmentCenter andTextSize:50.0];
    _svMins.tag = 2;
    [_svMins setDelegate:self];
    [_svMins setDataSource:self];
    
    //Add pickerView
    [self addSubview:pickerView];
    
    
    //Add the bar selector
    [pickerView addSubview:barSel];
    
    //Add scrollViews
    [pickerView addSubview:_svHours];
    [pickerView addSubview:_svMins];
    
    //Add gradients
    [pickerView.layer addSublayer:gradientLayerTop];
    [pickerView.layer addSublayer:gradientLayerBottom];
    
    //Set the time to now
    [self setTime:[NSDate stringFromDate:[NSDate localdate] withFormat:@"HH:mm"]];

}

#pragma mark - Other methods

//Center the value in the bar selector
- (void)centerValueForScrollView:(MGPickerScrollView *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    NSLog(@"%f哈哈哈哈哈哈哈%f",scrollView.contentOffset.y,scrollView.contentInset.top);
    int mod = (int)offset%(int)VALUE_HEIGHT;
    float newValue = (mod >= VALUE_HEIGHT/2.0) ? offset+(VALUE_HEIGHT-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/VALUE_HEIGHT);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

//Center phisically the cell
- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(MGPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*VALUE_HEIGHT;
    
    //Re-add the contentInset and set the new offset
    newOffset -= BAR_SEL_ORIGIN_Y;
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    //Highlight the cell
    [scrollView highlightCellWithIndexPathRow:indexPathRow];
    
    [_saveButton setEnabled:YES];
}

//Set the time automatically
- (void)setTime:(NSString *)time {
    //Get the string
    NSString *strTime;
    strTime = (NSString *)time;
    
    //Split
    NSArray *comp = [strTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    
    //Set the tableViews
//    [_svHours dehighlightLastCell];
//    [_svMins dehighlightLastCell];
//    [_svMeridians dehighlightLastCell];
    
    //Center the other fields
    
    [self centerCellWithIndexPathRow:([comp[0] intValue]) forScrollView:_svHours];//
    [self centerCellWithIndexPathRow:[comp[1] intValue] forScrollView:_svMins];//分钟从0开始，不用减1
//    [self centerCellWithIndexPathRow:[_arrMeridians indexOfObject:comp[2]] forScrollView:_svMeridians];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
        
        [self callBackSelectedTime];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
    
    [self callBackSelectedTime];
}
#pragma mark - 回调选择的时间
- (void)callBackSelectedTime
{
    if (!_svHours.isDragging && !_svHours.isDecelerating && !_svMins.isDragging && !_svMins.isDecelerating) {
        NSDate *date =  [NSDate localDateFromString:[NSString stringWithFormat:@"%@:%@",_arrHours[_svHours.tagLastSelected],_arrMinutes[_svMins.tagLastSelected]] withFormat:@"HH:mm"];
        
        //Send the date to the delegate
        if([_delegate respondsToSelector:@selector(conferenceDatePicker:saveDate:)])
            [_delegate conferenceDatePicker:self saveDate:date];
    }

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [_saveButton setEnabled:NO];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)scrollView;
    
    [sv dehighlightLastCell];
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:sv.cellFont];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setTextColor:(indexPath.row == sv.tagLastSelected) ? SELECTED_TEXT_COLOR : TEXT_COLOR];
    [cell.textLabel setText:sv.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VALUE_HEIGHT;
}

@end
