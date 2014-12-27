//
//  BarCodeReaderViewController.m
//  hospitality
//
//  Created by ems-osx-server on 09/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "BarCodeReaderViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BarCodeReaderViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *flashSwitch;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation BarCodeReaderViewController

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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.readerView start];
    [self.flashSwitch addTarget:self action:@selector(setupFlash) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.readerView stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}
#pragma mark - ZBar View Handlers
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:symbol.data]];
        break;
    }
}

-(void)setupView
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:_homeButton backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];

    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
    [ZBarReaderView class];
    self.readerView.readerDelegate = self;
    [self.readerView.scanner setSymbology:ZBAR_UPCA config:ZBAR_CFG_ENABLE to:0];
    self.readerView.zoom = 1.0;

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch] && ![device hasFlash]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"This device does not support flash functionality" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(149, 15, 22.5, 22.5)];
        [image setImage:[UIImage imageNamed:@"contact-map-close-icon"]];
        [self.bottomView addSubview:image];
        [self.flashSwitch setHidden:YES];
    }
}

-(void)setupFlash
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (self.flashSwitch.on) {
                self.bottomView.backgroundColor = App_Theme_Colour;
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                self.bottomView.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

@end
