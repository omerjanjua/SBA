//
//  ProductsDetailedViewController.h
//  hospitality
//
//  Created by Omer Janjua on 09/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ProductsDetailedViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* description;
@property (strong, nonatomic) NSString* price;
@property (strong, nonatomic) NSString* imageUrl;
@property (strong, nonatomic) NSString* imageUrl2;
@property (strong, nonatomic) NSString* imageUrl3;
@property (strong, nonatomic) NSString* imageUrl4;
@property (strong, nonatomic) NSMutableArray *data;

@end
