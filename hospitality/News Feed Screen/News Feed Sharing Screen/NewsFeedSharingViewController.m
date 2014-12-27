//
//  NewsFeedSharingViewController.m
//  hospitality
//
//  Created by Omer Janjua on 11/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "NewsFeedSharingViewController.h"
#import <Social/Social.h>
#import "UIViewController+MJPopupViewController.h"

@interface NewsFeedSharingViewController ()

@end

@implementation NewsFeedSharingViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Interactions
- (IBAction)postToTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ - I am using the "App_Name@" app, download it free from the AppStore!", self.newsTitle]];
        [tweetSheet addURL:[NSURL URLWithString:[UserDefault objectForKey:Apple_App_URL]]];
        [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserDefault objectForKey:App_Icon_URL]]]]];
        [self presentViewController:tweetSheet animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

- (IBAction)postToFacebook:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:[NSString stringWithFormat:@"%@ - I am using the "App_Name@" app, download it free from the AppStore!", self.newsTitle]];
        [facebookSheet addURL:[NSURL URLWithString:[UserDefault objectForKey:Apple_App_URL]]];
        [facebookSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserDefault objectForKey:App_Icon_URL]]]]];
        [self presentViewController:facebookSheet animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"You can't post to Facebook right now, make sure your device has an internet connection and you have at least one account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

- (IBAction)shareByEmail:(id)sender
{
    //email body text
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
    [emailBody appendString:[NSString stringWithFormat:@"<p>%@</p> <p>I am using the "App_Name@" app, download it free from the AppStore!</p> <p>"Apple_App_URL@"</p>", self.newsTitle]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserDefault objectForKey:App_Icon_URL]]]];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    //adding the base64 image data to the email body
    NSString *base64String = [imageData base64Encoding];
    [emailBody appendString:[NSString stringWithFormat:@"<p><b><img src='data:image/png;base64,%@'></b></p>", base64String]];
    [emailBody appendString:@"</body></html>"];
    
    //initiating the mfmailviewcontroller modally
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@""App_Name@""];
    [controller setMessageBody:emailBody isHTML:YES];
    if (controller) [self presentViewController:controller animated:YES completion:Nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Message Sent Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)shareBySMS:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.messageComposeDelegate = self;
        controller.body = [NSString stringWithFormat:@"%@ \n \n I am using the "App_Name@" app, download it free from the AppStore! \n \n "Apple_App_URL@"", self.newsTitle];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"You can't send SMS messages from this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Message Sent Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[UserDefault objectForKey:App_Name] message:@"Messaged Failed To Send" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)cancelButton:(id)sender
{
    [_popupCaller dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}

@end
