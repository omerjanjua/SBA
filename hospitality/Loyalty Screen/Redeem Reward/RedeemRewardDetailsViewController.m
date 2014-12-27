//
//  RedeemRewardDetailsViewController.m
//  hospitality
//
//  Created by Dev on 04/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "RedeemRewardDetailsViewController.h"
#import "RedeemRewardGenerateViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "RedeemRewardErrorViewController.h"
#import "LoadDefaultData.h"

@interface RedeemRewardDetailsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation RedeemRewardDetailsViewController

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
    if (![HelperClass validateEmail:self.emailTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:@"Please enter a valid email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefault objectForKey:CMS_ID], @"app_id", [UserDefault objectForKey:Loyalty_Device_ID], @"token", self.nameTextField.text, @"fullname", self.emailTextField.text, @"email", nil];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Loyalty_Redeem_Request] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
           // [LoadDefaultData loyaltyRedeemCode:responseObject];
            [self cmsResponse:responseObject];
            NSLog(@"SUCCESS:%@", responseObject);
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"FAILED:%@", [error localizedDescription]);
        }];
    }
}

-(void)cmsResponse:(NSDictionary *)data
{
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        [UserDefault setObject:[data objectForKey:@"code"] forKey:Loyalty_Redeem_Code];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:@"RedeemRewardGenerateViewController"];
        NSLog(@"YAY IT WORKED");
    }
    else if ([@"FAILED" isEqualToString:[data objectForKey:@"status"]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"You do not have enough stamps to redeem that reward" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        NSLog(@"FAILED");
    }
}

- (IBAction)closeButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:Nil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.nameTextField) || (textField == self.emailTextField)) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
