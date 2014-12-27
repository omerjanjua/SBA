//
//  BaseItem.h
//  hospitality
//
//  Created by Omer Janjua on 14/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

 #import "Mantle.h"

@interface BaseItem : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;

@end
