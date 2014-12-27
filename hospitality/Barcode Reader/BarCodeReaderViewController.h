//
//  BarCodeReaderViewController.h
//  hospitality
//
//  Created by ems-osx-server on 09/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface BarCodeReaderViewController : UIViewController <ZBarReaderViewDelegate>

@property (strong, nonatomic) IBOutlet ZBarReaderView *readerView;

@end
