//
//  CategoryItem.h
//  hospitality
//
//  Created by Omer Janjua on 28/05/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "Mantle.h"

@interface CategoryItem : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;

@end
