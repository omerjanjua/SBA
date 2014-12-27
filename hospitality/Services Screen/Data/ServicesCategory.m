//
//  ServicesCategory.m
//  hospitality
//
//  Created by Omer Janjua on 30/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "ServicesCategory.h"
#import "ServicesSubCategory.h"
#import "ServicesItem.h"

@implementation ServicesCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"categories": @"categories",
                                                                                            @"services": @"services"
                                                                                         }];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:ServicesSubCategory.class];
}

+ (NSValueTransformer *)servicesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:ServicesItem.class];
}

@end
