//
//  AC34BoatLocation.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AC34BoatLocation : NSObject

@property (nonatomic, copy) NSDate *locValidAt;
@property UInt32 sourceIdOfPosition; // position is for boat with this ID.
@property UInt32 seqNum;
@property double latitude;
@property double longitude;

@end
