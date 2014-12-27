//
//  LoyaltyStampSuccessViewController.m
//  hospitality
//
//  Created by Dev on 04/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "LoyaltyStampSuccessViewController.h"

@interface LoyaltyStampSuccessViewController ()

@end

@implementation LoyaltyStampSuccessViewController

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
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Close button IBAction
- (IBAction)closeButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:Nil];
}

@end
