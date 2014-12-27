//
//  EventsWithTKLibViewController.m
//  hospitality
//
//  Created by Nghiem Toan Trung on 7/10/14.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "EventsWithTKLibViewController.h"
#import <TapkuLibrary/NSDate+TKCategory.h>
#import "EventsTableViewCell.h"
#import "EventsData.h"

@interface EventsWithTKLibViewController ()

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *originalData;
@property (strong, nonatomic) NSArray *eventDates;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

//There's 2 delta's set up in this code which are for the navigation bar and the calendar which is joined with the tableview.

@implementation EventsWithTKLibViewController

- (void) loadView{
	[super loadView];
    
    int Delta = 64;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        Delta = 44;
    }
    
    CGRect frame = self.monthView.frame;
    frame.origin.y += Delta;
    self.monthView.frame = frame;
    
    [self setUpNavigationBar];
    
	self.tableView.backgroundColor = [UIColor whiteColor];
	
	float y,height;
	y = CGRectGetMaxY(self.monthView.frame);
	height = CGRectGetHeight(self.view.frame) - y;
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.bounds), height) style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self.view addSubview:_tableView];
	[self.view sendSubviewToBack:_tableView];
    
    UINib *nib = [UINib nibWithNibName:@"EventsTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}
-(void)setUpNavigationBar{
    //Init navigation bar
    int Delta = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        Delta = -20;
    }
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, Delta, 320, 64)];
    [navigationView setTag:100];
    [navigationView setBackgroundColor:App_Theme_Colour];
    
    UIButton *dashboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dashboardButton setFrame:CGRectMake(0, 26, 100, 38)];
    [dashboardButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 13, 55)];
    [dashboardButton addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *showAllEvents = [UIButton buttonWithType:UIButtonTypeCustom];
    [showAllEvents setFrame:CGRectMake(200, 28, 63, 38)];
    [showAllEvents setImageEdgeInsets:UIEdgeInsetsMake(1, 46, 17, 39)];
    [showAllEvents addTarget:self action:@selector(getEvents) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sideMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sideMenuButton setFrame:CGRectMake(263, 28, 57, 38)];
    [sideMenuButton setImageEdgeInsets:UIEdgeInsetsMake(3, 17, 20, 20)];
    [sideMenuButton addTarget:self action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(128, 27, 65, 21)];
    navigationTitle.text = @"EVENTS";
    navigationTitle.font = [UIFont fontWithName:@"Helvetica-Neue" size:17];
    
    [HelperClass navigationMenuSetup:navigationTitle navigationSubTitle:nil homeButton:dashboardButton backButton:nil eventsButton:showAllEvents sideMenuButton:sideMenuButton];
    
    [navigationView addSubview:navigationTitle];
    [navigationView addSubview:dashboardButton];
    [navigationView addSubview:showAllEvents];
    [navigationView addSubview:sideMenuButton];
    [self.view addSubview:navigationView];
}
- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}


#pragma mark - Get Data
-(void)getEvents
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Events] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableArray *tempData = [[NSMutableArray alloc] init];
         
         for (int  i = 0; i<[[responseObject objectForKey:@"matches"] count]; i++)
         {
             EventsData *eventsData = [[EventsData alloc] init];
             eventsData.title = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"title"] objectForKey:@"data"];
             eventsData.date = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"event_date"];
             eventsData.image = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"ext_image"] objectForKey:@"image_url"];
             [tempData addObject:eventsData];
         }
         self.originalData = [[NSMutableArray alloc] initWithArray:tempData];
         self.data = [self.originalData copy];
         _eventDates = [_originalData valueForKeyPath:@"date"];
         [self.tableView reloadData];
         
         [self.monthView reloadData];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
         [alert show];
         NSLog(@"FAILED: %@", [error localizedDescription]);
     }];
}

#pragma mark - TableViewSetup
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    [cell setController:self];
    EventsData *data = self.data[indexPath.row];
    cell.titleLabel.text = data.title;
    
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date = [_formatter dateFromString:data.date];
    [_formatter setDateFormat:@"dd/MM/yyyy"];
    cell.dateLabel.text = [_formatter stringFromDate:date];
    
    if (![data.image isEqualToString:@""])
    {
        cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.image]]];
    }
    else
    {
        cell.image.image = [UIImage imageNamed:@"events-placeholder-image"];
    }
    cell.imageData = data.image;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) generateHilightedDatesForStartDate:(NSDate*)start endDate:(NSDate*)end{
	
	
	NSLog(@"Delegate Range: %@ %@ %@",start,end,@([start daysBetweenDate:end]));
	
	self.dataArray = [NSMutableArray array];
	
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    
	NSDate *d = start;
    
	while(YES){
		
		NSLog(@"---> processed date %@" , [NSString stringWithFormat:@"%@ 00:00:00",[_formatter stringFromDate:d]]);
        if ([_eventDates containsObject:[NSString stringWithFormat:@"%@ 00:00:00",[_formatter stringFromDate:d]]]) {
            [self.dataArray addObject:@YES];
        }
		else{
            [self.dataArray addObject:@NO];
        }
		NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
		d = [NSDate dateWithDateComponents:info];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}


#pragma mark Month View Delegate & Data Source
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	[self generateHilightedDatesForStartDate:startDate endDate:lastDate];
	return self.dataArray;
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSPredicate *eventDatePredicate = [NSPredicate predicateWithFormat:@"date = %@", [formatter stringFromDate:date]];
    self.data = [self.originalData filteredArrayUsingPredicate:eventDatePredicate];
    
    [self.tableView reloadData];
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated{
	[self updateTableOffset:animated];
}

- (void) updateTableOffset:(BOOL)animated
{
	if(animated){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelay:0.1];
	}
    
	
	CGFloat y = CGRectGetMaxY(self.monthView.frame);
	self.tableView.frame = CGRectMake(CGRectGetMinX(self.tableView.frame), y, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.view.frame) - y);
	
	if(animated) [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    [self.monthView selectDate:[NSDate date]];
    
    [self getEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
