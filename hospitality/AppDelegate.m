//
//  AppDelegate.m
//  hospitality
//
//  Created by Omer Janjua on 17/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadDefaultData.h"
#import "LoadingViewController.h"
#import "SideMenuViewController.h"
#import "LoyaltyViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation AppDelegate

//TODO: put UIActivityIndicator on relavent screens
//TODO: loyalty code refactor
//TODO: Landscape movie screen issue

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // making the rootviewcontroller a nivagtion controller when added to the view hiearchy 
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[LoadingViewController alloc] init]];
    SideMenuViewController *menuViewController = [[SideMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navController leftMenuViewController:nil rightMenuViewController:menuViewController];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Menu_Background"];
    sideMenuViewController.delegate = self;
    sideMenuViewController.panGestureEnabled = YES;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 75;
    sideMenuViewController.parallaxEnabled = YES;
    sideMenuViewController.animationDuration = 0.25;
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    //Register for Push
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    //Register for Flurry
    [self flurryIntegration];
    
    //Creating App data at launch
    [LoadDefaultData createAppSettings];
    
    //Load App settings + Loyalty Settings
    [self loadAppSettings];
    [self loadLoyaltySettings];
    
    //Appirater Setup
    [self appiraterSetup];
    
    //Set Status Bar Style
    [self statusBarLogic];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Load App Settings
-(void)loadAppSettings
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Settings] parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [LoadDefaultData loadAppSettings:responseObject];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Cannot reach server, please check you internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"Load App Settings:%@", [error localizedDescription]);
     }];
}

-(void)loadLoyaltySettings
{
    BOOL downloaded = [UserDefault boolForKey:@"downloaded"];
    if (!downloaded)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *deviceData = [NSDictionary dictionaryWithObjectsAndKeys:[[UIDevice currentDevice] name], @"device_name", @"Apple", @"device_make", [[UIDevice currentDevice] model], @"device_model", nil];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Loyalty_Device_ID] parameters:deviceData success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"%@", responseObject);
             [LoadDefaultData loadLoyaltySettings:responseObject];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Load Loyalty Settings:%@", [error localizedDescription]);
         }];
        
        [UserDefault setBool:YES forKey:@"downloaded"];
    }
}

#pragma mark - Flurry Integration
-(void)flurryIntegration
{
    //note: iOS only allows one crash reporting tool per app, for now we have Flurry enabled to Yes
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:[UserDefault objectForKey:Flurry_API_Key]];
}

#pragma mark - Appirater Setup
-(void)appiraterSetup
{
    [Appirater setAppId:Apple_App_ID];
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

#pragma mark - Push Notification Setup
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    BOOL downloaded = [UserDefault boolForKey:@"finish"];
    if (!downloaded)
    {
        NSDictionary *deviceData = [NSDictionary dictionaryWithObjectsAndKeys:[[[[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""], @"device_token", [[UIDevice currentDevice] systemVersion], @"ios_version", @"ios", @"device_type", [[UIDevice currentDevice] name], @"device_name", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Push_Register] parameters:deviceData success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"Push Register Successful");
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Push Notification Registeratio Failed:%@", [error localizedDescription]);
        }];
        
        [UserDefault setBool:YES forKey:@"finish"];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [view show];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Push Notification Registeration Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"%@", [error localizedDescription]);
}

-(void)statusBarLogic
{
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if ([[self.window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]])
//    {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

@end
