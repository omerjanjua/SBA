//
//  MenuItemViewController.h
//  hospitality
//
//  Created by Omer Janjua on 09/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"

@interface MenuItemViewController : UIViewController <PSCollectionViewDataSource, PSCollectionViewDelegate>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *bannerText;

@end
