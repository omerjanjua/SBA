//
//  EventsTableViewCell.m
//  hospitality
//
//  Created by Omer Janjua on 16/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "EventsTableViewCell.h"
#import "EventsPopUpViewController.h"
#import "UIViewController+MJPopupViewController.h"

@implementation EventsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButtonPressed:(id)sender
{
    EventsPopUpViewController *controller = [[EventsPopUpViewController alloc] init];
    [controller setPopupCaller:_controller];
    controller.titleData = self.titleLabel.text;
    controller.dateData = self.dateLabel.text;
    controller.imageData = self.imageData;
    [_controller presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
}

@end
