//
//  HelperClass.h
//  hospitality
//
//  Created by Omer Janjua on 03/03/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperClass : NSObject

+(void)textValidation:(NSString *)name phoneText:(NSString *)phone messageText:(NSString *)message;
+(BOOL)validateEmail:(NSString *)text;
+(BOOL)validateNotEmpty:(NSString *)text;
+(void)navigationMenuSetup:(UILabel *)navigationTitle navigationSubTitle:(UILabel *)navigationSubTitle homeButton:(UIButton *)homeButton backButton:(UIButton *)backButton eventsButton:(UIButton *)eventsButton sideMenuButton:(UIButton *)sideMenuButton;

@end
