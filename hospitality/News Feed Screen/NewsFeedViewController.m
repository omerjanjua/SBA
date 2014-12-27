//
//  NewsFeedViewController.m
//  hospitality
//
//  Created by Omer Janjua on 02/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedData.h"
#import "NewsFeedSharingViewController.h"
#import "NewsArticleViewController.h"
#import <objc/runtime.h>
#import "UIViewController+MJPopupViewController.h"

static char kTitleButtonAssociatedKey;
static char kPushViewAssociatedKey;

@interface NewsFeedViewController (){
    PSCollectionView *scrollView;
    RTLabel *mainText;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *title;

@end

@implementation NewsFeedViewController

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

-(void)expandArticle:(id)btn
{
    NewsArticleViewController *controller = [[NewsArticleViewController alloc] init];
    
    NewsFeedData *newsData = objc_getAssociatedObject(btn,
                             &kPushViewAssociatedKey);

    controller.articleTitle = newsData.title;
    controller.description = newsData.description;
    controller.date = newsData.date;
    controller.imageUrl = newsData.imageUrl;    
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)shareArticle:(id)btn
{
    if ([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        NewsFeedSharingViewController *controller = [[NewsFeedSharingViewController alloc] initWithNibName:@"NewsFeedSharingViewController_35" bundle:nil];
        
        NewsFeedData *newsData = objc_getAssociatedObject(btn,
                                                          &kTitleButtonAssociatedKey);
        
        controller.newsTitle = newsData.title;
        [controller setPopupCaller:self];
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationSlideBottomTop];
    }
    else
    {
        NewsFeedSharingViewController *controller = [[NewsFeedSharingViewController alloc] initWithNibName:@"NewsFeedSharingViewController" bundle:nil];
        
        NewsFeedData *newsData = objc_getAssociatedObject(btn,
                                 &kTitleButtonAssociatedKey);
        
        controller.newsTitle = newsData.title;
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_News] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray *tempData = [[NSMutableArray alloc] init];
        for (int i = 0; i<[[responseObject objectForKey:@"matches"] count]; i++)
        {
            NewsFeedData *newsData = [[NewsFeedData alloc] init];
            newsData.title = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"headline"] objectForKey:@"data"];
            newsData.description = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"content"] objectForKey:@"data"];
            newsData.date = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"created_date"];
            newsData.imageUrl = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"ext_image"] objectForKey:@"image_url"];
            [tempData addObject:newsData];
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
// add banner image as subview 150
// add title banner as subview with 0.5alpha background if image 75px
// add title label as normal if no image
// add comments label as subview 44
// add expand button as subview
// add date label as subview 22
// add share button as subview
- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    NewsFeedData *newsData = [self.data objectAtIndex:index];

    if ([newsData.imageUrl isEqualToString:@""])
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 175)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleBanner = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 260.0, 75.0)];
        [titleBanner setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleBanner setNumberOfLines:2];
        [titleBanner setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [titleBanner setText:newsData.title];
        [view addSubview:titleBanner];
        
//if adding this +everthing by 10px at y coordinates
//        UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 65.0, 260.0, 44.0)];
//        [commentsLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//        [commentsLabel setNumberOfLines:2];
//        [commentsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
//        [commentsLabel setText:newsData.description];
//        [view addSubview:commentsLabel];
        

        RTLabel *commentsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20.0, 70.0, 260.0, 44.0)];
        [commentsLabel setLineBreakMode:RTTextLineBreakModeTruncatingTail];
        [commentsLabel setText:[newsData.description gtm_stringByUnescapingFromHTML]];
        [commentsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [view addSubview:commentsLabel];
        
        UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandButton setFrame:CGRectMake(0, 0, 220, 167)];
        [expandButton setImageEdgeInsets:UIEdgeInsetsMake(114, 20, 48, 180)];
        [expandButton setImage:[UIImage imageNamed:@"news-feed-expand-article-icon"] forState:UIControlStateNormal];
        [expandButton addTarget:self action:@selector(expandArticle:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:expandButton];
        
        objc_setAssociatedObject(expandButton,
                                 &kPushViewAssociatedKey,
                                 newsData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 215, 22)];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setAMSymbol:@"am"];
        [formatter setPMSymbol:@"pm"];
        
        NSDate *date = [formatter dateFromString:newsData.date];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [dateLabel setText:[NSString stringWithFormat:@"Posted %@", [formatter stringFromDate:date]]];
        [view addSubview:dateLabel];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(249, 110, 42, 43)];
        [shareButton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 1, 6)];
        [shareButton setImage:[UIImage imageNamed:@"news-feed-share-article-icon"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shareButton];
        
        objc_setAssociatedObject(shareButton,
                                 &kTitleButtonAssociatedKey,
                                 newsData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 321)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 304.0, 200.0)];
        bannerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newsData.imageUrl]]];
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
        [titleBanner setText:newsData.title];
        [titleBanner setBackgroundColor:[UIColor clearColor]];
        [view addSubview:titleBanner];

        //if adding this +everthing by 10px at y coordinates
//        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 215.0, 260.0, 44.0)];
//        [textView setValue:newsData.description forKeyPath:@"contentToHTMLString"];
//        [textView setScrollEnabled:NO];
//        textView.textContainer.maximumNumberOfLines = 2;
//        textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
//        [view addSubview:textView];
        

        RTLabel *commentsLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20.0, 220.0, 260.0, 44.0)];
        [commentsLabel setLineBreakMode:RTTextLineBreakModeTruncatingTail];
        [commentsLabel setText:[newsData.description gtm_stringByUnescapingFromHTML]];
        
        [commentsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [view addSubview:commentsLabel];
        
        UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandButton setFrame:CGRectMake(0.0, 0, 220.0, 313)];
        [expandButton setImageEdgeInsets:UIEdgeInsetsMake(264, 20, 44, 180)];
        [expandButton setImage:[UIImage imageNamed:@"news-feed-expand-article-icon"] forState:UIControlStateNormal];
        [expandButton addTarget:self action:@selector(expandArticle:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:expandButton];
        
        objc_setAssociatedObject(expandButton,
                                 &kPushViewAssociatedKey,
                                 newsData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 279.0, 215.0, 22.0)];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setAMSymbol:@"am"];
        [formatter setPMSymbol:@"pm"];
        
        NSDate *date = [formatter dateFromString:newsData.date];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [dateLabel setText:[NSString stringWithFormat:@"Posted %@", [formatter stringFromDate:date]]];
        [view addSubview:dateLabel];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(249.0, 259.0, 42.0,43.0)];
        [shareButton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 1, 6)];
        [shareButton setImage:[UIImage imageNamed:@"news-feed-share-article-icon"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:shareButton];
        
        objc_setAssociatedObject(shareButton,
                                 &kTitleButtonAssociatedKey,
                                 newsData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return view;
    }
}

-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    NewsFeedData *newsData = [self.data objectAtIndex:index];
    
    if ([newsData.imageUrl isEqualToString:@""])
    {
        return 165;
    }
    else
    {
        return 311;
    }
}

@end
