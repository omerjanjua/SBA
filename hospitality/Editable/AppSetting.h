//
//  AppSetting.h
//  hospitality
//
//  Created by Omer Janjua on 17/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#ifndef hospitality_AppSetting_h
#define hospitality_AppSetting_h

#pragma mark - General Defines
#define App_Name @"Appitized"
#define CMS_ID @"126"
#define Flurry_API_Key @""
#define Email @"info@appitized.com"
#define About_Us @""
#define Apple_App_ID @"870415501"
#define Apple_App_URL @"https://itunes.apple.com/us/app/appitized/id870415501?ls=1&mt=8"
#define Facebook_Website @"https://www.facebook.com/Appitized"
#define Twitter_Website @"https://twitter.com/appitized"
#define App_Icon_URL @"http://content.appitized.com/app_cms/image/136_6441bf2bef12e10356759e5ce29cbe54.png"
#define App_Theme_Colour [UIColor colorWithRed:97.0/255.0 green:191.0/255.0 blue:247.0/255.0 alpha:1]
#define App_Theme_Colour2 [UIColor colorWithRed:59.0/255.0 green:173.0/255.0 blue:221.0/255.0 alpha:1] //only used on the loyalty screen
#define Status_Bar_Color @"Light" //"Dark" FOR Dark content, for use on light backgrounds //"Light" FOR Light content, for use on dark backgrounds
#define Dashboard_Screen @"Dashboard_Generic" //Dashboard_Generic OR Dashboard_Generic_No_Loyalty OR Dashboard_Product OR Dashboard_Product_No_Loyalty OR Dashboard_Food OR Dashboard_Food_No_Loyalty OR Dashboard_Service OR Dashboard_Service_No_Loyalty

#pragma mark - URL Defines
#define Base_URL @"http://app.appitized.com/api/126/"
#define Push_Register @"push/register"
#define Get_Settings @"config"
#define Get_Loyalty_Device_ID @"loyalty/unique-code"
#define Get_Loyalty_Stamp_Count @"loyalty/user-stamps"
#define Collect_Stamps @"loyalty/collect-stamp"
#define Loyalty_Redeem_Request @"loyalty/redeem-request"
#define Loyalty_Redeem_Confirm @"loyalty/redeem-confirm"
#define Loyalty_Stamp_Period @"loyalty/settings"
#define Booking_Form @"booking"
#define Feedback_Form @"feedback"
#define Contact_Form @"contact"
#define Get_Gallery @"gallery"
#define Get_Offers @"offer"
#define Get_Documents @"document"
#define Get_Testimonials @"feedback/testimonials"
#define Get_News @"news"
#define Get_Services @"services"
#define Get_Menu @"menu"
#define Get_Products @"product"
#define Get_Contacts @"locations"
#define Get_Events @"events"
#define Get_Partners @"preferred-partners"
#define Get_Booking_Emails @"bookings/subjects"

#pragma mark - Not to be used by the CMS
#define Loyalty_Device_ID @"Loyalty_Device_ID"
#define Loyalty_Redeem_Code @"Loyalty_Redeem_Code"

#pragma mark - General Programming Shortcuts
#define UserDefault [NSUserDefaults standardUserDefaults]

#endif
