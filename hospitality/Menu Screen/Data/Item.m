//
//  Item.m
//  hospitality
//
//  Created by Omer Janjua on 14/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "Item.h"

@implementation Item

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"price": @"price",
                                                                                          @"vegetarian": @"vegetarian",
                                                                                          @"vegan": @"vegan",
                                                                                          @"glutenFree": @"gluten_free",
                                                                                          @"imageUrl": @"ext_image.image_url"
                                                                                          }];
}

@end
