//
//  AC34StreamDelegate.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34.h"
#import "AC34BoatLocation.h"
#import "AC34StreamHandler.h"
#import "AC34SecondViewController.h"


enum AC34StreamConstants {
    kHeaderSize = 15,
    kSyncByte1 = 0x47,
    kSyncByte2 = 0x83
};

enum AC34MessageType {
    kHeartBeatMsg       = 1,
    kRaceStatusMsg      = 12,
    kDisplayTextMsg     = 20,
    kXmlMsg             = 26,
    kRaceStartStatusMsg = 27,
    kYachtEventCodeMsg  = 29,
    kYachtActionCodeMsg = 31,
    kChatterTextMsg     = 36,
    kBoatLocationMsg    = 37,
    kMarkRoundingMsg    = 38
};

enum AC34MessageLength {
    kHeartBeatLen       = 4,
    kChatterPrefixLen   = 3,
    kLocationLen        = 56,
    kXmlPrefixLen       = 14
};

@implementation AC34StreamHandler

@synthesize delegate = _delegate;
@synthesize verbose = _verbose;

NSInputStream *inputStream;
CFReadStreamRef  readStream;
CFWriteStreamRef writeStream;

unsigned char hdrBuf[kHeaderSize];
unsigned char *bodyBuf;

// These track the number of bytes we have read so far for
// the header and body, respectively.
unsigned int numHdrBytesSoFar;
unsigned int numBodyBytesSoFar;
unsigned int numBodyBytesExpected; // size of bodyBuf

bool inHdr;


- (id) init {
    self = [super init];
    if (self) {
        inputStream = 0;
        bodyBuf = 0;
        numHdrBytesSoFar = 0;
        numBodyBytesSoFar = 0;
        numBodyBytesExpected = 0;
        inHdr = true;
        [self check];
        return self;
    }
    return nil;
}

// Check the rep invariants: make sure object state is consistent.
- (void) check {
    if (inHdr) {
        assert(numHdrBytesSoFar < kHeaderSize);
        assert(numBodyBytesSoFar == 0);
        assert(numBodyBytesExpected == 0);
        assert(bodyBuf == 0);
    } else {
        assert(numHdrBytesSoFar == kHeaderSize);
        assert(numBodyBytesSoFar >= 0);
        assert(numBodyBytesExpected > 0);
        assert(bodyBuf != 0);
    }
}

// Plumbing for delegates
struct {
    unsigned int heartBeatFrom:1;
    unsigned int chatterFrom:1;
    unsigned int locationUpdateFrom:1;
    unsigned int xmlFrom:1;
} delegateRespondsTo;

- (void) setDelegate:(id <AC34StreamDelegate>) newDelegate {
    if (_delegate != newDelegate) {
        _delegate = newDelegate;
        
        delegateRespondsTo.heartBeatFrom = [_delegate respondsToSelector:@selector(heartbeatFrom:at:withSeq:)];
        delegateRespondsTo.chatterFrom = [_delegate respondsToSelector:@selector(chatterFrom:at:withType:withChatter:)];
        delegateRespondsTo.locationUpdateFrom = [_delegate respondsToSelector:@selector(locationUpdateFrom:at:withLoc:)];
        delegateRespondsTo.xmlFrom = [_delegate respondsToSelector:@selector(xmlFrom:at:withXmlType:withXmlTimeStamp:withSeq:withAck:withData:)];
    }
} 



// Networking code follows

- (void) connectToServer:(NSString *) host port: (UInt32) port {
    NSLog(@"Connecting to AC34 server %@:%lu", host, port);
    CFStreamCreatePairWithSocketToHost(
                        NULL, CFSTR("localhost"), 4941,
                        &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *) readStream;
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [self check];
}

