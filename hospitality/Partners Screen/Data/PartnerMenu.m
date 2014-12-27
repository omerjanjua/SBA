//
//  PartnerMenu.m
//  hospitality
//
//  Created by Omer Janjua on 28/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "PartnerMenu.h"
#import "PartnerItem.h"

@implementation PartnerMenu

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                          @"preferred_partners": @"preferred_partners"
                                                                                          }];
}

+(NSValueTransformer *)preferred_partnersJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:PartnerItem.class];
}

@end
