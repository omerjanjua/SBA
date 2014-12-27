//
//  EventsPopUpViewController.m
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "EventsPopUpViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import <EventKit/EventKit.h>

@interface EventsPopUpViewController (){
    UIAlertView *alert;
}

@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation EventsPopUpViewController

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
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    self.eventStore = [[EKEventStore alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup View
-(void)setupView
{
    self.titleLabel.text = self.titleData;
    self.dateLabel.text = self.dateData;
    if (![self.imageData isEqualToString:@""])
    {
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageData]]];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"events-placeholder-image"];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [_popupCaller dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (IBAction)confirmButtonPressed:(id)sender
{
    [self checkEventStoreAccessForCalendar];
}

#pragma mark - Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert2 show];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             EventsPopUpViewController * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}

#pragma mark - This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    self.eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
    event.title     = self.titleData;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setAMSymbol:@"am"];
    [formatter setPMSymbol:@"pm"];
    event.startDate = [formatter dateFromString:self.dateData];
    event.endDate = [[formatter dateFromString:self.dateData] dateByAddingTimeInterval:86399]; //becuase the CMS always returns 12.am so adding 24hours -1 second
    
    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
    [_popupCaller dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Entry added to the calendar" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
    [alert show];
}

-(void)dealloc
{
    alert.delegate = nil;
}

@end
