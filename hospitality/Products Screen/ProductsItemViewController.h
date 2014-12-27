//
//  ProductsItemViewController.h
//  hospitality
//
//  Created by Omer Janjua on 02/06/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *data;

@end
