//
//  DocumentsViewController.m
//  hospitality
//
//  Created by Omer Janjua on 30/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentsData.h"
#import "PDFWebViewController.h"

@interface DocumentsViewController (){
    PSCollectionView *scrollView;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation DocumentsViewController

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
    [self scrollViewSetup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup
-(void)viewSetup
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:_homeButton backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];
    
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

#pragma mark - Scroll View Setup
-(void)scrollViewSetup
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        scrollView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0.0, 44, 320, 504)];
    } else {
        // Load resources for iOS 7 or later
        scrollView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0.0, 64, 320, 504)];
    }
    
    scrollView.collectionViewDelegate = self;
    scrollView.collectionViewDataSource = self;
    scrollView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1];
    scrollView.autoresizingMask = ~UIViewAutoresizingNone;
    scrollView.numColsPortrait = 2;
    [self.view addSubview:scrollView];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Documents] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray *tempData = [[NSMutableArray alloc] init];
        for (int i = 0; i<[[responseObject objectForKey:@"matches"] count]; i++)
        {
            DocumentsData *documentsData = [[DocumentsData alloc] init];
            documentsData.url = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"ext_pdf"];
            documentsData.name = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"title"] objectForKey:@"data"];
            [tempData addObject:documentsData];
        }
        self.data = [[NSMutableArray alloc] initWithArray:tempData];
        [scrollView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        NSLog(@"FAILED: %@", [error localizedDescription]);
    }];
}

-(Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index
{
    return [PSCollectionViewCell class];
}

-(NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return [self.data count];
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    DocumentsData *documentsData = [self.data objectAtIndex:index];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 190.0)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(53.0, 22.0, 45.0, 57.0)];
    [imageView setImage:[UIImage imageNamed:@"documents-pdf-icon"]];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 87.0, 87.0, 83.0)];
    [label setText:documentsData.name];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    [view addSubview:label];
    
    return view;
}

-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    return 190.0;
}

-(void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    DocumentsData *documentsData = [self.data objectAtIndex:index];
    PDFWebViewController *controller = [[PDFWebViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    [controller.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:documentsData.url]]];
}

@end
