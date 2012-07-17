//
//  AC34Boat.h
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

#import <Foundation/Foundation.h>

#import "AC34.h"

@class AC34BoatLocation;

@interface AC34Boat : NSObject

@property UInt32 sourceId; // Unique key
@property (nonatomic, copy) NSString *hullNum;
@property (nonatomic, copy) NSString *boatName;
@property (nonatomic, copy) NSString *skipper;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *boatType;

// bounding hull shape, array of AC34Point2D.  Should always exist.
@property (nonatomic, copy) NSArray *hullOutline; 

// dict from shape name -> NSArray of AC34Point2D
// May be empty, if so, use the bounding hull shape in hullOutline.
@property (nonatomic, copy) NSDictionary *hullShapes;

@property (nonatomic, copy) AC34Point3D *gpsPos;
@property (nonatomic, copy) AC34Point3D *flagPos;

// XXX if 'copy' insteady of retain, need to implement NSCopying on AC34BoatLocation
// http://stackoverflow.com/questions/4351053/copywithzone-being-called
@property (nonatomic, retain) AC34BoatLocation *lastLocation; 

@property (nonatomic, copy) NSDate *lastLocUpdateAt;

- (id) initWithName:(NSString *)name;

- (NSString *) displayName;
- (NSString *) displaySubtitle;

- (NSNumber *) key;

@end
