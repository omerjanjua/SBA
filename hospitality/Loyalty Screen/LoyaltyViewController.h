//
//  LoyaltyViewController.h
//  hospitality
//
//  Created by Omer Janjua on 26/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoyaltyViewController : UIViewController

@end

/*
 
  --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 
 Step 1:
 
 This is the main class that presents the modal mjpopup
 
 1: In the viewDidLoad add the notification center observer
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeModal:) name:@"Dismiss_Popup" object:Nil];
 
 2: Implement the selector method 
 -(void)closeModal:(NSNotificationCenter *)notification
 {
 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
 }
 
 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 
 Step 2:
 
 Whatever class was presented with the mjpopup in step 1.
 
 In there call the nsnotification postNotiication method so the dismiss pop up is called from class A therefore removing the modal pop up from the class it was generated from
 
 3: [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss_Popup" object:Nil];
 
 */