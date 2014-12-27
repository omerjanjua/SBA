//
//  SharingViewController.h
//  hospitality
//
//  Created by Omer Janjua on 11/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SharingViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, weak) UIViewController *popupCaller;

@end
