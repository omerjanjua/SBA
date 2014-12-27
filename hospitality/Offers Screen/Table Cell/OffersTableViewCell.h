//
//  OffersTableViewCell.h
//  hospitality
//
//  Created by Omer Janjua on 22/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersTableViewCell : UITableViewCell{
    
}

@property (strong, nonatomic) IBOutlet RTLabel *mainLabel;
@property (strong, nonatomic) IBOutlet RTLabel *detailedTextLabel;
@property (weak, nonatomic) id controller;
@property (strong, nonatomic) NSString *title;

- (IBAction)shareButtonPressed:(id)sender;


@end
