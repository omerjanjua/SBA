//
//  LoadDefaultData.h
//  hospitality
//
//  Created by Omer Janjua on 17/02/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadDefaultData : NSObject

+(void)createAppSettings;
+(void)loadAppSettings:(NSDictionary *)data;
+(void)loadLoyaltySettings:(NSDictionary *)data;
+(void)loyaltyRedeemCode:(NSDictionary *)data;

@end
