//
//  HelperClass.m
//  hospitality
//
//  Created by Omer Janjua on 03/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "HelperClass.h"
#import "UIViewController+MJPopupViewController.h"

@implementation HelperClass

+(void)textValidation:(NSString *)name phoneText:(NSString *)phone messageText:(NSString *)message
{
    if ([name isEqualToString:@""] || [name isEqualToString:@" "] || [name isEqualToString:@"  "] || [phone isEqualToString:@""] || [phone isEqualToString:@" "] || [phone isEqualToString:@"  "] || [message isEqualToString:@""] || [message isEqualToString:@" "] || [message isEqualToString:@"  "])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:@"Please fill in all text fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

+(BOOL)validateEmail:(NSString *)text
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:text];
}

+(BOOL)validateNotEmpty:(NSString *)text
{
    return ([text length] == 0) ? NO : YES;
}



+(void)navigationMenuSetup:(UILabel *)navigationTitle navigationSubTitle:(UILabel *)navigationSubTitle homeButton:(UIButton *)homeButton backButton:(UIButton *)backButton eventsButton:(UIButton *)eventsButton sideMenuButton:(UIButton *)sideMenuButton
{
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"]) {
        navigationTitle.textColor = [UIColor whiteColor];
        navigationSubTitle.textColor = [UIColor whiteColor];
        [homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigation-menu-back-button"] forState:UIControlStateNormal];
        [eventsButton setImage:[UIImage imageNamed:@"events-show-all-evetns-icon"] forState:UIControlStateNormal];
        [sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button"] forState:UIControlStateNormal];
    }
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"]) {
        navigationTitle.textColor = [UIColor blackColor];
        navigationSubTitle.textColor = [UIColor blackColor];
        [homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button-black"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigation-menu-back-button-black"] forState:UIControlStateNormal];
        [eventsButton setImage:[UIImage imageNamed:@"events-show-all-evetns-icon-black"] forState:UIControlStateNormal];
        [sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-black"] forState:UIControlStateNormal];
    }
    
    [homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button-gray"] forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageNamed:@"navigation-menu-back-button-gray"] forState:UIControlStateHighlighted];
    [eventsButton setImage:[UIImage imageNamed:@"events-show-all-evetns-icon-gray"] forState:UIControlStateHighlighted];
    [sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-gray"] forState:UIControlStateHighlighted];
}

@end
