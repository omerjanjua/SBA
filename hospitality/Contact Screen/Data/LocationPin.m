//
//  LocationPin.m
//  hospitality
//
//  Created by Omer Janjua on 11/04/2014.
//  Copyright (c) 2014 Appitized. All rights reserved.
//

#import "LocationPin.h"

@implementation LocationPin

@synthesize coordinate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(BOOL)isEqual:(id)object{
    
    if (![object isKindOfClass:[LocationPin class]]) {
        return NO;
    }
    
    if ([self.pinID isEqualToString:((LocationPin *)object).pinID]) {
        return  YES;
    }
    return NO;
}

@end
