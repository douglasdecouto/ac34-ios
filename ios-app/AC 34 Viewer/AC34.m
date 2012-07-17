//
//  AC34.m
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

