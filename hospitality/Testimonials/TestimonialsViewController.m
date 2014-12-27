//
//  TestimonialsViewController.m
//  hospitality
//
//  Created by Omer Janjua on 31/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "TestimonialsViewController.h"
#import "TestimonialsData.h"

@interface TestimonialsViewController (){
    PSCollectionView *scrollView;
    RTLabel *mainText;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation TestimonialsViewController

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
    scrollView.numColsPortrait = 1;
    [self.view addSubview:scrollView];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Testimonials] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray *tempData = [[NSMutableArray alloc] init];
        for (int i = 0; i<[[responseObject objectForKey:@"matches"] count]; i++)
        {
            TestimonialsData *testimonialsData = [[TestimonialsData alloc] init];
            testimonialsData.authorName = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"name"] objectForKey:@"data"];
            testimonialsData.comments = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"message"] objectForKey:@"data"];
            testimonialsData.imageUrl = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"ext_image"] objectForKey:@"image_url"];
            [tempData addObject:testimonialsData];
        }
        self.data = [[NSMutableArray alloc] initWithArray:tempData];
        [scrollView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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


// create 2 cells
// one with image one without image
// add banner image as subview
// add comma image as subview
// add comments label as subview
// add author label as subview

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    TestimonialsData *testimonialsData = [self.data objectAtIndex:index];

    // if no image execute this block showing no banner
    if ([testimonialsData.imageUrl isEqualToString:@""])
    {
        //cell view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 145.0)];
        view.backgroundColor = [UIColor whiteColor];
        
        //comma image subview
        UIImageView * commaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(124.0, 20.0, 53.0, 53.0)];
        [commaImageView setImage:[UIImage imageNamed:@"testimonial-icon"]];
        [view addSubview:commaImageView];

        //comments textview dynamic subview
        RTLabel *commentTextView = [[RTLabel alloc] initWithFrame:CGRectMake(20, 84, 260, 21)];
        [commentTextView setLineBreakMode:RTTextLineBreakModeWordWrapping];
        commentTextView.text = [testimonialsData.comments gtm_stringByUnescapingFromHTML];
        [commentTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize mainTextExpectedSize = [commentTextView optimumSize];
        commentTextView.frame = CGRectMake(20, 84, mainTextExpectedSize.width, mainTextExpectedSize.height);
        [view addSubview:commentTextView];
        
        //author label subview
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (mainTextExpectedSize.height + 104), 260, 21)];
        [authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [authorLabel setMinimumScaleFactor:15.0];
        [authorLabel setNumberOfLines:0];
        [authorLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        authorLabel.textAlignment = NSTextAlignmentCenter;
        [authorLabel setText:testimonialsData.authorName];
        [view addSubview:authorLabel];
        return view;
    }
    else
    {
        //cell view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 248.0)];
        view.backgroundColor = [UIColor whiteColor];
        
        //cell 1 banner
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 150.0)];
        bannerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:testimonialsData.imageUrl]]];
        bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:bannerImageView];
        
        //comma image subview
        UIImageView * commaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(124.0, 123.0, 53.0, 53.0)];
        [commaImageView setImage:[UIImage imageNamed:@"testimonial-icon"]];
        [view addSubview:commaImageView];
        
        //comments textview dynamic subview
        RTLabel *commentTextView = [[RTLabel alloc] initWithFrame:CGRectMake(20, 184, 260, 21)];
        [commentTextView setLineBreakMode:RTTextLineBreakModeWordWrapping];
        commentTextView.text = [testimonialsData.comments gtm_stringByUnescapingFromHTML];
        [commentTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize mainTextExpectedSize = [commentTextView optimumSize];
        commentTextView.frame = CGRectMake(20, 184, mainTextExpectedSize.width, mainTextExpectedSize.height);
        [view addSubview:commentTextView];
        
        //author label subview
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,  (mainTextExpectedSize.height + 207), 260, 21)];
        [authorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [authorLabel setMinimumScaleFactor:15.0];
        [authorLabel setNumberOfLines:0];
        [authorLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        authorLabel.textAlignment = NSTextAlignmentCenter;
        [authorLabel setText:testimonialsData.authorName];
        [view addSubview:authorLabel];
        return view;
    }
}

-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    TestimonialsData *testimonialsData = [self.data objectAtIndex:index];
    
    if ([testimonialsData.imageUrl isEqualToString:@""])
    {
        mainText = [[RTLabel alloc] init];
        [mainText setLineBreakMode:RTTextLineBreakModeWordWrapping];
        mainText.frame = CGRectMake(20, 84, 260, 21);
        mainText.text = [testimonialsData.comments gtm_stringByUnescapingFromHTML];
        [mainText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize mainTextExpectedSize = [mainText optimumSize];
        mainText.frame = CGRectMake(20, 84, mainTextExpectedSize.width, mainTextExpectedSize.height);
        return 145 + mainTextExpectedSize.height;
    }
    else
    {
        mainText = [[RTLabel alloc] init];
        [mainText setLineBreakMode:RTTextLineBreakModeWordWrapping];
        mainText.frame = CGRectMake(20, 184, 260, 21);
        mainText.text = [testimonialsData.comments gtm_stringByUnescapingFromHTML];
        [mainText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize mainTextExpectedSize = [mainText optimumSize];
        mainText.frame = CGRectMake(20, 184, mainTextExpectedSize.width, mainTextExpectedSize.height);
        return 248 + mainTextExpectedSize.height;
    }
}

@end
