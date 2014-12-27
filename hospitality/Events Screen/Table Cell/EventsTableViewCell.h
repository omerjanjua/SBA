//
//  EventsTableViewCell.h
//  hospitality
//
//  Created by Omer Janjua on 16/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSString *imageData;
@property (weak, nonatomic) id controller;

- (IBAction)addButtonPressed:(id)sender;

@end
