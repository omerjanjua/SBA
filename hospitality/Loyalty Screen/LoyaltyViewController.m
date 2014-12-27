//
//  LoyaltyViewController.m
//  hospitality
//
//  Created by Omer Janjua on 26/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "LoyaltyViewController.h"
#import "RedeemRewardDetailsViewController.h"
#import "RedeemRewardAcceptViewController.h"
#import "RedeemRewardErrorViewController.h"
#import "RedeemRewardGenerateViewController.h"
#import "LoyaltyStampViewController.h"
#import "LoyaltyStampErrorViewController.h"
#import "LoyaltyStampSuccessViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "FBShimmeringView.h"

@interface LoyaltyViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;

@property (strong, nonatomic) IBOutlet UIButton *redeemButton;
@property (strong, nonatomic) IBOutlet UIButton *stampButton;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UILabel *navigationSubTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) IBOutlet FBShimmeringView *stampCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stamp1;
@property (strong, nonatomic) IBOutlet UIImageView *stamp2;
@property (strong, nonatomic) IBOutlet UIImageView *stamp3;
@property (strong, nonatomic) IBOutlet UIImageView *stamp4;
@property (strong, nonatomic) IBOutlet UIImageView *stamp5;

@end

@implementation LoyaltyViewController

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
    [self viewSetup];
    [self setupRedeemButton];
    [self getStampsAmount];
    //add nsnotificationcenter for closing the popup of where it was called from
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeModal:) name:@"Dismiss_Popup" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setUp
-(void)viewSetup
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:_navigationSubTitle homeButton:_homeButton backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];
    
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"]) {
        _stampButton.titleLabel.textColor = [UIColor whiteColor];
        _redeemButton.titleLabel.textColor = [UIColor whiteColor];
    }
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"]) {
        _stampButton.titleLabel.textColor = [UIColor blackColor];
        _redeemButton.titleLabel.textColor = [UIColor blackColor];
    }

    [self loyaltyDescription];
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.stampButton.backgroundColor = App_Theme_Colour2;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

//TODO: refactor this later so code is not duplicated from DashboardViewController
#pragma mark - Loyalty Setup
-(void)loyaltyDescription
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Loyalty_Stamp_Period] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        _navigationTitle.text = [responseObject objectForKey:@"reward_title"];
        _navigationSubTitle.text = [responseObject objectForKey:@"reward_description"];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Cannot reach server, please check you internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

-(void)getStampsAmount
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefault objectForKey:CMS_ID],@"app_id",[UserDefault objectForKey:Loyalty_Device_ID],@"token", nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Loyalty_Stamp_Count] parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self assignStampLabelValue:[responseObject objectForKey:@"matches"]];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Could not reach server to get stamp count" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
         [alert show];
         NSLog(@"FAILED: %@", [error localizedDescription]);
     }];
}

-(void)assignStampLabelValue:(NSString *)stampLabelValue
{
    UILabel *label = [[UILabel alloc] initWithFrame:_stampCountLabel.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    if ([stampLabelValue intValue] == 0) {
        self.redeemButton.hidden = YES;
        self.stampButton.hidden = NO;
        
        label.text = @"Five more stamps to go until your next reward";
    }
    else if ([stampLabelValue intValue] == 1) {
        label.text = @"Four more stamps to go until your next reward";
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
    }
    else if ([stampLabelValue intValue] == 2) {
        label.text = @"Three more stamps to go until your next reward";
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
    }
    else if ([stampLabelValue intValue] == 3) {
        label.text = @"Two more stamps to go until your next reward";
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
    }
    else if ([stampLabelValue intValue] == 4) {
        label.text = @"One more stamp to go until your next reward";
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
    }
    else if ([stampLabelValue intValue] == 5) {
        self.redeemButton.hidden = NO;
        self.stampButton.hidden = YES;
        label.text = @"Please redeem your reward";
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
    }
    _stampCountLabel.contentView = label;
    _stampCountLabel.shimmering = YES;
}

-(void)setupRedeemButton
{
    self.redeemButton.backgroundColor = App_Theme_Colour2;
}

- (IBAction)redeemButtonPressed:(id)sender
{
    RedeemRewardDetailsViewController *loyaltyStamp = [[RedeemRewardDetailsViewController alloc] init];
    [self presentPopupViewController:loyaltyStamp animationType:MJPopupViewAnimationFade];
}

- (IBAction)stampButtonPressed:(id)sender
{
    LoyaltyStampViewController *loyaltyStamp = [[LoyaltyStampViewController alloc] init];
    [self presentPopupViewController:loyaltyStamp animationType:MJPopupViewAnimationFade];
}

#pragma mark - GUI Interactions
-(void)closeModal:(NSNotification *)notification
{
    NSString *key = [notification object];
    
    if ([@"LoyaltyStampErrorViewController" isEqualToString:key]) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissed:^{
            [self presentPopupViewController:[[LoyaltyStampErrorViewController alloc] init] animationType:MJPopupViewAnimationFade];
            [self getStampsAmount];
        }];
    }
    else if ([@"LoyaltyStampSuccessViewController" isEqualToString:key]) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissed:^{
            [self presentPopupViewController:[[LoyaltyStampSuccessViewController alloc] init] animationType:MJPopupViewAnimationFade];
            [self getStampsAmount];
        }];
    }
    else if ([@"RedeemRewardErrorViewController" isEqualToString:key]) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissed:^{
            [self presentPopupViewController:[[RedeemRewardErrorViewController alloc] init] animationType:MJPopupViewAnimationFade];
            [self getStampsAmount];
        }];
    }
    else if ([@"RedeemRewardAcceptViewController" isEqualToString:key]) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissed:^{
            [self presentPopupViewController:[[RedeemRewardAcceptViewController alloc] init] animationType:MJPopupViewAnimationFade];
            [self getStampsAmount];
        }];
    }
    else if ([@"RedeemRewardGenerateViewController" isEqualToString:key]) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissed:^{
            [self presentPopupViewController:[[RedeemRewardGenerateViewController alloc] init] animationType:MJPopupViewAnimationFade];
            [self getStampsAmount];
        }];
    }
    else{
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade dismissed:^{
            [self getStampsAmount];
        }];
    }
}
@end
