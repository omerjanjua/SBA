//
//  SideMenuViewController.h
//  hospitality
//
//  Created by Omer Janjua on 20/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate,UITabBarControllerDelegate>

@end


/*

SIDE MENU NOTES:
 
App Delegate:
- Setting the menu as root view controller
- Setting background image
- Menu button offset
 
Action set to the button to slide the menu out
[self.sideMenuViewController presentRightMenuViewController];
 

Side Menu View Controller:
- Setting the tableView side of things
- TableView frame
- didSelectRowAtIndexPath
- heightForRowAtIndexPath
- numberOfRowsInSection
- cellForRowAtIndexPath
 
*/