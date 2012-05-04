//
//  AC34BoatDataController.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AC34Boat;

@interface AC34BoatDataController : NSObject

@property (nonatomic, copy) NSMutableArray *boatList;
@property (nonatomic, copy) NSMutableDictionary *boatDict;

- (unsigned) countOfList;
- (AC34Boat *) objectInListAtIndex:(unsigned) theIndex;
- (void) addBoat:(AC34Boat *) theBoat;

@end
