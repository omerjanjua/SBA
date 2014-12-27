//
//  BookingFormViewController.m
//  hospitality
//
//  Created by ems-osx-server on 17/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "BookingFormViewController.h"
#import "JSON.h"
#import "BookingData.h"

@interface BookingFormViewController ()

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *yourEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *subjectTextField;
@property (strong, nonatomic) IBOutlet UITextField *desiredDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *desiredTimeTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *additionalInformationTextView;
@property (strong, nonatomic) IBOutlet UILabel *navigationTitle;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *sideMenuButton;
@property (strong, nonatomic) NSDate *pickerDate;
@property (strong, nonatomic) NSDate *pickerTime;
@property (strong, nonatomic) UIDatePicker *myPicker;
@property (strong, nonatomic) UIDatePicker *timePicker;
@property (strong, nonatomic) UIPickerView *emaiPicker;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *subjectIdString;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@end

@implementation BookingFormViewController

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
    [self getBookingEmails];
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
    [HelperClass navigationMenuSetup:_navigationTitle navigationSubTitle:nil homeButton:_homeButton backButton:nil eventsButton:nil sideMenuButton:_sideMenuButton];
    
    self.nameTextField.text = @"Your Name";
    self.yourEmailTextField.text = @"Your Email Address";
    self.subjectTextField.text = @"Subject";
    self.desiredDateTextField.text = @"Desired Date";
    self.desiredTimeTextField.text = @"Desired Time";
    self.phoneNumberTextField.text = @"Phone Number";
    self.additionalInformationTextView.text = @"Additional Information";
    
    NSArray *fields = @[ _nameTextField, _yourEmailTextField, _phoneNumberTextField, _subjectTextField, _desiredDateTextField, _desiredTimeTextField, _additionalInformationTextView];
    
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

-(void)getBookingEmails
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", Base_URL, Get_Booking_Emails] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableArray *tempData = [[NSMutableArray alloc] init];
         for (int i = 0; i<[[responseObject objectForKey:@"matches"] count]; i++)
         {
             BookingData *bookingData = [[BookingData alloc] init];
             bookingData.title = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"title"];
             bookingData.subjectID = [[[responseObject objectForKey:@"matches"] objectAtIndex:i] objectForKey:@"id"];
             [tempData addObject:bookingData];
         }
         _data = [[NSMutableArray alloc] initWithArray:tempData];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
         [alert show];
         NSLog(@"FAILED: %@", [error localizedDescription]);
     }];
}

