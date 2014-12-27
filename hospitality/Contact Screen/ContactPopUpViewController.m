//
//  ContactPopUpViewController.m
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ContactPopUpViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ContactData.h"
#import "ContactMapViewController.h"

@interface ContactPopUpViewController ()

@end

@implementation ContactPopUpViewController

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
    [self setupLabels];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma setupView
- (IBAction)closeButtonPressed:(id)sender
{
    [_popupCaller dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if ([_popupCaller isKindOfClass:[ContactMapViewController class]]) {
        [[(ContactMapViewController *)_popupCaller mapView] deselectAnnotation:nil animated:YES];
    }
}

- (IBAction)getDirectionButtonPressed:(id)sender
{
    
    NSString *strGetdirection = @"";
    NSString *lat = _contactData.latitude;
    NSString *log = _contactData.longitude;
    
    if([[UIDevice currentDevice].systemVersion floatValue] >=6){
        
        strGetdirection = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%@,%@",self.userCurrentLat,self.userCurrentLong,lat,log];
    }
    else{
        strGetdirection = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@,%@",self.userCurrentLat,self.userCurrentLong,lat,log];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strGetdirection]];
}

-(void)setupLabels
{
    [self.address setValue:[self dynamicContact:_contactData.name Address:_contactData.fullAddress Telephone:_contactData.telephone Emails:_contactData.email Website:_contactData.website] forKey:@"contentToHTMLString"];
}

-(NSString *)dynamicContact: (NSString *)title Address:(NSString *)address Telephone:(NSString*)telephone Emails:(NSString *)email Website:(NSString *)website
{
    NSString *fullString = @"";
    NSString *stringTitle = @"";
    NSString *stringAddress = @"";
    NSString *stringTelephone = @"";
    NSString *stringEmail = @"";
    NSString *stringWebsite = @"";
    
    if (title.length !=0) {
        NSString *fullAddressString = [_contactData.fullAddress stringByReplacingOccurrencesOfString:@", " withString:@"<br>"];
        stringTitle = [NSString stringWithFormat:@"<b><a href= 'http://maps.apple.com/?%@'>%@</a></b><br>", fullAddressString, _contactData.name];
    }
    
    if (address.length !=0) {
        NSString *fullAddressString = [_contactData.fullAddress stringByReplacingOccurrencesOfString:@", " withString:@"<br>"];
        stringAddress = [NSString stringWithFormat:@"%@<br><br>", fullAddressString];
    }
    
    if (telephone.length !=0) {
        stringTelephone = [NSString stringWithFormat:@"<b>T: </b><a href= \"tel://%@\">%@</a><br>", telephone, telephone];
    }
    
    if (email.length !=0) {
        stringEmail = [NSString stringWithFormat:@"<b>E: </b><a href= \"mailto:%@\">%@</a><br>", email, email];
    }
    
    if (website.length !=0) {
        stringWebsite = [NSString stringWithFormat:@"<b>W: </b><a href= '%@'>%@</a>", website, website];
    }
    
    fullString = [NSString stringWithFormat:@"<body style='font-family:Helvetica;font-size:13px;'>%@%@%@%@%@</body>", stringTitle, stringAddress, stringTelephone, stringEmail, stringWebsite];
    return fullString;
}

@end
