//
//  NewsArticleViewController.m
//  hospitality
//
//  Created by Omer Janjua on 02/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "NewsArticleViewController.h"
#import "NewsFeedSharingViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface NewsArticleViewController (){
    PSCollectionView *scrollView;
    RTLabel *mainText;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation NewsArticleViewController

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
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:nil backButton:_backButton eventsButton:nil sideMenuButton:_sideMenuButton];

    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareArticle
{
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        NewsFeedSharingViewController *controller = [[NewsFeedSharingViewController alloc] initWithNibName:@"NewsFeedSharingViewController_35" bundle:nil];
        controller.newsTitle = self.articleTitle;
        [controller setPopupCaller:self];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationSlideBottomTop];
    }
    else
    {
        NewsFeedSharingViewController *controller = [[NewsFeedSharingViewController alloc] initWithNibName:@"NewsFeedSharingViewController" bundle:nil];
        controller.newsTitle = self.articleTitle;
        [controller setPopupCaller:self];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationSlideBottomTop];
    }
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
}

-(Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index
{
    return [PSCollectionViewCell class];
}

-(NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return 1;
}


// create 2 cells
// add banner image as subview 150
// add title banner as subview with 0.5alpha background if image 75px
// add title label as normal if no image
// add date label as subview 22
// add share button as subview
// add seperator line as subview
// add comments label as subview 44

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    if ([self.imageUrl isEqualToString:@""])
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 175)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleBanner = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 260.0, 75.0)];
        [titleBanner setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleBanner setNumberOfLines:2];
        [titleBanner setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [titleBanner setText:self.articleTitle];
        [view addSubview:titleBanner];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 215, 22)];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setAMSymbol:@"am"];
        [formatter setPMSymbol:@"pm"];
        
        NSDate *date = [formatter dateFromString:self.date];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [dateLabel setText:[NSString stringWithFormat:@"Posted %@", [formatter stringFromDate:date]]];
        [view addSubview:dateLabel];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(249, 46, 42, 41)];
        [shareButton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 1, 6)];
        [shareButton setImage:[UIImage imageNamed:@"news-feed-share-article-icon"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shareButton];
        
        UIImageView *seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 95.0, 305.0, 0.5)];
        seperatorLine.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:seperatorLine];
        
        RTLabel *commentsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20.0, 110.0, 260.0, 44.0)];
        [commentsLabel setText:[self.description gtm_stringByUnescapingFromHTML]];
        [commentsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize commentsLabelExpectedSize = [commentsLabel optimumSize];
        commentsLabel.frame = CGRectMake(20, 110, commentsLabelExpectedSize.width, commentsLabelExpectedSize.height);
        [view addSubview:commentsLabel];

        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 321)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 304.0, 200.0)];
        bannerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:bannerImageView];
        
        UIView *titleBannerBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 125.0, 304.0, 75.0)];
        titleBannerBackground.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.50];
        [view addSubview:titleBannerBackground];
        
        UILabel *titleBanner = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 125.0, 260.0, 75.0)];
        [titleBanner setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleBanner setNumberOfLines:2];
        [titleBanner setFont:[UIFont boldSystemFontOfSize:17]];
        [titleBanner setTextColor:[UIColor whiteColor]];
        [titleBanner setText:self.articleTitle];
        [titleBanner setBackgroundColor:[UIColor clearColor]];
        [view addSubview:titleBanner];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 215, 215.0, 22.0)];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setAMSymbol:@"am"];
        [formatter setPMSymbol:@"pm"];
        
        NSDate *date = [formatter dateFromString:self.date];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [dateLabel setText:[NSString stringWithFormat:@"Posted %@", [formatter stringFromDate:date]]];
        [view addSubview:dateLabel];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(249.0, 196, 42.0, 41.0)];
        [shareButton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 1, 6)];
        [shareButton setImage:[UIImage imageNamed:@"news-feed-share-article-icon"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareArticle) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shareButton];
        
        UIImageView *seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 250.0, 300.0, 0.5)];
        seperatorLine.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:seperatorLine];
        
        RTLabel *commentsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20.0, 269, 260.0, 44.0)];
        [commentsLabel setText:[self.description gtm_stringByUnescapingFromHTML]];
        [commentsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize commentsLabelExpectedSize = [commentsLabel optimumSize];
        commentsLabel.frame = CGRectMake(20, 269, commentsLabelExpectedSize.width, commentsLabelExpectedSize.height);
        [view addSubview:commentsLabel];
    
        return view;
    }
}

-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    if ([self.imageUrl isEqualToString:@""])
    {
        mainText = [[RTLabel alloc] init];
        [mainText setLineBreakMode:RTTextLineBreakModeWordWrapping];
        mainText.frame = CGRectMake(20, 110, 260, 44);
        [mainText setText:[self.description gtm_stringByUnescapingFromHTML]];
        [mainText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize commentsLabelExpectedSize = [mainText optimumSize];
        mainText.frame = CGRectMake(20, 110, commentsLabelExpectedSize.width, commentsLabelExpectedSize.height);
        return commentsLabelExpectedSize.height + 135;
    }
    else
    {
        mainText = [[RTLabel alloc] init];
        [mainText setLineBreakMode:RTTextLineBreakModeWordWrapping];
        mainText.frame = CGRectMake(20, 269, 260, 44);
        [mainText setText:[self.description gtm_stringByUnescapingFromHTML]];
        [mainText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        CGSize commentsLabelExpectedSize = [mainText optimumSize];
        mainText.frame = CGRectMake(20, 269, commentsLabelExpectedSize.width, commentsLabelExpectedSize.height);
        return commentsLabelExpectedSize.height + 291;
    }
}

@end
