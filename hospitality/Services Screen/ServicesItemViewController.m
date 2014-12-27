//
//  ServicesItemViewController.m
//  hospitality
//
//  Created by Omer Janjua on 02/06/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ServicesItemViewController.h"
#import "ServicesDetailedViewController.h"
#import "ServicesDetailedNoImageViewController.h"
#import "ServicesItem.h"

@interface ServicesItemViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation ServicesItemViewController

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
    ServicesItem *serviceData = self.data[indexPath.row];
    
    if ([serviceData.imageUrl isEqualToString:@""] && [serviceData.imageUrl2 isEqualToString:@""] && [serviceData.imageUrl3 isEqualToString:@""] && [serviceData.imageUrl4 isEqualToString:@""])
    {
        ServicesDetailedNoImageViewController *controller = [[ServicesDetailedNoImageViewController alloc] init];
        controller.name = serviceData.title;
        controller.description = serviceData.description;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if (![serviceData.imageUrl isEqualToString:@""]) {
            [tempArray addObject:serviceData.imageUrl];
        }
        if (![serviceData.imageUrl2 isEqualToString:@""]) {
            [tempArray addObject:serviceData.imageUrl2];
        }
        if (![serviceData.imageUrl3 isEqualToString:@""]) {
            [tempArray addObject:serviceData.imageUrl3];
        }
        if (![serviceData.imageUrl4 isEqualToString:@""]) {
            [tempArray addObject:serviceData.imageUrl4];
        }
        
        if([[UIScreen mainScreen] bounds].size.height <= 480.0) {
            ServicesDetailedViewController *controller = [[ServicesDetailedViewController alloc] initWithNibName:@"ServicesDetailedViewController_35" bundle:nil];
            controller.name = serviceData.title;
            controller.description = serviceData.description;
            controller.imageUrl = serviceData.imageUrl;
            controller.imageUrl2 = serviceData.imageUrl2;
            controller.imageUrl3 = serviceData.imageUrl3;
            controller.imageUrl4 = serviceData.imageUrl4;
            controller.data = tempArray;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            ServicesDetailedViewController *controller = [[ServicesDetailedViewController alloc] initWithNibName:@"ServicesDetailedViewController" bundle:nil];
            controller.name = serviceData.title;
            controller.description = serviceData.description;
            controller.imageUrl = serviceData.imageUrl;
            controller.imageUrl2 = serviceData.imageUrl2;
            controller.imageUrl3 = serviceData.imageUrl3;
            controller.imageUrl4 = serviceData.imageUrl4;
            controller.data = tempArray;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
