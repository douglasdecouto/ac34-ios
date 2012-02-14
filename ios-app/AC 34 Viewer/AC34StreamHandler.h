//
//  AC34StreamDelegate.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AC34_HDR_SIZE 15
#define AC34_SYNC1 0x47
#define AC34_SYNC2 0x83

@interface AC34StreamHandler : NSObject <NSStreamDelegate> {

    CFReadStreamRef  readStream;
    CFWriteStreamRef writeStream;

    unsigned char hdrBuf[AC34_HDR_SIZE];
    unsigned char *bodyBuf;
    
    // These track the number of bytes we have read so far for
    // the header and body, respectively.
    unsigned int numHdrBytesSoFar;
    unsigned int numBodyBytesSoFar;
    unsigned int numBodyBytesExpected; // size of bodyBuf
    
    bool inHdr;
}

- (void) connectToServer:(NSString *) host port:(UInt32)port;
- (void) check; // rep invariant
- (void) readBytes:(NSStream *) theStream;


@end