#pragma mark - user Interactions
- (IBAction)submitButtonPressed:(id)sender
{
    if (![HelperClass validateNotEmpty:self.nameTextField.text] || ![HelperClass validateNotEmpty:self.desiredDateTextField.text] || ![HelperClass validateNotEmpty:self.desiredTimeTextField.text] || ![HelperClass validateNotEmpty:self.phoneNumberTextField.text] || ![HelperClass validateNotEmpty:self.additionalInformationTextView.text] || ![HelperClass validateNotEmpty:self.subjectTextField.text] || ![HelperClass validateEmail:self.yourEmailTextField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey: App_Name] message:@"Please fill in all text fields & valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.nameTextField.text, @"name", self.yourEmailTextField.text, @"email", self.subjectIdString, @"subject", self.phoneNumberTextField.text, @"phone", self.additionalInformationTextView.text, @"message", self.desiredDateTextField.text, @"ext_date", self.desiredTimeTextField.text, @"ext_time", nil];
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
        
        [dataDictionary setValue:dictionary.JSONFragment forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", Base_URL, Booking_Form] parameters:dataDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
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
        [self viewSetup];
    }
    else if ([@"Failed" isEqualToString:[data objectForKey:@"status"]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[NSString stringWithFormat:@"%@", [data objectForKey:@"message"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

#pragma mark - PickerView DataSource and Delegate
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BookingData *bookingData= [_data objectAtIndex:row];
    return bookingData.title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    BookingData *bookingData= [_data objectAtIndex:row];
    _subjectTextField.text = bookingData.title;
    _subjectIdString = bookingData.subjectID;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_nameTextField.text isEqualToString:@"Your Name"] && [_nameTextField isFirstResponder]) {
        _nameTextField.text = @"";
    }
    
    if ([_yourEmailTextField.text isEqualToString:@"Your Email Address"] && [_yourEmailTextField isFirstResponder]) {
        _yourEmailTextField.text = @"";
    }
    
    if ([_subjectTextField.text isEqualToString:@"Subject"] && [_subjectTextField isFirstResponder]) {
        _subjectTextField.text = @"";
    }
    
    if ([_desiredDateTextField.text isEqualToString:@"Desired Date"] && [_desiredDateTextField isFirstResponder]) {
        _desiredDateTextField.text = @"";
    }
    
    if ([_desiredTimeTextField.text isEqualToString:@"Desired Time"] && [_desiredTimeTextField isFirstResponder]) {
        _desiredTimeTextField.text = @"";
    }
    
    if ([_phoneNumberTextField.text isEqualToString:@"Phone Number"] && [_phoneNumberTextField isFirstResponder]) {
        _phoneNumberTextField.text = @"";
    }

    //create accessory view
    [_keyboardControls setActiveField:textField];
    
    _myPicker = [[UIDatePicker alloc] init];
    [_myPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    _myPicker.datePickerMode = UIDatePickerModeDate;
    [_desiredDateTextField setInputView:_myPicker];
    _pickerDate = _myPicker.date;
    
    _timePicker = [[UIDatePicker alloc] init];
    [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _timePicker.datePickerMode = UIDatePickerModeTime;
    [_desiredTimeTextField setInputView:_timePicker];
    _pickerTime = _timePicker.date;
    
    _emaiPicker = [[UIPickerView alloc] init];
    _emaiPicker.dataSource = self;
    _emaiPicker.delegate = self;
    [_subjectTextField setInputView:_emaiPicker];
    
    if ([_phoneNumberTextField isFirstResponder] || [_subjectTextField isFirstResponder] || [_desiredDateTextField isFirstResponder] || [_desiredTimeTextField isFirstResponder]) {
        [_scrollView setContentOffset:CGPointMake(0, + 115.0) animated:YES];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self textFieldPlaceHolderTextIfEmpty];
    if ([_phoneNumberTextField isFirstResponder] || [_subjectTextField isFirstResponder] || [_desiredDateTextField isFirstResponder] || [_desiredTimeTextField isFirstResponder]) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

-(void)dateChanged:(id)sender
{
    _pickerDate = _myPicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    _desiredDateTextField.text = [formatter stringFromDate:_pickerDate];
}

-(void)timeChanged:(id)sender
{
    _pickerTime = _timePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    _desiredTimeTextField.text = [formatter stringFromDate:_pickerTime];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_nameTextField isFirstResponder]) {
        [_yourEmailTextField becomeFirstResponder];
    }
    else if ([_yourEmailTextField isFirstResponder]) {
        [_phoneNumberTextField becomeFirstResponder];
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_additionalInformationTextView.text isEqualToString:@"Additional Information"]) {
        _additionalInformationTextView.text = @"";
    }

    //create accessory view
    [_keyboardControls setActiveField:textView];
    [_scrollView setContentOffset:CGPointMake(0, + 280.0) animated:YES];
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
    
    if ([_yourEmailTextField.text isEqualToString:@""]) {
        _yourEmailTextField.text = @"Your Email Address";
    }
    
    if ([_subjectTextField.text isEqualToString:@""]) {
        _subjectTextField.text = @"Subject";
    }
    
    if ([_desiredDateTextField.text isEqualToString:@""]) {
        _desiredDateTextField.text = @"Desired Date";
    }
    
    if ([_desiredTimeTextField.text isEqualToString:@""]) {
        _desiredTimeTextField.text = @"Desired Time";
    }
    
    if ([_phoneNumberTextField.text isEqualToString:@""]) {
        _phoneNumberTextField.text = @"Phone Number";
    }
}

-(void)textViewPlaceHolderTextIfEmpty
{
    if ([_additionalInformationTextView.text isEqualToString:@""]) {
        _additionalInformationTextView.text = @"Additional Information";
    }
}

@end
