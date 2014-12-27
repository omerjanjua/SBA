//
//  UIViewController+DashboardSetup.m
//  hospitality
//
//  Created by Omer Janjua on 12/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "UIViewController+DashboardSetup.h"

@implementation UIViewController (DashboardSetup)

-(void)settingUpDashboardType:(NSString *)dashboardType
{
    if ([dashboardType isEqualToString:@"Dashboard_Generic"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[DashboardViewController alloc] initWithNibName:@"DashboardViewController_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Generic_No_Loyalty"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[DashboardViewControllerNoLoyalty alloc] initWithNibName:@"DashboardViewControllerNoLoyalty_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[DashboardViewControllerNoLoyalty alloc] initWithNibName:@"DashboardViewControllerNoLoyalty" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];}
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Product"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ProductDashboardViewController alloc] initWithNibName:@"ProductDashboardViewController_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ProductDashboardViewController alloc] initWithNibName:@"ProductDashboardViewController" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Product_No_Loyalty"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ProductDashboardViewControllerNoLoyalty alloc] initWithNibName:@"ProductDashboardViewControllerNoLoyalty_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ProductDashboardViewControllerNoLoyalty alloc] initWithNibName:@"ProductDashboardViewControllerNoLoyalty" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Food"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[FoodDashboardViewController alloc] initWithNibName:@"FoodDashboardViewController_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[FoodDashboardViewController alloc] initWithNibName:@"FoodDashboardViewController" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Food_No_Loyalty"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[FoodDashboardViewControllerNoLoyalty alloc] initWithNibName:@"FoodDashboardViewControllerNoLoyalty_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[FoodDashboardViewControllerNoLoyalty alloc] initWithNibName:@"FoodDashboardViewControllerNoLoyalty" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Service"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ServiceDashboardViewController alloc] initWithNibName:@"ServiceDashboardViewController_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ServiceDashboardViewController alloc] initWithNibName:@"ServiceDashboardViewController" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
    
    if ([dashboardType isEqualToString:@"Dashboard_Service_No_Loyalty"]) {
        if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ServiceDashboardViewControllerNoLoyalty alloc] initWithNibName:@"ServiceDashboardViewControllerNoLoyalty_35" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
        else {
            self.sideMenuViewController.contentViewController = [[UINavigationController alloc] initWithRootViewController:[[ServiceDashboardViewControllerNoLoyalty alloc] initWithNibName:@"ServiceDashboardViewControllerNoLoyalty" bundle:nil]];
            [self.sideMenuViewController hideMenuViewController];
        }
    }
}

@end
