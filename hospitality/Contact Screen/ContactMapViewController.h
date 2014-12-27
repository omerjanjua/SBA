//
//  ContactMapViewController.h
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ContactMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, assign) int currentSelectedIndex;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

-(void)showMapAnnotationWithPinId:(NSString *)pinID;
@end
