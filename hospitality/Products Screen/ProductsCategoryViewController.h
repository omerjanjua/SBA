//
//  ProductsCategoryViewController.h
//  hospitality
//
//  Created by Omer Janjua on 30/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *data;

@end
