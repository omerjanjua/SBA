//
//  NewsArticleViewController.h
//  hospitality
//
//  Created by Omer Janjua on 02/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"

@interface NewsArticleViewController : UIViewController <PSCollectionViewDataSource, PSCollectionViewDelegate>

@property (strong, nonatomic) NSString *articleTitle;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *imageUrl;

@end
