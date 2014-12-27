//
//  PartnersSubMenuViewController.m
//  hospitality
//
//  Created by Omer Janjua on 27/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "PartnersSubMenuViewController.h"
#import "PartnersWebViewController.h"
#import "PartnerItem.h"

@interface PartnersSubMenuViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;

@end

@implementation PartnersSubMenuViewController

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

    _navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Setup
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PartnerItem *item = [_data objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                             
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        UIImageView *accessorryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 21)];
        accessorryView.image = [UIImage imageNamed:@"services-tableview-icon"];
        cell.accessoryView = accessorryView;
    }
    
    cell.textLabel.text = item.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PartnerItem *item= [_data objectAtIndex:indexPath.row];
    PartnersWebViewController *controller = [[PartnersWebViewController alloc] init];
    controller.domain = item.domain;
    [self.navigationController pushViewController:controller animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
