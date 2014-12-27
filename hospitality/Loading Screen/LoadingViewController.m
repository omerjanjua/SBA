//
//  LoadingViewController.m
//  hospitality
//
//  Created by Omer Janjua on 17/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "LoadingViewController.h"
#import "LoadDefaultData.h"

@interface LoadingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityInidicatorView;

@end

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"]) {
        [_loadingActivityInidicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"]) {
        [_loadingActivityInidicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [self performSelector:@selector(buttonTapped) withObject:nil afterDelay:5];
}

-(void)buttonTapped
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
