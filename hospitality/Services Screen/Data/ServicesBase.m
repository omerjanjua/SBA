//
//  ServicesBase.m
//  hospitality
//
//  Created by Omer Janjua on 30/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ServicesBase.h"

@implementation ServicesBase

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title": @"title.data",
             @"description": @"description.data"
             };
}

@end
