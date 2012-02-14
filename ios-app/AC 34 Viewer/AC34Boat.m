//
//  AC34Boat.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34Boat.h"

@implementation AC34Boat

@synthesize name = _name;

-(id)initWithName:(NSString *)name {
    
    self = [super init];
    if (self) {
        _name = name;
        return self;
    }
    return nil;


}


@end
