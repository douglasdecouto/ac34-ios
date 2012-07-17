//
//  AC34BoatDataController.m
//  AC 34 Viewer
//

// Copyright (c) 2012, Douglas S. J. De Couto, decouto@alum.mit.edu http://decouto.bm
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of the Douglas S. J. De Couto nor the names of other 
//   contributors to this project may be used to endorse or promote products
//   derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
