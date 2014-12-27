//
//  ContactMapViewController.m
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ContactMapViewController.h"
#import "ContactFormViewController.h"
#import "ContactDetailViewController.h"
#import "ContactPopUpViewController.h"
#import "ContactData.h"
#import "LocationPin.h"
#import "UIViewController+MJPopupViewController.h"

#import <objc/runtime.h>

static char kContactAssociatedAnnotationKey;

@interface ContactMapViewController (){
    NSString *pendingPinId;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *enquiryFormButton;
@property (strong, nonatomic) IBOutlet UIButton *contactDetailsButton;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ContactMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentSelectedIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self setupMapView];
    // Do any additional setup after loading the view from its nib.
    if (pendingPinId) {
        LocationPin *pin = [[LocationPin alloc] init];
        pin.pinID = pendingPinId;
        int index = [self.mapView.annotations indexOfObject:pin];
        
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:index] animated:YES];
        pendingPinId = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"])
    {
        _navigationTitle.textColor = [UIColor whiteColor];
        [_homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button"] forState:UIControlStateNormal];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button"] forState:UIControlStateNormal];
        [_enquiryFormButton setImage:[UIImage imageNamed:@"enquiry-form-button"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected"] forState:UIControlStateHighlighted];
    }
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"])
    {
        _navigationTitle.textColor = [UIColor blackColor];
        [_homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button-black"] forState:UIControlStateNormal];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-black"] forState:UIControlStateNormal];
        [_enquiryFormButton setImage:[UIImage imageNamed:@"enquiry-form-button-black"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected-black"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected-black"] forState:UIControlStateHighlighted];
    }
    [_homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button-gray"] forState:UIControlStateHighlighted];
    [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-gray"] forState:UIControlStateHighlighted];
    [_enquiryFormButton setImage:[UIImage imageNamed:@"enquiry-form-button-gray"] forState:UIControlStateHighlighted];
    
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

- (IBAction)formButtonPressed:(id)sender
{
    ContactFormViewController *controller = [[ContactFormViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)contactDetailButtonPressed:(id)sender
{
    ContactDetailViewController *controller = [[ContactDetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void)setupMapView
{
    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 20;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; //kCLLocationAccuracyHundredMeters
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (ContactData *contactData in self.data)
    {
        NSString *name = contactData.name;
        NSString *fullAddress = contactData.fullAddress;
        NSString *latitude = contactData.latitude;
        NSString *longitude = contactData.longitude;
        NSString *email = contactData.email;
        NSString *telephone = contactData.telephone;
        NSString *website = contactData.website;
        
        NSLog(@"%@%@%@%@%@%@%@", name, fullAddress, latitude, longitude, email, telephone, website);
                
        float f_lat = [latitude doubleValue];
        float f_long = [longitude doubleValue];
        
        if ((f_lat >= -90 && f_lat <= 90) && (f_long >= -180 && f_long <= 180))
        {
            MKCoordinateRegion region;
            region.center.latitude = f_lat;
            region.center.longitude = f_long;
            region.span.latitudeDelta = 0.01f;
            region.span.longitudeDelta = 0.01f;
            [self.mapView setRegion:region animated:YES];
            self.mapView.delegate = self;

            LocationPin *pin = [[LocationPin alloc] init];
            pin.pinID = contactData.pinId;
            pin.coordinate = region.center;
            [self.mapView addAnnotation:pin];
            
            
            objc_setAssociatedObject(pin,
                                     &kContactAssociatedAnnotationKey,
                                     contactData,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, pin.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, pin.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, pin.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, pin.coordinate.latitude);
        }
    }
    
    
    if (_currentSelectedIndex > -1 && self.mapView.annotations.count > 0) {
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:_currentSelectedIndex] animated:YES];
    }
    else{
        MKCoordinateRegion region;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
        region = [self.mapView regionThatFits:region];
        
        if ((region.center.latitude >= -90 && region.center.latitude <=90) && (region.center.longitude >= -180 && region.center.longitude<=180))
        {
            [self.mapView setRegion:region animated:NO];
        }
    }
    
}
-(void)showMapAnnotationWithPinId:(NSString *)pinID{
    if (!self.isViewLoaded) {
        pendingPinId = [pinID copy];
        
    }
    else{
        LocationPin *pin = [[LocationPin alloc] init];
        pin.pinID = pinID;
        int index = [self.mapView.annotations indexOfObject:pin];
        
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:index] animated:YES];
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        ContactPopUpViewController *controller = [[ContactPopUpViewController alloc] initWithNibName:@"ContactPopUpViewController_35" bundle:nil];
        [controller setPopupCaller:self];
        controller.userCurrentLat = self.mapView.userLocation.coordinate.latitude;
        controller.userCurrentLong = self.mapView.userLocation.coordinate.longitude;
        ContactData *data = objc_getAssociatedObject(view.annotation,
                                                     &kContactAssociatedAnnotationKey);
        [controller setContactData:data];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    }
    else {
        ContactPopUpViewController *controller = [[ContactPopUpViewController alloc] initWithNibName:@"ContactPopUpViewController" bundle:nil];
        [controller setPopupCaller:self];
        controller.userCurrentLat = self.mapView.userLocation.coordinate.latitude;
        controller.userCurrentLong = self.mapView.userLocation.coordinate.longitude;
        ContactData *data = objc_getAssociatedObject(view.annotation,
                                                     &kContactAssociatedAnnotationKey);
        [controller setContactData:data];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    }
    view.image = [UIImage imageNamed:@"contact-map-location-pin-selected"];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    view.image = [UIImage imageNamed:@"contact-map-location-pin"];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    UIImage *image = nil;
    static NSString *defaultPinID = @"annotation";
    MKAnnotationView *view = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];

    if (view == nil) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    image = [UIImage imageNamed:@"contact-map-location-pin"];

    view.image = image;
    return view;
}

@end
