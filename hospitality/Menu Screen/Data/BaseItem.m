//
//  BaseItem.m
//  hospitality
//
//  Created by Omer Janjua on 14/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem

#pragma mark MTLJSONSerializing 

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title": @"title.data",
             @"description": @"description.data"
             };
}

@end
