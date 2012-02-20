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
- (void) initializeDefaultDataList;
@end

@implementation AC34BoatDataController

@synthesize boatList = _boatList;
@synthesize boatDict = _boatDict;

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
    NSMutableDictionary *boatDict = [[NSMutableDictionary alloc] init];
    self.boatList = boatList;
    self.boatDict = boatDict;
    
    [self addBoatWithName:@"First Boat"];
}
    
// Need to provide custom property 'setters' to ensure
// list stays mutable.      
- (void) setBoatList:(NSMutableArray *) newList {
    if (_boatList != newList) {
        _boatList = [newList mutableCopy];
    }
}
     
- (void) setBoatDict:(NSMutableDictionary *) newDict {
    if (_boatDict != newDict) {
        _boatDict = [newDict mutableCopy];
    }
}

- (unsigned) countOfList {
    return [self.boatList count];
}
     
     
- (AC34Boat *) objectInListAtIndex:(unsigned) theIndex {
    if (theIndex >= [self countOfList]) {
        NSLog([NSString stringWithFormat:@"Bad index %d", theIndex]);
        return NULL;
    }
    return [self.boatList objectAtIndex:theIndex];
}


- (void) addBoatWithName:(NSString *) boatName {
    AC34Boat *b = [self.boatDict valueForKey:boatName];
    if (b == nil) {
        b = [[AC34Boat alloc] initWithName:boatName];
        [self.boatList addObject:b];
        [self.boatDict setValue:b forKey:boatName];
        NSLog(@"Added boat %@", [b name]);
    }
    else {
        NSLog(@"Boat %@ already exists", [b name]);
    }
}




@end
