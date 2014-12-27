//
//  RedeemRewardGenerateViewController.m
//  hospitality
//
//  Created by Dev on 04/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "RedeemRewardGenerateViewController.h"
#import "RedeemRewardAcceptViewController.h"
#import "RedeemRewardErrorViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface RedeemRewardGenerateViewController ()

@property (strong, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation RedeemRewardGenerateViewController

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
    self.codeTextField.text = [UserDefault objectForKey:Loyalty_Redeem_Code];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GUI Interactions
- (IBAction)checkButton:(id)sender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefault objectForKey:CMS_ID], @"app_id", [UserDefault objectForKey:Loyalty_Device_ID], @"token", [UserDefault objectForKey:Loyalty_Redeem_Code], @"redeem_code", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Loyalty_Redeem_Confirm] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"SUCCESS:%@", responseObject);
        [self cmsResponse:responseObject];
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"FAILED:%@", [error localizedDescription]);
    }];
}

-(void)cmsResponse:(NSDictionary *)data
{
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:@"RedeemRewardAcceptViewController"];
        NSLog(@"YAY IT WORKED");
    }
    else if ([@"FAILED" isEqualToString:[data objectForKey:@"status"]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:@"RedeemRewardErrorViewController"];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.codeTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
