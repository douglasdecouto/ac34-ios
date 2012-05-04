//
//  AC34Boat.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34Boat.h"

@implementation AC34Boat

@synthesize sourceId = _sourceId;
@synthesize hullNum = _hullNum;
@synthesize boatName = _boatName;
@synthesize skipper = _skipper;
@synthesize country = _country;
@synthesize boatType = _boatType;
@synthesize hullOutline = _hullOutline;
@synthesize hullShapes = _hullShapes;
@synthesize gpsPos = _gpsPos;
@synthesize flagPos = _flagPos;
@synthesize lastLocation = _lastLocation;
@synthesize lastLocUpdateAt = _lastLocUpdateAt;

- (id) initWithName:(NSString *) name {
    
    self = [super init];
    if (self) {
        self.boatName = name;
        return self;
    }
    return nil;
}

- (NSString *) displayName {
    return  self.boatName;
}

- (NSString *) displaySubtitle {
    if ([self.boatType isEqualToString:@"Yacht"])
        return [NSString stringWithFormat:@"%@ %@ / %@ / %@", 
                self.boatType, self.hullNum, self.skipper, self.country];
    else
        return [NSString stringWithFormat:@"%@ %@", self.boatType, self.hullNum];
    
}

- (NSNumber *) key {
    return [NSNumber numberWithUnsignedLong:self.sourceId];
}


@end
