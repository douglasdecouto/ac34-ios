//
//  AC34StreamDelegate.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AC34BoatLocation;

@protocol AC34StreamDelegate <NSObject>
@optional

- (void) heartBeatFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withSeq:(UInt32) sequenceNum;

- (void) chatterFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withType:(UInt32) chatterType withChatter:(NSString *) chatter;

- (void) locationUpdateFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withLoc:(AC34BoatLocation *)loc;

- (void) xmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withXmlType:(UInt32) xmlType withXmlTimeStamp:(NSDate *) xmlTimeStamp
        withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withData:(NSData *) xml;

@end
