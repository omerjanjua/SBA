//
//  OffersSharingViewController.h
//  hospitality
//
//  Created by Omer Janjua on 11/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface OffersSharingViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *offersTitle;
@property (nonatomic, weak) UIViewController *popupCaller;

@end
