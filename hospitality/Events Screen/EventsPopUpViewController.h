//
//  EventsPopUpViewController.h
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsPopUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSString *titleData;
@property (strong, nonatomic) NSString *dateData;
@property (strong, nonatomic) NSString *imageData;
@property (nonatomic, weak) UIViewController *popupCaller;

@end
