//
//  EventsViewController.m
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsTableViewCell.h"
#import "EventsData.h"
#import "CKCalendarView.h"

@interface EventsViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *originalData;
@end

@implementation EventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self getEvents];
    [self setupCalendar];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"EventsTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup View
-(void)setupView
{
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)showAllDatesButtonPressed:(id)sender
{
    [self getEvents];
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
         [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    [cell setController:self];
    EventsData *data = self.data[indexPath.row];
    cell.titleLabel.text = data.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date = [formatter dateFromString:data.date];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.dateLabel.text = [formatter stringFromDate:date];
    
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

#pragma mark - CalendarViewSetup
-(void)setupCalendar
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:2 frame:CGRectMake(0,44, 320, 320)];
        calendar.onlyShowCurrentMonth = NO;
        [self.view addSubview:calendar];
        calendar.delegate = self;
    } else {
        // Load resources for iOS 7 or later
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:2 frame:CGRectMake(0,64, 320, 320)];
        calendar.onlyShowCurrentMonth = NO;
        [self.view addSubview:calendar];
        calendar.delegate = self;
    }
}
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
     NSPredicate *eventDatePredicate = [NSPredicate predicateWithFormat:@"date = %@", [formatter stringFromDate:date]];
     self.data = [self.originalData filteredArrayUsingPredicate:eventDatePredicate];
    
    [self.tableView reloadData];
}

@end
