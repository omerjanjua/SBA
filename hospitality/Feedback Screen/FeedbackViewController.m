//
//  FeedbackViewController.m
//  hospitality
//
//  Created by ems-osx-server on 19/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "FeedbackViewController.h"
#import "JSON.h"

@interface FeedbackViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *yourMessageTextView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UILabel *navigationSubTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) IBOutlet EDStarRating *starRating;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation FeedbackViewController

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
    [self ratingLogic];
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupView
-(void)viewSetup
{
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:_navigationSubTitle homeButton:_homeButton backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];
    
    self.nameTextField.text = @"Your Name";
    self.emailTextField.text = @"Email Address";
    self.phoneNumberTextField.text = @"Phone Number";
    self.yourMessageTextView.text = @"Your Message";
    self.starRating.rating = 5;
    
    NSArray *fields = @[ _nameTextField, _emailTextField, _phoneNumberTextField, _yourMessageTextView];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [_keyboardControls setBarColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0]];
        [_keyboardControls setBarTintColor:[UIColor whiteColor]];
    }
    [self.keyboardControls setDelegate:self];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}

- (IBAction)homeButtonPressed:(id)sender
{
    [self settingUpDashboardType:[UserDefault objectForKey:Dashboard_Screen]];
}

#pragma mark - user Interactions
- (IBAction)submitButtonPressed:(id)sender
{
    if (![HelperClass validateNotEmpty:self.nameTextField.text] || ![HelperClass validateNotEmpty:self.phoneNumberTextField.text] || ![HelperClass validateNotEmpty:self.yourMessageTextView.text] || ![HelperClass validateEmail:self.emailTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:@"Please fill in all text fields & valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.nameTextField.text, @"name", self.emailTextField.text, @"email", self.phoneNumberTextField.text, @"phone", self.yourMessageTextView.text, @"message", [[NSNumber numberWithFloat:self.starRating.rating] stringValue], @"stars", nil];
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
        
        [dataDictionary setValue:dictionary.JSONFragment forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Feedback_Form] parameters:dataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"SUCCESS%@", responseObject);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:@"Feedback form successfully sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             [self viewSetup];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@", [error localizedDescription]);
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
}

-(void)ratingLogic
{
    self.starRating.backgroundColor  = [UIColor whiteColor];
    self.starRating.starImage = [UIImage imageNamed:@"feedback-star-unchecked.png"];
    self.starRating.starHighlightedImage = [UIImage imageNamed:@"feedback-star-checked.png"];
    self.starRating.maxRating = 5.0;
    self.starRating.delegate = self;
    self.starRating.editable=YES;
    self.starRating.rating= 5;
    self.starRating.displayMode=EDStarRatingDisplayFull;
    [self.starRating setNeedsDisplay];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_nameTextField.text isEqualToString:@"Your Name"] && [_nameTextField isFirstResponder]) {
        _nameTextField.text = @"";
    }
    
    if ([_emailTextField.text isEqualToString:@"Email Address"] && [_emailTextField isFirstResponder]) {
        _emailTextField.text = @"";
    }
    
    if ([_phoneNumberTextField.text isEqualToString:@"Phone Number"] && [_phoneNumberTextField isFirstResponder]) {
        _phoneNumberTextField.text = @"";
    }
    
    //create accessory view
    [_keyboardControls setActiveField:textField];
    
    if ([_emailTextField isFirstResponder] || [_phoneNumberTextField isFirstResponder]) {
    [_scrollView setContentOffset:CGPointMake(0, + 53.0) animated:YES];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self textFieldPlaceHolderTextIfEmpty];
    if ([_emailTextField isFirstResponder] || [_phoneNumberTextField isFirstResponder]) {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_nameTextField isFirstResponder]) {
        [_emailTextField becomeFirstResponder];
    }
    else if ([_emailTextField isFirstResponder]) {
        [_phoneNumberTextField becomeFirstResponder];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_yourMessageTextView.text isEqualToString:@"Your Message"]) {
        _yourMessageTextView.text = @"";
    }
    //create accessory view
    [_keyboardControls setActiveField:textView];
    
    [_scrollView setContentOffset:CGPointMake(0, + 153.0) animated:YES];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self textViewPlaceHolderTextIfEmpty];
   [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

-(void)textFieldPlaceHolderTextIfEmpty
{
    if ([_nameTextField.text isEqualToString:@""]) {
        _nameTextField.text = @"Your Name";
    }
    
    if ([_emailTextField.text isEqualToString:@""]) {
        _emailTextField.text = @"Email Address";
    }
    
    if ([_phoneNumberTextField.text isEqualToString:@""]) {
        _phoneNumberTextField.text = @"Phone Number";
    }
}

-(void)textViewPlaceHolderTextIfEmpty
{
    if ([_yourMessageTextView.text isEqualToString:@""]) {
        _yourMessageTextView.text = @"Your Message";
    }
}

@end
