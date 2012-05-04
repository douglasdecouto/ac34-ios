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
        NSLog(@"Bad index %d", theIndex);
        return NULL;
    }
    return [self.boatList objectAtIndex:theIndex];
}

- (AC34Boat *) boatForSourceId:(UInt32) sourceId {
    NSNumber *key = [NSNumber numberWithUnsignedLong:sourceId];
    return [self.boatDict objectForKey:key];
}


- (void) addBoat:(AC34Boat *) theBoat {
    AC34Boat *b = [self.boatDict objectForKey:[theBoat key]];
    if (b == nil) {
        [self.boatList addObject:theBoat];
        [self.boatDict setObject:theBoat forKey:[theBoat key]];
        NSLog(@"Added boat %@", theBoat.boatName);
    }
    else {  
        NSLog(@"Boat %@ already exists", theBoat.boatName);
    }
}




@end
