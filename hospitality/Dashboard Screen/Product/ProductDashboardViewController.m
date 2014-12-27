//
//  ProductDashboardViewController.m
//  hospitality
//
//  Created by Omer Janjua on 18/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ProductDashboardViewController.h"
#import "AboutUsViewController.h"
#import "LoyaltyViewController.h"
#import "TestimonialsViewController.h"
#import "NewsFeedViewController.h"
#import "ContactDetailViewController.h"
#import "BarCodeReaderViewController.h"
#import "ContactFormViewController.h"
#import "ContactMapViewController.h"
#import "GalleryViewController.h"
#import "OffersViewController.h"
#import "ProductsViewController.h"
#import "FBShimmeringView.h"

@interface ProductDashboardViewController ()

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *loyaltyView;

- (IBAction)dashboardButton1:(id)sender;
- (IBAction)dashboardButton2:(id)sender;
- (IBAction)dashboardButton3:(id)sender;
- (IBAction)dashboardButton4:(id)sender;
- (IBAction)dashboardButton5:(id)sender;
- (IBAction)dashboardButton6:(id)sender;

@property (strong, nonatomic) IBOutlet FBShimmeringView *stampCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stamp1;
@property (strong, nonatomic) IBOutlet UIImageView *stamp2;
@property (strong, nonatomic) IBOutlet UIImageView *stamp3;
@property (strong, nonatomic) IBOutlet UIImageView *stamp4;
@property (strong, nonatomic) IBOutlet UIImageView *stamp5;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation ProductDashboardViewController

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
    [self loyaltySetup];
    [self getStampsAmount];
    self.navigationController.navigationBarHidden = YES;
    self.navigationTitle.text = [UserDefault objectForKey:App_Name];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Dashbaord Setup
//
// Dashboard Button Layout
//     // 1 // 2 //
//     // 3 // 4 //
//     // 5 // 6 //
//

-(UIImage *)blankImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

- (IBAction)dashboardButton1:(id)sender
{
    ProductsViewController *controller = [[ProductsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton2:(id)sender
{
    OffersViewController *controller = [[OffersViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton3:(id)sender
{
    AboutUsViewController *controller = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton4:(id)sender
{
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.delegate = self;
    
    NSDictionary *normalState = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont: [UIFont systemFontOfSize:14.0]};
    ContactDetailViewController *contactDetailController = [[ContactDetailViewController alloc] init];
    UITabBarItem *contactDetailTabItem = [[UITabBarItem alloc] init];
    [contactDetailTabItem setTitleTextAttributes:normalState forState:UIControlStateNormal];
    [contactDetailTabItem setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    [contactDetailTabItem setTitle:@"List View"];
    //            [contactDetailController setTabBarItem:contactDetailTabItem];
    
    ContactMapViewController *contactMapController = [[ContactMapViewController alloc] init];
    UITabBarItem *contactMapTabItem = [[UITabBarItem alloc] init];
    [contactMapTabItem setTitleTextAttributes:normalState forState:UIControlStateNormal];
    [contactMapTabItem setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    [contactMapTabItem setTitle:@"Map View"];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:contactDetailController];
    [controller setTabBarItem:contactDetailTabItem];
    
    UINavigationController *controller1 = [[UINavigationController alloc] initWithRootViewController:contactMapController];
    [controller1 setTabBarItem:contactMapTabItem];
    
    [contactDetailController setMapController:contactMapController];
    
    //            [tabbarController setViewControllers:@[contactDetailController, contactMapController]];
    [tabbarController setViewControllers:@[controller, controller1]];
    UIView *separator = [[UIView alloc ] initWithFrame:CGRectMake(160, 0, 1, 49)];
    [separator setBackgroundColor:[UIColor whiteColor]];
    [tabbarController.tabBar insertSubview:separator atIndex:1];
    if ([tabbarController.tabBar respondsToSelector:@selector(setBarTintColor:)]) {
        [tabbarController.tabBar setBarTintColor:[UIColor blackColor]];
        [tabbarController.tabBar setTranslucent:NO];
    }
    else{
        [tabbarController.tabBar setTintColor:[UIColor blackColor]];
    }
    //this line for selected background on iOS 6
    [tabbarController.tabBar  setSelectionIndicatorImage:[self blankImage]];
    [self.navigationController pushViewController:tabbarController animated:NO];
}

- (IBAction)dashboardButton5:(id)sender
{
    NewsFeedViewController *controller = [[NewsFeedViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton6:(id)sender
{
    TestimonialsViewController *controller = [[TestimonialsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)loyalty:(id)sender
{
    if([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        LoyaltyViewController *controller = [[LoyaltyViewController alloc] initWithNibName:@"LoyaltyViewController_35" bundle:nil];
        [self.navigationController pushViewController:controller animated:NO];
    }
    else {
        LoyaltyViewController *controller = [[LoyaltyViewController alloc] initWithNibName:@"LoyaltyViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

#pragma mark - Loyalty Setup
-(void)loyaltySetup
{
    _loyaltyView.backgroundColor = App_Theme_Colour;
    _navigationView.backgroundColor = App_Theme_Colour;
    
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"]) {
        
        _navigationTitle.textColor = [UIColor whiteColor];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button"] forState:UIControlStateNormal];
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
    }
    
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"]) {
        
        _navigationTitle.textColor = [UIColor blackColor];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-black"] forState:UIControlStateNormal];
        [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
    }
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
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    label.backgroundColor = [UIColor clearColor];
    
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"]) {
        
        _navigationTitle.textColor = [UIColor whiteColor];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button"] forState:UIControlStateNormal];
        label.textColor = [UIColor whiteColor];
        if ([stampLabelValue intValue] == 0) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        }
        else if ([stampLabelValue intValue] == 1) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        }
        else if ([stampLabelValue intValue] == 2) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        }
        else if ([stampLabelValue intValue] == 3) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        }
        else if ([stampLabelValue intValue] == 4) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked.png"]];
        }
        else if ([stampLabelValue intValue] == 5) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-checked.png"]];
        }
    }
    
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"]) {
        
        _navigationTitle.textColor = [UIColor blackColor];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-black"] forState:UIControlStateNormal];
        label.textColor = [UIColor blackColor];
        if ([stampLabelValue intValue] == 0) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        }
        else if ([stampLabelValue intValue] == 1) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        }
        else if ([stampLabelValue intValue] == 2) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        }
        else if ([stampLabelValue intValue] == 3) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        }
        else if ([stampLabelValue intValue] == 4) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-unchecked-black.png"]];
        }
        else if ([stampLabelValue intValue] == 5) {
            [self.stamp1 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp2 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp3 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp4 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
            [self.stamp5 setImage:[UIImage imageNamed:@"loyalty-checked-black.png"]];
        }
    }
    label.text = @"Loyalty Card";
    _stampCountLabel.contentView = label;
    _stampCountLabel.shimmering = YES;
    
    [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-gray"] forState:UIControlStateHighlighted];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[UINavigationController class] ]) {
        if ([[(UINavigationController *)viewController visibleViewController] isKindOfClass:[ContactFormViewController class]]) {
            [(UINavigationController *)viewController popViewControllerAnimated:NO];
            return NO;
        }
    }
    return YES;
}

@end
