//
//  OffersTableViewCell.m
//  hospitality
//
//  Created by Omer Janjua on 22/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "OffersTableViewCell.h"
#import "OffersSharingViewController.h"
#import "UIViewController+MJPopupViewController.h"

@implementation OffersTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)shareButtonPressed:(id)sender
{
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        OffersSharingViewController *controllers = [[OffersSharingViewController alloc] initWithNibName:@"OffersSharingViewController_35" bundle:nil];
        controllers.offersTitle = self.title;
        [controllers setPopupCaller:_controller];
        [_controller presentPopupViewController:controllers animationType:MJPopupViewAnimationSlideBottomTop];
    }
    else
    {
        OffersSharingViewController *controllers = [[OffersSharingViewController alloc] initWithNibName:@"OffersSharingViewController" bundle:nil];
        controllers.offersTitle = self.title;
        [controllers setPopupCaller:_controller];
        [_controller presentPopupViewController:controllers animationType:MJPopupViewAnimationSlideBottomTop];
    }
}
@end
