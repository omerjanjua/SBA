//
//  MenuPopUpViewController.h
//  hospitality
//
//  Created by Omer Janjua on 06/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuPopUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet RTLabel *itemTitle;
@property (strong, nonatomic) IBOutlet RTLabel *itemDescription;
@property (strong, nonatomic) IBOutlet RTLabel *itemPrice;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIImageView *titleSeperator;
@property (strong, nonatomic) IBOutlet UIImageView *descriptionSeperator;
@property (strong, nonatomic) IBOutlet UIImageView *priceSeperator;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *titleData;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *price;
@property (nonatomic, weak) UIViewController *popupCaller;

@end
