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
