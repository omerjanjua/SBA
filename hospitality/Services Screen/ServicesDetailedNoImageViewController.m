//
//  ServicesDetailedNoImageViewController.m
//  hospitality
//
//  Created by Omer Janjua on 09/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ServicesDetailedNoImageViewController.h"
#import "EnquiryFormViewController.h"

@interface ServicesDetailedNoImageViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *serviceName;
@property (strong, nonatomic) IBOutlet UITextView *serviceDescription;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation ServicesDetailedNoImageViewController

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
    [self viewSetup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup View
-(void)viewSetup
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:nil backButton:_backButton eventsButton:nil sideMenuButton:_sideMenuButton];

    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
    self.serviceName.text = self.name;
    [self.serviceDescription setValue:[NSString stringWithFormat:@"<body style='font-family:Helvetica;font-size:13px;'>%@</body>", self.description] forKey:@"contentToHTMLString"];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enquireButtonPressed:(id)sender
{
    EnquiryFormViewController *controller = [[EnquiryFormViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
