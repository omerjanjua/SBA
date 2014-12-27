//
//  Menu.m
//  hospitality
//
//  Created by Omer Janjua on 14/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "Menu.h"
#import "Item.h"

@implementation Menu

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"menus": @"menus",
                                                                                          @"items": @"items"
                                                                                          }];
}

+(NSValueTransformer *)menusJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Menu.class];
}

+(NSValueTransformer *)itemsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Item.class];
}

@end
