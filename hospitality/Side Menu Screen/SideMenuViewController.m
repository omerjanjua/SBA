//
//  SideMenuViewController.m
//  hospitality
//
//  Created by Omer Janjua on 20/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideMenuTableViewCell.h"
#import "AboutUsViewController.h"
#import "SharingViewController.h"
#import "BarCodeReaderViewController.h"
#import "BookingFormViewController.h"
#import "ContactDetailViewController.h"
#import "DocumentsViewController.h"
#import "EventsWithTKLibViewController.h"
#import "FeedbackViewController.h"
#import "GalleryViewController.h"
#import "MenuTypeOfMealViewController.h"
#import "NewsFeedViewController.h"
#import "OffersViewController.h"
#import "ProductsViewController.h"
#import "ServicesViewController.h"
#import "TestimonialsViewController.h"
#import "ContactMapViewController.h"
#import "ContactFormViewController.h"
#import "PartnersViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface SideMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, readwrite, nonatomic) UIView *socialView;
@property (strong, readwrite, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) NSMutableArray *componentsArray;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *menuItemKeys;

@end

@implementation SideMenuViewController

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
	// Do any additional setup after loading the view.
    [self arraySetup];
    [self viewSetup];
    [self socialMediaSetup];
}

-(void)viewSetup
{
    /*--------------TableView Setup---------------*/
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(80, (self.view.frame.size.height - 410) / 2.0f, self.view.frame.size.width, (self.view.frame.size.height + 284) / 2.0f) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth; //427
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 169)];
        }
        [tableView setSeparatorColor:[UIColor lightGrayColor]];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.bounces = YES;
        tableView;
    });
    [self.view addSubview:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"SideMenuTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    /*--------------SocialView Setup---------------*/
    self.socialView = ({
        UIView *socialView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 62), self.view.frame.size.width, 62)];
        socialView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.30];
        socialView;
    });
    [self.view addSubview:self.socialView];
    
    /*--------------Header Setup---------------*/
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, (self.view.frame.size.height - 454) / 2.0f, 100, 22)];
    self.headerLabel.backgroundColor = [UIColor clearColor];
    self.headerLabel.text = @"NAVIGATION";
    self.headerLabel.textColor = [UIColor lightGrayColor];
    self.headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [self.view addSubview:self.headerLabel];

}

-(void)arraySetup
{
    _componentsArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSMutableArray alloc] init];
    _imagesArray = [[NSMutableArray alloc] init];
    _menuItemKeys = [[NSMutableArray alloc] init];
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Settings]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLResponse* response = nil;
    NSError* error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    if (!error)
    {
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        _componentsArray = [[NSMutableArray alloc] initWithArray:[[[responseObject objectForKey:@"config"] objectForKey:@"components"] objectForKey:@"list"]];
    }
    else
    {
        //Handle error here
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Cannot reach server, please check you internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
    }
    
    [_titleArray addObject:@"Dashboard"]; //item 1
    [_imagesArray addObject:@"side-menu-dashboard-icon"];
    [_menuItemKeys addObject:@"dashboard"];
    
    [_titleArray addObject:@"About Us"]; //item 2
    [_imagesArray addObject:@"side-menu-about-us-icon"];
    [_menuItemKeys addObject:@"about-us"];
    
    [_titleArray addObject:@"Barcode Reader"]; //item 3
    [_imagesArray addObject:@"side-menu-barcode-scanner-icon"];
    [_menuItemKeys addObject:@"barcode-scanner"];
    
    if ([_componentsArray containsObject:@"booking"]) {
        [_titleArray addObject:@"Booking Form"];
        [_imagesArray addObject:@"side-menu-bookings-icon"];
        [_menuItemKeys addObject:@"booking"];
    }
    
    if ([_componentsArray containsObject:@"locations"]) {
        [_titleArray addObject:@"Contact"];
        [_imagesArray addObject:@"side-menu-contact-icon"];
        [_menuItemKeys addObject:@"locations"];
    }
    
    if ([_componentsArray containsObject:@"document"]) {
        [_titleArray addObject:@"Documents"];
        [_imagesArray addObject:@"side-menu-documents-icon"];
        [_menuItemKeys addObject:@"document"];
    }
    
    if ([_componentsArray containsObject:@"events"]) {
        [_titleArray addObject:@"Events"];
        [_imagesArray addObject:@"side-menu-events-icon"];
        [_menuItemKeys addObject:@"events"];
    }
    
    if ([_componentsArray containsObject:@"feedback"]) {
        [_titleArray addObject:@"Feedback"];
        [_imagesArray addObject:@"side-menu-feedback-icon"];
        [_menuItemKeys addObject:@"feedback"];
    }
    
    if ([_componentsArray containsObject:@"gallery"]) {
        [_titleArray addObject:@"Gallery"];
        [_imagesArray addObject:@"side-menu-gallery-icon"];
        [_menuItemKeys addObject:@"gallery"];
    }

    if ([_componentsArray containsObject:@"menu"]) {
        [_titleArray addObject:@"Menu"];
        [_imagesArray addObject:@"side-menu-our-menu-icon"];
        [_menuItemKeys addObject:@"menu"];
    }
    
    if ([_componentsArray containsObject:@"news"]) {
        [_titleArray addObject:@"News Feed"];
        [_imagesArray addObject:@"side-menu-news-feed-icon"];
        [_menuItemKeys addObject:@"news"];
    }
   
    if ([_componentsArray containsObject:@"offers"]) {
        [_titleArray addObject:@"Offers"];
        [_imagesArray addObject:@"side-menu-special-offers-icon"];
        [_menuItemKeys addObject:@"offers"];
    }
    
    if ([_componentsArray containsObject:@"preferred-partners"]) {
        [_titleArray addObject:@"Partners"];
        [_imagesArray addObject:@"side-menu-partners-icon"];
        [_menuItemKeys addObject:@"preferred-partners"];
    }
    
    if ([_componentsArray containsObject:@"products"]) {
        [_titleArray addObject:@"Products"];
        [_imagesArray addObject:@"side-menu-our-products-icon"];
        [_menuItemKeys addObject:@"products"];
    }
    
    if ([_componentsArray containsObject:@"services"]) {
        [_titleArray addObject:@"Services"];
        [_imagesArray addObject:@"side-menu-services-icon"];
        [_menuItemKeys addObject:@"services"];
    }
    
    [_titleArray addObject:@"Testimonials"];
    [_imagesArray addObject:@"side-menu-testimonials-icon"];
    [_menuItemKeys addObject:@"testimonials"];
    
    [_titleArray addObject:@"App Suggestion"];
    [_imagesArray addObject:@"side-menu-app-suggestion-icon"];
    [_menuItemKeys addObject:@"suggestion"];
}

