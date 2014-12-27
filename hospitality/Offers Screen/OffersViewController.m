//
//  OffersViewController.m
//  hospitality
//
//  Created by Omer Janjua on 21/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "OffersViewController.h"
#import "offersTableViewCell.h"
#import "OffersData.h"

@interface OffersViewController (){
    
    RTLabel *mainText;
    RTLabel *detailText;
}

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSMutableArray *matches;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation OffersViewController

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
    [self getOffers];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
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
#pragma mark - Table View Setup
-(void)getOffers
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Offers] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        self.matches = [responseObject objectForKey:@"matches"];
        
        NSMutableArray *tempData = [[NSMutableArray alloc] init];
        
        for (int  i = 0; i<[self.matches count]; i++)
        {
            OffersData *offersData = [[OffersData alloc] init];
            offersData.title = [[[self.matches objectAtIndex:i] objectForKey:@"title"] objectForKey:@"data"];
            offersData.description = [[[self.matches objectAtIndex:i] objectForKey:@"description"] objectForKey:@"data"];
            
            [tempData addObject:offersData];
        }
        self.data = [[NSMutableArray alloc] initWithArray:tempData];
        [self.tableView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        NSLog(@"FAILED: %@", [error localizedDescription]);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OffersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    [cell setController:self];
    OffersData *data = self.data[indexPath.row];

    [cell.mainLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [cell.detailedTextLabel setLineBreakMode:RTTextLineBreakModeWordWrapping];
    
    cell.mainLabel.frame = CGRectMake(20, 20, 256, 21);
    cell.detailedTextLabel.frame = CGRectMake(20, 49, 256, 21);
    
    cell.mainLabel.text = [data.title gtm_stringByUnescapingFromHTML];
    cell.detailedTextLabel.text = [data.description gtm_stringByUnescapingFromHTML];
    
    [cell.mainLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [cell.detailedTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    CGSize mainTextExpectedSize = [cell.mainLabel optimumSize];
    CGSize detailTextExpectedSize = [cell.detailedTextLabel optimumSize];
    
    cell.mainLabel.frame = CGRectMake(20, 20, mainTextExpectedSize.width, mainTextExpectedSize.height);
    cell.detailedTextLabel.frame = CGRectMake(20, mainTextExpectedSize.height + 40 , detailTextExpectedSize.width, detailTextExpectedSize.height);
    
    //assigning title to cell property so it can be used in the sharing screen
    cell.title = data.title;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OffersData *data = self.data[indexPath.row];
    
    mainText = [[RTLabel alloc] init];
    detailText = [[RTLabel alloc] init];
    
    [mainText setLineBreakMode:RTTextLineBreakModeWordWrapping];
    [detailText setLineBreakMode:RTTextLineBreakModeWordWrapping];

    mainText.frame = CGRectMake(20, 20, 256, 21);
    detailText.frame = CGRectMake(20, 49, 256, 21);

    mainText.text = [data.title gtm_stringByUnescapingFromHTML];
    detailText.text = [data.description gtm_stringByUnescapingFromHTML];
    
    [mainText setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [detailText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    CGSize mainTextExpectedSize = [mainText optimumSize];
    CGSize detailTextExpectedSize = [detailText optimumSize];
    
    mainText.frame = CGRectMake(20, 20, mainTextExpectedSize.width, mainTextExpectedSize.height);
    detailText.frame = CGRectMake(20, 54, detailTextExpectedSize.width, detailTextExpectedSize.height);
    
    float totalHeightValue = mainTextExpectedSize.height + detailTextExpectedSize.height + 60;
    return totalHeightValue;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
