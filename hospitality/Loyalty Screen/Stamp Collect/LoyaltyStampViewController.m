//
//  LoyaltyStampViewController.m
//  hospitality
//
//  Created by Omer Janjua on 27/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "LoyaltyStampViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "LoyaltyStampErrorViewController.h"
#import "LoyaltyStampSuccessViewController.h"
#import "MKNetworkKit.h"

@interface LoyaltyStampViewController ()

@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UILabel *validityLabel;

@end

@implementation LoyaltyStampViewController

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
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    [self getStampValidityPeriod];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GUI Interactions
- (IBAction)confirmButton:(id)sender
{
    [self.codeTextField resignFirstResponder];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefault objectForKey:CMS_ID], @"app_id", [UserDefault objectForKey:Loyalty_Device_ID], @"token", self.codeTextField.text, @"code", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Collect_Stamps] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", responseObject);
        [self cmsResponse:responseObject];
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Stamp Collected:%@", [error localizedDescription]);
    }];
    
//    MKNetworkEngine *myEngine = [[MKNetworkEngine alloc] initWithHostName:@"loyalty.appitized.com/api/128" customHeaderFields:nil];
//    MKNetworkOperation *op = [myEngine operationWithPath:@"loyalty/collect-stamp" params:dictionary httpMethod:@"POST"ssl:NO];
//    [myEngine enqueueOperation:op];
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
//    {
//         [self cmsResponse:completedOperation.readonlyPostDictionary];
//    }
//    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
//    {
//         
//    }];
}

- (IBAction)closeButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:Nil];
}

-(void)cmsResponse:(NSDictionary *)data
{
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:@"LoyaltyStampSuccessViewController"];
        NSLog(@"YAY IT WORKED");
    }
    else if ([@"FAILED" isEqualToString:[data objectForKey:@"status"]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:@"LoyaltyStampErrorViewController"];
        NSLog(@"FAILED");
    }
}

-(void)getStampValidityPeriod
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Loyalty_Stamp_Period] parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self assignValidityLabelValue:[responseObject objectForKey:@"valid_period_stamp"]];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Could not get stamp validity period from server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
     }];
}


#pragma mark -Validity Label Logic
-(void)assignValidityLabelValue:(NSString *)validPeriodStamp
{
    if ([validPeriodStamp intValue] <= 3600) {
        self.validityLabel.text = [NSString stringWithFormat:@"Please note: Codes are only valid for %d hour", ([validPeriodStamp intValue]/60/60)];
    }
    else if (([validPeriodStamp intValue] > 3600) && ([validPeriodStamp intValue] < 86400)) {
        self.validityLabel.text = [NSString stringWithFormat:@"Please note: Codes are only valid for %d hours", ([validPeriodStamp intValue]/60/60)];
    }
    else if ([validPeriodStamp intValue] == 86400) {
        self.validityLabel.text = [NSString stringWithFormat:@"Please note: Codes are only valid for %d day", ([validPeriodStamp intValue]/60/60/24)];
    }
    else if (([validPeriodStamp intValue] > 86400) && ([validPeriodStamp intValue] < 604800)) {
        self.validityLabel.text = [NSString stringWithFormat:@"Please note: Codes are only valid for %d days", ([validPeriodStamp intValue]/60/60/24)];
    }
    else if ([validPeriodStamp intValue] == 604800) {
        self.validityLabel.text = [NSString stringWithFormat:@"Please note: Codes are only valid for %d week", ([validPeriodStamp intValue]/60/60/24/7)];
    }
    else if ([validPeriodStamp intValue] > 604800) {
        self.validityLabel.text = [NSString stringWithFormat:@"Please note: Codes are only valid for %d weeks", ([validPeriodStamp intValue]/60/60/24/7)];
    }
}

#pragma mark - Text Field Handler
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.codeTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
