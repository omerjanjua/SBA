//
//  GalleryViewController.h
//  hospitality
//
//  Created by Omer Janjua on 21/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "MWPhotoBrowser.h"

@interface GalleryViewController : UIViewController <PSCollectionViewDataSource, PSCollectionViewDelegate, MWPhotoBrowserDelegate>

@end
