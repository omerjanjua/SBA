//
//  ProductCategory.m
//  hospitality
//
//  Created by Omer Janjua on 30/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ProductCategory.h"
#import "ProductSubCategory.h"
#import "ProductItem.h"

@implementation ProductCategory

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"categories": @"categories",
                                                                                          @"products": @"products"
                                                                                          }];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:ProductSubCategory.class];
}

+ (NSValueTransformer *)productsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:ProductItem.class];
}

@end
