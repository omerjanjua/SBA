//
//  ProductsItemViewController.m
//  hospitality
//
//  Created by Omer Janjua on 02/06/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ProductsItemViewController.h"
#import "ProductsDetailedViewController.h"
#import "ProductsDetailedNoImageViewController.h"
#import "ProductItem.h"

@interface ProductsItemViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation ProductsItemViewController

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
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Setup
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        UIImageView *accessorryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
        accessorryView.image = [UIImage imageNamed:@"services-tableview-icon"];
        cell.accessoryView = accessorryView;
    }
    
    cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] title];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItem *productData = self.data[indexPath.row];
    
    if ([productData.imageUrl isEqualToString:@""] && [productData.imageUrl2 isEqualToString:@""] && [productData.imageUrl3 isEqualToString:@""] && [productData.imageUrl4 isEqualToString:@""])
    {
        ProductsDetailedNoImageViewController *controller = [[ProductsDetailedNoImageViewController alloc] init];
        controller.name = productData.title;
        controller.description = productData.description;
        controller.price = productData.price;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if (![productData.imageUrl isEqualToString:@""]) {
            [tempArray addObject:productData.imageUrl];
        }
        if (![productData.imageUrl2 isEqualToString:@""]) {
            [tempArray addObject:productData.imageUrl2];
        }
        if (![productData.imageUrl3 isEqualToString:@""]) {
            [tempArray addObject:productData.imageUrl3];
        }
        if (![productData.imageUrl4 isEqualToString:@""]) {
            [tempArray addObject:productData.imageUrl4];
        }
                
        if([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            ProductsDetailedViewController *controller = [[ProductsDetailedViewController alloc] initWithNibName:@"ProductsDetailedViewController_35" bundle:nil];
            controller.name = productData.title;
            controller.description = productData.description;
            controller.price = productData.price;
            controller.imageUrl = productData.imageUrl;
            controller.imageUrl2 = productData.imageUrl2;
            controller.imageUrl3 = productData.imageUrl3;
            controller.imageUrl4 = productData.imageUrl4;
            controller.data = tempArray;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            ProductsDetailedViewController *controller = [[ProductsDetailedViewController alloc] initWithNibName:@"ProductsDetailedViewController" bundle:nil];
            controller.name = productData.title;
            controller.description = productData.description;
            controller.price = productData.price;
            controller.imageUrl = productData.imageUrl;
            controller.imageUrl2 = productData.imageUrl2;
            controller.imageUrl3 = productData.imageUrl3;
            controller.imageUrl4 = productData.imageUrl4;
            controller.data = tempArray;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
