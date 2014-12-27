//
//  ContactData.h
//  hospitality
//
//  Created by Dev on 10/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactData : NSObject

@property (strong, nonatomic) NSString *pinId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *fullAddress;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *website;
@property (assign, nonatomic) float contactHeight;

@end
