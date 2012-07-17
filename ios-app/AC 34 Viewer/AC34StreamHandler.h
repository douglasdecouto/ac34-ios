//
//  AC34StreamDelegate.h
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
