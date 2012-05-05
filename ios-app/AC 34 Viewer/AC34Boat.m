//
//  AC34Boat.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34Boat.h"
#import "AC34BoatLocation.h"

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
    return [NSString stringWithFormat:@"[%lu] %@", self.sourceId, self.boatName];
}

- (NSString *) displaySubtitle {
    double lat = 0;
    double lon = 0;
    if (self.lastLocation != nil) {
        lat = self.lastLocation.latitude;
        lon = self.lastLocation.longitude;
    }
    if ([self.boatType isEqualToString:@"Yacht"]) {
        return [NSString stringWithFormat:@"%@ %@ / %@ / %@ / lat=%f, lon=%f", 
                self.boatType, self.hullNum, self.skipper, self.country, lat, lon];
    }
    else {
        return [NSString stringWithFormat:@"%@ %@ / lat=%f, lon=%f", self.boatType, self.hullNum, lat, lon];
    }
}

- (NSNumber *) key {
    return [NSNumber numberWithUnsignedLong:self.sourceId];
}


@end
