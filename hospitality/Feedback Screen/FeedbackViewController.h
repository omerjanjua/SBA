//
//  FeedbackViewController.h
//  hospitality
//
//  Created by ems-osx-server on 19/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "BSKeyboardControls.h"

@interface FeedbackViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, EDStarRatingProtocol, BSKeyboardControlsDelegate>

@end
