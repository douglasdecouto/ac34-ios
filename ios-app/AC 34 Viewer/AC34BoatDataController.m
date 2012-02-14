//
//  AC34BoatDataController.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34BoatDataController.h"
#import "AC34Boat.h"

// private initial constructor
@interface AC34BoatDataController ()
- (void)initializeDefaultDataList;
@end

@implementation AC34BoatDataController

@synthesize boatList = _boatList;

// Constructor
- (id) init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (void) initializeDefaultDataList {
    NSMutableArray *boatList = [[NSMutableArray alloc] init];
    self.boatList = boatList;
    [self addBoatWithName:@"First Boat"];
}
    
// Need to provide custom property 'setter' to ensure
// list stays mutable.      
- (void) setBoatList:(NSMutableArray *)newList {
    if (_boatList != newList) {
        _boatList = [newList mutableCopy];
    }
}
     
- (unsigned) countOfList {
    return [self.boatList count];
}
     
     
- (AC34Boat *) objectInListAtIndex:(unsigned)theIndex {
    if (theIndex >= [self countOfList]) {
        NSLog([NSString stringWithFormat:@"Bad index %d", theIndex]);
        return NULL;
    }
    return [self.boatList objectAtIndex:theIndex];
}


- (void) addBoatWithName:(NSString *) boatName {
    AC34Boat *b = [[AC34Boat alloc] initWithName:boatName];
    [self.boatList addObject:b];
    NSLog([NSString stringWithFormat:@"Added boat %@", [b name]]);
}




@end
