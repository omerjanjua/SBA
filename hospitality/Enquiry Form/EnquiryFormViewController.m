//
//  EnquiryFormViewController.m
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "EnquiryFormViewController.h"
#import "JSON.h"

@interface EnquiryFormViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation EnquiryFormViewController

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
    self.navigationView.backgroundColor = App_Theme_Colour;
    self.navigationController.navigationBarHidden = YES;
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
    
    self.nameTextField.text = @"Your Name";
    self.emailTextField.text = @"Your Email Address";
    self.phoneNumberTextField.text = @"Your Phone Number";
    self.messageTextView.text = @"Your Message";
    
    NSArray *fields = @[ _nameTextField, _emailTextField, _phoneNumberTextField, _messageTextView];
    
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

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender
{
    if (![HelperClass validateNotEmpty:self.nameTextField.text] || ![HelperClass validateNotEmpty:self.phoneNumberTextField.text] || ![HelperClass validateNotEmpty:self.messageTextView.text] || ![HelperClass validateEmail:self.emailTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:@"Please fill in all text fields & valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.nameTextField.text, @"name", self.emailTextField.text, @"email", self.phoneNumberTextField.text, @"phone", self.messageTextView.text, @"message" , nil];
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
        
        [dataDictionary setValue:dictionary.JSONFragment forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Contact_Form] parameters:dataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"SUCCESS%@", responseObject);
            [self cmsResponse:responseObject];
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
}

-(void)cmsResponse: (NSDictionary *)data
{
    if ([@"OK" isEqualToString:[data objectForKey:@"status"]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Booking From Submitted!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        [self setupView];
    }
    else if ([@"Failed" isEqualToString:[data objectForKey:@"status"]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[NSString stringWithFormat:@"%@", [data objectForKey:@"message"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_nameTextField.text isEqualToString:@"Your Name"] && [_nameTextField isFirstResponder]) {
        _nameTextField.text = @"";
    }
    
    if ([_emailTextField.text isEqualToString:@"Your Email Address"] && [_emailTextField isFirstResponder]) {
        _emailTextField.text = @"";
    }
    
    if ([_phoneNumberTextField.text isEqualToString:@"Your Phone Number"] && [_phoneNumberTextField isFirstResponder]) {
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
    if ([_messageTextView.text isEqualToString:@"Your Message"]) {
        _messageTextView.text = @"";
    }
    
    //create accessory view
    [_keyboardControls setActiveField:textView];
    [_scrollView setContentOffset:CGPointMake(0, + 160.0) animated:YES];
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
        _emailTextField.text = @"Your Email Address";
    }
    
    if ([_phoneNumberTextField.text isEqualToString:@""]) {
        _phoneNumberTextField.text = @"Your Phone Number";
    }
}

-(void)textViewPlaceHolderTextIfEmpty
{
    if ([_messageTextView.text isEqualToString:@""]) {
        _messageTextView.text = @"Your Message";
    }
}

@end
