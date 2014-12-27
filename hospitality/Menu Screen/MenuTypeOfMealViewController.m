//
//  MenuTypeOfMealViewController.m
//  hospitality
//
//  Created by Omer Janjua on 06/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "MenuTypeOfMealViewController.h"
#import "MenuMealCategoryViewController.h"
#import "MenuItemViewController.h"
#import "Meal.h"

@interface MenuTypeOfMealViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MenuTypeOfMealViewController

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
    self.data = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Menu] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSArray *array = [responseObject valueForKeyPath:@"matches"];
        for (NSDictionary *dict in array)
        {
            [self.data addObject:[MTLJSONAdapter modelOfClass:Meal.class fromJSONDictionary:dict error:nil]] ;
        }
        
        [self.tableView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
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
    Meal *selectedMeal = [self.data objectAtIndex:indexPath.row];
    
    if ([selectedMeal.menus count] > 0)
    {
        MenuMealCategoryViewController *controller = [[MenuMealCategoryViewController alloc] init];
        [controller setData:selectedMeal.menus];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if ([selectedMeal.items count] > 0)
    {
        MenuItemViewController *controller = [[MenuItemViewController alloc] init];
        [controller setData:selectedMeal.items];
        [self.navigationController pushViewController:controller animated:YES];
        controller.bannerText = [[self.data objectAtIndex:indexPath.row] title];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
