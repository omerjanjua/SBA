//
//  ProductsDetailedViewController.m
//  hospitality
//
//  Created by Omer Janjua on 09/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ProductsDetailedViewController.h"
#import "EnquiryFormViewController.h"
#import "UIImageView+WebCache.h"

@interface ProductsDetailedViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet iCarousel *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation ProductsDetailedViewController

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
    self.productName.text = self.name;
    self.productPrice.text = self.price;
    [self.productDescription setValue:[NSString stringWithFormat:@"<body style='font-family:Helvetica;font-size:13px;'>%@</body>", self.description] forKey:@"contentToHTMLString"];    
    self.imageView.type = iCarouselTypeLinear;
    [self initIndicatorScrollView:_imageScroll withData:self.data];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.imageView setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enquireButtonPressed:(id)sender
{
    EnquiryFormViewController *controller = [[EnquiryFormViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - iCarousel Setup
-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.data.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIImageView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(20, 84, 280, 136)];
        [view setImageWithURL:[NSURL URLWithString:[self.data objectAtIndex:index]]];
    }
    else
    {
        [view setImageWithURL:[NSURL URLWithString:[self.data objectAtIndex:index]]];
    }
    return view;
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [self setSelectedIndicator:_imageScroll withSelectedIndex:carousel.currentItemIndex];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

-(void)initIndicatorScrollView:(UIScrollView *)scrollView withData:(NSMutableArray *)data{
    //Suppose that each dot indicator has size of 16 x 16 and there is 5px space between them
    
    CGSize indicatorSize = CGSizeMake(9,9);
    float padding = 5;
    float leftMargin = (scrollView.frame.size.width - indicatorSize.width*[data count] - padding*([data count] - 1)) / 2.0;
    
    for (int i = 0; i < [data count]; i++) {
        UIButton *indicator = [UIButton buttonWithType:UIButtonTypeCustom];
        [indicator setFrame:CGRectMake(leftMargin, 5, indicatorSize.width, indicatorSize.height)];
        [indicator setImage:[UIImage imageNamed:@"image-scroll-unselected"] forState:UIControlStateNormal];
        [indicator setImage:[UIImage imageNamed:@"image-scroll-selected"] forState:UIControlStateSelected];
        [indicator setTag:100+i];
        [scrollView addSubview:indicator];
        
        leftMargin += indicatorSize.width + padding;
    }
    
    [self setSelectedIndicator:_imageScroll withSelectedIndex:0];
}

-(void)setSelectedIndicator:(UIScrollView *)scrollView withSelectedIndex:(int)selectedIndex{
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setSelected:NO];
        }
    }
    [(UIButton *)[scrollView viewWithTag:100 + selectedIndex] setSelected:YES];
}

@end
