//
//  DashboardViewControllerNoLoyalty.m
//  hospitality
//
//  Created by Omer Janjua on 18/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "DashboardViewControllerNoLoyalty.h"
#import "AboutUsViewController.h"
#import "TestimonialsViewController.h"
#import "NewsFeedViewController.h"
#import "ContactDetailViewController.h"
#import "BarCodeReaderViewController.h"
#import "GalleryViewController.h"
#import "OffersViewController.h"
#import "EventsWithTKLibViewController.h"
#import "ContactMapViewController.h"
#import "ContactFormViewController.h"

@interface DashboardViewControllerNoLoyalty ()

@property (weak, nonatomic) IBOutlet UIView *loyaltyView;

- (IBAction)dashboardButton1:(id)sender;
- (IBAction)dashboardButton2:(id)sender;
- (IBAction)dashboardButton3:(id)sender;
- (IBAction)dashboardButton4:(id)sender;
- (IBAction)dashboardButton5:(id)sender;
- (IBAction)dashboardButton6:(id)sender;
- (IBAction)dashboardButton7:(id)sender;
- (IBAction)dashboardButton8:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation DashboardViewControllerNoLoyalty

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
    self.navigationController.navigationBarHidden = YES;
    self.navigationTitle.text = [UserDefault objectForKey:App_Name];
    _loyaltyView.backgroundColor = App_Theme_Colour;
    // Do any additional setup after loading the view from its nib.

    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:nil backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];
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
//     // 7 // 8 //
//

-(UIImage *)blankImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

- (IBAction)dashboardButton1:(id)sender
{
    AboutUsViewController *controller = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton2:(id)sender
{
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.delegate = self;
    
    NSDictionary *normalState = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont: [UIFont systemFontOfSize:14.0]};
    ContactDetailViewController *contactDetailController = [[ContactDetailViewController alloc] init];
    UITabBarItem *contactDetailTabItem = [[UITabBarItem alloc] init];
    [contactDetailTabItem setTitleTextAttributes:normalState forState:UIControlStateNormal];
    [contactDetailTabItem setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    [contactDetailTabItem setTitle:@"List View"];
    
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

- (IBAction)dashboardButton3:(id)sender
{
    NewsFeedViewController *controller = [[NewsFeedViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton4:(id)sender
{
    GalleryViewController *controller = [[GalleryViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton5:(id)sender
{
    OffersViewController *controller = [[OffersViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton6:(id)sender
{
    TestimonialsViewController *controller = [[TestimonialsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton7:(id)sender
{
    EventsWithTKLibViewController *controller = [[EventsWithTKLibViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)dashboardButton8:(id)sender
{
    BarCodeReaderViewController *controller = [[BarCodeReaderViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
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
