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
        case kYachtChatter:     return @"Yacht";
        case kUmpireChatter:    return @"Umpire";
        case kRaceOfficerChatter:   return @"Race Officer";
        case kCommentaryChatter:    return @"Commentary";
        case kMachineChatter:   return @"Machine";
        default:
            return [NSString stringWithFormat:@"Unknown (%lu)", code];
    }
}

@end
