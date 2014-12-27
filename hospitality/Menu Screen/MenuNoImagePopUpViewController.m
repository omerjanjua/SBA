//
//  MenuNoImagePopUpViewController.m
//  hospitality
//
//  Created by Omer Janjua on 06/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "MenuNoImagePopUpViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface MenuNoImagePopUpViewController ()

@end

@implementation MenuNoImagePopUpViewController

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
    [self setupView];
    self.view.layer.cornerRadius = 7;
    self.view.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GUI Interactions
- (IBAction)closeButton:(id)sender
{
    [_popupCaller dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)setupView
{
    [self.itemTitle setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [self.itemDescription setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [self.itemTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [self.itemDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    
    [self.itemPrice setText:self.price];
    [self.itemPrice setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    
    [self.itemTitle setText:[self.titleData gtm_stringByUnescapingFromHTML]];
    [self.itemDescription setText:[self.description gtm_stringByUnescapingFromHTML]];
    
    self.itemTitle.frame = CGRectMake(20, 0, 231, [self.itemTitle optimumSize].height);
    
    float baseY = self.itemTitle.frame.origin.y;
    float baseH = self.itemTitle.frame.size.height;
    
    self.titleSeperator.frame = CGRectMake(20, baseY + baseH + 8, 231, 1);
    
    self.itemDescription.frame = CGRectMake(20, baseY + baseH + 17, 231, [self.itemDescription optimumSize].height);
    
    baseY = self.itemDescription.frame.origin.y;
    baseH = self.itemDescription.frame.size.height;
    
    self.descriptionSeperator.frame = CGRectMake(20, baseY + baseH + 8, 231, 1);
    self.priceLabel.frame = CGRectMake(20, baseY + baseH + 21, 68, 21);
    self.itemPrice.frame = CGRectMake(77, baseY + baseH + 21, 174, 31);
    self.priceSeperator.frame = CGRectMake(20, baseY + baseH + 56, 231, 1);
    self.closeButton.frame = CGRectMake(20, baseY + baseH + 56, 238, 49);
    
    CGRect mainViewFrame = self.view.frame;
    mainViewFrame.size.height = self.closeButton.frame.origin.y + self.closeButton.frame.size.height;
    self.view.frame = mainViewFrame;
}

@end
