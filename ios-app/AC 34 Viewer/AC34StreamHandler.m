//
//  AC34StreamDelegate.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34StreamHandler.h"

@implementation AC34StreamHandler

- (id) init {
    self = [super init];
    if (self) {
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

- (void) check {
    if (inHdr) {
        assert(numHdrBytesSoFar < AC34_HDR_SIZE);
        assert(numBodyBytesSoFar == 0);
        assert(numBodyBytesExpected == 0);
        assert(bodyBuf == 0);
    } else {
        assert(numHdrBytesSoFar == AC34_HDR_SIZE);
        assert(numBodyBytesSoFar >= 0);
        assert(numBodyBytesExpected > 0);
        assert(bodyBuf != 0);
    }
}


- (void) connectToServer:(NSString *) host port: (UInt32) port {
    NSLog(@"Connecting to AC34 server %@:%lu", host, port);
    CFStreamCreatePairWithSocketToHost(
                        NULL, CFSTR("localhost"), 4941,
                        &self->readStream, &self->writeStream);
    NSInputStream *inputStream = (__bridge NSInputStream *) self->readStream;
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [self check];
}

- (void) readBytes:(NSInputStream *) theStream {
    unsigned int nToRead;
    unsigned int nActuallyRead;
    
    
    while ([theStream hasBytesAvailable]) {
        [self check];
        
        if (inHdr) {
            // Still filling up header buffer.
            nToRead = AC34_HDR_SIZE - numHdrBytesSoFar;
            nActuallyRead = [theStream read:hdrBuf maxLength:nToRead];
            NSLog(@"Read %u header bytes", nActuallyRead);
            
            assert(nActuallyRead <= nToRead);
            numHdrBytesSoFar += nActuallyRead;
            
            if (numHdrBytesSoFar == AC34_HDR_SIZE) {
                // Header is complete, switch to reading body.
                assert(hdrBuf[0] == AC34_SYNC1);
                assert(hdrBuf[1] == AC34_SYNC2);
                numBodyBytesSoFar = 0;
                numBodyBytesExpected = hdrBuf[13] + 256*hdrBuf[14];
                numBodyBytesExpected += 4; // For checksum bytes.
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
            NSLog(@"nToRead: %u, numBodyByesExpected: %u, numBodyBytesSoFar: %u", nToRead, numBodyBytesExpected , numBodyBytesSoFar);
            nActuallyRead = [theStream read:bodyBuf maxLength:nToRead];
            NSLog(@"Read %u body bytes, %u so far, %u expected", nActuallyRead, nActuallyRead+numBodyBytesSoFar, numBodyBytesExpected);    
            
            assert(nActuallyRead <= nToRead);
            numBodyBytesSoFar += nActuallyRead;

            if (numBodyBytesSoFar == numBodyBytesExpected) {
                // Body is complete.  Do something with body and
                // header data, then switch to reading header mode.
                NSLog(@"Finished reading %u body bytes, processing message and expecting next header", numBodyBytesExpected);
                
                // XXX process message here.
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


- (void) stream:(NSStream *)theStream handleEvent:(NSStreamEvent) streamEvent {
	/* Handle a stream event */
    
    NSLog(@"streamEvent %d", streamEvent);
    
	switch (streamEvent) {
        case NSStreamEventHasBytesAvailable:
            /* Do read */
            NSLog(@"NSStreamEventHasBytesAvailable");
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
        }
            break;
            
        default:
            assert(0);
	}	
    [self check];
}




@end
