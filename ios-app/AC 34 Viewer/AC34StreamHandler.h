//
//  AC34StreamDelegate.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AC34StreamDelegate.h"

@interface AC34StreamHandler : NSObject <NSStreamDelegate>

@property (nonatomic, weak) id <AC34StreamDelegate> delegate;
@property bool verbose;

- (id) init;
- (void) check; // rep invariant

- (void) connectToServer:(NSString *) host port:(UInt32)port;
- (void) readBytes:(NSStream *) theStream;

// This is the top-level message body handler.  It dispatches 
// to more specifice message handling functions.  
// bodyLen includes 4 bytes for checksum.
- (void) handleMessage:(unsigned char *) hdr withBody:(unsigned char *)body bodyLen:(unsigned int) n;

// Following functions handle specific message types.
// bodyLen does NOT include 4 bytes for checksum.
- (void) handleHeartBeatMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n;

- (void) handleChatterMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n;

- (void) handleLocationMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n;

- (void) handleXmlMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n;


// Following functions are class utility methods.
+ (NSString *) messageTypeforCode: (UInt32) code;

// Returns UTC Date from 6-bye AC34 timestamp.
// buf must have at least 6 bytes
+ (NSDate *) timeStampFromBuf: (unsigned char *) buf; 

// Returns 4-byte unsigned integer stored in little-endian prder 
// in the first 4 bytes of buf.
+ (UInt32) uInt32FromBuf: (unsigned char *) buf;

// Returns 2-byte unsigned integer stored in little-endian prder 
// in the first 2 bytes of buf.
+ (UInt16) uInt16FromBuf: (unsigned char *) buf;

@end
