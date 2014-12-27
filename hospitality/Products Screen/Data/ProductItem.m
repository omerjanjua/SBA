//
//  ProductItem.m
//  hospitality
//
//  Created by Omer Janjua on 30/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ProductItem.h"

@implementation ProductItem

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"title": @"title.data",
                                                                                          @"description": @"description.data",
                                                                                          @"price": @"price",
                                                                                          @"imageUrl": @"ext_image.image_url",
                                                                                          @"imageUrl2": @"ext_image_1.image_url",
                                                                                          @"imageUrl3": @"ext_image_2.image_url",
                                                                                          @"imageUrl4": @"ext_image_3.image_url"
                                                                                          }];
}

@end
