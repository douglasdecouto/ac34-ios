//
//  AC34.h
//  AC 34 Viewer
//
// Generic utility functions and constants shared across the AC34 app.
//
//  Created by Douglas De Couto on 2012-02-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum AC34ChatterType {
    // Official AC34 chatter types
    kYachtChatter       = 1,
    kUmpireChatter      = 2,
    kRaceOfficerChatter = 3,
    kCommentaryChatter  = 4,
    kMachineChatter     = 5,
    
    // App-specific internal chatter types
    kInternalChatter    = 99
};

enum AC34XmlType {
    kRegattaXml = 5,
    kRaceXml    = 6,
    kBoatXml    = 7 
};

@interface AC34 : NSObject

+ (NSString *) chatterTypeforCode: (UInt32) code;
+ (NSString *) formatDateISO: (NSDate *) date;


@end