- (void) readBytes:(NSInputStream *) theStream {
    unsigned int nToRead;
    unsigned int nActuallyRead;
    
    if (theStream != inputStream) {
        NSLog(@"Got read for stream that is not our input stream");
        return;
    }
    
    while ([theStream hasBytesAvailable]) {
        [self check];
        
        if (inHdr) {
            // Still filling up header buffer.
            nToRead = kHeaderSize - numHdrBytesSoFar;
            nActuallyRead = [theStream read:hdrBuf maxLength:nToRead];
            if (self.verbose)
                NSLog(@"Read %u header bytes", nActuallyRead);
            
            assert(nActuallyRead <= nToRead);
            numHdrBytesSoFar += nActuallyRead;
            
            if (numHdrBytesSoFar == kHeaderSize) {
                // Header is complete, switch to "reading body: state.
                assert(hdrBuf[0] == kSyncByte1);
                assert(hdrBuf[1] == kSyncByte2);
                numBodyBytesSoFar = 0;
                numBodyBytesExpected = hdrBuf[13] + 256*hdrBuf[14];
                numBodyBytesExpected += 4; // For checksum bytes.
                if (self.verbose)
                    NSLog(@"Header complete, need %u body bytes", numBodyBytesExpected);
                bodyBuf = malloc(numBodyBytesExpected);
                assert(bodyBuf);
                inHdr = false;
            }
            [self check];
        }
        else {
            // Filling up body buffer, including trailing 4 bytes for checksum.
           
            nToRead = numBodyBytesExpected - numBodyBytesSoFar;
            if (self.verbose)
                NSLog(@"nToRead: %u, numBodyByesExpected: %u, numBodyBytesSoFar: %u", nToRead, numBodyBytesExpected , numBodyBytesSoFar);
            nActuallyRead = [theStream read:bodyBuf maxLength:nToRead];
            if (self.verbose)
                NSLog(@"Read %u body bytes, %u so far, %u expected", nActuallyRead, nActuallyRead+numBodyBytesSoFar, numBodyBytesExpected);    
            
            assert(nActuallyRead <= nToRead);
            numBodyBytesSoFar += nActuallyRead;

            if (numBodyBytesSoFar == numBodyBytesExpected) {
                // Body is complete.  Do something with body and
                // header data, then switch to reading header mode.
                if (self.verbose)
                    NSLog(@"Finished reading %u body bytes, processing message and expecting next header", numBodyBytesExpected);
                
                [self handleMessage:hdrBuf withBody:bodyBuf bodyLen:numBodyBytesExpected];
                
                // Change to "reading header" state.
                numHdrBytesSoFar = 0;
                numBodyBytesSoFar = 0;
                numBodyBytesExpected = 0;
                free(bodyBuf);
                bodyBuf = 0;
                inHdr = true;
                
                [self check];
                return; // Give other code a chance to run!
            }
            [self check];
        }
    }
    
    [self check];
}


- (void) handleMessage:(unsigned char *) hdr withBody:(unsigned char *) body bodyLen:(unsigned int) n {
    // bodyLen includes trailing check sum, Hdr must have kHeaderSize bytes.
    unsigned char messageType;
    UInt32 sourceId;
    unsigned int realBodyLen;
    NSDate *timeStamp;
    NSString *messageTypeStr;

    messageType = hdr[2];
    messageTypeStr = [AC34StreamHandler messageTypeforCode:messageType];
    
    timeStamp = [AC34StreamHandler timeStampFromBuf:(hdr+3)];
    
    sourceId = hdr[9] | (hdr[10] << 8) | (hdr[11] << 16) | (hdr[12] << 24);
    
    NSLog(@"%@ Message type '%@' from %lu", [AC34 formatDateISO:timeStamp], messageTypeStr, sourceId);
    
    // XXX Verify checksum
    
    realBodyLen = n - 4;
    
    switch (messageType) {
        case kHeartBeatMsg:
            [self handleHeartBeatMessageFrom:sourceId at:timeStamp withBody:body bodyLen:realBodyLen];
            break;
        case kChatterTextMsg:
            [self handleChatterMessageFrom:sourceId at:timeStamp withBody:body bodyLen:realBodyLen];
            break;
        case kBoatLocationMsg:
            [self handleLocationMessageFrom:sourceId at:timeStamp withBody:body bodyLen:realBodyLen];
            break;
        case kXmlMsg:
            [self handleXmlMessageFrom:sourceId at:timeStamp withBody:body bodyLen:realBodyLen];
            break;
        default:
            NSLog(@"Unhandled message type '%@'", messageTypeStr);
    } 
    
}

