//
//  MenuItemViewController.m
//  hospitality
//
//  Created by Omer Janjua on 09/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "MenuItemViewController.h"
#import "Item.h"
#import "UIImageView+WebCache.h"
#import "MenuPopUpViewController.h"
#import "MenuNoImagePopUpViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface MenuItemViewController (){
    PSCollectionView *scrollView;
    NSMutableArray *unfinishedLodingImages;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UILabel *bannerLabel;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation MenuItemViewController

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
    [self scrollViewSetup];
    // Do any additional setup after loading the view from its nib.
    
    unfinishedLodingImages = [[NSMutableArray alloc] initWithArray:[self.data valueForKey:@"imageUrl"]];
    for(int i = [unfinishedLodingImages count] -1 ; i > -1; i--){
        if ([unfinishedLodingImages[i] isKindOfClass:[NSNull class]] || [@"" isEqualToString:unfinishedLodingImages[i]]) {
            [unfinishedLodingImages removeObjectAtIndex:i];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup View
-(void)setupView
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:nil backButton:_backButton eventsButton:nil sideMenuButton:_sideMenuButton];

    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
    self.bannerLabel.text = self.bannerText;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewSetup
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        scrollView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0.0, 102, 320, 446)];
    } else {
        // Load resources for iOS 7 or later
        scrollView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0.0, 122, 320, 446)];
    }
    scrollView.collectionViewDelegate = self;
    scrollView.collectionViewDataSource = self;
    scrollView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1];
    scrollView.autoresizingMask = ~UIViewAutoresizingNone;
    scrollView.numColsPortrait = 2;
    [self.view addSubview:scrollView];
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
    Item *item = [self.data objectAtIndex:index];

    if ([item.imageUrl isEqualToString:@""])
    {
        UIView *view_bkg  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150, 77)];
        view_bkg.backgroundColor = [UIColor whiteColor];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 135, 54)];
        [descriptionLabel setText:item.title];
        [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [view_bkg addSubview:descriptionLabel];
        
//        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 135, 54)];
//        [textView setValue:item.title forKeyPath:@"contentToHTMLString"];
//        [textView setScrollEnabled:NO];
//        [textView setEditable:NO];
//        [textView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//        textView.textContainer.maximumNumberOfLines = 2;
//        textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
//        [view_bkg addSubview:textView];
        
//        RTLabel *descriptionLabel = [[RTLabel alloc] initWithFrame:CGRectMake(5, 5, 135, 54)];
//        [descriptionLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
//        [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
//        
//        NSString *str = [item.title gtm_stringByUnescapingFromHTML];
//        
//        float chacterWidth = ceilf([@"A" sizeWithFont:descriptionLabel.font].width);
//        
//        int capbleLength = [self lengthOfString:str thatFitsIntoView:descriptionLabel withFont:descriptionLabel.font];
//        
//        if (descriptionLabel.frame.size.width / chacterWidth > capbleLength) {
//            [descriptionLabel setText:str];
//        }
//        else{
//            [descriptionLabel setText:[NSString stringWithFormat:@"%@...", [str substringToIndex:capbleLength -5]]];
//        }
//        
//        [view_bkg addSubview:descriptionLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 110, 24)];
        [priceLabel setFont:[UIFont systemFontOfSize:15]];
        [priceLabel setText:item.price];
        [view_bkg addSubview:priceLabel];
        return view_bkg;
    }
    else
    {
        UIView *view_bkg  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150, 205)];
        view_bkg.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 145, 129)];
        [imgView setImageWithURL:[NSURL URLWithString:item.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [unfinishedLodingImages removeObject:item.imageUrl];
            if ([unfinishedLodingImages count] == 0) {
                //TODO handle dimiss indicator here
                NSLog(@"---> finish loading all images");
            }
        }];
        [[view_bkg layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[view_bkg layer] setBorderWidth:3.0];
        [view_bkg addSubview:imgView];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 135, 54)];
        [descriptionLabel setText:item.title];
        [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [view_bkg addSubview:descriptionLabel];
        
//        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 130, 135, 54)];
//        [textView setValue:item.title forKeyPath:@"contentToHTMLString"];
//        [textView setScrollEnabled:NO];
//        [textView setEditable:NO];
//        [textView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//        textView.textContainer.maximumNumberOfLines = 2;
//        textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
//        [view_bkg addSubview:textView];
        
//        RTLabel *descriptionLabel = [[RTLabel alloc] initWithFrame:CGRectMake(5, 130, 135, 54)];
//        [descriptionLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
//        [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
//        
//        NSString *str = [item.title gtm_stringByUnescapingFromHTML];
//        
//        float chacterWidth = ceilf([@"A" sizeWithFont:descriptionLabel.font].width);
//        
//        int capbleLength = [self lengthOfString:str thatFitsIntoView:descriptionLabel withFont:descriptionLabel.font];
//        
//        if (descriptionLabel.frame.size.width / chacterWidth > capbleLength) {
//            [descriptionLabel setText:str];
//        }
//        else{
//            [descriptionLabel setText:[NSString stringWithFormat:@"%@...", [str substringToIndex:capbleLength -5]]];
//        }
//        
//        [view_bkg addSubview:descriptionLabel];

        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 110, 24)];
        [priceLabel setFont:[UIFont systemFontOfSize:15]];
        [priceLabel setText:item.price];
        [view_bkg addSubview:priceLabel];
        return view_bkg;
    }
}

- (NSInteger)lengthOfString:(NSString *)str
           thatFitsIntoView:(UIView *)displayView
                   withFont:(UIFont *)font
{
    CGSize textSize = [str sizeWithFont:font
                               forWidth:displayView.frame.size.width
                          lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger lengthThatFits;
    if (textSize.height > displayView.frame.size.height) {
        lengthThatFits = str.length * displayView.frame.size.height / textSize.height;
    } else {
        lengthThatFits = str.length;
    }
    
    return lengthThatFits;
}

-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    Item *item = [self.data objectAtIndex:index];
    
    if ([item.imageUrl isEqualToString:@""])
    {
        return 77;
    }
    else
    {
        return  205;
    }
}

-(void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
//TODO: make menu pop ups dynamic height and fix close button
    Item *item = [self.data objectAtIndex:index];
    
    if ([item.imageUrl isEqualToString:@""])
    {
        MenuNoImagePopUpViewController *controller = [[MenuNoImagePopUpViewController alloc] init];
        [controller setPopupCaller:self];
        controller.titleData = item.title;
        controller.description = item.description;
        controller.price = item.price;
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    }
    else
    {
        MenuPopUpViewController *controller = [[MenuPopUpViewController alloc] init];
        [controller setPopupCaller:self];
        controller.image = item.imageUrl;
        controller.titleData = item.title;
        controller.description = item.description;
        controller.price = item.price;
        [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    }

}

@end
