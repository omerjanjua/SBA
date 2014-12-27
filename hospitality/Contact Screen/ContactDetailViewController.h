//
//  ContactDetailViewController.h
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactMapViewController;

@interface ContactDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (weak, nonatomic) ContactMapViewController *mapController;
@end
