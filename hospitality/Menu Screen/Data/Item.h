//
//  Item.h
//  hospitality
//
//  Created by Omer Janjua on 14/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "BaseItem.h"

@interface Item : BaseItem

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *vegetarian;
@property (nonatomic, strong) NSString *vegan;
@property (nonatomic, strong) NSString *glutenFree;
@property (nonatomic, strong) NSString *imageUrl;

@end
