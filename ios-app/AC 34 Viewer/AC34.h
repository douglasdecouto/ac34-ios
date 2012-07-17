//
//  AC34.h
//  AC 34 Viewer
//
// Generic utility functions and constants shared across the AC34 app.
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

@interface AC34Point2D : NSObject
@property float x;
@property float y;
- (AC34Point2D *) initWithX: (float) theX y:(float) theY;
@end

@interface AC34Point3D : NSObject
@property float x;
@property float y;
@property float z;
- (AC34Point3D *) initWithX: (float) theX y:(float) theY z:(float) theZ;
- (AC34Point2D *) point2D;
@end

