//
//  GalleryViewController.m
//  hospitality
//
//  Created by Omer Janjua on 21/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryData.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HCYoutubeParser.h"

@interface GalleryViewController (){
    PSCollectionView *scrollView;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation GalleryViewController

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
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Gallery] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {       
        NSMutableArray *tempData = [[NSMutableArray alloc] init];
        for (int i =0; i<[[responseObject objectForKey:@"matches"]count] ; i++)
        {
            GalleryData *galleryData = [[GalleryData alloc]init];
            galleryData.url = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"url"];
            galleryData.type = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"type"];
            galleryData.imageSize = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"image_size"];
            galleryData.videoThumbnailUrl = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"thumbnail_url"];
            [tempData addObject:galleryData];
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
    GalleryData *galleryData = [self.data objectAtIndex:index];
    float newHeight ;
    
    if (!galleryData.imageSize) {
        newHeight = 150.0;
    }
    else{
        NSString *imageSize = galleryData.imageSize;
        
        float width = [[[imageSize componentsSeparatedByString:@"x"] objectAtIndex:0] floatValue];
        float height = [[[imageSize componentsSeparatedByString:@"x"] objectAtIndex:1] floatValue];
        
        newHeight = (150.0 /width) * height;
    }
    
    UIView *view_bkg  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, newHeight )];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0-5, newHeight-3 )];
    
    [imgView setImageWithURL:[NSURL URLWithString:galleryData.url]];
    if ([galleryData.type isEqualToString:@"video"])
    {
//Either get thumbnail from youtube parser or CMS
//        [imgView setImageWithURL:[HCYoutubeParser thumbnailUrlForYoutubeURL:[NSURL URLWithString:galleryData.url] thumbnailSize:YouTubeThumbnailDefault]];
        [imgView setImageWithURL:[NSURL URLWithString:galleryData.videoThumbnailUrl]];
        UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 117, 39.0, 21.0)];
        [playImage setImage:[UIImage imageNamed:@"gallery-play-image"]];
        [imgView addSubview:playImage];
    }
    
    [[view_bkg layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[view_bkg layer] setBorderWidth:3.0];
    [view_bkg addSubview:imgView];
    
    return view_bkg;
}

-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    GalleryData *galleryData = [self.data objectAtIndex:index];
    if (!galleryData.imageSize) {
        return 150;
    }
    NSString *imageSize = galleryData.imageSize;
    
    float width = [[[imageSize componentsSeparatedByString:@"x"] objectAtIndex:0] floatValue];
    float height = [[[imageSize componentsSeparatedByString:@"x"] objectAtIndex:1] floatValue];
    
    return  floorf((150.0 / width) * height);
}

-(void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    GalleryData *galleryData = [self.data objectAtIndex:index];
    if ([galleryData.type isEqualToString:@"video"])
    {
        NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:galleryData.url]];
        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:@"medium"]]];
        [self presentViewController:mp animated:NO completion:nil];
    }
    else
    {
        [MWPhoto photoWithURL:[NSURL URLWithString:galleryData.url]];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.alwaysShowControls = NO;
        browser.enableGrid = YES;
        browser.startOnGrid = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;
#endif
        [browser setCurrentPhotoIndex:index];
        [self.navigationController pushViewController:browser animated:YES];
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.data.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    GalleryData *galleryData = [self.data objectAtIndex:index];
    
    if ([galleryData.type isEqualToString:@"image"]){
        return [MWPhoto photoWithURL:[NSURL URLWithString:galleryData.url]];
    }
    else
    {
        return [MWPhoto photoWithURL:[NSURL URLWithString:galleryData.videoThumbnailUrl]];
    }
    
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    GalleryData *galleryData = [self.data objectAtIndex:index];
    
    if ([galleryData.type isEqualToString:@"image"]){
        return [MWPhoto photoWithURL:[NSURL URLWithString:galleryData.url]];
    }
    else
    {
        return [MWPhoto photoWithURL:[NSURL URLWithString:galleryData.videoThumbnailUrl]];
    }
    return nil;
}

@end
