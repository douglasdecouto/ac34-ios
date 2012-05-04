//
//  AC34Boat.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

@property (nonatomic, copy) AC34BoatLocation *lastLocation;
@property (nonatomic, copy) NSDate *lastLocUpdateAt;

- (id)initWithName:(NSString *)name;

- (NSString *) displayName;
- (NSString *) displaySubtitle;

- (NSNumber *) key;

@end
