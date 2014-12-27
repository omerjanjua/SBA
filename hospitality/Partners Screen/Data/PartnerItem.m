//
//  PartnerItem.m
//  hospitality
//
//  Created by Omer Janjua on 28/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "PartnerItem.h"

@implementation PartnerItem

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"title": @"title.data",
                                                                                          @"domain": @"domain"
                                                                                          }];
}

@end
