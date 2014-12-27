//
//  ContactPopUpViewController.h
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ContactData;

@interface ContactPopUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *address;
@property (assign, nonatomic) CLLocationDegrees userCurrentLat;
@property (assign, nonatomic) CLLocationDegrees userCurrentLong;
@property (nonatomic,strong) ContactData *contactData;
@property (nonatomic, weak) UIViewController *popupCaller;

@end
