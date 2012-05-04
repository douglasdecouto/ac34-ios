//
//  AC34.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34.h"

@implementation AC34

+ (NSString *) formatDateISO: (NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [formatter stringFromDate:date];
}

+ (NSString *) chatterTypeforCode: (UInt32) code {
    switch (code) {
        case kYachtChatter:         return @"Yacht";
        case kUmpireChatter:        return @"Umpire";
        case kRaceOfficerChatter:   return @"Race Officer";
        case kCommentaryChatter:    return @"Commentary";
        case kMachineChatter:       return @"Machine";
        case kInternalChatter:      return @"Internal";
        default:
            return [NSString stringWithFormat:@"Unknown (%lu)", code];
    }
}

@end


@implementation AC34Point2D
@synthesize x = _x;
@synthesize y = _y;
- (AC34Point2D *) initWithX: (float) theX y:(float) theY {
    self = [super init];
    if (self) {
        self.x = theX;
        self.y = theY;
    }
    return self;
}
@end

@implementation AC34Point3D
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
- (AC34Point3D *) initWithX: (float) theX y:(float) theY  z:(float) theZ {
    self = [super init];
    if (self) {
        _x = theX;
        _y = theY;
        _z = theZ;
    }
    return self;
}
- (AC34Point2D *) point2D {
    return [[AC34Point2D alloc] initWithX: self.x y:self.y];
}
@end

