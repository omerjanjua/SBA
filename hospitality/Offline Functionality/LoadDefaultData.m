//
//  LoadDefaultData.m
//  hospitality
//
//  Created by Omer Janjua on 17/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "LoadDefaultData.h"

@implementation LoadDefaultData

+(void)createAppSettings
{
    NSUserDefaults *user = UserDefault;
    
    if ([user objectForKey:App_Name] == nil)
    {
        [user setObject:App_Name forKey:App_Name];
        [user setObject:Email forKey:Email];
        [user setObject:CMS_ID forKey:CMS_ID];
        [user setObject:Flurry_API_Key forKey:Flurry_API_Key];
        [user setObject:About_Us forKey:About_Us];
        [user setObject:Apple_App_ID forKey:Apple_App_ID];
        [user setObject:Apple_App_URL forKey:Apple_App_URL];
        [user setObject:Facebook_Website forKey:Facebook_Website];
        [user setObject:Twitter_Website forKey:Twitter_Website];
        [user setObject:App_Icon_URL forKey:App_Icon_URL];
        [user setObject:Loyalty_Device_ID forKey:Loyalty_Device_ID];
        [user setObject:Loyalty_Redeem_Code forKey:Loyalty_Redeem_Code];
        [user setObject:Dashboard_Screen forKey:Dashboard_Screen];
        [user setObject:Status_Bar_Color forKey:Status_Bar_Color];
    }
    [user synchronize];
}

+(void)loadAppSettings:(NSDictionary *)data
{
    NSUserDefaults *user = UserDefault;
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        if ([[data objectForKey:@"config"] objectForKey:@"app_name"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"app_name"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"app_name"] forKey:App_Name];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"app_id"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"app_id"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"app_id"] forKey:CMS_ID];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"email"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"email"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"email"] forKey:Email];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"flurry"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"flurry"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"flurry"] forKey:Flurry_API_Key];
        }
        if ([[[data objectForKey:@"config"] objectForKey:@"about"] objectForKey:@"data"] != [NSNull null] && ![[[[data objectForKey:@"config"] objectForKey:@"about"] objectForKey:@"data"] isEqualToString:@""])
        {
            [user setObject:[[[data objectForKey:@"config"] objectForKey:@"about"] objectForKey:@"data"] forKey:About_Us];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"apple_app_id"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"apple_app_id"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"apple_app_id"] forKey:Apple_App_ID];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"apple_app_url"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"apple_app_url"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"apple_app_url"] forKey:Apple_App_URL];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"facebook"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"facebook"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"facebook"] forKey:Facebook_Website];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"twitter"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"twitter"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"twitter"] forKey:Twitter_Website];
        }
        if ([[data objectForKey:@"config"] objectForKey:@"icon_image_url"] != [NSNull null] && ![[[data objectForKey:@"config"] objectForKey:@"icon_image_url"] isEqualToString:@""])
        {
            [user setObject:[[data objectForKey:@"config"] objectForKey:@"icon_image_url"] forKey:App_Icon_URL];
        }
        if ([[[data objectForKey:@"config"] objectForKey:@"templatesettings"] objectForKey:@"dashboard_screen"] != [NSNull null] && ![[[[data objectForKey:@"config"] objectForKey:@"templatesettings"] objectForKey:@"dashboard_screen"] isEqualToString:@""])
        {
            [user setObject:[[[data objectForKey:@"config"] objectForKey:@"templatesettings"] objectForKey:@"dashboard_screen"] forKey:Dashboard_Screen];
        }
        if ([[[data objectForKey:@"config"] objectForKey:@"templatesettings"] objectForKey:@"status_bar_colour"] != [NSNull null] && ![[[[data objectForKey:@"config"] objectForKey:@"templatesettings"] objectForKey:@"status_bar_colour"] isEqualToString:@""])
        {
            [user setObject:[[[data objectForKey:@"config"] objectForKey:@"templatesettings"] objectForKey:@"status_bar_colour"] forKey:Status_Bar_Color];
        }
    }
    [user synchronize];
}

+(void)loadLoyaltySettings:(NSDictionary *)data
{
    NSUserDefaults *loyalty = UserDefault;
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        if ([data objectForKey:@"token"] != [NSNull null] && ![[data objectForKey:@"token"] isEqualToString:@""])
        {
            [loyalty setObject:[data objectForKey:@"token"] forKey:Loyalty_Device_ID];
        }
    }
    [loyalty synchronize];
}

+(void)loyaltyRedeemCode:(NSDictionary *)data
{
    NSUserDefaults *redeem = UserDefault;
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        if ([data objectForKey:@"code"] != [NSNull null] && ![[data objectForKey:@"code"] isEqualToString:@""])
        {
            [redeem setObject:[data objectForKey:@"code"] forKey:Loyalty_Redeem_Code];
        }
    }
    [redeem synchronize];
}

@end