- (void) handleHeartBeatMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n {

    UInt32 seq;
    
    if (n < kHeartBeatLen) {
        NSLog(@"Heartbeat message from %lu too short, expected 4 bytes but got %u", sourceId, n);
        return;
    }
    
    seq = [AC34StreamHandler uInt32FromBuf:body];
    
    if (delegateRespondsTo.heartBeatFrom)
        [self.delegate heartBeatFrom:sourceId at:timeStamp withSeq:seq];
}

- (void) handleChatterMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n {

    UInt32 chatterVersion, chatterLen, chatterType, bytesInChatter;
    NSString *chatter;
    char *buf;
    
    if (n < kChatterPrefixLen) {
        NSLog(@"Chatter message header from %lu too short, expected at least %u bytes but got %u", sourceId, kChatterPrefixLen, n);        
        return;
    }
    chatterVersion = body[0];
    if (chatterVersion != 1) {
        NSLog(@"Bad chatter version %lu from %lu, expected version 1", chatterVersion, sourceId);
    }
    chatterType = body[1]; 
    chatterLen = body[2];
    
    if (n < kChatterPrefixLen + chatterLen) {
        NSLog(@"Bad chatter body from %lu, expected %lu but got %u bytes", sourceId, chatterLen + 3, n);        
    }
    
    // Docs say message is null-terminated but from test data that is not the case. 
    bytesInChatter = chatterLen < n - kChatterPrefixLen ? chatterLen : n - kChatterPrefixLen;
    buf = malloc(bytesInChatter + 1);
    assert(buf);
    memcpy(body + kChatterPrefixLen, buf, bytesInChatter);
    buf[bytesInChatter] = 0;
    chatter = [[NSString alloc] initWithUTF8String:buf];
    
    if (delegateRespondsTo.chatterFrom)
        [self.delegate chatterFrom:sourceId at:timeStamp withType:chatterType withChatter:chatter];
}

- (void) handleLocationMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n {
    
    if (n < kLocationLen) {
        NSLog(@"Location update from %lu too short, expected %u but got %u bytes", sourceId, kLocationLen, n);
        return;
    }
    
    AC34BoatLocation *boatLoc = [[AC34BoatLocation alloc] init];
    
    if (delegateRespondsTo.locationUpdateFrom)
        [self.delegate locationUpdateFrom:sourceId at:timeStamp withLoc:boatLoc];
}


- (void) handleXmlMessageFrom:(UInt32) sourceId at:(NSDate *) timeStamp withBody:(unsigned char *) body bodyLen:(unsigned int) n {
    
    UInt32 xmlVersion, ackNum, xmlType, seqNum, xmlLen;
    NSDate *xmlTimeStamp;
    NSData *xmlData;
    
    if (n < kXmlPrefixLen) {
        NSLog(@"XML message header from %lu too short, expected at least %u bytes but got %u", sourceId, kXmlPrefixLen, n);        
        return;
    }
    xmlVersion = body[0];
    if (xmlVersion != 1) {
        NSLog(@"Bad XML version %lu from %lu, expected version 1", xmlVersion, sourceId);
    }
    
    ackNum = [AC34StreamHandler uInt16FromBuf:(body + 1)];
    xmlTimeStamp = [AC34StreamHandler timeStampFromBuf:(body + 3)];
    xmlType = body[9]; 
    seqNum = [AC34StreamHandler uInt16FromBuf:(body + 10)];
    xmlLen = [AC34StreamHandler uInt16FromBuf:(body + 12)];
    
    if (n < kXmlPrefixLen + xmlLen) {
        NSLog(@"Bad XML body from %lu, expected %lu but got %u bytes", sourceId, xmlLen + kXmlPrefixLen, n);        
    }

    // XXX We are copying the buffer here; will the XML library copy it in turn?
    
    // From docs, XML messages are null-terminated, but from
    // test data experience is mixed.  So strip any trailing
    // nulls in the data.
    while (xmlLen > 0 && body[kXmlPrefixLen + xmlLen - 1] == 0) {
        xmlLen--;
    }
    xmlData = [NSData dataWithBytes:body+kXmlPrefixLen length:xmlLen];
    
    if (delegateRespondsTo.xmlFrom) {
        [self.delegate xmlFrom:sourceId at:timeStamp 
                    withXmlType:xmlType withXmlTimeStamp:xmlTimeStamp 
                    withSeq:seqNum withAck:ackNum withData:xmlData];
    }
}