#pragma mark - Social Media Share Setup

-(void)socialMediaSetup
{
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setImage:[UIImage imageNamed:@"navigation-facebook"] forState:UIControlStateNormal];
    [facebookButton setFrame:CGRectMake(20, 17, 28, 28)];
    [facebookButton addTarget:self action:@selector(openFacebookWebsite) forControlEvents:UIControlEventTouchUpInside];
    [self.socialView addSubview:facebookButton];
    
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton setImage:[UIImage imageNamed:@"navigation-twitter"] forState:UIControlStateNormal];
    [twitterButton setFrame:CGRectMake(106, 17, 28, 28)];
    [twitterButton addTarget:self action:@selector(openTwitterWebsite) forControlEvents:UIControlEventTouchUpInside];
    [self.socialView addSubview:twitterButton];
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailButton setImage:[UIImage imageNamed:@"navigation-email"] forState:UIControlStateNormal];
    [emailButton setFrame:CGRectMake(192, 17, 29, 29)];
    [emailButton addTarget:self action:@selector(openEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.socialView addSubview:emailButton];
    
    UIButton *socialMediaShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [socialMediaShare setImage:[UIImage imageNamed:@"navigation-share"] forState:UIControlStateNormal];
    [socialMediaShare setFrame:CGRectMake(277, 15, 21, 29)];
    [socialMediaShare addTarget:self action:@selector(socialMediaShare) forControlEvents:UIControlEventTouchUpInside];
    [self.socialView addSubview:socialMediaShare];
}

-(void)openFacebookWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Facebook_Website]];
}

-(void)openTwitterWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Twitter_Website]];
}

-(void)openEmail
{
    if ([[UserDefault objectForKey:Email] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"No email in directory" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:[UserDefault objectForKey:Email]]];
        if (controller) [self presentViewController:controller animated:YES completion:Nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Message Sent Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)socialMediaShare
{
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        SharingViewController *controller = [[SharingViewController alloc] initWithNibName:@"SharingViewController_35" bundle:nil];
        [controller setPopupCaller:self];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationSlideBottomTop];
    }
    else
    {
        SharingViewController *controller = [[SharingViewController alloc] initWithNibName:@"SharingViewController" bundle:nil];
        [controller setPopupCaller:self];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationSlideBottomTop];
    }
}
-(UIImage *)blankImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}
#pragma mark - UITableView Delegate
//TODO: need to refactor this to work with dynamic adding in the menu items
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = _menuItemKeys[indexPath.row];
    
    if ([@"dashboard" isEqualToString:key]) {
        [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
    }
    
    if ([@"about-us" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[AboutUsViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"barcode-scanner" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[BarCodeReaderViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"booking" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[BookingFormViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"locations" isEqualToString:key]) {
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
        
        self.sideMenuViewController.contentViewController = tabbarController;
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"document" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[DocumentsViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"events" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[EventsWithTKLibViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"feedback" isEqualToString:key]) {
        if([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    if ([@"gallery" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[GalleryViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"menu" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[MenuTypeOfMealViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"news" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[NewsFeedViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"offers" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[OffersViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"preferred-partners" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[PartnersViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"products" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ProductsViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"services" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ServicesViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"testimonials" isEqualToString:key]) {
        self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[TestimonialsViewController alloc] init]];
        [self.sideMenuViewController hideMenuViewController];
    }
    if ([@"suggestion" isEqualToString:key]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"sbafeedback@appitized.com"]];
        if (controller) [self presentViewController:controller animated:YES completion:Nil];
    }
}

#pragma mark - UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[SideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.image.image = [UIImage imageNamed:_imagesArray[indexPath.row]];
    
    return cell;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end