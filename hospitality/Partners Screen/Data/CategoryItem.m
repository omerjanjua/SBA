//
//  CategoryItem.m
//  hospitality
//
//  Created by Omer Janjua on 28/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "CategoryItem.h"

@implementation CategoryItem

#pragma mark MTLJSONSerializing

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title": @"title.data"
             };
}

@end
