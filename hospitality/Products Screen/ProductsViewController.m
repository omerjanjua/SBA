//
//  ProductsViewController.m
//  hospitality
//
//  Created by Omer Janjua on 09/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductsCategoryViewController.h"
#import "ProductsItemViewController.h"
#import "ProductCategory.h"


@interface ProductsViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ProductsViewController

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
    [self getProducts];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Setup
-(void)setupView
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:_homeButton backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];

    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

#pragma mark - Table View Setup
-(void)getProducts
{
    self.data = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Products] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSArray *array = [responseObject valueForKeyPath:@"matches"];
        for (NSDictionary *dict in array)
        {
            [self.data addObject:[MTLJSONAdapter modelOfClass:ProductCategory.class fromJSONDictionary:dict error:nil]];
        }
        
        [self.tableView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

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
    ProductCategory *selectedProduct = self.data[indexPath.row];
    
    if ([selectedProduct.categories count] > 0)
    {
        ProductsCategoryViewController *controller = [[ProductsCategoryViewController alloc] init];
        [controller setData:selectedProduct.categories];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if ([selectedProduct.products count] > 0)
    {
        ProductsItemViewController *controller = [[ProductsItemViewController alloc] init];
        [controller setData:selectedProduct.products];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