- (void) stream:(NSStream *)theStream handleEvent:(NSStreamEvent) streamEvent {
	/* Handle a stream event */
    
    // NSLog(@"streamEvent %d", streamEvent);
    
    // Should really use if-statement and bitmasks here, as per:
    // http://stackoverflow.com/questions/7639427/how-to-open-multiple-socket-streams-on-the-same-runloop-in-ios-possible
	switch (streamEvent) {
        case NSStreamEventHasBytesAvailable:
            /* Do read */
            // NSLog(@"NSStreamEventHasBytesAvailable");
            [self readBytes:theStream];
            break;
            
        case NSStreamEventEndEncountered:
            /* Close it up */
            NSLog(@"NSStreamEventEndEncountered");
            break;
            
            /* The following events aren't handled */
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"NSStreamEventHasSpaceAvailable");
            break;
        case NSStreamEventNone: 
            NSLog(@"NSStreamEventNone");
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"NSStreamEventOpenCompleted");
            break;
            
        case NSStreamEventErrorOccurred: {
            /* Handle stream errors, e.g. couldn't connect to host, etc. */
            NSError *theError = [theStream streamError];
            NSLog(@"Error reading stream (%i): %@",
                   [theError code], [theError localizedDescription]);
            
            [theStream close];
            
            // XXX Unschedule the stream from the run-loop?
            // OR... try again to connect?
        }
            break;
            
        default:
            assert(0);
	}	
    [self check];
}



+ (NSString *) messageTypeforCode: (UInt32) code {
    switch (code) {
        case kHeartBeatMsg:     return @"Heartbeat";
        case kRaceStatusMsg:    return @"Race Status"; 
        case kDisplayTextMsg:   return @"Display Text";
        case kXmlMsg:           return @"XML Data";
        case kRaceStartStatusMsg:   return @"Race Start Status";
        case kYachtEventCodeMsg:    return @"Yacht Event Code";
        case kYachtActionCodeMsg:   return @"Yacht Action Code";
        case kBoatLocationMsg:  return @"Boat Location";
        case kMarkRoundingMsg:  return @"Mark Rounding";
        default:
            return [NSString stringWithFormat:@"Unknown (%lu)", code];
    }
}

+ (NSDate *) timeStampFromBuf: (unsigned char *) buf {
    UInt64 timeStampMs;
    NSDate *timeStamp;
    
    timeStampMs = ((UInt64) buf[0]) | ((UInt64) buf[1] << 8) 
        | ((UInt64) buf[2] << 16) | ((UInt64) buf[3] << 24) 
        | ((UInt64) buf[4] << 32) | ((UInt64) buf[5] << 40);
    timeStamp = [NSDate dateWithTimeIntervalSince1970:(timeStampMs / 1000.0)];
    
    return timeStamp;
}

+ (UInt32) uInt32FromBuf: (unsigned char *) buf {
    UInt32 val;
    val = buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24);
    return val;
}

+ (UInt16) uInt16FromBuf: (unsigned char *) buf {
    UInt16 val;
    val = buf[0] | (buf[1] << 8);
    return val;
}

@end
