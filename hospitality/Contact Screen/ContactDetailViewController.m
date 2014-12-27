//
//  ContactDetailViewController.m
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactFormViewController.h"
#import "ContactMapViewController.h"
#import "ContactData.h"

@interface ContactDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *enquiryFormButton;
@property (strong, nonatomic) IBOutlet UIButton *contactDetailsButton;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ContactDetailViewController

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self viewSetup];
    [self getContacts];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewSetup
{
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Light"])
    {
        _navigationTitle.textColor = [UIColor whiteColor];
        [_homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button"] forState:UIControlStateNormal];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button"] forState:UIControlStateNormal];
        [_enquiryFormButton setImage:[UIImage imageNamed:@"enquiry-form-button"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected"] forState:UIControlStateHighlighted];
    }
    if ([[UserDefault objectForKey:Status_Bar_Color] isEqualToString:@"Dark"])
    {
        _navigationTitle.textColor = [UIColor blackColor];
        [_homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button-black"] forState:UIControlStateNormal];
        [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-black"] forState:UIControlStateNormal];
        [_enquiryFormButton setImage:[UIImage imageNamed:@"enquiry-form-button-black"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected-black"] forState:UIControlStateNormal];
        [_contactDetailsButton setImage:[UIImage imageNamed:@"contact-details-button-selected-black"] forState:UIControlStateHighlighted];
    }
    [_homeButton setImage:[UIImage imageNamed:@"navigation-menu-dashboard-button-gray"] forState:UIControlStateHighlighted];
    [_sideMenuButton setImage:[UIImage imageNamed:@"navigation-menu-button-gray"] forState:UIControlStateHighlighted];
    [_enquiryFormButton setImage:[UIImage imageNamed:@"enquiry-form-button-gray"] forState:UIControlStateHighlighted];
   
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

- (IBAction)contactFormButtonPressed:(id)sender
{
    ContactFormViewController *controller = [[ContactFormViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)mapViewButtonPressed:(id)sender
{
    ContactMapViewController *controller = [[ContactMapViewController alloc] init];
    controller.data = self.data;
    [controller setCurrentSelectedIndex:-1];
    
    [self.navigationController pushViewController:controller animated:NO];
}

-(void)getContacts
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Contacts] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray *tempData = [[NSMutableArray alloc] init];
        for (int i = 0; i<[[responseObject objectForKey:@"matches"] count]; i++)
        {
            ContactData *contactData = [[ContactData alloc] init];
            contactData.pinId = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"id"];
            contactData.name = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"name"];
            contactData.fullAddress = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"full_address"];
            contactData.latitude = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"latitude"];
            contactData.longitude =  [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"longitude"];
            contactData.email =  [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"email"];
            contactData.telephone = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"telephone"];
            contactData.website = [[[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"ext_website"] objectForKey:@"data"];
            [tempData addObject:contactData];
        }
        self.data = [[NSMutableArray alloc] initWithArray:tempData];
        [_mapController setData:self.data];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        UIImageView *accessorryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
        accessorryView.image = [UIImage imageNamed:@"services-tableview-icon"];
        cell.accessoryView = accessorryView;
    }
    
    ContactData *contactData = self.data[indexPath.row];
    cell.textLabel.text = contactData.name;
    cell.detailTextLabel.text = contactData.fullAddress;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ContactMapViewController *controller = [[ContactMapViewController alloc] init];
//    [controller setData:self.data];
//    [controller setCurrentSelectedIndex:-1]; //indexPath.row
//    
//    [self.navigationController pushViewController:controller animated:NO];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.tabBarController) {
        [self.tabBarController setSelectedIndex:1];
        ContactData *contactData = self.data[indexPath.row];
        [_mapController showMapAnnotationWithPinId:contactData.pinId];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
